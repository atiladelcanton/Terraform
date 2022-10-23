resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name = "${var.prefix}-sg"
  }
}
