user nginx;
worker_processes 4;
pid /var/run/nginx.pid;

events {
	worker_connections 768;
	# multi_accept on;
}

http {
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        server_tokens off;
        access_log /var/log/nginx/access.log;
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
		#add_header Content-Security-Policy "default-src 'self'; img-src 'self'; script-src 'self'; font-src 'self'; style-src 'self'; child-src 'self'";

		keepalive_timeout 80s;
		server_name localhost;
		charset     utf-8;
		client_max_body_size 75M;

		# Proxy the console server's UI
		{{if service "consul"}}
		location /consul-status{
			proxy_pass http://127.0.0.1:8500/ui;
		}

		location /v1{
			proxy_pass http://127.0.0.1:8500/v1;
		}
		{{end}}

		# Used to check the health of nginx
		location /nginx-health {
			stub_status;
			allow 127.0.0.1;
			deny all;
		}
	}

}
daemon off;
