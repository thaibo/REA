provider "aws" {
  region = "ap-southeast-2"
}

data "template_file" "user_data" {
template = "${file("user-data")}"
}

resource "aws_instance" "web" {
  ami = "ami-08bd00d7713a39e7d"
  instance_type = "t2.micro"
  security_groups = ["sinatra"]
  key_name = "ec2"
  user_data = "${data.template_file.user_data.rendered}"
  root_block_device {
    delete_on_termination = "true"
 }
  tags = {
    Name = "Webapp"
  }
}
