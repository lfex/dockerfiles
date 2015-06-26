TAG_PREFIX = lfex/

all: clean build-all

build-all: opensuse debian ubuntu arch centos oracle raspbian

setup:
	@echo "Run the following in your shell:"
	@echo '  $$(boot2docker shellinit)'

.PHONY: setup opensuse debian ubuntu arch slackware centos oracle raspbian

check: check-opensuse check-debian check-ubuntu check-arch check-centos check-oracle check-raspbian

push: check clean push-all

push-all: push-opensuse push-debian push-ubuntu push-arch push-centos push-oracle push-raspbian

clean:
	@-docker rm $(shell docker ps -a -q)
	@-docker rmi $(shell docker images -q --filter 'dangling=true')

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Common to all
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dockerfile: TAG = $(TAG_PREFIX)$(SYSTEM)
dockerfile:
	@cat common/head.Dockerfile > $(SYSTEM)/Dockerfile
	@cat common/caveat.Dockerfile >> $(SYSTEM)/Dockerfile
	@cat common/version.Dockerfile >> $(SYSTEM)/Dockerfile
	@cat $(SYSTEM)/base.Dockerfile >> $(SYSTEM)/Dockerfile
	@cat common/maintainer.Dockerfile >> $(SYSTEM)/Dockerfile
	@cat $(SYSTEM)/system.Dockerfile >> $(SYSTEM)/Dockerfile
	@cat common/lfe-setup.Dockerfile >> $(SYSTEM)/Dockerfile
	@docker build -t $(TAG) $(SYSTEM)

check-lfe:
	@echo "Checking LFE for lfex/$(SYSTEM) ..."
	@docker run -t  $(TAG_PREFIX)$(SYSTEM)

lfe:
	@docker run -i -t $(TAG_PREFIX)$(SYSTEM) lfe

bash:
	@docker run -i -t $(TAG_PREFIX)$(SYSTEM) bash

dockerhub-push:
	@docker push $(TAG_PREFIX)$(SYSTEM)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# openSUSE
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

opensuse:
	@SYSTEM=opensuse make dockerfile

check-opensuse:
	@SYSTEM=opensuse make check-lfe

lfe-opensuse:
	@SYSTEM=opensuse make lfe

bash-opensuse:
	@SYSTEM=opensuse make bash

push-opensuse:
	@SYSTEM=opensuse make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Debian
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

debian:
	@SYSTEM=debian make dockerfile

check-debian:
	@SYSTEM=debian make check-lfe

lfe-debian:
	@SYSTEM=debian make lfe

bash-debian:
	@SYSTEM=debian make bash

push-debian:
	@SYSTEM=debian make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ubuntu
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ubuntu:
	@SYSTEM=ubuntu make dockerfile

check-ubuntu:
	@SYSTEM=ubuntu make check-lfe

lfe-ubuntu:
	@SYSTEM=ubuntu make lfe

bash-ubuntu:
	@SYSTEM=ubuntu make bash

push-ubuntu:
	@SYSTEM=ubuntu make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Arch
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

arch:
	@SYSTEM=arch make dockerfile

check-arch:
	@SYSTEM=arch make check-lfe

lfe-arch:
	@SYSTEM=arch make lfe

bash-arch:
	@SYSTEM=arch make bash

push-arch:
	@SYSTEM=arch make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Slackware
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

slackware:
	@SYSTEM=slackware make dockerfile

check-slackware:
	@SYSTEM=slackware make check-lfe

lfe-slackware:
	@SYSTEM=slackware make lfe

bash-slackware:
	@SYSTEM=slackware make bash

push-slackware:
	@SYSTEM=slackware make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CentOS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

centos:
	@SYSTEM=centos make dockerfile

check-centos:
	@SYSTEM=centos make check-lfe

lfe-centos:
	@SYSTEM=centos make lfe

bash-centos:
	@SYSTEM=centos make bash

push-centos:
	@SYSTEM=centos make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Oracle Linux
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

oracle:
	@SYSTEM=oracle make dockerfile

check-oracle:
	@SYSTEM=oracle make check-lfe

lfe-oracle:
	@SYSTEM=oracle make lfe

bash-oracle:
	@SYSTEM=oracle make bash

push-oracle:
	@SYSTEM=oracle make dockerhub-push

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Raspbian
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

raspbian:
	@SYSTEM=raspbian make dockerfile

check-raspbian:
	@SYSTEM=raspbian make check-lfe

lfe-raspbian:
	@SYSTEM=raspbian make lfe

bash-raspbian:
	@SYSTEM=raspbian make bash

push-raspbian:
	@SYSTEM=raspbian make dockerhub-push
