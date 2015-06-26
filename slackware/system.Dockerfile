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
