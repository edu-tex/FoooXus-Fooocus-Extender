# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# Copy the project files from the local directory to the container
COPY . /app

# Set up the virtual environment
RUN python -m venv venv

# Activate virtual environment and install dependencies
RUN /bin/bash -c "source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"

# Copy the .env.docker file into the container
COPY .env.docker /app/.env

# Process the config template using environment variables
RUN envsubst < /app/templates/config.tpl > /app/config.yml

# Expose necessary ports (adjust if needed)
EXPOSE 5000

# Run the application
CMD ["/bin/bash", "-c", "source venv/bin/activate && python foooxus.py"]
