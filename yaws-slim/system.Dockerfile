    apt-get install -y libpam0g-dev dh-autoreconf curl git && \
    curl -O https://s3.amazonaws.com/rebar3/rebar3 && \
    chmod +x rebar3 && \
    mv rebar3 /usr/local/bin && \
    