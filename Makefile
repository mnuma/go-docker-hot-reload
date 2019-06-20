go-mod-init:
	docker run -v `pwd`:/go/app -w /go/app golang:1.12-alpine go mod init app

build:
	@echo "Build App..."
	docker-compose build

start-server:
	@echo "Running Server..."
	docker-compose up

stop-server:
	@echo "Stop Server..."
	docker-compose down

watch-logs:
	docker-compose logs -f

clean:
	docker system prune -f
	docker volume prune -f

test:
	 docker-compose -f docker-compose-test.yml run unittest
