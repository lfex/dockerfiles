ENV HOME /root
RUN pacman -Syu --noconfirm \
    base-devel \
    erlang \
    curl \
    git
