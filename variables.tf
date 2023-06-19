# variable "cidr_blocks" {
#   description = "cidr blocks"
#   # type  = list(string)
#   type = list(object({
#     cidr_block = string
#     name       = string
#   }))
# }

# variable "vpc_cidr_block" {
#   description = "vpc/subnet cidr blocks and name tags for vpc/subnet "
#   default     = "10.0.0.0/16"
#   type        = string
# }

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "instance_type" {}
variable "private_key_location" {}