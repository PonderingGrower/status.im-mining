data "aws_ami" "image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64*"]
  }
}

data "aws_route53_zone" "selected" {
  name         = "${var.domain}"
  private_zone = false
}
