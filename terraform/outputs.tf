output "vpc_id" {
  value = aws_vpc.new-vpc.id
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.new-vpc.cidr_block
}

output "route_table_id" {
  value = aws_route_table.new-rtb.id
}
