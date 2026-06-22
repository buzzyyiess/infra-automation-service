import logging
import json
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from app.schema import RequestPayload
from app.renderer import render_s3_tf

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("uvicorn")

app = FastAPI(title="Terraform-Parse Service", version="1.0.0", docs_url="/docs")

@app.get("/healthz", status_code=status.HTTP_200_OK)
def health_check():
    return {"status": "healthy"}

@app.post("/v1/terraform")
def generate_terraform_manifest(data: RequestPayload):
    props = data.payload.properties
    
    try:
        hcl_output = render_s3_tf(props)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    output_filename = "generated_bucket.tf"
    try:
        # Persist generated manifest output directly onto the local file engine
        with open(output_filename, "w", encoding="utf-8") as f:
            f.write(hcl_output)
    except IOError:
        raise HTTPException(status_code=500, detail="IO Error")

    logger.info(f"Successfully generated infrastructure manifest for bucket: {props.bucket_name}")

    # Code-level formatting: Returns a pretty-printed JSON response with indentations
    response_payload = {
        "status": "success",
        "target_file": output_filename,
        "manifest_preview": hcl_output.splitlines()
    }
    
    return JSONResponse(
        status_code=status.HTTP_201_CREATED,
        content=response_payload
    )