include Makefile.firebase

# current dir
curdir := `basename $(shell pwd)`
user := $(shell id -nu)
uid := $(shell id -u)
group := $(shell id -ng)
gid := $(shell id -g)

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
clean:
	rm -rf .git*
	cat Makefile | grep -n "^clean:" | awk -F : '{print $$1}' | xargs -I @ sed -ie '@,$$d' Makefile # このコマンドから下を全部削除
set:
	sed -i "s/USER=.*/USER=${user}/" .env
	sed -i "s/USER_ID=.*/USER_ID=${uid}/" .env
	sed -i "s/GROUP=.*/GROUP=${group}/" .env
	sed -i "s/GROUP_ID=.*/GROUP_ID=${gid}/" .env
	sed -i "s/APP_NAME=.*/APP_NAME=${curdir}/" .env
vue_init:
	docker-compose run app vue create .
git_init:
	git init
	git config --local user.name "$(GIT_USER)"
	git config --local user.email "$(GIT_EMAIL)"
init:
	make set
	make build
	make vue_init
	make up
	make git_init
	make clean
