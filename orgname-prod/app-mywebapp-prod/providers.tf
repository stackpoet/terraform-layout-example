provider "aws" {
  version = "~> 2.58"
  region  = "${local.region}"
}

provider "template" {
  version = "~> 2.1.0"
}
