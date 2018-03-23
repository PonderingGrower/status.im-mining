output "public_ip" {
  value = ["${aws_instance.miner.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_route53_record.miner.*.name}"]
}

output "id_list" {
  value = ["${aws_instance.miner.*.id}"]
}

output "sec_group_id" {
  value = "${aws_security_group.miner.id}"
}
