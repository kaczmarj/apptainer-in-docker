FROM golang:1.24-alpine3.22 AS builder

RUN apk add --no-cache \
        # Required for apptainer to find min go version
        bash \
        binutils-gold \
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
ARG MCONFIG_OPTIONS="--with-suid"
WORKDIR $GOPATH/src/github.com/apptainer
RUN    git clone https://github.com/apptainer/apptainer.git \
    && cd apptainer \
    && git checkout "$APPTAINER_COMMITISH" \
    && ./mconfig $MCONFIG_OPTIONS -p /usr/local/apptainer \
    && cd builddir \
    && make \
    && make install


FROM alpine:3.22

ARG username=appuser
ARG groupname=$username
ARG userid=1000
ARG groupid=1000

RUN    apk upgrade --no-cache \
    && apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && apk del tzdata \
    && apk add --no-cache tini
RUN    addgroup -g ${groupid} ${groupname} \
    && adduser -D -g "" -u ${userid} -G ${groupname} -h /work ${username}

ENV APPTAINER_TMPDIR="/tmp-apptainer"
RUN mkdir -p "$APPTAINER_TMPDIR" && chown ${userid}:${groupid} "$APPTAINER_TMPDIR"
COPY --from=builder /usr/local/apptainer /usr/local/apptainer
RUN apk add --no-cache libseccomp squashfs-tools
ENV PATH="/usr/local/apptainer/bin:$PATH"

USER ${username}
WORKDIR /work
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/apptainer/bin/apptainer"]
