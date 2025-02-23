data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs_count = 3
  azs       = slice(data.aws_availability_zones.available.names, 0, local.azs_count)
}
