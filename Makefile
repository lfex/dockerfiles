TAG_PREFIX = lfex/

setup:
	@$(boot2docker shellinit)

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

all: opensuse

clean:
	@docker rm $(shell docker ps -a -q)
	@docker rmi $(shell docker images -q --filter 'dangling=true')

.PHONY: opensuse
