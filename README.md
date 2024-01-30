# terraform-module-aws-cloudfront

A Terraform module for creating a CloudFront distribution at AWS.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_acm_certificate.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which the infrastructure will be provisioned. | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the S3 bucket which contains the dashboard source code | `string` | n/a | yes |
| <a name="input_cloudfront_ttl"></a> [cloudfront\_ttl](#input\_cloudfront\_ttl) | How many seconds an object remains in cache | `number` | n/a | yes |
| <a name="input_lambda_arn"></a> [lambda\_arn](#input\_lambda\_arn) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | application name | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_origin_access_identity"></a> [origin\_access\_identity](#input\_origin\_access\_identity) | The Origin Access Identity giving CloudFront permission to access the corresponding S3 bucket. | `string` | n/a | yes |
| <a name="input_origin_path"></a> [origin\_path](#input\_origin\_path) | Optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | The unique identifier of the CloudFront distribution. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The domain name that points to the CloudFront distribution. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The hosted zone ID for the domain that points to the CloudFront distribution. |
<!-- END_TF_DOCS -->