#
# VPC
#

# We need to create a data source to get information about the DNS zone
# we're using for the webapp module to create DNS entries.
data "aws_route53_zone" "prod" {
  name = var.zone_name
}

# We're going to give the prod VPC a different cidr_slash16 just to keep
# us from confusing it with the dev deployment. It's worth mentioning
# that this isn't strictly necessary though, since they are in different
# accounts on completely unconnected networks, and we could just give them
# the same network addresses -- but it would introduce unnecessary
# confusion, so let's not do that.
module "prod_vpc" {
  source = "../../modules/aws-example-vpc"

  region      = var.region
  environment = var.environment

  cidr_slash16 = "10.1"
}

module "app_my_webapp_prod_ecr" {
  source = "../../modules/aws-example-ecr-repo"

  name = "app-my-webapp"
}

module "my_webapp_prod" {
  source = "../../modules/aws-example-webapp"

  alb_logs_bucket = var.logging_bucket
  alb_subnets     = module.prod_vpc.public_subnets

  db_subnet_group_name = module.prod_vpc.vpc_name
  db_subnets           = module.prod_vpc.database_subnets

  dns_zone_id = data.aws_route53_zone.prod.zone_id
  domain_name = "my-webapp.prod.example.com"

  ecs_subnets = module.prod_vpc.private_subnets
  environment = var.environment

  vpc_id = module.prod_vpc.vpc_id
}

