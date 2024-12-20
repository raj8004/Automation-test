# Use Python 3.9 as the base image
FROM python:3.9-slim

# Install necessary dependencies for running Selenium with Chrome
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    gnupg \
    ca-certificates \
    libx11-dev \
    libxcomposite-dev \
    libxrandr-dev \
    libgtk-3-dev \
    libgbm-dev \
    libasound2 \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libindicator3-7 \
    libpango1.0-0 \
    libgdk-pixbuf2.0-0 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

# Install Google Chrome (latest version)
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# Install ChromeDriver (download the latest stable version)
RUN CHROME_DRIVER_VERSION=`curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && wget https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

# Set up working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app will run on
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "app.py"]
