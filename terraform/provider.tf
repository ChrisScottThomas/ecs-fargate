# provider.tf

# Specify the provider and access details
# variable ref for region, adds flexability - set in variables.tf
provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials" #default for Mac/Linux
  profile                = "default"
  region                 = var.aws_region
}

