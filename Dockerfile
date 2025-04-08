FROM rust:slim-buster@sha256:bed077243d5e7e02226ac4a2d816999806708b7dedd553c80d568ce4f0b6c964 as build

WORKDIR /build/

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install pkg-config libssl-dev
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build

RUN cargo install --path .

FROM varnish:7.6.1@sha256:5222d9fc93675d533d073d184c25e3e2ae4a2511dac03642704c029f073535a5 as prod

COPY --from=build /build/target/release/varnishslog /usr/bin/varnishslog

CMD ["/bin/sh", "-c", "varnishlog -g raw -w /dev/stdout | /usr/bin/varnishslog"]
