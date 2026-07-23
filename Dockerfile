FROM nginx:1.27-alpine

COPY passgen.html /usr/share/nginx/html/index.html
