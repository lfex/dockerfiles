# Base image
#
# VERSION 0.2
FROM debian:latest
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    erlang \
    ca-certificates \
    libcurl4-openssl-dev \
    curl \
    git

ENV LFE_HOME /opt/erlang/lfe
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/rvirding/lfe.git && \
      cd $LFE_HOME && \
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

ENV ERL_LIBS=$ERL_LIBS:$LFE_HOME
CMD /usr/bin/lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
