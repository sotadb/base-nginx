# nginx

[![](https://images.microbadger.com/badges/image/sotadb/nginx.svg)](https://microbadger.com/images/sotadb/nginx "Get your own image badge on microbadger.com")


This is the self-configuring nginx container used by SotADB.info. It is 
configured to serve HTTPS using auto-obtained keys from 
[Let's Encrypt](https://letsencrypt.org/). It's an Alpine 3.5 image containing 
the following:

 * Consul agent
 * Consul-template
 * ContainerPilot
 * nginx
 * acme-client

