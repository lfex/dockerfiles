    apt-get remove \
    --purge \
    -y \
    make gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
