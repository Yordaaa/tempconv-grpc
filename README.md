# TempConv (gRPC + Protocol Buffers) — Go backend, Flutter Web frontend, GKE-ready

This repo is a minimal temperature conversion app built **without REST**:

- **Backend**: Go gRPC service (no DB; pure calculation)
  - Exposes **real gRPC** on port `50051` (for native clients + load tests)
  - Exposes **gRPC-Web** on port `8080` (for browser/Flutter web)
- **Frontend**: Flutter Web app that calls the backend using **gRPC-Web**
- **Containerization**: Docker (targets **linux/amd64** for GKE nodes)
- **Kubernetes**: manifests to deploy to **GKE**
- **Load testing**: `k6` gRPC test script (hits port `50051`)

## Repo layout

- `proto/` — `.proto` definitions shared by backend + frontend
- `backend/` — Go gRPC server + tests + Dockerfile
- `frontend/` — Flutter web app + Dockerfile
- `deploy/` — Kubernetes manifests (GKE-friendly)
- `loadtest/` — k6 load tests

## High-level flow (why 2 ports?)

Browsers cannot use “native” HTTP/2 gRPC directly. Flutter Web therefore uses **gRPC-Web**.
To keep load testing and non-browser clients simple, the backend also exposes a standard gRPC port.

## Prereqs

You said these are already installed:

- Docker
- kubectl
- Google Cloud SDK + `gke-gcloud-auth-plugin`
- k6

### About Go/Flutter/protoc

This repo is set up so you can do **builds and code generation using Docker**, even if `go`, `flutter`, or `protoc` are not on your PATH in a given terminal/editor session.

If you prefer local tooling, you’ll also need:

- `protoc`
- Go plugins: `protoc-gen-go`, `protoc-gen-go-grpc`
- Dart plugin: `protoc_plugin`

We’ll generate code for Go and Dart from the same `proto/tempconv/v1/tempconv.proto`.

## Quickstart (local)

Run everything with Docker:

```powershell
docker compose up --build
```

- Frontend: `http://localhost:8081`
- Backend gRPC-Web: `http://localhost:8080`
- Backend gRPC (native): `localhost:50051`

## Full guide

See `docs/STEP_BY_STEP.md`.

