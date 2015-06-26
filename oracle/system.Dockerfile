RUN yum -y update; yum clean all
RUN yum groups mark convert
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install which curl wget git

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_3_general
ENV ERLANG_RPM esl-erlang_18.0-1~centos~7_amd64.rpm
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM
RUN rpm -Uvh --nodeps --replacefiles $ERLANG_RPM && \
    rm $ERLANG_RPM
