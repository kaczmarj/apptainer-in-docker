# Apptainer in Docker

[![Docker images available at ghcr.io/alberto743/apptainer-in-docker](https://img.shields.io/badge/GHCR-ghcr.io%2Falberto743%2Fapptainer--in--docker-blue)](https://github.com/alberto743/apptainer-in-docker/pkgs/container/apptainer-in-docker)

Two Docker recepies are availble in this repository;
- [`package.Dockerfile`](package.Dockerfile) installs Apptainer based on the version available in [Alpine](https://pkgs.alpinelinux.org/package/edge/community/x86_64/apptainer)
- [`compile.Dockerfile`](compile.Dockerfile) installs a custom version of Apptainer from sources based on the tag specified via the `APPTAINER_COMMITISH` build argument.
The resulting Docker image can be used on any system with Docker or Podman to build Apptainer images.
This project is targeted towards high-performance computing users who have Apptainer/Singularity installed on their clusters but do not have Apptainer/Singularity on their local computers to build images.


## Convert local Docker image to Apptainer format

In the following example, we convert an existing Docker image to Apptainer format.

```bash
$ docker pull alpine:3.22
$ docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/work \
    ghcr.io/alberto743/apptainer-in-docker build alpine_3.22.sif docker-daemon://alpine:3.22
```

This output `.sif` file will be owned by root, so you can change ownership:

```bash
sudo chown USER:GROUP alpine_3.22.sif
```

## Build Apptainer image in Docker

With the following command, we build a small Apptainer image defined in [`test_alpine.def`](test_alpine.def).
This Apptainer image will be saved in the current directory `myimage.sif`.

```bash
$ docker run --rm --privileged -v $(pwd):/work ghcr.io/alberto743/apptainer-in-docker \
  build myimage.sif test_alpine.def
```

## Run Apptainer image in Docker

One can run a Apptainer image within this Docker image.
This is not recommended, but it is possible.

```bash
$ docker run --rm ghcr.io/alberto743/apptainer-in-docker \
  run shub://GodloveD/lolcow
```

Here is the output:

```
 _________________________________________
/ He that is giddy thinks the world turns \
| round.                                  |
|                                         |
| -- William Shakespeare, "The Taming of  |
\ the Shrew"                              /
 -----------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

The previous command may require `--privileged`.

## Build image

It is possible to compile a custom version of Apptainer by using the [`compile/Dockerfile`](compile/Dockerfile).

Apptainer version 1.2.0:

```bash
$ docker build --build-arg APPTAINER_COMMITISH=v1.2.0 \
               -t apptainer:1.2.0 \
               -f compile/Dockerfile .
```

Bleeding-edge (main branch):

```bash
$ docker build --build-arg APPTAINER_COMMITISH=main \
               -t apptainer:latest \
               -f compile/Dockerfile .
```
