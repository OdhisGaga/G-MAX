
# Use the official Node.js LTS Buster image as base
FROM node:lts-buster

# Set working directory
WORKDIR /app

# Update package sources to use the Debian archive (Buster repositories have moved)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
 && sed -i '/security/d' /etc/apt/sources.list \
 && apt-get -o Acquire::Check-Valid-Until=false update \
 && apt-get -o Acquire::Check-Valid-Until=false install -y ffmpeg imagemagick webp \
 && apt-get -o Acquire::Check-Valid-Until=false upgrade -y \
 && npm install --global pm2 \
 && rm -rf /var/lib/apt/lists/*

# Copy package.json and package-lock.json for dependency installation
COPY package.json package-lock.json./

# Install app dependencies
RUN npm ci

# Copy the rest of your application code
COPY ..

# Expose port (adjust if your app uses a different one)
EXPOSE 3000

# Start the app using pm2-runtime
CMD ["pm2-runtime", "start", "richgaga.js"]
```
