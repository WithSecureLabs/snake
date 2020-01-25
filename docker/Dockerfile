# Build system
FROM debian:buster-20191118-slim
RUN apt update \
    && apt install -y \
        git libfuzzy-dev python3 python3-pip ssdeep \
    && rm -rf /var/lib/apt \
    && rm -rf /var/cache/apt \
    # user and directories
    && useradd -u 2000 -r -s /sbin/nologin -d /var/cache/snake snaked \
    && mkdir -p /etc/snake/scales \
    && mkdir -p /var/run/snake \
    && mkdir -p /var/cache/snake \
    && mkdir -p /var/db/snake \
    && mkdir -p /var/log/snake \
    && mkdir -p /var/lib/snake/scales \
    && chown snaked:snaked -R /etc/snake \
    && chown snaked:snaked -R /etc/snake/scales \
    && chown snaked:snaked -R /var/run/snake \
    && chown snaked:snaked -R /var/cache/snake \
    && chown snaked:snaked -R /var/db/snake \
    && chown snaked:snaked -R /var/log/snake \
    && chown snaked:snaked -R /var/lib/snake

COPY snake-core /tmp/snake
RUN pip3 install /tmp/snake[ssdeep] \
    && cp /tmp/snake/snake/data/config/snake.conf /etc/snake/snake.conf

COPY docker/entrypoint.sh /entrypoint.sh

VOLUME [ "/etc/snake", "/var/db/snake", "/var/lib/snake/scales" ]
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["snake"]
