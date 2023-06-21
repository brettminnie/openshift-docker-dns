ARG BUILD_IMAGE="alpine:3.18"

FROM ${BUILD_IMAGE}
ENV DATA_DIR="/config" \
    BIND_USER=named

COPY container_resources/entrypoint.sh /usr/bin/
RUN apk update && \
    apk add bind==9.18.14-r1 bind-tools==9.18.14-r1 bash==5.2.15-r5 which==2.21-r4 --no-cache && \
    rm -rf /var/cache/apk/* && \
    mkdir /config && \
    chmod +x /usr/bin/entrypoint.sh
VOLUME ${DATA_DIR}
COPY container_resources/config ${DATA_DIR}/
COPY container_resources/etc /etc
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["/usr/sbin/named", "-4", "-g", "-p", "1053", "-c", "/config/named.conf"]
