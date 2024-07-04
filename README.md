# Red Bucket

A S3 Bucket module designed to be practical for casual use.

<!-- prettier-ignore-start -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.example_cert](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.example_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.default](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_route53_record.example_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route53_record) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.red-bucket](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_encryption](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_versioning](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.hosting](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.file](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/region) | data source |
| [aws_route53_zone.example](https://registry.terraform.io/providers/hashicorp/aws/5.57.0/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apex_domain"></a> [apex\_domain](#input\_apex\_domain) | Set the domain name. | `string` | `""` | no |
| <a name="input_enable_public_block"></a> [enable\_public\_block](#input\_enable\_public\_block) | Enable public access block. (Must be disabled for static website hosting)) | `bool` | `true` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Set the project name. | `string` | `"red-test"` | no |
| <a name="input_record_name"></a> [record\_name](#input\_record\_name) | Set the sub-domain name. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Set the appropriate AWS region. | `string` | `"us-east-1"` | no |
| <a name="input_s3_website"></a> [s3\_website](#input\_s3\_website) | Map containing static web-site hosting or redirect configuration. | `any` | `{}` | no |
| <a name="input_website_path"></a> [website\_path](#input\_website\_path) | Set the path to the website content. | `string` | `"../site"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_red_bucket_name"></a> [red\_bucket\_name](#output\_red\_bucket\_name) | The S3 bucket for storing whatever you want |
| <a name="output_s3_url"></a> [s3\_url](#output\_s3\_url) | S3 hosting URL (HTTP) |
| <a name="output_website_record"></a> [website\_record](#output\_website\_record) | Route 53 record for the website |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | Website URL (HTTPS) |
<!-- END_TF_DOCS -->
<!-- prettier-ignore-end -->
