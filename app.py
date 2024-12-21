import os
import subprocess
from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

app = Flask(__name__)

def setup_chromedriver():
    """Download and install Chrome and ChromeDriver."""
    try:
        # Download and install Google Chrome
        os.system("wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb")
        os.system("dpkg -i chrome.deb || apt-get -fy install")

        # Fetch the latest ChromeDriver version
        chromedriver_version = subprocess.check_output(
            "curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE", shell=True
        ).decode("utf-8").strip()

        # Download ChromeDriver
        os.system(f"wget https://chromedriver.storage.googleapis.com/{chromedriver_version}/chromedriver_linux64.zip")
        os.system("unzip chromedriver_linux64.zip -d /usr/local/bin/")
        os.system("rm chromedriver_linux64.zip")  # Clean up the zip file after extraction
        print("ChromeDriver setup complete.")
    except Exception as e:
        print(f"Error setting up ChromeDriver: {e}")
        raise


def create_webdriver():
    """Create a Selenium WebDriver instance."""
    options = Options()
    options.add_argument("--headless")  # Run Chrome in headless mode
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.binary_location = "/usr/bin/google-chrome"  # Set Chrome binary location

    service = Service("/usr/local/bin/chromedriver")
    return webdriver.Chrome(service=service, options=options)


@app.route("/webdriver-status", methods=["GET"])
def check_webdriver():
    """Check if WebDriver is working."""
    try:
        driver = create_webdriver()
        driver.get("https://www.google.com")
        title = driver.title
        driver.quit()
        return jsonify({"status": "success", "message": f"WebDriver is working. Title: {title}"})
    except Exception as e:
        return jsonify({"status": "error", "message": f"WebDriver is not working. Error: {str(e)}"})


if __name__ == "__main__":
    # Ensure ChromeDriver and Chrome are set up before starting the app
    try:
        setup_chromedriver()
    except Exception as e:
        print(f"Error setting up environment: {e}")
        exit(1)  # Exit if setup fails

    # Run the Flask app
    app.run(host="0.0.0.0", port=8080)
