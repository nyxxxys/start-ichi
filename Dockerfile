# Stage 1: Build the React application
FROM node:18-alpine as build-frontend
WORKDIR /app/client
COPY app/client/package*.json ./
RUN npm install
COPY app/client ./
RUN npm run build

# Stage 2: Set up the Flask application
FROM python:3.10-slim
WORKDIR /app

# Copy requirements and install dependencies
COPY app/server/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask app
COPY app/server ./

# Copy the built React app from the previous stage
COPY --from=build-frontend /app/client/build ./client/build

# Create data directory
RUN mkdir -p /app/data

# Set the working directory where data.json will be stored
ENV DATA_FILE=/app/data/data.json

# Expose port
EXPOSE 5000

# Start Flask app
CMD ["python", "app.py"] 