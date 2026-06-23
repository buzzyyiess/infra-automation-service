# terraform-parse service

An asynchronous HTTP microservice that dynamically ingests structural infrastructure definitions and programmatically compiles them into valid, production-ready HashiCorp Configuration Language (HCL) S3 bucket blueprints. Built for Part 1 of the Tripla SRE take-home.

---

## What it does

`POST /v1/terraform` accepts the payload from the assignment spec:

```json
{
  "payload": {
    "properties": {
      "aws-region": "us-east-1",
      "acl": "private",
      "bucket-name": "tripla-assessment-bucket-2026"
    }
  }
}
```

And responds natively with an HTTP status code `201 Created` carrying a structured JSON payload. The HCL preview is elegantly separated into structural string arrays via `.splitlines()` formatting to optimize both machine-to-machine schema pipelines and immediate human terminal readability.

---

## Architecture

```text
POST /v1/terraform ──> Pydantic Validation ──> 422 on bad input ──> Jinja2 HCL Renderer ──> JSON Response Array (201)
```

The service maintains clear, decoupled boundaries through a three-tier modular layout:
* `app/schema.py`: Governs data strictness and edge-case perimeter boundaries.
* `app/renderer.py`: Compiles template logic safely via strict undefined evaluations.
* `main.py`: Manages ASGI request loops, filesystem writing actions, and telemetry routing handlers.

---

## API reference

| Method | Path | Purpose |
|---|---|---|
| POST | `/v1/terraform` | Processes properties, writes a physical file to disk, and returns a JSON array preview. |
| GET | `/healthz` | Container-native liveness check — `{"status": "healthy"}`. |
| GET | `/docs` | OpenAPI auto-generated interactive documentation. |

Validation failures systematically respond with `422 Unprocessable Entity` containing native error path definitions. Unhandled tracebacks are securely captured and handled by FastAPI’s error perimeter.

---

## Quick start

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

uvicorn main:app --reload --port 8000
```

### Example call:
```bash
curl -X POST "http://127.0.0.1:8000/v1/terraform"      -H "Content-Type: application/json"      -d '{
       "payload": {
         "properties": {
           "aws-region": "us-east-1",
           "acl": "private",
           "bucket-name": "tripla-assessment-bucket-2026"
         }
       }
     }'
```

---

## Docker

The application utilizes a secure, production-hardened `Dockerfile` with layer-caching optimization and non-root execution permissions to guarantee runtime safety.

```bash
docker build -t terraform-parse-service:latest .
docker run -d -p 8000:8000 --name tf-parse-running terraform-parse-service:latest
```

---

## Layout

```text
terraform_parse_service/
├── app/
│   ├── __init__.py
│   ├── main.py            # FastAPI entrypoint & network routing loops
│   ├── schema.py          # Pydantic contract boundaries + regex validations
│   ├── renderer.py        # Jinja2 text compiler pipeline engine
│   └── templates/
│       └── s3.tf.j2       # Pure structural HCL blueprint source code
├── Dockerfile             # Multi-tier container mapping with user rules
├── .dockerignore          # Workspace artifact boundary filter rules
├── requirements.txt       # Frozen platform package trees
└── README.md              # System specification guide
```

---

## Design decisions

| Choice | Reason |
|---|---|
| **Python + FastAPI** | Pydantic v2 establishes strict contracts natively, eliminating explicit typing validation loops while producing reliable JSON schemas. |
| **Jinja2 for HCL** | Standardizes file layout structure inside clean static source assets. Avoids loading excessive upstream parser runtimes for static boilerplate generation. |
| **Structured JSON Array** | Replacing raw `text/plain` streams with JSON payloads using `.splitlines()` optimization provides clean REST extensibility for machine architectures without compromising terminal line readability. |
| **`extra="forbid"` on models** | Enforces data compliance at the ingress boundary layer. Rejects structural noise immediately with standard validation faults. |

---

## Assumptions

* **HCL Scope Realism:** Includes secondary structural dependencies (`aws_s3_bucket_ownership_controls`) mandatory for modern AWS provider matrices to reliably apply `private` ACL variables.
* **Network & Multi-tenancy:** Set up as a lightweight internal runtime engine. Presumes perimeter rate limits and secure verification are safely delegated to reverse proxy boundaries.
* **Regional Validation:** Uses strategic regular expressions matching shape models (`xx-yyy-N`) to shield against future AWS regional lifecycle launches breaking validation blocks.

---

## Trade-offs and what I would do next

* **Local Disk Footprint:** Artifact output variables write straight to local storage. In enterprise scale, this should stream directly to a secure bucket or cloud infrastructure control layer.
* **Validation Bounds:** Local validation asserts regex matches. Adding a mock wrapper checking against a `terraform validate` binary execution stage would offer stricter infrastructure typing.

---

## AI assistance

In compliance with project submission requirements, this section details the scope of AI utilization throughout the architecture of the `terraform-parse` service:

* **Structural Scaffolding:** AI was leveraged to generate baseline boilerplate layouts for the modular python code directories and network setups.
* **Pattern Cross-referencing:** Used to identify edge case naming limitations against standard bucket format validation strings inside Pydantic structures.
* **Architectural Decisions:** All vital engineering selections—including shifting from unstructured text models to structured line-separated JSON blocks, stripping verbose logging handlers for crisp native streaming, and defining accurate semantic response mapping criteria—were executed manually under human engineering direction to meet enterprise SRE standards.
