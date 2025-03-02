FROM rust:slim-buster@sha256:bed077243d5e7e02226ac4a2d816999806708b7dedd553c80d568ce4f0b6c964 as build

WORKDIR /usr/src/

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install pkg-config libssl-dev
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build

RUN cargo install --path .

FROM varnish:7.5.0 as prod

COPY --from=build /usr/src/varnishslog /usr/bin/varnishslog

CMD "varnishlog -g raw -w /dev/stdout | /usr/bin/varnishslog"
