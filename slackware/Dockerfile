# Base image
#
# VERSION 0.2
FROM vbatts/slackware
MAINTAINER LFE Maintainers <maintainers@lfe.io>

RUN slackpkg update
RUN slackpkg upgrade-all -default_answer=yes -batch=yes
RUN slackpkg install -default_answer=yes -batch=yes \
    binutils gcc-4 gcc-g++-4 glibc-2 libmpc kernel-headers \
    texinfo make autoconf automake m4 zlib bc cmake libarchive
    nettle lzo libxml2 cyrus-sasl ca-certificates rsync
RUN slackpkg install -default_answer=yes -batch=yes \
    jdk \
    curl \
    git

ENV DISTRO_VERSION `cat /etc/slackware-version |cut -d \  -f 2`
ENV SBOPATH /var/lib/sbopkg/SBo/$DISTRO_VERSION/$DISTRO_VERSION
RUN mkdir -p /tmp/workspace
RUN cd /tmp/workspace && \
    git clone https://gitlab.com/slackport/sport.git && \
    cd sport && \
    ./sport.SlackBuild && \
    installpkg /tmp/sport*tgz
RUN mkdir -p /var/lib/sbopkg/SBo/$DISTRO_VERSION
RUN rsync -av \
    rsync://slackbuilds.org/slackbuilds/$DISTRO_VERSION \
    /var/lib/sbopkg/SBo/$DISTRO_VERSION/

RUN sport install erlang-otp

RUN curl -L -o /usr/local/bin/rebar https://github.com/rebar/rebar/wiki/rebar && \
    chmod 755 /usr/local/bin/rebar
RUN curl -L -o /usr/local/bin/rebar3 https://s3.amazonaws.com/rebar3/rebar3 && \
    chmod 755 /usr/local/bin/rebar3
RUN curl -L -o ./lfetool https://raw.github.com/lfe/lfetool/dev-v1/lfetool && \
      bash ./lfetool install

ENV LFE_HOME /opt/erlang/lfe
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/rvirding/lfe.git && \
      cd $LFE_HOME && \
      make compile && \
      make install
RUN lfetool download deps

ENV ERL_LIBS=$ERL_LIBS:$LFE_HOME
CMD /usr/bin/lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
