FROM ubuntu:22.04

RUN apt update && apt install -y apache2 w3m nano

COPY mysite.vlinux.se.conf /etc/apache2/sites-available/mysite.vlinux.se.conf

RUN a2ensite mysite.vlinux.se.conf

RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

CMD apachectl -D FOREGROUND
