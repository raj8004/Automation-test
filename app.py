from flask import Flask, request, jsonify, render_template
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
import time

app = Flask(__name__)

# Set up Chrome options to run in headless mode (without opening a browser window)
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")

# Set path to your ChromeDriver here
driver_path = "/path/to/chromedriver"  # Update this path to your chromedriver

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')

    # Initialize the WebDriver
    driver = webdriver.Chrome(executable_path=driver_path, options=chrome_options)
    driver.get("https://example.com/login")  # Use the actual login URL here

    # Allow time for the page to load
    time.sleep(2)

    # Find email and password fields and fill them
    email_field = driver.find_element(By.NAME, "email")  # Update the correct name or ID for the website
    password_field = driver.find_element(By.NAME, "password")  # Update the correct name or ID for the website
    email_field.send_keys(email)
    password_field.send_keys(password)

    # Find the login button and click
    login_button = driver.find_element(By.NAME, "login_button")  # Update with actual button name or ID
    login_button.click()

    # Wait for the login to complete
    time.sleep(5)

    # Check if login was successful (based on an element that appears after login)
    try:
        profile_element = driver.find_element(By.ID, "profile")  # Update with the actual element ID or class
        driver.quit()
        return jsonify({"status": "success", "message": "Login successful"})
    except:
        driver.quit()
        return jsonify({"status": "failure", "message": "Login failed"})

if __name__ == "__main__":
    app.run(debug=True)
