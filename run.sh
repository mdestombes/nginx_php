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

# Needed initial configuration
[ ! -d /home/web/private/config ] && mkdir -p /home/web/private/config
[ ! -f /home/web/private/config/nginx.default.conf ] && cp /home/config/nginx.default.conf /home/web/private/config/nginx.default.conf
[ ! -f /home/web/private/config/www.php.ini ] && cp /home/config/www.php.ini /home/web/private/config/www.php.ini
[ ! -f /home/web/private/config/www.php.conf ] && cp /home/config/www.php.conf /home/web/private/config/www.php.conf
[ ! -f /home/web/private/config/logrotate ] && cp /home/config/logrotate /home/web/private/config/logrotate

# Nedded log directory
[ ! -d /home/web/private/log ] && mkdir -p /home/web/private/log
[ ! -f /home/web/private/log/error.log ] && touch /home/web/private/log/error.log
[ ! -f /home/web/private/log/host.access.log ] && touch /home/web/private/log/host.access.log

# Overwrite configuration
cp /home/web/private/config/nginx.default.conf /etc/nginx/conf.d/default.conf
cp /home/web/private/config/www.php.ini /etc/php/7.0/fpm/php.ini
cp /home/web/private/config/www.php.conf /etc/php/7.0/fpm/pool.d/www.conf
cp /home/web/private/config/logrotate /etc/logrotate.d/nginx

# Change owner for web directory
chown www-data:www-data -R /home/web

# Change acces for logrotate
chmod 644 /etc/logrotate.d/nginx
chown root:root /etc/logrotate.d/nginx

# Start web service
echo "[Web service start]"
service nginx start
service php7.0-fpm start

# Start CRON
service cron start

# Stop server in case of signal INT or TERM
echo "Waiting..."
trap stop INT
trap stop TERM

read < /tmp/FIFO &
wait
