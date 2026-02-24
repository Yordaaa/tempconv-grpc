FROM golang:1.24-bookworm AS build

WORKDIR /src

# Tools for protobuf codegen
RUN apt-get update >/dev/null \
  && apt-get install -y --no-install-recommends protobuf-compiler ca-certificates >/dev/null \
  && rm -rf /var/lib/apt/lists/*

# Go deps first (better layer caching)
COPY backend/go.mod backend/go.sum ./backend/
WORKDIR /src/backend
RUN go mod download

# Copy source + proto schema
COPY backend/cmd ./cmd
COPY proto /src/proto

# Generate Go code (overwrites into ./gen)
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
  && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
  && export PATH="$PATH:$(go env GOPATH)/bin" \
  && mkdir -p gen \
  && protoc \
    -I /src/proto \
    --go_out=gen --go_opt=paths=source_relative \
    --go-grpc_out=gen --go-grpc_opt=paths=source_relative \
    /src/proto/tempconv/v1/tempconv.proto

RUN go test ./...

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /out/tempconv-server ./cmd/server

FROM gcr.io/distroless/static-debian12:nonroot

EXPOSE 50051
EXPOSE 8080

ENV GRPC_PORT=50051
ENV WEB_PORT=8080

COPY --from=build /out/tempconv-server /tempconv-server

USER nonroot:nonroot
ENTRYPOINT ["/tempconv-server"]

