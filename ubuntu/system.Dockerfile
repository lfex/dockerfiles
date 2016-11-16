ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --fix-missing
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    ca-certificates \
    libcurl4-openssl-dev \
    curl \
    wget \
    git \
    pandoc

ENV ERLANG_DEB1 erlang-solutions_1.0_all.deb
ENV ERLANG_DEB2 esl-erlang_19.1.3-1~ubuntu~xenial_amd64.deb
ENV ERLANG_HOST http://packages.erlang-solutions.com
ENV ERLANG_PATH erlang/esl-erlang/FLAVOUR_1_general
RUN curl -L -O $ERLANG_HOST/$ERLANG_DEB1
RUN dpkg -i $ERLANG_DEB1 && rm $ERLANG_DEB1
RUN apt-get update
RUN curl -L -O $ERLANG_HOST/$ERLANG_PATH/$ERLANG_DEB2
RUN dpkg -i --force-depends $ERLANG_DEB2 && rm $ERLANG_DEB2

RUN apt-get update
RUN apt-get -f install -y --fix-missing
RUN apt-get install -y \
  man
