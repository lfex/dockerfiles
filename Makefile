TAG_PREFIX = lfex/

all: opensuse

setup:
	@echo "Run the following in your shell:"
	@echo '  $$(boot2docker shellinit)'

.PHONY: setup opensuse debian

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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CentOS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

