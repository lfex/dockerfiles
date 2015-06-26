RUN yum -y update; yum clean all
RUN yum groups mark convert
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install which curl wget git

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_3_general
ENV ERLANG_RPM esl-erlang_18.0-1~centos~7_amd64.rpm
RUN cd /tmp && \
    curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM
RUN cd /tmp && \
    rpm -Uvh --nodeps --replacefiles $ERLANG_RPM

ENV LFE_HOME /opt/erlang/lfe
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/lfe/lfe.git && \
      cd $LFE_HOME && \
      git checkout color-shell-banner && \
      make compile && \
      make install
