
{{ $acme_ready := file "/acme/keys/configured"|parseInt }}
user nginx;
worker_processes 4;
pid /var/run/nginx.pid;
daemon off;

events {
	worker_connections 768;
	# multi_accept on;
}


http {

	# filter for access logs. We don't want to log the health-checks!
	map $remote_addr $log_ip {
		"127.0.0.1" 0;
		default 1;
	}

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        server_tokens off;
        access_log /var/log/nginx/access.log combined if=$log_ip;
        error_log  /var/log/nginx/error.log;
        gzip on;
        gzip_disable "msie6";
        default_type application/octet-stream;

        include /etc/nginx/mime.types;

	server {
		listen	80 default_server;

		add_header X-Frame-Options "DENY";
		add_header X-XSS-Protection "1; mode=block";
		add_header X-Content-Type-Options "nosniff";

		keepalive_timeout 80s;
		server_name localhost;
		charset     utf-8;
		client_max_body_size 75M;
		root /var/www/;

		{{ if $acme_ready }}
		return 301 https://$host$request_uri;
		{{ end }}

		location ^~ /.well-known/acme-challenge/ {
			alias /acme/challange;
		}
		
		location /nginx-health {
			stub_status;
			allow 127.0.0.1;
			deny all;
		}
	}

{{ if $acme_ready }}
	server {
		listen 443 ssl http2;
		ssl_certificate /acme/keys/fullchain.pem;
                ssl_certificate_key /acme/keys/key.pem;
                ssl_session_cache shared:SSL:10m;
                ssl_protocols TLSv1.1 TLSv1.2;

		ssl_ciphers '-ALL:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA:ECDHE-ECDSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384::DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256';
		ssl_prefer_server_ciphers on;
		ssl_dhparam /acme/keys/dhparams.pem;
		ssl_stapling on;
		ssl_stapling_verify on;


		add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";
		add_header X-Frame-Options "DENY"; 
		add_header X-XSS-Protection "1; mode=block"; 
		add_header X-Content-Type-Options "nosniff"; 
		add_header Content-Security-Policy "default-src 'self';";

		keepalive_timeout 80s; 
		server_name localhost; 
		charset utf-8; 
		client_max_body_size 75M; 
		root /var/www/;
		
		location ^~ /.well-known/acme-challenge/ {
			alias /acme/challange;
		}

		{{ if service "consul" }}
		location /ui{
			add_header Content-Security-Policy "default-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' 'unsafe-inline'";
			proxy_pass http://127.0.0.1:8500/ui;
		}
		location /v1{
			proxy_pass http://127.0.0.1:8500/v1;
		}
		{{ end }}

		location /nginx-health {
			stub_status;
			allow 127.0.0.1;
			deny all;
		}
	}
{{ end }}
}
