LFE_VERSION = 2.2.0
LATEST_ERL = 28.1
ERL_VERSIONS_NEW = 23.3 24.3 25.3 26.2 27.3 $(LATEST_ERL)
ERL_VERSIONS_MID = 21.3 22.3
ERL_VERSIONS_OLD = 20.3
ERL_VERSIONS_STD =  $(ERL_VERSIONS_OLD) $(ERL_VERSIONS_MID) $(ERL_VERSIONS_NEW)
# ERL_VERSIONS_SLIM = $(ERL_VERSIONS_MID) $(ERL_VERSIONS_NEW)
ERL_VERSIONS_SLIM = $(ERL_VERSIONS_STD)
# ERL_VERSIONS_ALPINE = $(ERL_VERSIONS_NEW)
ERL_VERSIONS_ALPINE = $(ERL_VERSIONS_STD)
OFFICIAL_TYPE = alpine
TAG_PREFIX = lfex/lfe
YAWS_TAG_PREFIX = lfex/yaws
BUILD_DIR = build
# XXX Note that, for right now, the bleeding-edge branch in the lfe/lfe repo
#     needs to be used in order to properly and cleanly use LFE as an
#     entry point in the Docker images. Once rvirding/lfe has merged the PRs
#     which contain the appropriate fixes, future versioned LFE Docker images
#     can be built using rvirding/lfe + version tag.
LFE_REPO = git@github.com:lfe/lfe.git
LFE_BRANCH = develop
#YAWS_REPO = git@github.com:erlsci/yaws.git
YAWS_REPO = git@github.com:erlyaws/yaws.git
YAWS_BRANCH = rebar3-support

default: all

build-all-lfe:  alpine slim standard

build-all-yaws: yaws-standard yaws-slim yaws-alpine

all: clean update-erlang build-all-lfe build-all-yaws

build-push-all: all yaws-push yaws-push-latest push push-latest

push-all: push push-latest

.PHONY: standard slim alpine push yaws-standard yaws-slim yaws-alpine

clean:
	@rm -f $(BUILD_DIR)/lfe/.build $(BUILD_DIR)/yaws/.build $(BUILD_DIR)/Dockerfile

clean-docker:
	@-docker rm `docker ps -a -q`
	@-docker rmi `docker images -q --filter 'dangling=true'`

clean-build:
	@rm -rf $(BUILD_DIR)

clean-all: clean-build clean-docker

.PRECIOUS: $(BUILD_DIR)/. $(BUILD_DIR)%/.

$(BUILD_DIR):
	@mkdir -p $(@D)

$(BUILD_DIR)/lfe: | $(BUILD_DIR)
	@git clone $(LFE_REPO) $(BUILD_DIR)/lfe && \
	cd $(BUILD_DIR)/lfe && git checkout $(LFE_BRANCH)

$(BUILD_DIR)/x11: | $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/x11

$(BUILD_DIR)/yaws: | $(BUILD_DIR)
	@git clone $(YAWS_REPO) $(BUILD_DIR)/yaws && \
	cd $(BUILD_DIR)/yaws && git checkout $(YAWS_BRANCH)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Common to all
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

$(BUILD_DIR)/lfe/.build: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
$(BUILD_DIR)/lfe/.build: | $(BUILD_DIR)/lfe
	@cat common/head.Dockerfile > $(BUILD_DIR)/Dockerfile
	@cat common/caveat.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/base.Dockerfile | sed s'/{{VERSION}}/$(ERL_VERSION)/' >> $(BUILD_DIR)/Dockerfile
	@cat common/lfe-setup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/system.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/lfe-compile.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/cleanup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/finish.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@docker build -t $(TAG) $(BUILD_DIR)

$(BUILD_DIR)/x11/.build: TAG = $(TAG_PREFIX)-x11:$(LFE_VERSION)-$(ERL_VERSION)-alpine
$(BUILD_DIR)/x11/.build: | $(BUILD_DIR)/x11
	@cat common/head.Dockerfile > $(BUILD_DIR)/Dockerfile
	@cat common/caveat.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat x11/base.Dockerfile | \
	sed s'/{{LATEST_ERL}}/$(ERL_VERSION)/' | \
	sed s'/{{LFE_VERSION}}/$(LFE_VERSION)/' >> $(BUILD_DIR)/Dockerfile
	@cat x11/setup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat x11/system.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat x11/cleanup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat x11/finish.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cp x11/supervisord.conf $(BUILD_DIR)/
	@docker build -t $(TAG) $(BUILD_DIR)

$(BUILD_DIR)/yaws/.build: TAG = $(YAWS_TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
$(BUILD_DIR)/yaws/.build: | $(BUILD_DIR)/yaws
	@cat common/yaws-head.Dockerfile > $(BUILD_DIR)/Dockerfile
	@cat common/caveat.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat yaws-$(IMG_TYPE)/base.Dockerfile | \
	sed s'/{{ERL_VERSION}}/$(ERL_VERSION)/' | \
	sed s'/{{LFE_VERSION}}/$(LFE_VERSION)/' >> $(BUILD_DIR)/Dockerfile
	@cat common/yaws-setup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/system.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat yaws-$(IMG_TYPE)/system.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/yaws-compile.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat yaws-$(IMG_TYPE)/cleanup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/cleanup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/yaws-finish.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@docker build -t $(TAG) $(BUILD_DIR)

check-lfe:
	@echo "Checking LFE for lfex/$(IMG_TYPE) ..."
	@docker run -t $(TAG_PREFIX)$(IMG_TYPE)

lfe:
	@docker run -it $(TAG_PREFIX)$(IMG_TYPE) lfe

bash:
	@docker run -it $(TAG_PREFIX)$(IMG_TYPE) bash

run-x11: TAG = $(TAG_PREFIX)-x11:$(LFE_VERSION)-$(LATEST_ERL)-alpine
run-x11:
	@docker run -p 5900:5900 -e DISPLAY=:0 $(TAG)

x11-bash: TAG = $(TAG_PREFIX)-x11:$(LFE_VERSION)-$(LATEST_ERL)-alpine
x11-bash:
	@docker run -it --entrypoint=bash $(TAG)


version: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
version:
	@echo $(TAG)

dockerhub-push: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
dockerhub-push:
	@docker push $(TAG)

x11-dockerhub-push: TAG = $(TAG_PREFIX)-x11:$(LFE_VERSION)-$(ERL_VERSION)-alpine
x11-dockerhub-push:
	@docker push $(TAG)

yaws-dockerhub-push: TAG = $(YAWS_TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
yaws-dockerhub-push:
	@docker push $(TAG)

docker-test: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
docker-test:
	@docker run $(TAG) -eval "(io:format \"~p~n\" (list (erlang:list_to_integer (lists:reverse (erlang:integer_to_list (lists:foldl #'*/2 1 '(1 2 3 4)))))))"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Image Types
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

update-erlang:
	@for EV in $(ERL_VERSIONS_STD); do ERL_VERSION=$$EV \
	docker pull erlang:$$EV; done
	@for EV in $(ERL_VERSIONS_SLIM); do ERL_VERSION=$$EV \
	docker pull erlang:$$EV-slim; done
	@for EV in $(ERL_VERSIONS_ALPINE); do ERL_VERSION=$$EV \
	docker pull erlang:$$EV-alpine; done

standard:
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) $(BUILD_DIR)/lfe/.build ; done

slim:
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) $(BUILD_DIR)/lfe/.build ; done

alpine:
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) $(BUILD_DIR)/lfe/.build ; done

alpine-latest:
	@IMG_TYPE=alpine ERL_VERSION=$(LATEST_ERL) $(MAKE) $(BUILD_DIR)/lfe/.build

x11: alpine-latest clean
	@ERL_VERSION=$(LATEST_ERL) $(MAKE) $(BUILD_DIR)/x11/.build

yaws-standard:
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	LFE_VERSION=$(LFE_VERSION) $(MAKE) $(BUILD_DIR)/yaws/.build ; done

yaws-slim:
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	LFE_VERSION=$(LFE_VERSION) $(MAKE) $(BUILD_DIR)/yaws/.build ; done

yaws-alpine:
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	LFE_VERSION=$(LFE_VERSION) $(MAKE) $(BUILD_DIR)/yaws/.build ; done

push:
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done

push-latest:
	@docker tag $(TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-standard $(TAG_PREFIX):latest-standard
	@docker push $(TAG_PREFIX):latest-standard
	@docker tag $(TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-slim $(TAG_PREFIX):latest-slim
	@docker push $(TAG_PREFIX):latest-slim
	@docker tag $(TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-$(OFFICIAL_TYPE) $(TAG_PREFIX):latest-alpine
	@docker push $(TAG_PREFIX):latest-alpine
	@docker tag $(TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-$(OFFICIAL_TYPE) $(TAG_PREFIX):latest
	@docker push $(TAG_PREFIX):latest

docker-tests:
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) docker-test ; done
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) docker-test ; done
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) docker-test ; done

versions:
	@echo REPOSITORY:TAG
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) version ; done | sort -r
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) version ; done | sort -r
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) version ; done | sort -r
	@echo $(TAG_PREFIX):latest

image-sizes:
	@docker images -f reference=lfex/lfe --format="table {{.Repository}}:{{.Tag}}\t{{.Size}}"|grep -v '<none>'

x11-push:
	@ERL_VERSION=$(LATEST_ERL) $(MAKE) x11-dockerhub-push

yaws-push:
	@-for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) yaws-dockerhub-push ; done
	@-for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) yaws-dockerhub-push ; done
	@-for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) yaws-dockerhub-push ; done

yaws-push-latest:
	docker tag $(YAWS_TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-standard $(YAWS_TAG_PREFIX):latest-standard
	docker push $(YAWS_TAG_PREFIX):latest-standard
	docker tag $(YAWS_TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-slim $(YAWS_TAG_PREFIX):latest-slim
	docker push $(YAWS_TAG_PREFIX):latest-slim
	docker tag $(YAWS_TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-$(OFFICIAL_TYPE) $(YAWS_TAG_PREFIX):latest
	docker push $(YAWS_TAG_PREFIX):latest
