# Red Bucket

## [![Red Bucket Module](https://github.com/RussellGilmore/red-bucket/actions/workflows/module-test.yml/badge.svg?branch=main)](https://github.com/RussellGilmore/red-bucket/actions/workflows/module-test.yml)

A practical S3 bucket module — private and encrypted by default, with an
optional secure static-website mode fronted by CloudFront over HTTPS.

**Requirements:**

1. Terraform >= 1.15.0
2. Trivy >= 0.68.2

Trivy can be installed via Homebrew on macOS with the command:

```bash
brew install aquasecurity/trivy/trivy
```

## Security posture

-   All public access blocked; SSE-S3 encryption and versioning always on
-   `force_destroy` defaults to `false`
-   Static-website mode uses CloudFront Origin Access Control (OAC) with a
    distribution-scoped bucket policy — the bucket is never publicly readable
-   HTTPS enforced with an ACM-managed certificate (TLS 1.2_2021 minimum)
-   Scanned with Trivy and gitleaks; integration-tested with Terratest

## Usage

A private bucket — see [`examples/complete`](./examples/complete):

```hcl
provider "aws" {
  region = "us-east-1"
}

module "bucket" {
  source = "RussellGilmore/red-bucket/aws"

  project_name = "my-project"
  bucket_name  = "data"
}
```

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.47.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.47.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_acm_certificate.public_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.public_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.public_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.red_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.hosting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.website_files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to apply to all resources created by this module. | `map(string)` | `{}` | no |
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | Apex domain whose Route53 hosted zone holds the website records. Required when enable\_static\_website is true. | `string` | `""` | no |
| <a name="input_auth_lambda_arn"></a> [auth\_lambda\_arn](#input\_auth\_lambda\_arn) | ARN of a Lambda@Edge function for viewer-request authentication. Must be set when enable\_authentication is true. | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket (combined with project\_name). | `string` | n/a | yes |
| <a name="input_enable_authentication"></a> [enable\_authentication](#input\_enable\_authentication) | Enable Lambda@Edge-based authentication on the CloudFront distribution. | `bool` | `false` | no |
| <a name="input_enable_static_website"></a> [enable\_static\_website](#input\_enable\_static\_website) | Create the CloudFront + ACM + Route53 resources needed to serve the bucket as a secure static website. | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to destroy the bucket even when it contains objects. Defaults to false to protect against accidental data loss; set true for ephemeral or test buckets. | `bool` | `false` | no |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | Domain name of an S3 bucket to receive CloudFront access logs (e.g. my-logs.s3.amazonaws.com). When empty, access logging is disabled. The bucket must have ACLs enabled and grant the awslogsdelivery account write access. | `string` | `""` | no |
| <a name="input_logging_prefix"></a> [logging\_prefix](#input\_logging\_prefix) | Object key prefix for CloudFront access logs within logging\_bucket. | `string` | `"cloudfront/"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for resource naming and the Project tag. | `string` | n/a | yes |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | Fully-qualified record name for the website (e.g. app.example.com). Required when enable\_static\_website is true. | `string` | `""` | no |
| <a name="input_website_path"></a> [website\_path](#input\_website\_path) | Path to the static website content to upload. | `string` | `"../site"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_red_bucket_name"></a> [red\_bucket\_name](#output\_red\_bucket\_name) | The S3 bucket for storing whatever you want |
| <a name="output_s3_url"></a> [s3\_url](#output\_s3\_url) | S3 hosting URL (HTTP) |
| <a name="output_website_record"></a> [website\_record](#output\_website\_record) | Route 53 record for the website |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | Website URL (HTTPS) |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
