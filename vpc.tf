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
# resource "aws_subnet" "microshift_private_subnet" {
#   vpc_id     = aws_vpc.microshift_vpc.id
#   cidr_block = var.private_subnet_cidr

#   tags = merge(
#     local.common_tags,
#     tomap({
#       "Name" = "${local.cluster_id}-private-subnet"
#     })
#   )
# }

# Create an Internet Gateway
resource "aws_internet_gateway" "microshift_internet_gw" {
  vpc_id = aws_vpc.microshift_vpc.id

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-internet-gateway"
    })
  )
}

# Create the aws public subnet
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

# Create a route table allowing all addresses access to the Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.microshift_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.microshift_internet_gw.id
  }

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${local.cluster_id}-public-route-table"
    })
  )
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public-subnet" {
  subnet_id      = aws_subnet.microshift_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

