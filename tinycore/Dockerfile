# LFE image
#
# This Dockerfile was generated automatically by the lfex/dockerfiles Makefile.
# Do not make any edits to this file, as they will be overwritten.
#
# If you wish to make changes, e.g. for a pull request on Github, edit
# ./*/*.Dockerfile and/or ./common/*.Dockerfile.
#
# VERSION 0.3
#
FROM tatsushid/tinycore:6.3-x86
MAINTAINER LFE Maintainers <maintainers@lfe.io>

ENV LANG C.UTF-8
ENV ERL_VERSION 18.1
ENV ERL_HOME /opt/erlang/$ERL_VERSION
ENV PATH $PATH:$ERL_HOME/bin
ENV ERL_LIBS $ERL_HOME:$ERL_LIBS

RUN tce-load -wic \
    gcc \
    make \
    compiletc \
    coreutils \
    perl5 \
    glibc_base-dev
RUN tce-load -wic \
    ncurses-dev \
    readline-dev
RUN tce-load -wic \
    curl \
    git \
    openssl-1.0.1-dev
RUN tce-load -wic \
    bash

USER root
ENV HOME /root

RUN curl -L -O https://raw.githubusercontent.com/yrashk/kerl/master/kerl && \
    chmod a+x kerl && \
    mv kerl /usr/local/bin
RUN kerl update releases

RUN kerl build $ERL_VERSION $ERL_VERSION
RUN kerl install $ERL_VERSION $ERL_HOME
RUN . $ERL_HOME/activate

ENV LFE_HOME /opt/erlang/lfe
ENV ERL_LIBS $ERL_LIBS:$LFE_HOME:/root/.lfe/libs/ltest:/root/.lfe/libs/lutil:/root/.lfe/libs/lcfg

RUN echo
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/lfe/lfe.git && \
      cd $LFE_HOME && \
      git checkout color-shell-banner && \
      make compile && \
      make install

RUN curl -L -o /usr/local/bin/rebar https://github.com/rebar/rebar/wiki/rebar && \
    chmod 755 /usr/local/bin/rebar
RUN curl -L -o /usr/local/bin/rebar3 https://s3.amazonaws.com/rebar3/rebar3 && \
    chmod 755 /usr/local/bin/rebar3
RUN curl -L -o ./lfetool https://raw.github.com/lfe/lfetool/dev-v1/lfetool && \
    bash ./lfetool install && \
    rm ./lfetool
RUN lfetool download deps
RUN git clone https://github.com/erlware/relx.git && \
    cd relx && \
    ./rebar3 update && \
    ./rebar3 escriptize
RUN mv relx/_build/default/bin/relx /usr/local/bin
RUN rm -rf relx
RUN curl -L -O https://raw.githubusercontent.com/yrashk/kerl/master/kerl && \
    chmod a+x kerl && \
    mv kerl /usr/local/bin
RUN kerl update releases

CMD lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
