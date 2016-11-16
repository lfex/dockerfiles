ENV LFE_HOME /opt/erlang/lfe
ENV PATH $PATH:$LFE_HOME/bin
ENV HOME /root
ENV USER_REBAR $HOME/.config/rebar3
ENV USER_REBAR_CONFIG $USER_REBAR/rebar.config

### LFE ###

RUN echo
RUN mkdir -p $LFE_HOME
RUN cd `dirname $LFE_HOME` && \
      git clone https://github.com/rvirding/lfe.git
RUN cd $LFE_HOME && \
      mkdir -p ebin && \
      make compile && \
      make install && \
      make docs && \
      make docs-man

### rebar3 ###

RUN echo
RUN curl -L -o /usr/local/bin/rebar3 https://s3.amazonaws.com/rebar3/rebar3 && \
    chmod 755 /usr/local/bin/rebar3

### Hex.pm rebar3 plugin ###

RUN echo
RUN mkdir -p $USER_REBAR
RUN echo "{plugins, [rebar3_hex]}." >> $USER_REBAR_CONFIG
RUN rebar3
RUN rebar3 version
RUN cat $USER_REBAR_CONFIG
RUN rebar3 update
RUN rebar3 hex

### relx ###

RUN git clone https://github.com/erlware/relx.git && \
    cd relx && \
    rebar3 update && \
    rebar3 escriptize
RUN mv relx/_build/default/bin/relx /usr/local/bin
RUN rm -rf relx

### kerl ###

RUN curl -L -O https://raw.githubusercontent.com/yrashk/kerl/master/kerl && \
    chmod a+x kerl && \
    mv kerl /usr/local/bin
RUN kerl update releases

CMD lfe -eval "(io:format \"The answer is: ~p~n\"  (list (* 2 (lists:foldl (lambda (n acc) (+ n acc)) 0 (lists:seq 1 6)))))"
