# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy application files to the container
COPY . /app

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app runs on
EXPOSE 8080

# Command to run the Flask app
CMD ["python", "app.py"]
