    apt-get remove \
    --purge \
    -y \
    dh-autoreconf && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
