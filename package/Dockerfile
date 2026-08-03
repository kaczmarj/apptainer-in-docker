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
RUN apk add --no-cache apptainer

USER ${username}
WORKDIR /work
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/apptainer"]
