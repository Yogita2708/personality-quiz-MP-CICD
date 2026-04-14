# Start from a lightweight web server image
FROM nginx:alpine

# Copy your quiz HTML into nginx's web folder
COPY index.html /usr/share/nginx/html/index.html

# Tell Docker this container listens on port 80
EXPOSE 7000