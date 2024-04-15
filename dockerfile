# # Stage 1: Build the React application
# FROM node:18-alpine as build

# ARG VITE_BACKEND_URL
# # Set the working directory in the Docker image
# WORKDIR /app

# # Copy package.json and package-lock.json (or yarn.lock) files
# COPY package*.json ./

# # Install all dependencies
# RUN npm install

# # Copy the rest of your application's source code
# COPY . .

# ENV VITE_BACKEND_URL=$VITE_BACKEND_URL

# # Build the application
# RUN npm run build

# # Stage 2: Serve the application using Nginx
# FROM nginx:stable-alpine

# # Set the working directory to nginx asset directory
# WORKDIR /usr/share/nginx/html

# # Remove default nginx static assets
# RUN rm -rf ./*

# COPY default.conf /etc/nginx/conf.d/default.conf

# # Copy static assets from builder stage
# COPY --from=build /app/dist .

# # Containers run nginx with global directives and daemon off
# ENTRYPOINT ["nginx", "-g", "daemon off;"]

# ---- Base Node ----
FROM node:18-alpine AS base
# set working directory
WORKDIR /app
# Set environment variables
ENV NODE_ENV=production
# Copy package.json and lock file
COPY package*.json ./

# ---- Dependencies ----
FROM base AS dependencies
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm install --only=production 
# Copy production node_modules aside
RUN cp -R node_modules prod_node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install

# ---- Build ----
FROM dependencies AS build
COPY . .
# Build static assets
RUN npx vite build

# --- Release with Alpine ----
FROM base AS release
# Copy production node_modules
COPY --from=dependencies /app/prod_node_modules ./node_modules
# Copy built static assets from the build stage
COPY --from=build /app/dist ./dist
# Expose the port the app runs on
EXPOSE 3000
# Command to run the app
CMD [ "npm", "start" ]
