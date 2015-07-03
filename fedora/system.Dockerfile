RUN dnf check-update || dnf -y upgrade
RUN dnf -y install python-dnf-plugins-extras-migrate wget
RUN dnf -y groupinstall "Development Tools"; dnf clean all

ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_3_general
ENV ERLANG_RPM1 erlang-solutions-1.0-1.noarch.rpm
ENV ERLANG_RPM2 esl-erlang_15.b.3-1~fedora~beefymiracle_amd64.rpm
RUN curl -L -O $ERLANG_HOST/$ERLANG_RPM1 && \
    curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM2
RUN rpm -Uvhf $ERLANG_RPM1 || echo "Ignoring errors ..."
RUN dnf -y install erlang-hipe erlang-doc
RUN rpm -Uvh --nodeps --replacefiles $ERLANG_RPM2 || \
        echo "Ignoring errors ..."
RUN rm $ERLANG_RPM1 $ERLANG_RPM2
