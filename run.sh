#!/usr/bin/env bash
echo "###########################################################################"
echo "# Web Server - " `date`
echo "###########################################################################"
[ -p /tmp/FIFO ] && rm /tmp/FIFO
mkfifo /tmp/FIFO

export TERM=linux

function stop {
	echo "[Web service stop]"
	service nginx stop
	service php7.0-fpm stop

	exit
}

# Stop web service
echo "[Web service stop]"
service nginx stop
service php7.0-fpm stop

# Needed initial web files and directories run check
[ ! -d /home/web/public ] && mkdir -p /home/web/public
[ ! -f /home/web/public/index.php ] && cp /home/config/index.php /home/web/public/index.php
[ ! -f /home/web/public/error.html ] && cp /home/config/error.html /home/web/public/error.html

[ ! -d /home/web/private/config ] && mkdir -p /home/web/private/config
[ ! -f /home/web/private/config/nginx.default.conf ] && cp /home/config/nginx.default.conf /home/web/private/config/nginx.default.conf
[ ! -f /home/web/private/config/www.php.ini ] && cp /home/config/www.php.ini /home/web/private/config/www.php.ini
[ ! -f /home/web/private/config/www.php.conf ] && cp /home/config/www.php.conf /home/web/private/config/www.php.conf

[ ! -d /home/web/private/log ] && mkdir -p /home/web/private/log

# Overwrite configuration
cp /home/web/private/config/nginx.default.conf /etc/nginx/conf.d/default.conf
cp /home/web/private/config/www.php.ini /etc/php/7.0/fpm/php.ini
cp /home/web/private/config/www.php.conf /etc/php/7.0/fpm/pool.d/www.conf

# Give acces R/W to web directoty
chown www-data:www-data -R /home/web

# Give acces R/W to web directoty
chown www-data:www-data -R /home/web

# Start web service
echo "[Web service start]"
service nginx start
service php7.0-fpm start

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
