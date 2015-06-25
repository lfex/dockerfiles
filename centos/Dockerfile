# Base image
#
# VERSION 0.2
FROM centos:latest
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN yum -y update; yum clean all
RUN yum groups mark convert
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install curl wget git

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_3_general
ENV ERLANG_RPM1 erlang-solutions-1.0-1.noarch.rpm
ENV ERLANG_RPM2 esl-erlang_17.5-1~centos~7_amd64.rpm
RUN cd /tmp && \
    curl -L -O $ERLANG_HOST/$ERLANG_RPM1 && \
    curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM2
RUN cd /tmp && \
    rpm -Uvh $ERLANG_RPM1
RUN cd /tmp && \
    yum -y install erlang-hipe erlang-doc erlang-manpages \
        erlang-mode erlang-src
RUN cd /tmp && \
    rpm -Uvh --nodeps --replacefiles $ERLANG_RPM2

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
      bash ./lfetool install
RUN lfetool download deps

ENV ERL_LIBS=$ERL_LIBS:$LFE_HOME
CMD /usr/bin/lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
