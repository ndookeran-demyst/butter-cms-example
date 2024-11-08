# Using a specific version of node image based on Debian Bullseye
FROM node:20.18.0-bullseye

# Set an environment variable
ARG MANTA_HOST
ENV MANTA_HOST=${MANTA_HOST}

# Use bash for running shell commands
SHELL ["/bin/bash", "-c"]

# Prepare system and create a non-root user with access to audio and video groups
RUN set -euxo pipefail \
    && groupadd -r pptruser \
    && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

# Change to the non-root user
USER pptruser


# Set working directory
WORKDIR /app

# Copy application files to container
COPY --chown=pptruser:pptruser . /app/

# Install dependencies and build the application
RUN npm install \
    && npm run build

# Expose the port the app runs on
EXPOSE 5000

# Define the default command to run the app
ENTRYPOINT ["yarn"]
CMD ["start"]
