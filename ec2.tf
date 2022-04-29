data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# ====================
#
# EC2 Instance
#
# ====================
resource "aws_instance" "demo" {
  #   ami                    = data.aws_ssm_parameter.amzn2_ami.value
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = [aws_security_group.demo.id]
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.demo.id
  instance_type          = "t3.micro"

  user_data = file("./setup.sh")

  tags = {
    Name = "demo"
  }
}

# ====================
#
# Elastic IP
#
# ====================
resource "aws_eip" "demo" {
  instance = aws_instance.demo.id
  vpc      = true
}

# ====================
#
# Key Pair
#
# ====================
resource "aws_key_pair" "demo" {
  key_name   = "demo-key"
  public_key = file("~/.ssh/demo-key.pub")
}
