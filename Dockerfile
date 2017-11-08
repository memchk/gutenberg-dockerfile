FROM alpine:edge AS build

MAINTAINER Carson Page <pagem.carson@gmail.com>

ENV VERSION v0.2.2

RUN apk update && apk add rust cargo cmake build-base coreutils openssl-dev libsass-dev

RUN mkdir -p /usr/src/gutenberg

RUN wget https://github.com/Keats/gutenberg/archive/${VERSION}.tar.gz -O gutenberg.tar.gz && \
    tar -xzf gutenberg.tar.gz --strip-components=1 -C /usr/src/gutenberg && \
    rm gutenberg.tar.gz && cd /usr/src/gutenberg

WORKDIR /usr/src/gutenberg

RUN cargo build --release

FROM alpine:latest

EXPOSE 80

RUN apk update && apk add ca-certificates

COPY --from=build /usr/src/gutenberg/target/release/gutenberg /usr/bin/gutenberg
RUN chmod +x /usr/bin/gutenberg && mkdir /workdir
WORKDIR /workdir
CMD ["gutenberg", "serve", "--port=80", "--interface=0.0.0.0"]
