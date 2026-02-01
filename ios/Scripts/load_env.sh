#!/bin/bash

# Load environment variables from .env file
ENV_FILE="${SRCROOT}/../../.env"

if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from .env"

    # Read .env file and export variables
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        if [[ ! $key =~ ^# && -n $key ]]; then
            # Remove leading/trailing whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)

            # Export variable
            export "$key=$value"
            echo "Loaded: $key"
        fi
    done < "$ENV_FILE"
else
    echo "Warning: .env file not found at $ENV_FILE"
    echo "Using default values"
fi
