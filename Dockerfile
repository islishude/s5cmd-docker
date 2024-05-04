FROM golang:1.22.2-alpine as build
RUN apk add --no-cache git make
WORKDIR  /s5cmd
COPY . ./
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 make build

FROM alpine:3.19.1
COPY --from=build /s5cmd/s5cmd /usr/local/bin/
RUN apk add --no-cache tar pv zstd tmux
WORKDIR /aws
ENTRYPOINT ["s5cmd"]
