TAG_PREFIX = lfex/

all: clean build-all

build-all: opensuse debian ubuntu arch centos oracle

setup:
	@echo "Run the following in your shell:"
	@echo '  $$(boot2docker shellinit)'

.PHONY: setup opensuse debian ubuntu arch slackware centos oracle

push: clean push-all

push-all: push-opensuse push-debian push-ubuntu push-arch push-centos push-oracle

clean:
	@docker rm $(shell docker ps -a -q)
	@docker rmi $(shell docker images -q --filter 'dangling=true')

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# openSUSE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

opensuse: TAG = $(TAG_PREFIX)opensuse
opensuse:
	@docker build -t $(TAG) opensuse

check-opensuse: TAG = $(TAG_PREFIX)opensuse
check-opensuse:
	@docker run -t $(TAG)

lfe-opensuse: TAG = $(TAG_PREFIX)opensuse
lfe-opensuse:
	@docker run -i -t $(TAG) lfe

bash-opensuse: TAG = $(TAG_PREFIX)opensuse
bash-opensuse:
	@docker run -i -t $(TAG) bash

push-opensuse: TAG = $(TAG_PREFIX)opensuse
push-opensuse:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Debian
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

debian: TAG = $(TAG_PREFIX)debian
debian:
	@docker build -t $(TAG) debian

check-debian: TAG = $(TAG_PREFIX)debian
check-debian:
	@docker run -t $(TAG)

lfe-debian: TAG = $(TAG_PREFIX)debian
lfe-debian:
	@docker run -i -t $(TAG) lfe

bash-debian: TAG = $(TAG_PREFIX)debian
bash-debian:
	@docker run -i -t $(TAG) bash

push-debian: TAG = $(TAG_PREFIX)debian
push-debian:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ubuntu
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ubuntu: TAG = $(TAG_PREFIX)ubuntu
ubuntu:
	@docker build -t $(TAG) ubuntu

check-ubuntu: TAG = $(TAG_PREFIX)ubuntu
check-ubuntu:
	@docker run -t $(TAG)

lfe-ubuntu: TAG = $(TAG_PREFIX)ubuntu
lfe-ubuntu:
	@docker run -i -t $(TAG) lfe

bash-ubuntu: TAG = $(TAG_PREFIX)ubuntu
bash-ubuntu:
	@docker run -i -t $(TAG) bash

push-ubuntu: TAG = $(TAG_PREFIX)ubuntu
push-ubuntu:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Arch
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

arch: TAG = $(TAG_PREFIX)arch
arch:
	@docker build -t $(TAG) arch

check-arch: TAG = $(TAG_PREFIX)arch
check-arch:
	@docker run -t $(TAG)

lfe-arch: TAG = $(TAG_PREFIX)arch
lfe-arch:
	@docker run -i -t $(TAG) lfe

bash-arch: TAG = $(TAG_PREFIX)arch
bash-arch:
	@docker run -i -t $(TAG) bash

push-arch: TAG = $(TAG_PREFIX)arch
push-arch:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Slackware
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

slackware: TAG = $(TAG_PREFIX)slackware
slackware:
	@docker build -t $(TAG) slackware

check-slackware: TAG = $(TAG_PREFIX)slackware
check-slackware:
	@docker run -t $(TAG)

lfe-slackware: TAG = $(TAG_PREFIX)slackware
lfe-slackware:
	@docker run -i -t $(TAG) lfe

bash-slackware: TAG = $(TAG_PREFIX)slackware
bash-slackware:
	@docker run -i -t $(TAG) bash

push-slackware: TAG = $(TAG_PREFIX)slackware
push-slackware:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CentOS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

centos: TAG = $(TAG_PREFIX)centos
centos:
	@docker build -t $(TAG) centos

check-centos: TAG = $(TAG_PREFIX)centos
check-centos:
	@docker run -t $(TAG)

lfe-centos: TAG = $(TAG_PREFIX)centos
lfe-centos:
	@docker run -i -t $(TAG) lfe

bash-centos: TAG = $(TAG_PREFIX)centos
bash-centos:
	@docker run -i -t $(TAG) bash

push-centos: TAG = $(TAG_PREFIX)centos
push-centos:
	@docker push $(TAG)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Oracle Linux
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

oracle: TAG = $(TAG_PREFIX)oracle
oracle:
	@docker build -t $(TAG) oracle

check-oracle: TAG = $(TAG_PREFIX)oracle
check-oracle:
	@docker run -t $(TAG)

lfe-oracle: TAG = $(TAG_PREFIX)oracle
lfe-oracle:
	@docker run -i -t $(TAG) lfe

bash-oracle: TAG = $(TAG_PREFIX)oracle
bash-oracle:
	@docker run -i -t $(TAG) bash

push-oracle: TAG = $(TAG_PREFIX)oracle
push-oracle:
	@docker push $(TAG)

