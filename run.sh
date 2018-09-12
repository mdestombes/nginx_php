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

# Needed initial web files and directories run check
if [ ! -d /home/config/log ]; then
	mkdir /home/config/log
	[ ! -f /home/web/index.php ] && cp /home/config/index.php /home/web/index.php
	[ ! -f /home/web/error.html ] && cp /home/config/error.html /home/web/error.html
fi

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
