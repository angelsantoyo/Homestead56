###!/usr/bin/env bash

  mkdir /etc/nginx/ssl 2>/dev/null
  openssl genrsa -out "/etc/nginx/ssl/$1.key" 2048 2>/dev/null
  openssl req -new -key /etc/nginx/ssl/$1.key -out /etc/nginx/ssl/$1.csr -subj "/CN=$1/O=Vagrant/C=UK" 2>/dev/null
  openssl x509 -req -days 365 -in /etc/nginx/ssl/$1.csr -signkey /etc/nginx/ssl/$1.key -out /etc/nginx/ssl/$1.crt 2>/dev/null

  block="
###################################################
#
# Provided by the Magento Support Center
# http://magentosupport.help/knowledgebase/configuring-nginx-to-work-with-magento-advanced/
#
# Your Magento Tutorial specialists
#
server {
    listen ${3:-80} default;
    server_name  $1;
    root \"$2\";

    access_log /var/log/nginx/magento-access_log;
    error_log /var/log/nginx/magento-error_log;

    location / {
            	index index.php;
            	if (\$request_uri ~* \"\\.(ico|css|js|gif|jpe?g|png)\$\") {
                		access_log off;
                		expires max;
            	}
            	try_files \$uri \$uri/ @handler;
        	}

        	location /app/                       { deny all; }
        	location /includes/                  { deny all; }
        	location /lib/                       { deny all; }
        	location /media/downloadable/        { deny all; }
        	location /pkginfo/                   { deny all; }
        	location /report/config.xml          { deny all; }
        	location /var/                       { deny all; }
    	location /lib/minify/ 		     { allow all; }

        	location /var/export/ {
            	auth_basic              "Restricted";
            	auth_basic_user_file    htpasswd;
            	autoindex               on;
        	}

    	location @handler {
            	rewrite ^(.*) /index.php?\$1 last;
        	}

    	fastcgi_intercept_errors on;

    	location ~ \\.php\$ {
    		fastcgi_split_path_info ^(.+\\.php)(/.+)\$;

        		include fastcgi_params;
    		fastcgi_param   SCRIPT_FILENAME    \$document_root\$fastcgi_script_name;
            	fastcgi_param   SCRIPT_NAME        \$fastcgi_script_name;

        		fastcgi_index index.php;
        		fastcgi_pass unix:/var/run/php5-fpm.sock;
    	}
}"

 echo "$block" > "/etc/nginx/sites-available/$1"
 ln -fs "/etc/nginx/sites-available/$1" "/etc/nginx/sites-enabled/$1"
 service nginx restart
 service php5-fpm restart