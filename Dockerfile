# We use alpine as the base, with nginx as a web front-end
FROM alpine:3.5 
ENV LANG en_US.UTF-8
ARG PACKAGES="nginx"

COPY root /

RUN apk --update add --no-cache $PACKAGES && \
 ln -sf /dev/stdout /var/log/nginx/access.log && \
 ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
