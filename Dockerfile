# Step 1: Use a Node.js base image
FROM node:20 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock) files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Build the project
RUN npm run build

# Step 2: Use nginx to serve the application
FROM nginx

# Since your build directory is /dist, modify this line accordingly
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the Docker host, so we can access it 
# from the outside.
EXPOSE 80

# The command to run when the container is started
CMD ["nginx", "-g", "daemon off;"]