FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /src

RUN apt-get update >/dev/null \
  && apt-get install -y --no-install-recommends protobuf-compiler ca-certificates >/dev/null \
  && rm -rf /var/lib/apt/lists/*

COPY proto /src/proto
COPY frontend/app /src/app

WORKDIR /src/app

# Install deps
RUN flutter pub get

# Generate Dart gRPC stubs from shared proto
RUN export PUB_CACHE=/tmp/.pub-cache \
  && dart pub global activate protoc_plugin >/dev/null \
  && export PATH="$PATH:$PUB_CACHE/bin" \
  && mkdir -p lib/gen \
  && protoc -I /src/proto --dart_out=grpc:lib/gen /src/proto/tempconv/v1/tempconv.proto

ARG BACKEND_URL=http://localhost:8080
RUN flutter build web --release --dart-define=BACKEND_URL=$BACKEND_URL

FROM nginx:alpine

COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/app/build/web /usr/share/nginx/html

EXPOSE 80

