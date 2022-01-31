resource "aws_instance" "Jenkin" {
  ami           = lookup(var.ami_id, var.region)
  instance_type = var.instance_type

# Public Subnet assign to instance
  subnet_id     = aws_subnet.public_1.id

# Security group assign to instance
  vpc_security_group_ids=[aws_security_group.allow_ssh.id]

# key name
  key_name = var.key_name

  tags = {
    Name = "Jenkin"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.Jenkin.public_ip
    private_key = "${file("../key/ec2-sg-key.pem")}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y openjdk-11-jre-headless",
      "wget https://get.jenkins.io/war-stable/2.319.1/jenkins.war"
    ]
  }
}

resource "aws_instance" "Build" {
  ami           = lookup(var.ami_id, var.region)
  instance_type = var.instance_type

# Public Subnet assign to instance
  subnet_id     = aws_subnet.public_1.id

# Security group assign to instance
  vpc_security_group_ids=[aws_security_group.allow_ssh.id]

# key name
key_name = var.key_name

  tags = {
    Name = "Build"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    host = aws_instance.Build.public_ip
    private_key = "${file("../key/ec2-sg-key.pem")}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt update",
      "sudo apt install -y openjdk-11-jre-headless",
      "sudo apt install -y maven",
      "sudo apt install -y ansible",
      "sudo apt install -y docker*",
      "sudo usermod -aG docker $USER",
      "sudo chmod 666 /var/run/docker.sock",
      "sudo usermod -aG root $USER",
      "sudo apt install -y unzip",
      "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o awscliv2.zip",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "sudo apt install -y python-pip",
      "pip install boto"
    ] 
  }
}
