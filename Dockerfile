# We use alpine as the base, with nginx as a web front-end
FROM sotadb/containerpilot
COPY root /
ARG PACKAGES="nginx curl acme-client openssl"

RUN apk --update add --no-cache $PACKAGES && \
 mkdir -p /etc/nginx/ssl && \
 mkdir -p /var/www/acme && \
 chown -R nginx:nginx /var/www && \
 ln -sf /dev/stdout /var/log/nginx/access.log && \
 ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443 

