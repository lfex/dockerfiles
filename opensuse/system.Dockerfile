RUN zypper refresh
RUN zypper --non-interactive install -y \
    patterns-openSUSE-devel_basis \
    openssl openssl-devel \
    curl \
    git

RUN ln -s /lib/libcrypto.so.1.0.0 /lib/libcrypto.so.10
RUN ln -s /lib64/libcrypto.so.1.0.0 /lib64/libcrypto.so.10
RUN ldconfig

ENV ERLANG_RPM esl-erlang_18.1-1~centos~7_amd64.rpm
ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_1_general
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_RPM
RUN rpm -Uvh --replacepkgs --nodeps $ERLANG_RPM && \
    rm $ERLANG_RPM
