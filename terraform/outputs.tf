# outputs.tf

# Get our load balancer A record after deployment
output "alb_hostname" {
  value = "${aws_lb.main.dns_name}"
}
