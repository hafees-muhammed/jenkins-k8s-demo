FROM nginx:1.27

COPY app/index.html /usr/share/nginx/html/

COPY app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

