# We use alpine as the base, with nginx as a web front-end
FROM sotadb/containerpilot
COPY root /
ARG PACKAGES="nginx curl acme-client openssl"

RUN apk --update add --no-cache $PACKAGES && \
 rmdir /var/www/acme && \
 ln -s /acme/keys /etc/ssl/acme && \
 ln -s /acme/challange /var/www/acme && \
 ln -sf /dev/stdout /var/log/nginx/access.log && \
 ln -sf /dev/stderr /var/log/nginx/error.log

# This volume should be shared amongst nginx servers. It stores our keys 
# and challanges.
VOLUME ["/acme"]

EXPOSE 80 443 

