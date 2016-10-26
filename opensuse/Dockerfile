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
FROM opensuse:tumbleweed
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN zypper refresh
RUN zypper --non-interactive install -y \
    patterns-openSUSE-devel_basis
RUN zypper --non-interactive install -y \
    openssl openssl-devel
RUN zypper --non-interactive install -y \
    curl \
    git
RUN zypper --non-interactive install -y \
    lksctp-tools lksctp-tools-devel \
    libncurses5
RUN zypper --non-interactive install -y \
    pandoc

RUN ln -s /lib/libcrypto.so.1.0.0 /lib/libcrypto.so.10
RUN ln -s /lib64/libcrypto.so.1.0.0 /lib64/libcrypto.so.10
RUN ldconfig

ENV ERLANG_RPM esl-erlang_19.1~centos~7_amd64.rpm
ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_1_general
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM
RUN rpm -Uvh --replacepkgs --nodeps $ERLANG_RPM && \
    rm $ERLANG_RPM
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
