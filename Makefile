# current dir
curdir := `basename $(shell pwd)`
user := $(shell id -nu)
uid := $(shell id -u)
group := $(shell id -ng)
gid := $(shell id -g)

run:
	make set
	make build
	make vue_init
	make up
	make git_clean
build:
	docker-compose build
up:
	docker-compose up -d
down:
	docker-compose down
yarn_build:
	docker-compose run --rm app yarn build
containers:
	docker container ls -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
stop_all:
	docker ps --format {{.Names}} --filter name=${curdir} | xargs docker stop
image_clean:
	docker images --format "{{.Repository}}" | grep ${curdir} | xargs docker rmi
prune:
	docker system prune -f
include Makefile.firebase
git_clean:
	rm -rf .git*
	git init
	sed -ie 's/.*make set$$//' Makefile        # make setは一度キリ
	sed -ie 's/.*make vue_init$$//' Makefile   # make vue_initも一度キリ
	sed -ie 's/.*make git_clean$$//' Makefile  # make git_cleanも一度キリ
	sed -ie '/^$$/d' Makefile                  # make 空行削除
	cat Makefile | grep -n "^git_clean:" | awk -F : '{print $$1}' | xargs -I @ sed -ie '@,$$d' Makefile # このコマンドから下を全部削除
set:
	sed -i "s/USER=.*/USER=${user}/" .env
	sed -i "s/USER_ID=.*/USER_ID=${uid}/" .env
	sed -i "s/GROUP=.*/GROUP=${group}/" .env
	sed -i "s/GROUP_ID=.*/GROUP_ID=${gid}/" .env
	sed -i "s/APP_NAME=.*/APP_NAME=${curdir}/" .env
vue_init:
	docker-compose run app vue create .
