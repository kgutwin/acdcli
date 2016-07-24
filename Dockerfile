FROM alpine:3.4

MAINTAINER sedlund@github @sredlund

RUN apk update \
    && apk upgrade \
    && apk add python3 fuse elinks ca-certificates \
    && pip3 install acdcli \
    && rm -rf /root/.cache \
    && apk del wget ca-certificates \
    && rm /var/cache/apk/* \
    && addgroup user \
    && adduser -G user -D user

ENV LIBFUSE_PATH=/usr/lib/libfuse.so.2

USER user

ENTRYPOINT ["/usr/bin/acdcli"]

CMD ["-h"]
