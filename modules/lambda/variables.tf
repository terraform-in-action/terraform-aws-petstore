variable "namespace" {
  type = string
}

variable "rds_user" {
  type = string
}

variable "rds_password" {
  type = string
}

variable "rds_host" {
  type = string
}

variable "rds_port" {
  type = string
}

variable "rds_database" {
  type = string
}

variable "sg" {
  type = any
}