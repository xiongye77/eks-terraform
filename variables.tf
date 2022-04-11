variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "ap-southeast-2"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 3
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  # description = "Name of the project deployment."
  type = string
  default= "eks-test"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSWorkshop"
    "Environment" = "Development"
    "Owner"       = "Ye Xiong"
  }
}


variable "demo_dns_zone" {
  description = "Specific to your setup, pick a public domain you have in route53, this must be changed. check output of aws route53 list-hosted-zones"
  default = "poc.csnglobal.net"

}


variable "demo_dns_name" {
  description = " A demo domain name for the web access"
  default     = "sslingress"
}


