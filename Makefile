run:
	@docker-compose up

install:
	@docker-compose run web_mn bundle install

update:
	@docker-compose run web_mn bundle update

create:
	@docker-compose run --rm web_mn bundle exec rake db:create

migrate:
	@docker-compose run --rm web_mn rake db:migrate

seed:
	@docker-compose run --rm web_mn rake db:seed

setup:
	@docker-compose run --rm web_mn rake db:migrate db:seed

console:
	@docker-compose run --rm web_mn rails console

reset:
	@docker-compose run --rm web_mn rake db:drop db:create db:migrate db:seed

pry:
	@docker-compose run --service-ports web_mn
