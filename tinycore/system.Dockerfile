ENV LANG C.UTF-8
ENV ERL_VERSION 18.3
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

