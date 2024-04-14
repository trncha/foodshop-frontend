# Stage 1: Build the React application
FROM node:18-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Serve the application using serve
FROM node:18-alpine

WORKDIR /app

# Install serve - A static file serving and directory listing server
RUN npm install -g serve

# Copy the build output from the previous stage
COPY --from=build /app/dist /app

# Serve the static files
CMD ["serve", "-s", "/app", "-l", "80"]
