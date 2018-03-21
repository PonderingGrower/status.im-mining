provider "aws" {
  region = "${var.region}"
}

module "key_pair" {
  source       = "modules/key_pair"
  key_name     = "${var.key_name}"
  pub_key_path = "${var.pub_key_path}"
}

module "base_security" {
  source       = "modules/base"
  env          = "${var.env}"
  default_tags = "${var.default_tags}"
}

module "miner" {
  ami              = "${data.aws_ami.image.id}"
  source           = "modules/miner"
  pub_key_path     = "${var.pub_key_path}"
  ssh_user         = "${var.ssh_user}"
  private_key_path = "${var.private_key_path}"
  env              = "${var.env}"
  key_name         = "${module.key_pair.key_name}"
  sg_id            = "${module.base_security.sg_id}"
  instance_type    = "${var.miner_params["type"]}"
  name             = "${var.miner_params["name"]}"
  count            = "${var.miner_params["count"]}"
  default_tags     = "${var.default_tags}"
  zone_id          = "${data.aws_route53_zone.selected.zone_id}"
  domain           = "${var.domain}"
}

/* This is a way to run ansible for launched hosts. */
resource null_resource "ansible_miner" {
  depends_on = [
    "module.miner",
  ]

  /* Uncomment if you want to run this more than once */
  triggers {
    key = "${uuid()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      cd ../ansible &&
      ansible-playbook miner.yml \
        -e "etherbase=${var.etherbase}" \
    EOF
  }
}
