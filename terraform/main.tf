locals {
    region = "us-east-1"
    ssh_user = "ubuntu"
    key_name = "aws-rsa"
    private_key_path = "/home/mikestrommgmail/.ssh/aws-rsa"
    public_key_path = "/home/mikestrommgmail/.ssh/aws-rsa.pub"
}

resource "aws_key_pair" "deployer" {
  key_name   = local.key_name
  public_key = file(local.public_key_path)
}

resource "aws_security_group" "k8s" {
  name = "k8s"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s-master" {
  ami = "ami-04505e74c0741db8d"
  count = 1
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name = local.key_name
  tags = {
     Name = "k8s"
     Role = "master"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH is up!'"]
    connection {
      host = "${self.public_ip}"
      type = "ssh"
      user = local.ssh_user
      private_key = file(local.private_key_path)
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/../ansible/"
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${local.private_key_path} master.yaml"
  }
}

resource "aws_instance" "k8s-worker" {
  ami = "ami-04505e74c0741db8d"
  count = 2
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name = local.key_name
  tags = {
     Name = "k8s"
     Role = "worker"
  }

  provisioner "remote-exec" {
    inline = ["echo 'SSH is up!'"]
    connection {
      host = "${self.public_ip}"
      type = "ssh"
      user = local.ssh_user
      private_key = file(local.private_key_path)
    }
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/../ansible/"
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${local.private_key_path} worker.yaml"
  }
}

output "k8s-master_public_ip" {
  value = aws_instance.k8s-master.public_ip
}