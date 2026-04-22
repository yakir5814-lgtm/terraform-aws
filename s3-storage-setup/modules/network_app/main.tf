# יצירת ה-VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "MainVPC" }
}

# יצירת סאבנטים לפי הכמות שהוגדרה
resource "aws_subnet" "this" {
  count      = var.subnet_count
  vpc_id     = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  
  tags = { Name = "Subnet-${count.index}" }
}

# מציאת AMI עדכני של Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# יצירת ה-EC2
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.this[0].id
  associate_public_ip_address = var.assign_public_ip

  tags = { Name = "AppServer" }
}
