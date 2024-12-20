from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options

app = Flask(__name__)

@app.route('/api/login', methods=['POST'])
def login():
    try:
        # Get email and password from frontend request
        data = request.json
        email = data.get('email')
        password = data.get('password')

        if not email or not password:
            return jsonify({"status": False, "message": "Email and password are required"}), 400

        # Set up Selenium WebDriver
        chrome_options = Options()
        chrome_options.add_argument("--headless")  # Run in headless mode (no browser UI)
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")

        driver = webdriver.Chrome(options=chrome_options)

        try:
            # Open Facebook login page
            driver.get("https://www.facebook.com/")

            # Find and fill the email field
            email_field = driver.find_element(By.ID, "email")
            email_field.send_keys(email)

            # Find and fill the password field
            password_field = driver.find_element(By.ID, "pass")
            password_field.send_keys(password)

            # Click the login button
            login_button = driver.find_element(By.NAME, "login")
            login_button.click()

            # Wait for the page to load and check for success or error
            driver.implicitly_wait(5)

            # Example success check (modify this based on actual Facebook structure)
            if "Home" in driver.title:
                message = "Login successful"
                status = True
            else:
                message = "Login failed. Please check your credentials."
                status = False

        except Exception as e:
            driver.quit()
            return jsonify({"status": False, "message": f"An error occurred: {str(e)}"}), 500

        finally:
            # Close the browser
            driver.quit()

        # Return success or error message to frontend
        return jsonify({"status": status, "message": message})

    except Exception as e:
        return jsonify({"status": False, "message": f"An unexpected error occurred: {str(e)}"}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)