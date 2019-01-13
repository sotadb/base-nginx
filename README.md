# base-nginx

[![](https://images.microbadger.com/badges/image/sotadb/base-nginx.svg)](https://microbadger.com/images/sotadb/base-nginx "Get your own image badge on microbadger.com")


This is the stripped down nginx container used by SotADB.info for serving 
static files. Because this is designed to operation behind Kubernetes' 
ingress load balancer, it does not use HTTPS. It's an Alpine 3.5 image 
containing the following:

 * nginx

