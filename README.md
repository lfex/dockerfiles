# dockerfiles

*Dockerfiles for LFE on various distributions*

<image src="resources/images/docker-thumb.png" />


## About

This repository provides a handful of LFE ``Dockerfile``s for various Linux
distributions, thus allowing a developer instant access to an environment
where they can run LFE or do LFE development.


## Distributions

This repo provides ``Dockerfile``s for the following Linux distributions:

* Arch Linux
* CentOS (a rather tortured -- but working -- Erlang install to ensurexi
  leex is present... help?)
* Debian
* openSUSE
* Oracle Linux
* Slackware (currently broken... help!)
* Ubuntu

If you don't see your favourite, we accept pull requests!


## Bonus

Each image comes with a bonus: a special color LFE REPL banner :-) (free,
in every box, kids!)

<img src="resources/images/screenshot.png" />


## Usage

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

```bash
$ make lfe-opensuse
Erlang/OTP 17 [erts-6.1] [source] [64-bit] [smp:8:8] [async-threads:10] [hipe]
[kernel-poll:false]

LFE Shell V6.1 (abort with ^G)
>
```


Start up a container and log in directly to a Bash shell:

```bash
$ make bash-opensuse
0c66429e657e:/ #
```

