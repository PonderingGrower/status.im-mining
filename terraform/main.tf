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
  name             = "${var.miner_params["name"]}"
  count            = "${var.miner_params["count"]}"
  default_tags     = "${var.default_tags}"
  zone_id          = "${data.aws_route53_zone.selected.zone_id}"
  domain           = "${var.domain}"
}

resource null_resource "ansible_miner" {
	triggers {
    key = "${uuid()}"
  }

	depends_on = [
		"module.miner"
	]

	provisioner "local-exec" {
		command = <<EOF
			cd ../ansible &&
			ansible-playbook site.yml \
				-e env=${var.env} \
        -e group_name=${var.miner_params["name"]}
    EOF
	}
}
