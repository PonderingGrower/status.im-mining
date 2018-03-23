resource "aws_instance" "sentry" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  vpc_security_group_ids = [
    "${var.sg_id}",
    "${aws_security_group.sentry.id}",
  ]

  root_block_device {
    volume_size = "40"
    volume_type = "gp2"
    delete_on_termination = "true"
  }

  tags = "${merge(var.default_tags, map(
    "Name",  "${var.name}",
    "Group", "${var.env}-${var.name}-cluster"
  ))}"

  /* This is just a connection check */
  provisioner "remote-exec" {
    inline = [
      "#Connected!",
    ]

    connection {
      agent       = false
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_route53_record" "sentry" {
  zone_id = "${var.zone_id}"
  name    = "${aws_instance.sentry.tags.Name}.${var.env}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.sentry.public_ip}"]
}

resource "aws_security_group" "sentry" {
  name        = "${var.env}-sentry-sg"
  description = "Allow Graphite backend access for netdata"

  ingress {
    from_port       = 0
    to_port         = 2003
    protocol        = "tcp"
    security_groups = ["${var.miner_sec_group}"]
  }
  # Grafana access
  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Graphite access
  ingress {
    from_port   = 0
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.default_tags}"
}
