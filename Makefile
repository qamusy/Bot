ruby = $(shell docker ps -qf label=qamusy-bot=ruby)
stack = $(shell docker ps -qf label=qamusy-bot)
init:
	docker-compose up -d
bundle:
	docker exec -it $(ruby) apk --update add gcc g++ postgresql-dev make
	docker exec -it $(ruby) bundle install
migrate:
	docker exec -it $(ruby) rake db:migrate
bootstrap: bundle migrate
clean:
	docker rm -f $(stack)
