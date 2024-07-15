FROM alpine:3.20
LABEL maintainer="Hetao<hetao@hetao.name>"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk update \
	&& apk add tzdata  \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "Asia/Shanghai" > /etc/timezone

#php extensions-83
RUN apk add curl supervisor nginx php83-pear php83-dev php83-fpm php83-imap php83-mbstring php83-common php83-ldap php83-pdo_mysql php83-mysqlnd php83-mysqli php83-bcmath php83-curl php83-opcache php83-gd php83-xml php83-simplexml php83-intl php83-iconv php83-openssl php83-session php83-zip php83-ftp php83-pcntl php83-sockets php83-gettext php83-exif php83-tokenizer php83-sysvsem php83-calendar php83-dom php83-posix php83-fileinfo php83-phar php83-xmlreader php83-xmlwriter php83-sysvmsg php83-shmop php83-ctype php83-bz2 php83-dba php83-ffi php83-gmp php83-sysvshm

#php pecl extensions-83
RUN apk add php83-pecl-grpc php83-pecl-redis php83-pecl-imagick php83-pecl-swoole php83-pecl-mcrypt

WORKDIR /var/www/html

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/conf.d /etc/nginx/conf.d/
COPY config/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY config/php.ini /etc/php83/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx
USER nobody
COPY --chown=nobody www/ /var/www/html/
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping || exit 1
