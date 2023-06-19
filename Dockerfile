ARG BUILD_IMAGE="almalinux:8-minimal"

FROM ${BUILD_IMAGE}
ENV DATA_DIR="/config" \
    BIND_USER=named

COPY container_resources/entrypoint.sh /usr/local/bin/
RUN microdnf update -y && \
    microdnf install -y bind bind-utils which && \
    mkdir /config && \
    microdnf clean all && \
    rm -rf /tmp/* && \
    rm -rf /usr/local/share/man/* && \
    chmod +x /usr/local/bin/entrypoint.sh

VOLUME ${DATA_DIR}
COPY container_resources/config ${DATA_DIR}/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/sbin/named", "-4", "-g", "-p", "1053", "-c", "/config/named.conf"]
