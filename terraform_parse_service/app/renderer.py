from pathlib import Path
from jinja2 import Environment, FileSystemLoader, StrictUndefined
from app.schema import BucketProperties

# Calculate explicit blueprint asset template directory pathway
TEMPLATE_DIR = Path(__file__).parent / "templates"

# Initialize template engine with strict undefined variable parameters
jinja_env = Environment(
    loader=FileSystemLoader(TEMPLATE_DIR),
    undefined=StrictUndefined
)

def render_s3_tf(props: BucketProperties) -> str:
    """Compiles validated properties into a clean standard-compliant HCL string."""
    template = jinja_env.get_template("s3.tf.j2")
    return template.render(
        aws_region=props.aws_region,
        bucket_name=props.bucket_name,
        acl=props.acl
    )
