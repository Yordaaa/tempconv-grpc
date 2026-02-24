Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Generates Go protobuf + gRPC code into backend/gen using Docker (no local protoc required).

$root = (Resolve-Path "$PSScriptRoot\..").Path

docker run --rm `
  -v "${root}:/work" `
  -w /work `
  golang:1.24-bookworm `
  bash -c 'set -eu; apt-get update >/dev/null; apt-get install -y --no-install-recommends protobuf-compiler ca-certificates >/dev/null; cd backend; go install google.golang.org/protobuf/cmd/protoc-gen-go@latest; go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest; export PATH=$PATH:$(go env GOPATH)/bin; mkdir -p gen; protoc -I ../proto --go_out=gen --go_opt=paths=source_relative --go-grpc_out=gen --go-grpc_opt=paths=source_relative ../proto/tempconv/v1/tempconv.proto'
if ($LASTEXITCODE -ne 0) { throw "docker run failed with exit code $LASTEXITCODE" }

Write-Host "OK: generated Go code into backend/gen"

