FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y wget unzip curl \
    && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip && mv chromedriver /usr/bin/

# Set the working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Run the application
CMD ["python", "app.py"]