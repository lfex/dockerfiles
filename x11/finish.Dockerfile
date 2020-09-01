# RUN xhost +
# RUN cp /etc/X11/xinit/xinitrc ~/.xinitrc

RUN echo '#! /bin/bash' > ~/xterm && \
    echo "touch /root/.Xauthority" >> ~/xterm && \
    echo "xauth generate :0 . trusted" >> ~/xterm && \
    echo 'xauth add ${HOST}:0 . $(xxd -l 16 -p /dev/urandom)' >> ~/xterm && \
    echo "xterm -geometry 120x32+10+10 -ls -title \"LFE MACHINE\" &" >> ~/xterm && \
    echo "while true; do sleep 20; done;" >> ~/xterm && \
    chmod 755 ~/xterm    

USER root

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
