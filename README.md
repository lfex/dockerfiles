# dockerfiles

*Dockerfiles for LFE on various distributions*

<image src="resources/images/docker-thumb.png" />

##### Table of Contents

* [About](#about-)
* [Distributions](#distributions-)
* [Bonus](#bonus-)
* [Usage](#usage-)
  * [Native Docker](#native-docker)
  * [From Source](#from-source)


## About [&#x219F;](#table-of-contents)

This repository provides a handful of LFE ``Dockerfile``s for various Linux
distributions, thus allowing a developer instant access to an environment
where they can run LFE or do LFE development.

Each image comes with the following:
 * Erlang and LFE
 * The rebar3, relx, and kerl tools


## Distributions [&#x219F;](#table-of-contents)

This repo provides ``Dockerfile``s for the following Linux distributions:

* Arch Linux
* CentOS (a rather tortured -- but working -- Erlang install to ensure
  leex is present... help?)
* Debian
* Fedora
* openSUSE
* Oracle Linux
* Raspbian (pending tests)
* Slackware (currently broken... help!)
* Tiny Core Linux
* Ubuntu

If you don't see your favourite, we accept pull requests!

Ordered by size (smallest to largest using the output from ``docker images``),
we have the following:

```
lfex/debian          latest              857ff2a1a047        565.4 MB
lfex/ubuntu          latest              c6d3f8ee6367        572.2 MB
lfex/tinycore        latest              67d363082648        867.8 MB
lfex/centos          latest              c0f7ddd3cc86        912 MB
lfex/opensuse        latest              1287380be3c2        1.229 GB
lfex/oracle          latest              bde166074202        1.319 GB
lfex/fedora          latest              a40b62cbb7d0        1.426 GB
lfex/arch            latest              53c8fe225bb8        1.574 GB
```


## Bonus [&#x219F;](#table-of-contents)

Each image comes with a bonus: a special color LFE REPL banner :-)

(Free! One in every box, kids!)

<img src="resources/images/screenshot.png" />


## Usage [&#x219F;](#table-of-contents)

### Native Docker

Example usage is given below using the ``lfex/opensuse`` image. For other
distributions, simply substitute the name in all the ``make`` targets.

Pull an image from [Docker Hub](https://registry.hub.docker.com/repos/lfex/):

```bash
$ docker pull lfex/opensuse
```

Start the REPL:

```
$ docker run -i -t lfex/opensuse lfe
```


### From Source

Example usage is given below using the ``lfex/opensuse`` image. For other
distributions, simply substitute the name in all the ``make`` targets.

Build an image:

```bash
$ make opensuse
```

Ensure an image is working as expected:

```bash
$ make check-opensuse
The answer is: 42
```

Start up a container and log in directly to an LFE REPL:

```
$ make lfe-opensuse
Erlang/OTP 19 [erts-8.1] [source-77fb4f8] [64-bit] [smp:4:4] [async...

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


Start up a container and log in directly to a Bash shell:

```bash
$ make bash-opensuse
0c66429e657e:/ #
```

