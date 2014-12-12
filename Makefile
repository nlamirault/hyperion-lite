# Copyright (C) 2014  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

NAME=hyperion-lite
CONTAINER=nlamirault/$(NAME)

DOCKER_HYPERION=/var/docker/$(NAME)

VERSION=$(shell \
        grep "\# VERSION" Dockerfile \
	|awk -F' ' '{print $$3}')

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

DOCKER = docker
DOCKER_MACHINE_URI=https://github.com/docker/machine/releases/download
DOCKER_MACHINE_VERSION=0.0.1
FIG_URI=https://github.com/docker/fig/releases/download
FIG_VERSION=1.0.1

all: help

help:
	@echo -e "$(OK_COLOR)==== $(NAME) [$(VERSION)] ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- setup     : Creates directories used by Hyperion"
	@echo -e "$(WARN_COLOR)- build     : Make the Docker image"
	@echo -e "$(WARN_COLOR)- start     : Start a container"
	@echo -e "$(WARN_COLOR)- stop      : Stop the container"
	@echo -e "$(WARN_COLOR)- publish   : Publish the image"

setup:
	@echo "Creates $(DOCKER_HYPERION) directories on host"
	sudo mkdir -p $(DOCKER_HYPERION)/elasticsearch
	sudo mkdir -p $(DOCKER_HYPERION)/graphite
	sudo mkdir -p $(DOCKER_HYPERION)/supervisor
	sudo mkdir -p $(DOCKER_HYPERION)/nginx
	sudo mkdir -p $(DOCKER_HYPERION)/redis
	sudo chmod -R 777 $(DOCKER_HYPERION)/elasticsearch

init:
	@echo -e "$(OK_COLOR)[$(APP)] Initialisation de l'environnement$(NO_COLOR)"
	@wget $(DOCKER_MACHINE_URI)/$(DOCKER_MACHINE_VERSION)/linux -O machine
	@chmod +x ./machine
	@curl -Ls $(FIG_URI)/$(FIG_VERSION)/fig-`uname -s`-`uname -m` > ./fig
	@chmod +x ./fig

destroy:
	@echo -e "Destroying $(DOCKER_HYPERION) directory on host"
	@sudo rm -fr $(DOCKER_HYPERION)

reset: destroy setup

build:
	@echo -e "$(OK_COLOR) Build $(CONTAINER):$(VERSION)$(NO_COLOR)"
	@$(DOCKER) build -t $(CONTAINER):$(VERSION) .

start:
	client/hyperion.sh start

stop:
	client/hyperion.sh stop

publish:

	@$(DOCKER) publish $(CONTAINER):$(VERSION)

clean:
	@echo -e "$(OK_COLOR)[$(NAME)] Nettoyage de l'environnement$(NO_COLOR)"
	client/hyperion.sh clean
	rm -f machine
