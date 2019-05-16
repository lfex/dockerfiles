    mkdir log && \
    rebar3 compile && \
    autoreconf -fi > /dev/null && \
    ./configure > /dev/null && \
    make > /dev/null && \
