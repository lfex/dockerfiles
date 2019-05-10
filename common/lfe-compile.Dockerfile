    mkdir -p ebin examples/ebin && \
    make && \
    make install && \ 
    for FILE in church.lfe ets_demo.lfe fizzbuzz.lfe guessing-game.lfe http-async.lfe http-sync.lfe joes-fav.lfe ring.lfe simple-erl-exercises.lfe; \
    do \
    lfec -I include -o examples/ebin examples/${FILE}; \
    done && \
    