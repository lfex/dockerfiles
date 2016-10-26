# LFE image
#
# This Dockerfile was generated automatically by the lfex/dockerfiles Makefile.
# Do not make any edits to this file, as they will be overwritten.
#
# If you wish to make changes, e.g. for a pull request on Github, edit
# ./*/*.Dockerfile and/or ./common/*.Dockerfile.
#
# VERSION 1.0
#
FROM debian:jessie
MAINTAINER LFE Maintainers <maintainers@lfe.io>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential
RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    libcurl4-openssl-dev \
    curl \
    wget \
    git
RUN apt-get install -y --no-install-recommends \
    libsctp1 libsctp-dev lksctp-tools
RUN apt-get install -y --no-install-recommends \
    pandoc

ENV ERLANG_DEB1 erlang-solutions_1.0_all.deb
ENV ERLANG_DEB2 esl-erlang_19.1.3-1~debian~jessie_amd64.deb
ENV ERLANG_HOST https://packages.erlang-solutions.com
ENV ERLANG_PATH erlang/esl-erlang/FLAVOUR_1_general
RUN curl -L -O $ERLANG_HOST/$ERLANG_DEB1
RUN dpkg -i $ERLANG_DEB1 && rm $ERLANG_DEB1
RUN apt-get update
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_DEB2
RUN dpkg -i --force-depends $ERLANG_DEB2 && rm $ERLANG_DEB2
ENV LFE_HOME /opt/erlang/lfe
ENV PATH $PATH:$LFE_HOME/bin

RUN echo
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/lfe/lfe.git && \
      cd $LFE_HOME && \
      mkdir -p ebin && \
      make compile && \
      make install

RUN echo
RUN curl -L -o /usr/local/bin/rebar3 https://s3.amazonaws.com/rebar3/rebar3 && \
    chmod 755 /usr/local/bin/rebar3
RUN git clone https://github.com/erlware/relx.git && \
    cd relx && \
    rebar3 update && \
    rebar3 escriptize
RUN mv relx/_build/default/bin/relx /usr/local/bin
RUN rm -rf relx
RUN curl -L -O https://raw.githubusercontent.com/yrashk/kerl/master/kerl && \
    chmod a+x kerl && \
    mv kerl /usr/local/bin
RUN kerl update releases

CMD lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
