resource "aws_default_security_group" "default-sg" {
  # name   = "myapp-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["Ubuntu Server * Type"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# output "aws_ami_id" {
#   value = data.aws_ami.ubuntu.id
# }

# resource "aws_key_pair" "ssh-key" {
#   key_name = "server-key"
# }

resource "aws_instance" "myapp-server" {
  ami                         = "ami-09db9d79b41ec058e"
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = "Frankfurt-Keypair"
  tags = {
    Name = "${var.env_prefix}-server"
  }
  user_data = file("entry-script.sh")

  # connection {
  #   type        = "ssh"
  #   host        = self.public_ip
  #   user        = "ec2-user"
  #   private_key = file(var.private_key_location)
  # }

  # provisioner "file" { #Copies files from local server to remote server
  #   source      = "entry-script.sh"
  #   destination = "/home/ec2-user/entry-script-on-ec2.sh"
  # }

  # provisioner "remote-exec" { #Executes commands on remote server
  #   # inline = ["mkdir newdir"]
  #   script = file("entry-script.sh-on-ec2")
  # }

  # provisioner "local-exec" { #invokes a local executable after a resource is created  
  #   # command = "echo ${self.public_ip} > output.txt"
  #   command = "echo %PUBLIC_IP% > output.txt"
  # }

}