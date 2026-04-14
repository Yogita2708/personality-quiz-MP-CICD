provider "aws" {
  region = "ap-south-1"   # Mumbai region (close to India!)
}

# Create a virtual server (EC2 instance)
resource "aws_instance" "quiz_server" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Ubuntu 22.04 image ID
  instance_type = "t2.micro"               # Free tier eligible!
  key_name      = "my-key-pair"            # SSH key to log in

  # Open port 80 (web) and 22 (SSH) to the internet
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "PersonalityQuizServer"
  }
}

# Firewall rules
resource "aws_security_group" "web_sg" {
  name = "quiz-web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Allow all web traffic
  }
}
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # Allow SSH
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }