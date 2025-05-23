# Start with a base image
FROM alpine:3.21.3

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apk update


# Install Python and pip
RUN apk add --no-cache python3 py3-pip

RUN python3 -m venv vital_sync

RUN pip install --upgrade pip
# Install the required packages
# . ./vital_sync/bin/activate
RUN pip install "fastapi[standard]"