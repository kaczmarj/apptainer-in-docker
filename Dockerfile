FROM golang:1.14.0-alpine as builder

ARG SINGULARITY_COMMITISH="master"

WORKDIR $GOPATH/src/github.com/sylabs
RUN apk add --no-cache gawk gcc git libc-dev linux-headers libressl-dev libuuid libseccomp-dev make util-linux-dev
RUN git clone https://github.com/sylabs/singularity.git \
    && cd singularity \
    && git checkout "$SINGULARITY_COMMITISH" \
    && ./mconfig -p /usr/local/singularity \
    && cd builddir \
    && make \
    && make install

FROM alpine:3.7
COPY --from=builder /usr/local/singularity /usr/local/singularity
ENV PATH="/usr/local/singularity/bin:$PATH" \
    SINGULARITY_TMPDIR="/tmp-singularity"
RUN apk add --no-cache ca-certificates libseccomp squashfs-tools \
    && rm -rf /tmp/* \
    && mkdir -p $SINGULARITY_TMPDIR
WORKDIR /work
ENTRYPOINT ["/usr/local/singularity/bin/singularity"]
