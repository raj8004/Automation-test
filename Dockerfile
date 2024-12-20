from flask import Flask, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time

app = Flask(__name__)

# Function to initialize the Selenium WebDriver with Chrome
def get_chrome_driver():
    # Set Chrome options for headless mode (no GUI)
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Run in headless mode
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--remote-debugging-port=9222")
    
    # Path to chromedriver (it should be installed in the Docker container)
    driver = webdriver.Chrome(executable_path='/usr/local/bin/chromedriver', options=chrome_options)
    return driver

@app.route('/')
def hello_world():
    # Use Selenium to open Google
    driver = get_chrome_driver()
    
    # Open a website
    driver.get("https://www.google.com")
    
    # Get the page title to confirm the browser worked
    page_title = driver.title

    # Sleep for a moment to let the page load
    time.sleep(2)
    
    # Close the driver
    driver.quit()
    
    # Return the title of the page as a response
    return jsonify(message=f"Successfully opened Google. Page title is: {page_title}")

if __name__ == '__main__':
    app.run(port=8080, host='0.0.0.0')
