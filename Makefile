dev:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml up rails webpacker
bide:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml build ide
ride:
	docker-compose -f docker-compose.yml -f docker-compose.dev.yml run ide

deploy_build:
	docker-compose -f docker-compose-deploy.yml build blue


