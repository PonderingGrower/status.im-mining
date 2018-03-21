output "public_ips" {
  value = "${module.miner.public_ip}"
}

output "public_dns" {
  value = "${module.miner.public_dns}"
}

output "instance_ids" {
  value = "${module.miner.id_list}"
}
