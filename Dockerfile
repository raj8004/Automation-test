# Use Python as the base image
FROM python:3.10-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    default-jdk \
    libnss3 \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Install ChromeDriver
RUN CHROMEDRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -N https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d /usr/local/bin/ && \
    rm ~/chromedriver_linux64.zip

# Set display for headless Chrome
ENV DISPLAY=:99

# Install Selenium Python package
RUN pip install selenium

# Add your app to the container
WORKDIR /app
COPY . /app

# Expose any required ports
EXPOSE 8080

# Command to run your script
CMD ["python", "your_script.py"]
