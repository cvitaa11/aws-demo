provider "aws" {
  region = "eu-central-1"
}

provider "aws" {
  alias  = "replication"
  region = "eu-west-1"
}
