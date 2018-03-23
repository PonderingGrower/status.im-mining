output "public_dns" {
  value = [
    "${module.miner.public_dns}"
    "${module.sentry.public_dns}",
  ]
}

output "public_ips" {
  value = [
    "${module.miner.public_ip}",
    "${module.sentry.public_ip}"
  ]
}

output "instance_ids" {
  value = [
    "${module.miner.id_list}",
    "${module.sentry.id_list}"
  ]
}
