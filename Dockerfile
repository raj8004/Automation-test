
# Step 1: Use the Python base image
FROM python:3.9-slim

# Step 2: Set environment variable to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Step 3: Install dependencies including wget, unzip, curl, and libraries for Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Step 4: Install the latest stable version of Google Chrome
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome.deb && \
    dpkg -i google-chrome.deb || apt-get install -fy && \
    rm google-chrome.deb

# Step 5: Install ChromeDriver matching the installed version of Chrome
RUN LATEST_DRIVER_VERSION=$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE_131) && \
    wget -N https://chromedriver.storage.googleapis.com/$LATEST_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/bin/chromedriver && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Step 6: Set the working directory and copy the application code
WORKDIR /app
COPY . .

# Step 7: Install Python dependencies from the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt

# Step 8: Expose the Flask application port
EXPOSE 5000

# Step 9: Run the Flask application
CMD ["python", "app.py"]
