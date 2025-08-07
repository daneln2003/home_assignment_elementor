# Rick & Morty Microservice · DevOps Assignment (Elementor)

This project implements a minimal microservice that fetches and filters Rick and Morty characters and demonstrates full DevOps practices — including containerization, Helm packaging, and a GitHub Actions CI/CD pipeline.

## 🚀 Features

- ✅ Python FastAPI microservice  
- ✅ Filters alive **human characters** from **Earth**  
- ✅ `/characters`, `/healthz`, and `/metrics` endpoints  
- ✅ Dockerized with non-root user & multi-stage build  
- ✅ Helm chart with production-ready configs (HPA, resources, tolerations, etc.)  
- ✅ CI/CD pipeline: dev → staging → production using **Kind** (local Kubernetes)  
- ✅ Manual approval gates for staging and production  

## 📁 Project Structure

```
.
├── app/                      # Python microservice
│   ├── main.py
│   └── requirements.txt
├── helm-chart/               # Helm chart
│   ├── templates/
│   ├── values.yaml
│   ├── values-dev.yaml
│   ├── values-stg.yaml
│   └── values-prod.yaml
├── .github/workflows/ci-cd.yaml
├── Dockerfile
└── README.md
```

## 🧠 Endpoints

| Endpoint      | Purpose                                             |
|---------------|-----------------------------------------------------|
| `/characters` | List alive humans from Earth                        |
| `/metrics`    | Exposes Prometheus metric (`characters_fetched_total`) |
| `/healthz`    | Simple health check (returns 200 OK)                |

## 🐍 Local Development

Install dependencies:

```
pip install -r app/requirements.txt
```

Run the service locally:

```
cd app
uvicorn main:app --reload --port 8000
```

Then test:

- http://localhost:8000/characters  
- http://localhost:8000/metrics  
- http://localhost:8000/healthz

## 🐳 Docker

Build the image:

```
docker build -t rickmorty-app .
```

Run it:

```
docker run -p 8000:8000 rickmorty-app
```

## ⚙️ Helm Deployment (Local or Remote)

Install to a local Kubernetes cluster (e.g. kind or minikube):

```
helm upgrade --install rickmorty-app ./helm-chart -f helm-chart/values-dev.yaml
```

To deploy staging or production configs:

```
helm upgrade --install rickmorty-app ./helm-chart -f helm-chart/values-stg.yaml
helm upgrade --install rickmorty-app ./helm-chart -f helm-chart/values-prod.yaml
```

## 🤖 CI/CD Pipeline (GitHub Actions)

The pipeline includes 4 stages:

1. **Build**
   - Builds Docker image with dynamic tag (`github.run_number`)
   - Pushes to Docker Hub

2. **Deploy to Dev**
   - Spins up a Kind Kubernetes cluster
   - Deploys to `dev` namespace
   - Validates with rollout and `/healthz`

3. **Deploy to Staging** *(manual approval)*
   - Uses Helm with `values-stg.yaml`
   - Deploys to `staging` namespace after Dev succeeds

4. **Deploy to Production** *(manual approval)*
   - Uses `values-prod.yaml`
   - Deploys to `prod` namespace after Staging

### Environments

- Manual approvals are enforced via GitHub **Environments**
- Create `staging` and `prod` environments in the repo Settings → Environments

## 🛡️ Security & Best Practices

- Non-root Docker user  
- Multi-stage Docker build  
- Helm chart includes:
  - HPA support
  - Resource limits/requests
  - Tolerations and affinity
- Readiness and liveness probes
- Separated values files for `dev`, `staging`, and `prod`

## 📦 Example: values-stg.yaml

```yaml
replicaCount: 2

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 4

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: rickmorty-stg.local
      paths:
        - path: /
          pathType: Prefix
```

## 🔒 GitHub Secrets Required

| Secret Name       | Description              |
|-------------------|--------------------------|
| `DOCKER_USERNAME` | Docker Hub username      |
| `DOCKER_PASSWORD` | Docker Hub token/password |

## 👨‍💻 Author

This solution was implemented as part of the Elementor DevOps Engineer Assignment.  
All CI/CD, Kubernetes, and application components were created from scratch.