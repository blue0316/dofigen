# This file is generated by Dofigen v0.0.0
# https://github.com/lenra-io/dofigen

# syntax=docker/dockerfile:1.4

# builder
FROM ekidd/rust-musl-builder AS builder
ADD --link . ./
RUN \
    --mount=type=cache,sharing=locked,uid=1000,gid=1000,target=/home/rust/.cargo\
    --mount=type=cache,sharing=locked,uid=1000,gid=1000,target=/home/rust/src/target\
    cargo build --release -F cli --target=x86_64-unknown-linux-musl && \
    mv target/x86_64-unknown-linux-musl/release/dofigen ../

# runtime
FROM scratch AS runtime
WORKDIR /app
COPY --link --chown=1000:1000 --from=builder "/home/rust/dofigen" "/bin/"
ENTRYPOINT ["/bin/dofigen"]
CMD ["--help"]
