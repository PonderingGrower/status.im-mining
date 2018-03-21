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
}
