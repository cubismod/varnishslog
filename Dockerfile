FROM rust:slim-buster@sha256:bed077243d5e7e02226ac4a2d816999806708b7dedd553c80d568ce4f0b6c964 as build

WORKDIR /build/

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install pkg-config libssl-dev
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build

RUN cargo install --path .

FROM varnish:7.6.1@sha256:b50eef0a85e66ca675bb652eeb4f2dc6a209645c5b2ea2ac03059a8e250187aa as prod

COPY --from=build /build/target/release/varnishslog /usr/bin/varnishslog

CMD ["/bin/sh", "-c", "varnishlog -g raw -w /dev/stdout | /usr/bin/varnishslog"]
