#security group for the EKS cluster nodes
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"
  description = "Security group for EKS nodes"
  vpc_id      = module.vpc.vpc_id

#allow inbound communication from the jump server
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.128/25"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-nodes-sg"
  }
}

#security group for the jump server
resource "aws_security_group" "jump_server_sg" {
  name        = "jump-server-sg"
  description = "Allow SSH traffic"
  vpc_id      = module.vpc.vpc_id

#allow inbound SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere.
  }

#allow outbound communication to the EKS nodes
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "jump-server-sg"
  }
}

#launch the jump server instance
resource "aws_instance" "jump_server" {
  ami           = "ami-0f58b397bc5c1f2e8" #ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "timescale.pem" 

  subnet_id              = module.vpc.public_subnets[0]
  security_groups        = [aws_security_group.jump_server_sg.name]

  tags = {
    Name = "jump-server"
  }

  provisioner "local-exec" {
    command = "echo Jump server created"
  }
}