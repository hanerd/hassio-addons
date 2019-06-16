
FROM homeassistant/amd64-base-python:3.7

# Setup base

RUN apk add --no-cache \
        openssl libffi musl libstdc++ \
    && apk add --no-cache --virtual .build-dependencies \
        g++ musl-dev openssl-dev libffi-dev \
    && pip3 install --no-cache-dir certbot=="0.32.0" \
    && apk del .build-dependencies

# Copy data
COPY run.sh /

CMD [ "/run.sh" ]
