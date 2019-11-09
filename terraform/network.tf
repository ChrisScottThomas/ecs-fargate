# network.tf

# Check for available AZ's
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
}

# Create private subnets per AZ
resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
}

# Create public subnets per AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
}

# Create Internet gateway for public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id  = aws_vpc.main.id
}

# Route the public subnet traffic to IGW
resource "aws_route" "internet_access" {
  route_table_id          = aws_vpc.main.main_route_table_id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "aws_internet_gateway.gw.id"
}

#Creae NAT gateway with Elastic IP for private subnet to reach the internet
resource "aws_eip" "gw" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)
}

# Make non-local traffic route through the NAT gateway on private subnet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id

  route {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
    }
}

# Force the route tables to the private subnets, else they will defaul to the main routing table
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
