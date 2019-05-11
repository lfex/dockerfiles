LFE_VERSION = 1.3
LATEST_ERL = 21.3
ERL_VERSIONS_NEW = 20.3 $(LATEST_ERL)
ERL_VERSIONS_MID = 18.3 19.3
ERL_VERSIONS_OLD = 17.5
ERL_VERSIONS_STD =  $(ERL_VERSIONS_OLD) $(ERL_VERSIONS_MID) $(ERL_VERSIONS_NEW)
ERL_VERSIONS_SLIM = $(ERL_VERSIONS_MID) $(ERL_VERSIONS_NEW)
ERL_VERSIONS_ALPINE = $(ERL_VERSIONS_NEW)
OFFICIAL_TYPE = alpine
TAG_PREFIX = lfex/lfe
BUILD_DIR = build
# XXX Note that, for right now, the bleeding-edge branch in the lfe/lfe repo
#     needs to be used in order to properly and cleaning use LFE as an 
#     entry point in the Docker images. Once rvirding/lfe has merged the PRs
#     which contain the appropriate fixes, future versioned LFE Docker images
#     can be built using rvirding/lfe + version tag.
LFE_REPO = git@github.com:lfe/lfe.git
LFE_BRANCH = bleeding-edge

# tags should be of the form:
# lfex/lfe:1.3-20.3-standard
# lfex/lfe:1.3-19.3-slim
# lfex/lfe:1.3-18.3-alpine

all: clean update-erlang build-all

build-all: standard slim alpine

build-push-all: all push push-latest

.PHONY: standard slim alpine push

clean:
	@-docker rm `docker ps -a -q`
	@-docker rmi `docker images -q --filter 'dangling=true'`
	@rm -rf $(BUILD_DIR)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)
	git clone $(LFE_REPO) $(BUILD_DIR)/lfe
	cd $(BUILD_DIR)/lfe && git checkout $(LFE_BRANCH)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Common to all
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dockerfile: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
dockerfile: $(BUILD_DIR)
	@cat common/head.Dockerfile > $(BUILD_DIR)/Dockerfile
	@cat common/caveat.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/base.Dockerfile | sed s'/{{VERSION}}/$(ERL_VERSION)/' >> $(BUILD_DIR)/Dockerfile
	@cat common/lfe-setup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/system.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/lfe-compile.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat $(IMG_TYPE)/cleanup.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@cat common/finish.Dockerfile >> $(BUILD_DIR)/Dockerfile
	@docker build -t $(TAG) $(BUILD_DIR)

check-lfe:
	@echo "Checking LFE for lfex/$(IMG_TYPE) ..."
	@docker run -t  $(TAG_PREFIX)$(IMG_TYPE)

lfe:
	@docker run -i -t $(TAG_PREFIX)$(IMG_TYPE) lfe

bash:
	@docker run -i -t $(TAG_PREFIX)$(IMG_TYPE) bash

dockerhub-push: TAG = $(TAG_PREFIX):$(LFE_VERSION)-$(ERL_VERSION)-$(IMG_TYPE)
dockerhub-push:
	@docker push $(TAG)

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
	$(MAKE) dockerfile ; done

slim:
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) dockerfile ; done

alpine:
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) dockerfile ; done
	
push:
	@for EV in $(ERL_VERSIONS_STD); do IMG_TYPE=standard ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done
	@for EV in $(ERL_VERSIONS_SLIM); do IMG_TYPE=slim ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done
	@for EV in $(ERL_VERSIONS_ALPINE); do IMG_TYPE=alpine ERL_VERSION=$$EV \
	$(MAKE) dockerhub-push ; done

push-latest:
	@docker tag $(TAG_PREFIX):$(LFE_VERSION)-$(LATEST_ERL)-$(OFFICIAL_TYPE) $(TAG_PREFIX):latest
	@docker push $(TAG_PREFIX):latest