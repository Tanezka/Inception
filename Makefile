all: add_host
	@mkdir -p "$(HOME)/data/wordpress"
	@mkdir -p "$(HOME)/data/mariadb"
	@docker-compose -f ./srcs/docker-compose.yml up

add_host:
	@if ! grep -q "127.0.0.1	tkaraaga.42.fr" /etc/hosts; then \
		echo "127.0.0.1	tkaraaga.42.fr" | sudo tee -a /etc/hosts > /dev/null; \
	fi

clean: down
	@docker system prune -af
	@test -d /home/$(USER)/data && rm -rf /home/$(USER)/data

stop_containers:
	@if [ -n "$$(docker ps -q)" ]; then \
		docker stop $$(docker ps -q); \
	fi

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re:
	@docker-compose -f ./srcs/docker-compose.yml up --build

rm_images:
	@if [ -n "$$(docker images -q)" ]; then \
		docker rmi -f $$(docker images -q); \
	fi

rm_networks:
	@if [ -n "$$(docker network ls --filter type=custom -q)" ]; then \
		docker network rm $$(docker network ls --filter type=custom -q); \
	fi

rm_volumes:
	@if [ -n "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi

rm_containers:
	@if [ -n "$$(docker ps -qa)" ]; then \
		docker rm $$(docker ps -qa); \
	fi

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs -f

.PHONY: all down re clean stop_containers rm_containers rm_images rm_volumes rm_networks add_host logs