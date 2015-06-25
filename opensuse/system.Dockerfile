# Base image
#
# VERSION 0.2
FROM opensuse:latest
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN zypper refresh
RUN zypper --non-interactive install -y \
    patterns-openSUSE-devel_basis \
    erlang erlang-src \
    curl \
    git
