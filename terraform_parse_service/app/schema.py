import re
from pydantic import BaseModel, Field, field_validator

class BucketProperties(BaseModel):
    # Enforce strict schema validation configuration
    model_config = {"extra": "forbid"}
    aws_region: str = Field(alias="aws-region")
    acl: str
    bucket_name: str = Field(alias="bucket-name")

    @field_validator("aws_region")
    @classmethod
    def validate_region(cls, v: str) -> str:
        # Validate standard AWS region naming structures
        if not re.match(r"^[a-z]{2}-[a-z]+-\d+$", v):
            raise ValueError("Invalid AWS Region topology format.")
        return v

    @field_validator("bucket_name")
    @classmethod
    def validate_bucket(cls, v: str) -> str:
        # Enforce global AWS S3 naming limitations and constraints
        if not re.match(r"^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", v) or ".." in v:
            raise ValueError("Bucket name violates global AWS S3 naming restrictions.")
        return v

    @field_validator("acl")
    @classmethod
    def validate_acl(cls, v: str) -> str:
        # Restrict input to standard acceptable S3 canonical ACL parameters
        allowed = {"private", "public-read", "public-read-write", "authenticated-read"}
        if v not in allowed:
            raise ValueError("Unsupported or invalid S3 ACL profile.")
        return v

class PayloadWrapper(BaseModel):
    model_config = {"extra": "forbid"}
    properties: BucketProperties

class RequestPayload(BaseModel):
    model_config = {"extra": "forbid"}
    payload: PayloadWrapper
