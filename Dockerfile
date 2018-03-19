# We use alpine as the base, with nginx as a web front-end
FROM alpine:3.5
ENV LANG en_US.UTF-8
COPY root /
ARG FEATURES="nginx"
# envsubst is extracted from gettext
ARG BUILDDEPS="gettext"
ARG buildversion=none

RUN apk --update add --no-cache --virtual .build-deps $BUILDDEPS  \
	&& apk --update add --no-cache $FEATURES  \
	&& mv /usr/bin/envsubst /usr/local/bin/ \
	&& chown -R nginx:nginx /var/www \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& apk del .build-deps

EXPOSE 80 443 

ENTRYPOINT ["/usr/local/bin/nginx-prep.sh"] # put env vars into nginx.conf
CMD ["nginx", "-c", "/etc/nginx/nginx.conf"]
