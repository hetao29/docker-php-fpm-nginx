build:
	docker build . -t hetao29/docker-php-fpm-nginx:latest
push:
	docker tag hetao29/php-fpm-nginx:latest hetao29/docker-php-fpm-nginx:1.0.0
	docker push -a hetao29/docker-php-fpm-nginx
start:
	docker stack deploy --with-registry-auth -c docker-compose.yml php-fpm
stop:
	docker stack rm php-fpm
