resource "aws_iam_role" "example-role" {
  name = "Jenkins-terraform"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "example_attachment" {
  role = aws_iam_role.example-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
resource "aws_iam_instance_profile" "example-profile" {
  name = "Jenkins-terraform"
  role = aws_iam_role.example-role.name
}
resource "aws_security_group" "jenkins-sg" {
  name = "Jenkins-Security-group"
  description = "ports to open for the security group"
  ingress {
    description = "TLS from VPC"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port = 9000
    to_port = 9000
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port = 3000
    to_port = 3000
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Jenkins-sg"
  }
}
resource "aws_instance" "web-instance" {
  ami = "ami-0e83be366243f524a"
  instance_type = "t2.large"
  key_name = "universal-ohio"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data = templatefile("./install_jenkins.sh", {})
  iam_instance_profile = aws_iam_instance_profile.example-profile.name

  tags = {
    Name = "Jenkins"
  }
  root_block_device {
    volume_size = 20
  }
}
