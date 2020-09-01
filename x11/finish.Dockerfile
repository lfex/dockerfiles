# RUN xhost +
# RUN cp /etc/X11/xinit/xinitrc ~/.xinitrc

RUN echo '#! /bin/bash' > ~/xterm && \
    echo "xterm -geometry 80x24+10+10 -ls -title \"LFE MACHINE\" &" >> ~/xterm && \
    echo "while true; do sleep 20; done;" >> ~/xterm && \
    chmod 755 ~/xterm

USER root
# ENTRYPOINT [ "x11vnc", \
#     "-xkb", "-noxrecord", "-noxfixes", "-noxdamage", \
#     "-repeat", "-wait", "5", "-permitfiletransfer", "-tightfilexfer", \
#     "-find", "-forever", "-create", "-nopw", "-auth", "guess" ]

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
