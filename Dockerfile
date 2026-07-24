FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/index.html
COPY words.txt /usr/share/nginx/html/words.txt
COPY lorem.txt /usr/share/nginx/html/lorem.txt
