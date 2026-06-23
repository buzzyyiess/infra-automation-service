# Infrastructure Automation Service

## Overview

This repository contains the complete solution for the Tripla Infrastructure Automation assessment.

The solution accepts infrastructure payload objects, dynamically renders compliant HashiCorp Configuration Language (HCL) manifests, and deploys the application stack onto a local Kubernetes platform.

The repository consists of three independent deliverables:

* **Task 1** – Terraform Parse Service
* **Task 2** – Terraform Infrastructure Remediation
* **Task 3** – Kubernetes/Helm Deployment

---

# Solution Overview

## Task 1 – Terraform Parse Service

### Objective

* Build an HTTP API that accepts infrastructure payloads
* Validate incoming requests
* generate Terraform HCL- Renders the s3 file
* Persist generated manifests
* Return a structured preview of the generated tf configuration

### Technologies

* Python
* FastAPI
* Pydantic
* Jinja2
* Docker


### API Endpoints

| Method | Endpoint        | Description            |
| ------ | --------------- | ---------------------- |
| POST   | `/v1/terraform` | Generate Terraform HCL |
| GET    | `/healthz`      | Health endpoint        |
| GET    | `/docs`         | OpenAPI documentation  |

---

## Task 2 – Terraform Infrastructure

### Objective

Review, fix and modernize the provided Terraform infrastructure.

### Bug Fixes

* Upgraded deprecated EKS module to v20
* Replaced unsupported `node_groups` implementation with `eks_managed_node_groups`
* Modularized infrastructure configuration
* Added environment parameterization
* Configured remote Terraform state
* Added DynamoDB state locking
* Reviewed S3 ACL deprecation warning
* Improved EKS endpoint security
* Removed hardcoded resource names

### Validation

* `terraform init -backend=false`
* `terraform validate`
* Successful module validation
* Provider compatibility verified

---

## Task 3 – Kubernetes/Helm Deployment

### Objective

Package and deploy the application using Helm onto a local Kubernetes cluster.

### Deliverables

* Docker image
* Helm chart
* Kubernetes manifests
* Local deployment on Kind
* Service exposure
* Application verification

---

# Repository Structure

```text
.
├── terraform-parse-service/
├── infrastructure/
├── helm/
└── README.md
```

---

# Local Validation

## Build Docker Image

```bash
cd terraform_parse_service
docker build -t terraform-parse-service .
cd ..
```

## Create Kind Cluster

```bash
kind create cluster --name tripla
```

## Load Docker Image

```bash
kind load docker-image terraform-parse-service:1.0 --name tripla
```

## Deploy Helm Chart

```bash
helm upgrade --install terraform-parser ./helm
```

## Verify Resources

```bash
kubectl get pods
kubectl get svc
kubectl get deployments
```

## Port Forward

```bash
kubectl port-forward svc/backend-svc 8000:8000
```

## Health Check

```bash
curl http://localhost:8000/healthz
```

Expected Response

```json
{
  "status":"healthy"
}
```

## Generate Terraform

```bash
curl -s http://localhost:8000/v1/terraform \
  -H "Content-Type: application/json" \
  -d '{
    "payload": {
      "properties": {
        "aws-region": "eu-west-1",
        "acl": "private",
        "bucket-name": "tripla-bucket"
      }
    }
  }' | jq -r '.manifest_preview[]'
```

Expected Result

* HTTP 201 Created
* Generated Terraform manifest
* Manifest written to disk
* JSON preview returned
* Invalid requests return **HTTP 422 Unprocessable Entity** with structured validation errors.


---


# Design Decisions

## Task 1

* FastAPI selected for lightweight asynchronous APIs
* Pydantic used for strict schema validation
* Jinja2 separates infrastructure templates from business logic
* Structured JSON response preferred over raw text output
* Modular application layout for maintainability

---

## Task 2

* Upgraded to EKS Module v20 for long-term compatibility
* Managed Node Groups adopted instead of legacy worker groups
* Remote Terraform state configured for collaborative workflows
* DynamoDB locking prevents concurrent state corruption
* Environment-specific variables eliminate naming conflicts
* Private EKS API endpoint improves cluster security

---

## Task 3

* Helm selected for reusable Kubernetes deployments
* Kind provides lightweight local Kubernetes validation
* Docker image built once and reused locally
* Kubernetes resources parameterized through Helm values
* Health probes included for container readiness

---

# Trade-offs

## Task 1

* Generates HCL only for the assignment schema
* Validation is request-level rather than executing `terraform validate`
* Generated manifests are stored locally instead of remote object storage.
* API returns a `manifest_preview` for immediate inspection while persisting the generated `.tf` file locally.


## Task 2

* Backend configuration remains embedded for simplicity
* Single Terraform stack instead of independent infrastructure layers
* Minimal monitoring configuration to keep scope aligned with the assignment

## Task 3

* Local Kind cluster used instead of managed Kubernetes
* Local image loading replaces container registry publishing
* Basic Helm chart without GitOps or progressive delivery

---

# Future Improvements/Enhancements

## Terraform Parse/render service:

* Support additional AWS resources and more complex nested schemas.
* Store generated Terraform artifacts in object storage (e.g., S3) with downloadable URLs.
* Implement structured logging with request IDs,timestamps for easier debugging.

## Terraform Infrastructure

* Terraform Cloud for the state management
* Multiple NodeGroups as per AZ deployment strategy
* Cluster Autoscaler or Karpenter
* EKS control plane logging: audit logs enabling too,
* Prometheus and Grafana monitoring
* GitHub Actions CI/CD pipeline


## Kubernetes/Helm

* Horizontal Pod Autoscaler
* Ingress Controller
* External Secrets
* ArgoCD or FluxCD
* Resource quotas and limits
* Liveness probe for frontend app


---
# Cleanup

Uninstall Helm Release

```bash
helm uninstall terraform-parser
```
Delete Kind Cluster
```
kind delete cluster --name tripla
```
Remove Local Docker Image (Optional)
```
docker rmi terraform-parse-service
```

The above commands remove all local resources created during the assignment, including the Helm release, Kind cluster, Docker image, and generated Terraform manifests.

---

# AI Usage

AI was used as an engineering productivity tool throughout the assignment.

### Assisted With

* Initial project scaffolding
* Documentation drafting
* Terraform module migration research
* Code review and validation
* Architecture brainstorming
* Best-practice verification

### Completed Manually

* Overall solution architecture
* Infrastructure design decisions
* Terraform refactoring and module migration
* FastAPI application implementation
* Helm chart configuration
* Kubernetes deployment validation
* Docker image creation
* Testing and debugging
* Final code review and technical decisions

All implementation decisions, validation, debugging, and final architectural choices were performed manually, with AI serving as an assistant for research, documentation, and review rather than autonomous code generation.
