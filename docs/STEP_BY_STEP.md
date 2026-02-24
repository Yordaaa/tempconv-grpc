## Step-by-step: TempConv (Go gRPC + Flutter Web gRPC-Web) → Docker → GKE

### 0) Architecture (what we’re building)

- **One `.proto` contract** in `proto/tempconv/v1/tempconv.proto`
- **Backend (Go)** serves:
  - **native gRPC** on `:50051` (fast + ideal for load tests)
  - **gRPC-Web** on `:8080` (required for browsers / Flutter web)
- **Frontend (Flutter Web)** calls the backend via **gRPC-Web**
- **Containers**: built as Linux images; GKE nodes are **amd64**, so we build for **linux/amd64**
- **Kubernetes (GKE)**: two Deployments + Services (LoadBalancers for frontend and gRPC-Web)

Why gRPC-Web?

- Browsers can’t open native HTTP/2 gRPC connections like mobile/VM clients can.
- So the backend exposes a gRPC-Web endpoint that Flutter web can use.

---

### 1) Generate code from `.proto` (optional)

The Docker builds also generate code, but if you want generated code locally:

- **Go**:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\gen-go.ps1
```

- **Dart**:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\gen-dart.ps1
```

---

### 2) Run locally with Docker Compose

From repo root:

```powershell
docker compose up --build
```

You’ll get:

- **Backend gRPC**: `localhost:50051`
- **Backend gRPC-Web**: `http://localhost:8080`
- **Frontend**: `http://localhost:8081`

---

### 3) Run tests locally

#### Backend unit tests (in a container)

```powershell
docker run --rm -v "${pwd}:/work" -w /work/backend golang:1.24-bookworm bash -c "go test ./..."
```

#### Load test (k6 → native gRPC)

Run from repo root (so `./proto` resolves):

```powershell
k6 run -e TARGET=localhost:50051 loadtest\tempconv-grpc.js
```

---

### 4) Deploy to GKE (Google Kubernetes Engine)

Assumptions:

- You have a GCP project and billing enabled.
- You want a **GKE** cluster with **amd64** nodes (default).
- You will push images to **Artifact Registry**.

Set variables:

```powershell
$PROJECT   = "<your-gcp-project-id>"
$REGION    = "europe-west1"           # pick your region
$REPO      = "tempconv"
$CLUSTER   = "tempconv-gke"
```

Enable APIs:

```powershell
gcloud config set project $PROJECT
gcloud services enable container.googleapis.com artifactregistry.googleapis.com
```

Create an Artifact Registry Docker repo:

```powershell
gcloud artifacts repositories create $REPO --repository-format=docker --location=$REGION
```

Create a cluster:

```powershell
gcloud container clusters create $CLUSTER --region $REGION --num-nodes 2
gcloud container clusters get-credentials $CLUSTER --region $REGION
```

Build & push images **for linux/amd64** (important for GKE nodes):

```powershell
$BACKEND_IMAGE  = "$REGION-docker.pkg.dev/$PROJECT/$REPO/tempconv-backend:v1"
$FRONTEND_IMAGE = "$REGION-docker.pkg.dev/$PROJECT/$REPO/tempconv-frontend:v1"

docker buildx build --platform linux/amd64 -t $BACKEND_IMAGE  -f backend/Dockerfile  --push .
```

Deploy backend first:

1) Edit `deploy/kustomization.yaml` to set `tempconv-backend` image to `$BACKEND_IMAGE`.
2) Apply:

```powershell
kubectl apply -k deploy
```

Get the **backend gRPC-Web** external IP:

```powershell
kubectl -n tempconv get svc tempconv-backend-grpcweb
```

Build & push the frontend image (bake the backend URL into the web build):

```powershell
$BACKEND_URL = "http://<BACKEND_GRPCWEB_EXTERNAL_IP>"
docker buildx build --platform linux/amd64 -t $FRONTEND_IMAGE -f frontend/Dockerfile --build-arg BACKEND_URL=$BACKEND_URL --push .
```

Then update `deploy/kustomization.yaml` to set the `tempconv-frontend` image to `$FRONTEND_IMAGE`, and re-apply:

```powershell
kubectl apply -k deploy
```

Get the frontend external IP:

```powershell
kubectl -n tempconv get svc tempconv-frontend
```

Open `http://<FRONTEND_EXTERNAL_IP>` in your browser.

---

### 5) Load test in-cluster (optional)

This runs k6 **inside** the cluster against the internal gRPC service:

```powershell
kubectl -n tempconv apply -f deploy\k6-configmap.yaml
kubectl -n tempconv apply -f deploy\k6-job.yaml
kubectl -n tempconv logs job/tempconv-k6 -f
```

