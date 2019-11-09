# provider.tf

# Specify the provider and access details

provider "aws" {
  shared_credential_file = "$HOME/.aws/credentials" #default for Mac/Linux
  profile                = "default"
  region                 = "var.aws_region"         #variable ref for region, adds flexability - set in variables.tf
}

