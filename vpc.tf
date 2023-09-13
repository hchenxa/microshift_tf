# Create the microshift node vpc
resource "aws_vpc" "microshift_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-vpc"
    })
  )
}

# Create the microshift node private subnet
resource "aws_subnet" "microshift_private_subnet" {
  vpc_id     = aws_vpc.microshift_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-private-subnet"
    })
  )
}

resource "aws_subnet" "microshift_public_subnet" {
  vpc_id            = aws_vpc.microshift_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.zones.names[0]

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-public-subnet"
    })
  )
}
