FROM nginx:1.19-alpine

RUN adduser -S -G www-data www-data
RUN echo "upstream php-upstream { server phpfpm:9000; }" > /etc/nginx/conf.d/upstream.conf

WORKDIR /var/www/app