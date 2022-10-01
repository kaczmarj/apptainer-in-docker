FROM golang:1.19.1-alpine3.16 as builder

RUN apk add --no-cache \
        # Required for apptainer to find min go version
        bash \
        cryptsetup \
        gawk \
        gcc \
        git \
        libc-dev \
        linux-headers \
        libressl-dev \
        libuuid \
        libseccomp-dev \
        make \
        util-linux-dev

ARG APPTAINER_COMMITISH="main"
WORKDIR $GOPATH/src/github.com/apptainer
RUN git clone https://github.com/apptainer/apptainer.git \
    && cd apptainer \
    && git checkout "$APPTAINER_COMMITISH" \
    && ./mconfig --without-suid -p /usr/local/apptainer \
    && cd builddir \
    && make \
    && make install

FROM alpine:3.16
COPY --from=builder /usr/local/apptainer /usr/local/apptainer
ENV PATH="/usr/local/apptainer/bin:$PATH" \
    APPTAINER_TMPDIR="/tmp-apptainer"
RUN apk add --no-cache ca-certificates libseccomp squashfs-tools tzdata \
    && mkdir -p $APPTAINER_TMPDIR \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && apk del tzdata \
    && rm -rf /tmp/* /var/cache/apk/*
WORKDIR /work
ENTRYPOINT ["/usr/local/apptainer/bin/apptainer"]
