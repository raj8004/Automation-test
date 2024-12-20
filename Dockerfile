# Use the official Python 3.9 image as the base image
FROM python:3.9-slim

# Install necessary dependencies for Google Chrome and ChromeDriver
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
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome 114
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable=114.0.5735.90-1 && \
    apt-get clean

# Install ChromeDriver 114.0.5735.90
RUN LATEST_DRIVER_VERSION=$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE_114) && \
    wget -N https://chromedriver.storage.googleapis.com/$LATEST_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variables for Chrome
ENV PATH=$PATH:/usr/local/bin

# Copy the rest of the application code into the container
COPY . /app

# Expose the port that the Flask app will run on
EXPOSE 8080

# Run the application when the container starts
CMD ["python", "app.py"]
