FROM rust:slim-buster

WORKDIR /usr/src/

RUN apt-get -y update && apt-get -y upgrade && apt-get -y install pkg-config libssl-dev
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
COPY ./src ./src

RUN cargo build

RUN cargo install --path .
RUN rm src/*.rs

ENTRYPOINT ["varnishlog"]
