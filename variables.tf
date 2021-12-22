variable "rgname" {
  type = string
}

variable "location" {
  type = string
}

variable "keyvault" {
  type = string
}

variable "tagsmap" {
  type = map
}

variable "objectid" {
  type = map
}

variable "keyvaultresourcegroup" {
  type = string
}

variable "subnetidmap" {
  description = "List of subnets(please specify subnetids here) to be allowed to access sa"
  type        = map
  default     = {
    sa1 = ["sn1","sn2"],
    sa2 = ["sn1"]
  }
}

variable "sa" {
  description = "List of filesystems to create for each sa"
  type        = map
  default     = {
    sa1 = ["fs1","fs2"],
    sa2 = ["fs1","fs2"]
  }
}

variable "fsacl" {
  description = "List of acl to create for each fs"
  type        = map(object({
    grpread: list(string),
    grpwrite: list(string),
    usrread: list(string),
    usrwrite: list(string)
  }))
  default     = {
    "fs" = { 
       grpread = null
       grpwrite = null
       usrread = null
       usrwrite = null
    } 
  }
}

variable "enckeyname" {
type = string
}

variable "enckeyversion" {
type  = string 
}

variable "salockname" {
  type = string
}

variable "tagsmap" {
  type = map
}
