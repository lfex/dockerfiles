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
FROM centos:latest
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN yum -y update; yum clean all
RUN yum groups mark convert
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install curl wget git

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_1_general
ENV ERLANG_RPM1 erlang-solutions-1.0-1.noarch.rpm
ENV ERLANG_RPM2 esl-erlang_19.1~centos~7_amd64.rpm
RUN curl -L -O $ERLANG_HOST/$ERLANG_RPM1 && \
    curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM2
RUN rpm -Uvh $ERLANG_RPM1 && rm $ERLANG_RPM1
RUN yum -y install erlang-hipe erlang-doc erlang-manpages \
        erlang-mode erlang-src
RUN rpm -Uvh --nodeps --replacefiles $ERLANG_RPM2 && \
    rm $ERLANG_RPM2
ENV LFE_HOME /opt/erlang/lfe
ENV PATH $PATH:$LFE_HOME/bin

RUN echo
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/rvirding/lfe.git && \
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
