    apk add --update git linux-pam-dev autoconf automake libtool sed gawk && \
    mkdir log && \
    rebar3 compile && \
    autoreconf -fi > /dev/null && \
    ./configure > /dev/null && \
    make > /dev/null && \
