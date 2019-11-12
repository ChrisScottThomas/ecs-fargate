# ecs-fargate

This contains terraform templates for creating an AWS ECS Fargate cluster, publically loadbalanced and that deploys containers within the cluster.  
I chose Terraform due to previous experience, and it's application to more than just one product.  

### Tasks  

* Creates ECS Fargate Cluster in AWS on any account  

* Creates Load Balancer on Public IP space  

* Creates a Private Subnet for Apps  

* NGINX reverse Proxy container, PHP-FPM container.  

* Loadbalances public traffic to NGINX container  

* CloudWatch Logs for Apps  

* CloudWatch Alarms to trigger scaling on CPU thresholds  

### Requirements

* Terraform  
* An AWS Account  
* Git  

### Instructions  

```
git clone git@github.com:ChrisScottThomas/ecs-fargate.git
```  

```
cd ecs-fargate/terraform
```  

```
terraform plan -out .terraform.out
```  

```
terraform apply ".terraform.out"
```  

On completion you should receive a message, telling you how to access the loadbalancer via DNS.
```
Outputs:

alb_hostname = hello-load-balancer-1234567.eu-west-2.elb.amazonaws.com
```  

### Customisation

most customisation should be applied via the `variables.tf` file.  Here you can alter regions, images, resources etc.

### Improvements

* TLS needs adding. Lack of knowledge and time prevented this.  
* PHP-FPM doesn't work. Mainly due to lack of experience with PHP-FPM  
* Use of volumes to inject config.  Currently packages into the container, which isn't best practice.  
* Use of Route53.  Would be nice to use a real DNS name over the auto-generated LB name.  
