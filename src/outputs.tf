# Instance private IPs
output "ips" {
  # join all the instance private IPs with commas separating them
  value = "${join(", ", aws_instance.web.*.private_ip)}"
}

# Load balancer dns name
output "site_address" {
  value = "${aws_elb.web.dns_name}"
}
