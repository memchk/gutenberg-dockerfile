FROM ekidd/rust-musl-builder

MAINTAINER Carson Page <pagem.carson@gmail.com>

ENV VERSION v0.2.2

RUN apt update -y && apt install -y wget tar && \
    wget https://github.com/Keats/gutenberg/archive${VERSION}.tar.gz -O gutenberg.tar.gz && \
    tar -xzf gutenberg.tar.gz && \
    rm gutenberg.tar.gz
    
RUN cargo build --release
