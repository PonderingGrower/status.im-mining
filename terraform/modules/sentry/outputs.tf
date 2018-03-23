output "public_ip" {
  value = ["${aws_instance.sentry.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_route53_record.sentry.*.name}"]
}

output "id_list" {
  value = ["${aws_instance.sentry.*.id}"]
}
