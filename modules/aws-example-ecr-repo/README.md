<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
Creates an ECR repo and lifeycle policy. Defaults to our standard lifecycle
policy if one is not supplied.

Creates the following resources:

* ECR repository
* ECR repository lifecycle

## Usage

```hcl
module "ecr_ecs_myapp" {
 source = "../../modules/aws-ecr-repository"
 name   = "myapp"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| lifecycle\_policy | ECR repository lifecycle policy document. Used to override our default policy. | string | `""` | no |
| name | ECR repository name. | string | n/a | yes |
| tags | Additional tags to apply. | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Full ARN of the repository. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
