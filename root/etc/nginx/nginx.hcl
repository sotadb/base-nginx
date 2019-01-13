user nginx;
worker_processes 4;
pid /var/run/nginx.pid;
daemon off;

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
        access_log /var/log/nginx/access.log combined if=$log_ip;
        error_log  /var/log/nginx/error.log;
        default_type application/octet-stream;

        include /etc/nginx/mime.types;

	server {
		listen	80 default_server;

		keepalive_timeout 80s;
		server_name localhost;
		charset     utf-8;
		client_max_body_size 75M;
		root /var/www/;

	}
}
