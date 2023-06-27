# dockerfiles

_Dockerfiles for LFE based upon the official Erlang Docker images_

<image src="https://github.com/lfex/dockerfiles/raw/main/resources/images/docker-thumb.png" />

##### Table of Contents

- [About](#about-)
  - [LFE](#lfe-)
  - [Images](#images-)
- [Usage](#usage-)
  - [Instant REPL](#instant-repl-)
  - [Running Examples](#running-examples-)
    - Modules via CLI
    - Interactive Modules via `main`
    - Precompiled Modules via LFE REPL
    - Slurping Modules via LFE REPL
    - Scripts
- [License](#license-)
- [User Feedback](#user-feedback-)
  - [Issues](#issues-)
  - [Contributing](#contributing-)

## About [&#x219F;](#table-of-contents)

### LFE [&#x219F;](#table-of-contents)

<img align="right" src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/LFE_%28Lisp_Flavored_Erlang%29_Logo.png/240px-LFE_%28Lisp_Flavored_Erlang%29_Logo.png" />LFE (Lisp Flavored Erlang) is a functional, concurrent, general-purpose programming language and Lisp dialect built on top of Core Erlang and the Erlang Virtual Machine (BEAM). LFE builds on top of Erlang in order to provide a Lisp syntax for writing distributed, fault-tolerant, soft real-time, non-stop applications. LFE also extends Erlang to support meta-programming with Lisp macros and an improved developer experience with a feature-rich REPL.

### Images [&#x219F;](#table-of-contents)

This repository provides a handful of LFE `Dockerfile`s based on similar
Erlang docker files (available [here](https://hub.docker.com/_/erlang)):

- standard (Debian, [buildpack-deps](https://hub.docker.com/_/buildpack-deps/)
  based images)
- slim (Debian based images with only what Erlang requires)
- alpine

These include the following LFE versions:

- 2.1.1

Alpine, Slim, and Standard images are available for the supported versions:

- 23.3, 24.3, 25.3, 26.0
- 21.3, 22.3
- 20.3

The LFE images are published with tags in the following format:

```
[org]/[project]:[lfe-version]-[erlang-version]-[image-type]
```

For example, LFE v2.1.1 running on Erlang 25.3 in an Alpine-based container would be:

```
lfex/lfe:2.1.1-25.3-alpine
```

Note that the Alpine image is considered the canonical one, thus the `latest`
tag is against an Alpine image with the most recent release of LFE and Erlang.
If this is what you want, than simply using either of the following will pull
this down:

```
docker run -it lfex/lfe:latest
```

or

```
docker run -it lfex/lfe
```

Additionally, the following latest versions are also provided as a convenience:

- lfex/lfe:latest-standard
- lfex/lfe:latest-slim

All published LFE Docker images are available here:

- [https://hub.docker.com/r/lfex/lfe/tags](https://hub.docker.com/r/lfex/lfe/tags)

## Usage [&#x219F;](#table-of-contents)

### Instant REPL [&#x219F;](#table-of-contents)

Running an LFE REPL in any of the provided images is as simple as the following:

```
docker run lfex/lfe:2.1.1-25.3-alpine
```

```
Erlang/OTP 25 [erts-13.2.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]

   ..-~.~_~---..
  (      \\     )    |   A Lisp-2+ on the Erlang VM
  |`-.._/_\\_.-':    |   Type (help) for usage info.
  |         g |_ \   |
  |        n    | |  |   Docs: http://docs.lfe.io/
  |       a    / /   |   Source: http://github.com/lfe/lfe
   \     l    |_/    |
    \   r     /      |   LFE v2.1.1 (abort with ^G)
     `-E___.-'

lfe>
```

### Running Examples [&#x219F;](#table-of-contents)

#### Modules via CLI

Some of the LFE example modules have been compiled in these Docker images for
your testing convenience. How they are run depends upon each example. For
instance, here's how to run the LFE port of the classic Erlang "ring" example:

```
docker run lfex/lfe -pa examples/ebin -noshell -run ring main 503 50000000
```

Note that, because these Docker images use `ENTRYPOINT`, they can be run just
like you run the installed `lfe` binary on a system, complete with command line
flags. The only difference is that instead of typing `lfe` in the terminal,
we type `docker run lfex/lfe:1.3-20.3-alpine`.

This will run for a while, then you'll get the expected output:

```
Result: 292
```

Another example, based on
<http://joearms.github.io/2013/11/21/My-favorite-erlang-program.html>, will take
_quite_ a long while to finish:

```
docker run lfex/lfe:1.3-18.3-slim -pa examples/ebin -noshell -run joes-fav run-it
```

```
30414093201713378043612608166064768844377641568960512000000000000
```

#### Interactive Modules via `main`

For interactive modules where you don't need the LFE prompt:

```
$ docker run -i lfex/lfe \
  -pa examples/ebin -noshell -run guessing-game main
```

```
Guess the number I have chosen, between 1 and 10.
Guess number: 1
Your guess is too low.
Guess number: 10
Your guess is too high.
Guess number: 5
Well-guessed!!
```

#### Precompiled Modules via LFE REPL

Another pre-compiled module in the Docker images is the one demonstrating
Church numerals in LFE. To use it, you just need to include the `examples/ebin`
in the Elrang modules path:

```
docker run -it lfex/lfe:latest -pa examples/ebin
```

```lisp
lfe> (church:one)
#Fun<church.1.125931718>
lfe> (church:get-church 10)
#Fun<church.7.125931718>
lfe> (church:church->int1 (church:get-church 20))
20
```

Another pre-compiled example, utilizing Erlang inboxes and message-passing:

```lisp
lfe> (messenger-back:send-message (self) "Well, I was able to extend the original entry a bit, yes.")
#(#Pid<0.80.0> "Well, I was able to extend the original entry a bit, yes.")
Received message: 'Well, I was able to extend the original entry a bit, yes.'
Sending message to process <0.80.0> ...
lfe> (messenger-back:send-message (self) "And what does it say now?")
#(#Pid<0.80.0> "And what does it say now?")
Received message: 'And what does it say now?'
Sending message to process <0.80.0> ...
lfe> (messenger-back:send-message (self) "Mostly harmless.")
#(#Pid<0.80.0> "Mostly harmless.")
Received message: 'Mostly harmless.'
Sending message to process <0.80.0> ...
```

Then, we can flush the REPL process' inbox to see all the messages it has
received:

```lisp
(c:flush)
Shell got {"Well, I was able to extend the original entry a bit, yes."}
Shell got {"And what does it say now?"}
Shell got {"Mostly harmless."}
ok
```

#### Slurping Modules via LFE REPL

If we wanted to run one of the LFE examples that is not pre-compiled (or, as
is the case for the following example, run code that is not meant to be
compiled, but instead simply run in a REPL session), we can just use `slurp`.
Here's the General Problem Solver LFE example using this approach:

```
docker run -it lfex/lfe
```

```lisp
lfe> (slurp "examples/gps1.lfe")
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

#### Scripts

You can also run the LFE example scripts by changing the entry point:

```
docker run --entrypoint=examples/sample-lfescript lfex/lfe:1.3-20.3-standard
```

This will give us an error, since we didn't pass it the correct argument type:

```
usage: examples/sample-lfescript <integer>
```

Now that we know what to do, thanks to the usage message, let's try again:

```
docker run --entrypoint=examples/sample-lfescript lfex/lfe:1.3-20.3-slim 10
```

```
factorial 10 = 3628800
```

Or another script example:

```
docker run --entrypoint=examples/sample-lfe-shellscript lfex/lfe 5
```

```
factorial 5 = 120
```

## License [&#x219F;](#table-of-contents)

View [license information](https://github.com/lfe/lfe/blob/master/LICENSE)
for the software contained in this image.

## User Feedback [&#x219F;](#table-of-contents)

### Issues [&#x219F;](#table-of-contents)

If you have any problems with or questions about this image, please contact us
by submitting an issue:

- for the [Docker images themselves](https://github.com/lfex/dockerfiles/issues)
- with the [LFE programming language](https://github.com/rvirding/lfe/issues)

You can also reach many of the official image maintainers via the
`#docker-library` IRC channel on [Freenode](https://freenode.net).

### Contributing [&#x219F;](#table-of-contents)

You are invited to contribute new features, fixes, or updates, large or small;
we are always thrilled to receive pull requests, and do our best to process them
as fast as we can.

Before you start to code, we recommend discussing your plans
through a [GitHub feature issue](https://github.com/rvirding/lfe/issues),
especially for more ambitious contributions. This gives other contributors a
chance to point you in the right direction, give you feedback on your design,
and help you find out if someone else is working on the same thing.
