locals {
    region = "us-east-1"
    ssh_user = "ubuntu"
    key_name = "aws-rsa"
    private_key_path = "/home/mikestrommgmail/.ssh/aws-rsa"
}

resource "aws_security_group" "nginx" {
  name = "nginx_access"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.nginx_access.id]
  key_name = local.key_name
  tags = {
     Name = "nginx"
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wating for SSH to come up'"]
    connection {
      type = "ssh"
      user = local.ssh_user
      private_key = file(local.private_key_path)
      host = aws_instance.nginx.public_ip
    }
  }

  provisioner "local-exec" {
    command = <<EOT
        "ansible-playbook -i ${aws_instance.nginx.public_ip},
        --private-key ${local.private_key_path}
        ./ansible/nginx.yaml"
    EOT
  }
}

output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}