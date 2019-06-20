setup:
	docker run -v `pwd`:/go/app -w /go/app golang:1.12-alpine go mod init app

build:
	docker-compose build --no-cache

start-server:
	docker-compose up

stop-server:
	docker-compose down

watch-logs:
	docker-compose logs -f

monitor-redis:
	docker exec -it redis redis-cli monitor

test:
	docker-compose -f docker-compose-test.yml run unittest

clean:
	docker system df
	@docker-compose rm
	@docker system prune -f
	@docker volume prune -f
	docker system df
