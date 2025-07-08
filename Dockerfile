FROM alpine

ARG username=appuser
ARG groupname=$username
ARG userid=1000
ARG groupid=1000

RUN    apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && apk del tzdata \
    && apk add tini

RUN    apk upgrade --no-cache \
    && apk add --no-cache apptainer

RUN    addgroup -g ${groupid} ${groupname} \
    && adduser -D -g "" -u ${userid} -G ${groupname} -h /work ${username}

USER ${username}
WORKDIR /work
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/apptainer"]
