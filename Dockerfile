FROM ghcr.io/ironpeakservices/iron-alpine/iron-alpine:3.20.3

LABEL maintainer="Risto Lievonen"

ENV PYTHON_VERSION 3.12.7-r0
ENV PIP_VERSION 24.0-r2
ENV NODE_VERSION 23.1.0

RUN mkdir /app/backend
COPY . /app/backend/

RUN apk add --no-cache python3=${PYTHON_VERSION} py3-pip=${PIP_VERSION}
RUN pip install -r /app/backend/requirements.txt --break-system-packages

RUN apk add --no-cache \
    libstdc++ \
  && apk add --no-cache --virtual .build-deps \
    curl \
  && ARCH= OPENSSL_ARCH='linux*' && alpineArch="$(apk --print-arch)" \
    && case "${alpineArch##*-}" in \
      x86_64) ARCH='x64' CHECKSUM="32328ab3c3c91e737d165352dab0c7ee67b89a1d00b5226d711c8bf9d15f3bfd" OPENSSL_ARCH=linux-x86_64;; \
      x86) OPENSSL_ARCH=linux-elf;; \
      aarch64) OPENSSL_ARCH=linux-aarch64;; \
      arm*) OPENSSL_ARCH=linux-armv4;; \
      ppc64le) OPENSSL_ARCH=linux-ppc64le;; \
      s390x) OPENSSL_ARCH=linux-s390x;; \
      *) ;; \
    esac \
  && if [ -n "${CHECKSUM}" ]; then \
  set -eu; \
  curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
  echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  # Remove unused OpenSSL headers to save ~34MB. See this NodeJS issue: https://github.com/nodejs/node/issues/46451
  && find /usr/local/include/node/openssl/archs -mindepth 1 -maxdepth 1 ! -name "$OPENSSL_ARCH" -exec rm -rf {} \; \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

#ENTRYPOINT [ "python" ]

USER app

EXPOSE 8000
CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]