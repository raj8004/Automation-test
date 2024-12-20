# Use the official Python image
FROM python:3.9-slim

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libnss3 \
    libgconf-2-4 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libatk1.0-0 \
    libcups2 \
    libxrandr2 \
    libasound2 \
    libgtk-3-0 \
    libgbm-dev \
    libxshmfence-dev \
    fonts-liberation \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome.deb && \
    dpkg -i google-chrome.deb || apt-get install -fy && \
    rm google-chrome.deb

# Set the ChromeDriver version to match the installed Chrome version (131)
ENV CHROME_DRIVER_VERSION=131.0.6778.204

# Print the ChromeDriver version for debugging purposes
RUN echo "ChromeDriver Version: $CHROME_DRIVER_VERSION"

# Download and install ChromeDriver
RUN wget -N https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip \
    || { echo 'Failed to download or unzip ChromeDriver'; exit 1; }

# Copy the project files into the container
WORKDIR /app
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5000

# Command to run the Flask app
CMD ["python", "app.py"]
