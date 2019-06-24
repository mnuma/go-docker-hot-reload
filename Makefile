_spanner='spanner://projects/$(PROJECT_ID)/instances/$(INSTANCE)/databases/mnuma' -path ./migrations
# migrate=docker run -v `pwd`:/srv -w /srv --link mysqldemo migrate/migrate:latest

setup:
	docker run -v `pwd`:/go/app -w /go/app golang:1.12-alpine go mod init app

build:
	docker-compose build --no-cache

modcache:
	go clean -modcache

start-server:
	docker-compose up -d
	make watch-logs

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

migrate-prepare-go:
	go get -u -d github.com/golang-migrate/migrate/cli
	migrate --version

migrate-create: ## ex: make migrate-create NAME=create_users
	migrate create -ext sql -dir migrations ${NAME}

migrate-up:
	migrate -database $(_spanner) up
	make migrate-version

migrate-up-1:
	migrate -database $(_spanner) up 1
	make migrate-version

migrate-down-1:
	migrate -database $(_spanner) down 1
	make migrate-version

migrate-version:
	migrate -database $(_spanner) version

migrate-force: # make migrate-force V=20190620072805
	migrate -database $(_spanner) force ${V}
