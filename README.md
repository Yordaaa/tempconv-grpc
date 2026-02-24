# TempConv gRPC Service

This repository contains a minimal temperature conversion backend written in Go using gRPC/gRPC-Web, and a Flutter web frontend that communicates with it via gRPC-Web — no REST involved.

## Structure

- `backend/` – Go gRPC service (exposes native gRPC on `:50051` and gRPC-Web on `:8080`)
- `frontend/` – Flutter web application using gRPC-Web to call the backend
- `proto/` – Shared Protobuf definitions used by both backend and frontend
- `deploy/` – Kubernetes manifests for deployment on GKE
- `loadtest/` – k6 load test script targeting the native gRPC port
- `scripts/` – Helper scripts for code generation and setup

## Backend (Go)

### Getting started

```bash
cd backend
go mod tidy
go test ./...  # run unit tests
```

### gRPC Ports

| Port    | Protocol   | Used by                        |
|---------|------------|--------------------------------|
| `50051` | gRPC       | Native clients, k6 load tests  |
| `8080`  | gRPC-Web   | Flutter Web (browser clients)  |

> Browsers cannot use native HTTP/2 gRPC directly. The backend exposes both ports to support both use cases.

### Build and run

```bash
go build -o tempconv-backend ./
./tempconv-backend
```

### Containerization

A `Dockerfile` is provided; build with:

```bash
docker build -t tempconv-backend backend/
```

## Frontend (Flutter Web)

The frontend calls the backend using **gRPC-Web** generated from the shared `.proto` file.

```bash
cd frontend
flutter pub get
flutter build web
```

Dockerize using a multi-stage build (build in `flutter` image, serve via nginx).

```bash
docker build -t tempconv-frontend frontend/
```

## Local Quickstart (Docker Compose)

Run the full stack locally:

```bash
docker compose up --build
```

| Service             | URL                        |
|---------------------|----------------------------|
| Frontend            | http://localhost:8081       |
| Backend gRPC-Web    | http://localhost:8080       |
| Backend gRPC native | localhost:50051             |

## Protobuf Code Generation

Shared `.proto` definitions live in `proto/tempconv/v1/tempconv.proto`.

Generate Go and Dart code using Docker (no local `protoc` needed):

```bash
./scripts/gen-go.ps1      # generates Go stubs in backend/
./scripts/gen-dart.ps1    # generates Dart stubs in frontend/
```

If you prefer local tooling, install:
- `protoc`
- Go plugins: `protoc-gen-go`, `protoc-gen-go-grpc`
- Dart plugin: `protoc_plugin`

## Kubernetes / GKE

1. Install `gcloud`, `kubectl`, and ensure `gcloud` is authenticated.

2. Create a GKE cluster (AMD64 nodes):
   ```bash
   gcloud container clusters create tempconv-cluster \
     --zone=us-central1-c --num-nodes=3 --machine-type=e2-medium
   ```

3. Get credentials:
   ```bash
   gcloud container clusters get-credentials tempconv-cluster --zone us-central1-c
   ```

4. Build and push images to Google Container Registry (GCR):
   ```bash
   gcloud builds submit --tag gcr.io/$PROJECT_ID/tempconv-backend:latest ./backend
   gcloud builds submit --tag gcr.io/$PROJECT_ID/tempconv-frontend:latest ./frontend
   ```

5. Apply manifests:
   ```bash
   kubectl apply -f deploy/backend-deployment.yaml
   kubectl apply -f deploy/frontend-deployment.yaml
   kubectl apply -f deploy/backend-service.yaml
   kubectl apply -f deploy/frontend-service.yaml
   ```

6. After services are provisioned, note the external IP of the frontend service and use it to access the web app.

## Load Testing

Run the k6 script against the native gRPC port:

```bash
k6 run loadtest/tempconv-test.js
```

> The load test targets port `50051` directly using native gRPC.

## Testing on AMD64 GKE Nodes

GKE default nodes are amd64, which matches the Go binary built without CGO. Docker images are built targeting `linux/amd64`.

## CI/CD

Add a GitHub Actions workflow to build, test, and push images whenever code is pushed to the `main` branch. (Not yet included.)

---

Follow the step-by-step sections above to iteratively implement features, containerize, and deploy.
