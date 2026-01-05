ARG BUILD_IMAGE="alpine:3.23"

FROM ${BUILD_IMAGE}
ENV DATA_DIR="/config" \
    BIND_USER=named

COPY container_resources/entrypoint.sh /usr/bin/
RUN apk update && \
    apk add  \
      bind==9.20.17-r0 \
      bind-tools==9.20.17-r0 \
      bash==5.3.3-r1 \
      which==2.23-r0 --no-cache && \
    rm -rf /var/cache/apk/* && \
    mkdir /config && \
    chmod +x /usr/bin/entrypoint.sh
VOLUME ${DATA_DIR}
COPY container_resources/config ${DATA_DIR}/
COPY container_resources/etc /etc
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/sbin/named", "-4", "-g", "-p", "1053", "-c", "/config/named.conf"]
