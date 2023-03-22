locals {
  inst_type     = "t2.large"
  key           = "my_key"
  key_pair_path = "/Users/agro/Desktop/TerraformAll/terraform-project-test/my_key.pem"
}

# EC2 instance configuration
resource "aws_instance" "pub1a" {
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "web-server-01"
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
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "web-server-02"
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

/* resource "aws_instance" "pub1c" {
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.db.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "db-instance01"
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
} */


# EC2 instance configuration
resource "aws_instance" "pub2a" {
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "web-server-03"
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
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.web.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "web-server-04"
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

/* resource "aws_instance" "pub2c" {
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public2.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.db.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "db-instance02"
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

resource "aws_instance" "pub1c" {
  ami                         = var.ami
  instance_type               = local.inst_type
  subnet_id                   = aws_subnet.public1.id
  key_name                    = local.key
  security_groups             = ["${aws_security_group.db.id}"]
  associate_public_ip_address = true
  tags = {
    Name = "db-instance01"
  }

  provisioner "remote-exec" {
    inline = ["echo 'waiting for SSH to be ready'", "sudo apt install python3-mysqldb -y"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(local.key_pair_path)
      host        = aws_instance.pub1c.public_ip
    }
  }
  depends_on = [
    aws_security_group.db
  ]
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.pub1c.public_ip}, -u ubuntu --private-key ${local.key_pair_path} database.yml"
  }
} */