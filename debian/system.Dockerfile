ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    ca-certificates \
    libcurl4-openssl-dev \
    curl \
    wget \
    git

ENV ERLANG_DEB1 erlang-solutions_1.0_all.deb
ENV ERLANG_DEB2 esl-erlang_18.1-1~debian~jessie_amd64.deb
ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH site/esl/esl-erlang/FLAVOUR_1_general
RUN curl -L -O $ERLANG_HOST/$ERLANG_DEB1
RUN dpkg -i $ERLANG_DEB1 && rm $ERLANG_DEB1
RUN apt-get update
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_DEB2
RUN dpkg -i --force-depends $ERLANG_DEB2 && rm $ERLANG_DEB2

