FROM alpine:latest

RUN apk add --no-cache mongodb
RUN mkdir -p /data/db && \
    mkdir -p /data/logs && \
    mkdir -p /data/config && \
    addgroup mongodb mongodb && \
    wget --no-check-certificate -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    rm -rf /var/cache/apk/*
RUN mkdir /docker-entrypoint-initdb.d
COPY ./db-setup.js /docker-entrypoint-initdb.d
COPY ./data/config/mongod.conf /data/config
# COPY ./init_db.sh /tmp
# RUN chmod +x /tmp/init_db.sh
# RUN /tmp/init_db.sh
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh && \
    chmod +x usr/local/bin/docker-entrypoint.sh
VOLUME ["/data"]
EXPOSE 27017

CMD ["docker-entrypoint.sh"]