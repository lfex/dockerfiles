RUN yum -y update; yum clean all
RUN yum groups mark convert
RUN yum -y groupinstall "Development Tools"; yum clean all
RUN yum -y install curl wget git

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_3_general
ENV ERLANG_RPM1 erlang-solutions-1.0-1.noarch.rpm
ENV ERLANG_RPM2 esl-erlang_18.0-1~centos~7_amd64.rpm
RUN curl -L -O $ERLANG_HOST/$ERLANG_RPM1 && \
    curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM2
RUN rpm -Uvh $ERLANG_RPM1 && rm $ERLANG_RPM1
RUN yum -y install erlang-hipe erlang-doc erlang-manpages \
        erlang-mode erlang-src
RUN rpm -Uvh --nodeps --replacefiles $ERLANG_RPM2 && \
    rm $ERLANG_RPM2
