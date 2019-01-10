# Singularity in Docker

You've heard of [Docker in Docker](https://github.com/jpetazzo/dind), but what about Singularity in Docker?

The Dockerfile in this repository builds Singularity 3.x. The resulting Docker image can be used on any system with Docker to build Singularity images. This project is targeted towards high-performance computing users who have Singularity installed on their clusters but do not have Singularity on their local computers to build images.

## Build Singularity image in Docker

With the following command, we build a small Singularity image defined in [`Singularity_test`](Singularity_test). This Singularity image will be saved in the current directory as `myimage.sif`.

```bash
$ docker run --rm --privileged -v $(pwd):/work kaczmarj/singularity:3.0.2 \
  build /work/myimage.sif /work/Singularity_test
```

## Run Singularity image in Docker

One can run a Singularity image within this Docker image. This is not recommended, but it is possible.

```bash
$ docker run --rm --privileged kaczmarj/singularity:3.0.2 \
  run shub://GodloveD/lolcow
```

## Build image

Singularity version 3.0.2:

```bash
$ docker build --build-arg SINGULARITY_COMMITISH=v3.0.2 -t singularity:3.0.2 - < Dockerfile
```

Bleeding-edge (master branch):

```bash
$ docker build --build-arg SINGULARITY_COMMITISH=master -t singularity:latest - < Dockerfile
```
