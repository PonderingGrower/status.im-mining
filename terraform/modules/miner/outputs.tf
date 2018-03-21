output "public_ip" {
  value = ["${aws_instance.miner.*.public_ip}"]
}

output "id_list" {
  value = ["${aws_instance.miner.*.id}"]
}
