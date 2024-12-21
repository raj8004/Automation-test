from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

# Initialize Flask app
app = Flask(__name__)

# Define the WebDriver status route
@app.route('/webdriver-status', methods=['GET'])
def check_webdriver():
    try:
        # Set up Chrome options for headless mode
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")

        # Set up the ChromeDriver service
        service = Service("/usr/local/bin/chromedriver")

        # Initialize WebDriver
        driver = webdriver.Chrome(service=service, options=chrome_options)

        # Test WebDriver by opening a webpage
        driver.get("https://www.google.com")
        title = driver.title  # Get the title of the webpage

        # Close WebDriver
        driver.quit()

        # Return success message
        return jsonify({
            "status": "success",
            "message": "WebDriver is working!",
            "page_title": title
        })

    except Exception as e:
        # Return error message if WebDriver fails
        return jsonify({
            "status": "error",
            "message": f"WebDriver failed: {str(e)}"
        })

# Main entry point
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
