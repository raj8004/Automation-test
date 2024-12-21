from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Configure Chrome options for headless mode
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")

# Set up the ChromeDriver service
service = Service("/usr/local/bin/chromedriver")

# Initialize the WebDriver
driver = webdriver.Chrome(service=service, options=chrome_options)

# Example: Open a website
driver.get("https://www.google.com")
print("Title:", driver.title)

# Close the browser
driver.quit()
