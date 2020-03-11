# Singularity in Docker

You've heard of [Docker in Docker](https://github.com/jpetazzo/dind), but what about Singularity in Docker?

The Dockerfile in this repository builds Singularity 3.x. The resulting Docker image can be used on any system with Docker to build Singularity images. This project is targeted towards high-performance computing users who have Singularity installed on their clusters but do not have Singularity on their local computers to build images.

## Build Singularity image in Docker

With the following command, we build a small Singularity image defined in [`Singularity_test`](Singularity_test). This Singularity image will be saved in the current directory as `myimage.sif` (3.x) or `myimage.simg` (2.x).

Singularity 3.x

```bash
$ docker run --rm --privileged -v $(pwd):/work kaczmarj/singularity:3.5.3 \
  build myimage.sif Singularity_test
```

Singularity 2.x

```bash
$ docker run --rm --privileged -v $(pwd):/work kaczmarj/singularity:2.6.1 \
  build myimage.simg Singularity_test
```

## Run Singularity image in Docker

One can run a Singularity image within this Docker image. This is not recommended, but it is possible.

```bash
$ docker run --rm --privileged kaczmarj/singularity:3.5.3 \
  run shub://GodloveD/lolcow
```

```bash
$ docker run --rm --privileged kaczmarj/singularity:2.6.1 \
  run shub://GodloveD/lolcow
```

## Build image

Singularity version 3.5.3:

```bash
$ docker build --build-arg SINGULARITY_COMMITISH=v3.5.3 -t singularity:3.5.3 - < Dockerfile
```

Bleeding-edge (master branch):

```bash
$ docker build --build-arg SINGULARITY_COMMITISH=master -t singularity:latest - < Dockerfile
```

Singularity 2.6.1:

```bash
$ docker build --build-arg SINGULARITY_COMMITISH=2.6.1 -t singularity:2.6.1 - < Dockerfile.2x
```
