#!/bin/bash

# Function to check if a command exists
is_installed() {
    command -v "$1" &> /dev/null
}

echo "--- Starting System Check and Installation ---"

# 1. Docker
if is_installed docker; then
    echo "✅ Docker is already installed."
else
    echo "⏳ Installing Docker..."
    sudo apt-get update && sudo apt-get install -y docker.io
fi

# 2. Docker Compose
if is_installed docker-compose; then
    echo "✅ Docker Compose is already installed."
else
    echo "⏳ Installing Docker Compose..."
    sudo apt-get install -y docker-compose
fi

# 3. Python 3
if is_installed python3; then
    echo "✅ Python3 is present: $(python3 --version)"
else
    echo "⏳ Installing Python3..."
    sudo apt-get install -y python3
fi

# 4. Django
if python3 -m django --version &> /dev/null; then
    echo "✅ Django is already installed."
else
    echo "⏳ Installing Django via pip..."
    pip3 install django
fi

echo "--- All tasks completed! ---"