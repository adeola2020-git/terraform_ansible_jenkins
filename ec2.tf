locals {
  inst_type     = "t2.micro"
  key           = "cba-web-KP"
  key_pair_path = "/home/adeola/cba-web-KP.pem" #"/Users/agro/Desktop/TerraformAll/terraform-project-test/my_key.pem"
}

# EC2 instance configuration
resource "aws_instance" "pub1a" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "web-server-01" #${count.index + 1}
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3 -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub1a.public_ip
    }
  }
  depends_on = [
    aws_security_group.web
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub1a.public_ip}, -u ubuntu --private-key ${local.key_pair_path} playbook.yml"
  }
}

resource "aws_instance" "pub1b" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "web-server-02" #${count.index + 1}
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3 -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub1b.public_ip
    }
  }
  depends_on = [
    aws_security_group.web
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub1b.public_ip}, -u ubuntu --private-key ${local.key_pair_path} playbook.yml"
  }
}

resource "aws_instance" "pub1c" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.db.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "db-instance01" #${count.index + 1}
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3-mysqld -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub1c.public_ip
    }
  }
  depends_on = [
    aws_security_group.web
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub1c.public_ip}, -u ubuntu --private-key ${local.key_pair_path} database.yml"
  }
}


# EC2 instance configuration
resource "aws_instance" "pub2a" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "web-server-03" #"${count.index + 1}"
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3 -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub2a.public_ip
    }
  }
  depends_on = [
    aws_security_group.web
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub2a.public_ip}, -u ubuntu --private-key ${local.key_pair_path} playbook.yml"
  }
}

resource "aws_instance" "pub2b" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "web-server-04" #${count.index + 1}
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3 -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub2b.public_ip
    }
  }
  depends_on = [
    aws_security_group.web
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub2b.public_ip}, -u ubuntu --private-key ${local.key_pair_path} playbook.yml"
  }
}

resource "aws_instance" "pub2c" {
  #count                       = 1
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.db.id}"]
  associate_public_ip_address = true
  #user_data = filebase64("user_data.sh")
  tags = {
    Name = "db-instance02" #${count.index + 1}
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3-mysqldb -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub2c.public_ip
    }
  }
  depends_on = [
    aws_security_group.db
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub2c.public_ip}, -u ubuntu --private-key ${local.key_pair_path} database.yml"
  }
}




# # EC2 instance configuration
# resource "aws_instance" "priv1" {
#   ami             = var.ami
#   instance_type   = local.inst_type
#   subnet_id       = aws_subnet.private1.id
#   security_groups = ["${aws_security_group.db.id}"]
#   key_name        = local.key
#   tags = {
#     Name = "db-private-1"
#   }

#   provisioner "remote-exec" {
#     inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3-mysqldb -y"]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(local.key_pair_path)
#       host        = aws_instance.priv1.private_ip
#     }
#   }
#   depends_on = [
#     aws_security_group.db
#   ]
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${aws_instance.priv1.private_ip}, -u ubuntu --private-key ${local.key_pair_path} database.yml"
#   }
# }

# # EC2 instance configuration
# resource "aws_instance" "priv2" {
#   ami             = var.ami
#   instance_type   = local.inst_type
#   subnet_id       = aws_subnet.private2.id
#   key_name        = local.key
#   security_groups = ["${aws_security_group.db.id}"]

#   tags = {
#     Name = "db-private-2"
#   }

#   provisioner "remote-exec" {
#     inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3-mysqldb -y"]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file(local.key_pair_path)
#       host        = aws_instance.priv2.private_ip
#     }
#   }
#   depends_on = [
#     aws_security_group.db
#   ]
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${aws_instance.priv2.private_ip}, -u ubuntu --private-key ${local.key_pair_path} database.yml"
#   }

# }




