# NGINX server with PHP maagement

Docker build for create a basic Nginx server with PHP interpreter.

## Features
 - Easy install
 - Easy access to web file directory
 - `Docker stop` is a clean stop 

## Usage
Fast & Easy server setup:  
  `docker run -d -p 8080:80 --name web_server mdestombes/nginx_php`

You can map your web directory:  
  `docker run -d -p 8080:80 -v /my/path/to/web/directory:/home/web:rw --name web_server mdestombes/nginx_php`

---

## Recommended Usage
 - First run  
  `docker run -d -p 8080:80 -v /my/path/to/web/directory:/home/web:rw --name web_server mdestombes/nginx_php`

---

## Variables
+ __TZ__
Time Zone : Set the container timezone (for crontab). (You can get your timezone posix format with the command `tzselect`. For example, France is "Europe/Paris").

---

## Volumes
+ __/home/web__: Working directory

---

## Expose
+ Port: __80__: HTML port

---

## Known issues

---

## Changelog
+ 1.0:
  - Initial image
