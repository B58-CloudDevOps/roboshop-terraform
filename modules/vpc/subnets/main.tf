resource "aws_subnet" "main" {
  count             = length(var.cidr)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}


resource "aws_route_table" "main" {
  count = length(var.cidr)

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table_association" "main" {
  count          = length(var.cidr)
  subnet_id      = aws_subnet.main.*.id[count.index]
  route_table_id = aws_route_table.main.*.id[count.index]
}

resource "aws_internet_gateway" "igw" {
  count = var.name == "public" ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# Public Route 
resource "aws_route" "igw_route" {
  count = length(var.cidr)

  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Provisions NAT Gateway 

resource "aws_eip" "lb" {
  count  = var.name == "public" ? length(var.cidr) : 0
  domain = "vpc"
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.example]
}