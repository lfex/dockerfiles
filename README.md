# dockerfiles

*Dockerfiles for LFE on various distributions*

<image src="resources/images/docker-thumb.png" />

##### Table of Contents

* [About](#about-)
* [Usage](#usage-)
  * [Instant REPL](#instant-repl-)
  * [Running Examples](#running-examples-)


## About [&#x219F;](#table-of-contents)

This repository provides a handful of LFE `Dockerfile`s based on similar 
Erlang docker files (available [here](https://hub.docker.com/_/erlang)):
* standard (Debian, [buildpack-deps](https://hub.docker.com/_/buildpack-deps/) 
  based images)
* slim (Debian based images with only what Erlang requires)
* alpine

These include the following LFE versions:
* 1.3-dev

Dependeing upon image type, some or all of the following Erlang versions are 
available:
* 17.5 (only with standard image type)
* 18.3 (standard and slim)
* 19.3 (standard and slim)
* 20.3 (all)
* 21.3 (all)

The LFE image are published with tags in the following format:

```
<org>/<project>:<lfe-version>-<erlang-version>-<image-type>
```

For example, LFE v1.3 running on Erlang 20.3 in an Alpine-based container would be:
```
lfex/lfe:1.3-20.3-alpine
```

All published LFE Docker images are available here:
* [https://hub.docker.com/r/lfex/lfe/tags](https://hub.docker.com/r/lfex/lfe/tags)


## Usage [&#x219F;](#table-of-contents)

### Instant REPL [&#x219F;](#table-of-contents)

Running an LFE REPL in any of the provided images is as simple as the following:

```
$ docker run -i -t lfex/lfe:1.3-21.3-alpine
```
```
Erlang/OTP 21 [erts-10.3.5] [source] [64-bit] [smp:6:6] [ds:6:6:10] [async-threads:1] [hipe]

   ..-~.~_~---..
  (      \\     )    |   A Lisp-2+ on the Erlang VM
  |`-.._/_\\_.-':    |   Type (help) for usage info.
  |         g |_ \   |
  |        n    | |  |   Docs: http://docs.lfe.io/
  |       a    / /   |   Source: http://github.com/rvirding/lfe
   \     l    |_/    |
    \   r     /      |   LFE v1.3-dev (abort with ^G)
     `-E___.-'

lfe> 
```

From here, we can run some of the example code:
```lisp
lfe> (slurp '"examples/gps1.lfe")
```
```lisp
#(ok gps1)
```
```lisp
lfe> (gps '(son-at-home car-needs-battery have-money have-phone-book)
lfe>      '(son-at-school)
lfe>      (school-ops))
```
```
executing 'look-up-number'
executing 'telephone-shop'
executing 'tell-shop-problem'
executing 'give-shop-money'
executing 'shop-installs-battery'
executing 'drive-son-to-school'
solved
```


### Running Examples [&#x219F;](#table-of-contents)

Some of the LFE example modules have been compiled in these Docker images for 
your testing convenience. How they are run depends upon each example. For 
instance, here's how to run the LFE port of the classic Erlang "Ring" example:

```
$ docker run lfex/lfe:1.3-21.3-alpine -pa examples/ebin -noshell -run ring main 503 50000000
```

Note that, because these Docker images use `ENTRYPOINT`, they can be run just 
like you run the install `lfe` binary on a system, complete with command line 
flags. The only difference is that instead of typing `lfe` in the terminal, 
we type `docker run lfex/lfe:1.3-20.3-alpine`.

This will run for a while, then you'll get the expected output:
```
Result: 292
```

Another example, based on 
http://joearms.github.io/2013/11/21/My-favorite-erlang-program.html, will take 
_quite_ a while to finish:

```
$ docker run lfex/lfe:1.3-18.3-slim -pa examples/ebin -noshell -run joes-fav run-it
```
```
30414093201713378043612608166064768844377641568960512000000000000
```

Those are example modules; you can also run the LFE example scripts by changing
the entry point:

```
$ docker run --entrypoint=examples/sample-lfescript lfex/lfe:1.3-20.3-standard
```
This will give us an error, since we didn't pass it the correct argument type:
```
usage: examples/sample-lfescript <integer>
```
Let's try again:
```
$ docker run --entrypoint=examples/sample-lfescript lfex/lfe:1.3-20.3-standard 10
```
```
factorial 10 = 3628800
```
Or another script example:
```
$ docker run --entrypoint=examples/sample-lfe-shellscript lfex/lfe:1.3-19.3-slim 5
```
```
factorial 5 = 120
```