resource "aws_instance" "miner" {
  ami           = "${var.ami}"
  count         = "${var.count}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = [
    "${var.sg_id}",
    "${aws_security_group.miner.id}",
  ]

  tags = "${merge(var.default_tags, map(
    "Name",  "${var.env}-${var.name}-${format("%02d", count.index+1)}",
    "Group", "${var.env}-${var.name}-cluster"
  ))}"

  provisioner "remote-exec" {
    inline = "#Connected!"

    connection {
      agent       = false
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_security_group" "miner" {
  name        = "${var.env}-miner-sg"
  description = "Allow Ethereum node access"

  ingress {
    from_port   = 0
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 30303
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.default_tags}"
}
