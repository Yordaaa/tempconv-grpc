Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Generates Dart protobuf + gRPC stubs into frontend/app/lib/gen using Docker (no local protoc required).

$root = (Resolve-Path "$PSScriptRoot\..").Path

docker run --rm `
  -v "${root}:/work" `
  -w /work `
  dart:stable `
  bash -c 'set -eu; apt-get update >/dev/null; apt-get install -y --no-install-recommends protobuf-compiler ca-certificates >/dev/null; export PUB_CACHE=/tmp/.pub-cache; dart pub global activate protoc_plugin >/dev/null; export PATH=$PATH:$PUB_CACHE/bin; mkdir -p frontend/app/lib/gen; protoc -I proto --dart_out=grpc:frontend/app/lib/gen proto/tempconv/v1/tempconv.proto'
if ($LASTEXITCODE -ne 0) { throw "docker run failed with exit code $LASTEXITCODE" }

Write-Host "OK: generated Dart code into frontend/app/lib/gen"

