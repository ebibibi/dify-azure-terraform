variable "subscription-id" {
  type = string
  default = "b0f2ddcb-c22b-4728-89b3-26e90a494ae4"
}

#virtual network variables
variable "resourcegroup-name" {
  type = string
  default = "dify"
}

variable "region" {
  type = string
  default = "japaneast"
}

variable "ip-prefix" {
  type = string
  default = "10.1"
}
#end virtual network variables

variable "storage-account" {
  type = string
  default = "acadifytest"
}

variable "storage-account-container" {
  type = string
  default = "dfy"
}

variable "redis" {
  type = string
  default = "acadifyredis"
}

variable "psql-flexible" {
  type = string
  default = "acadifypsql"
}

variable "pgsql-user" {
  type = string
  default = "user"
}

variable "pgsql-password" {
  type = string
  default = "#QWEASDasP@ssw0rd"
}

variable "aca-env" {
  type = string
  default = "dify-aca-env"
}

variable "aca-loga" {
  type = string
  default = "dify-loga"
}

variable "isProvidedCert" {
  type = bool
  default = false
}

variable "aca-cert-path" {
  type = string
  default = "./certs/difycert.pfx"
}

variable "aca-cert-password" {
  type = string
  default = "password"
}

variable "aca-dify-customer-domain" {
  type = string
  default = "dify.nikadwang.com"
}

variable "aca-app-min-count" {
  type = number
  default = 0
}

variable "is_aca_enabled" {
  type = bool
  default = true
}

variable "dify-api-image" {
  type = string
  default = "langgenius/dify-api:main"
  #default = "langgenius/dify-api:0.7.1"
}

variable "dify-sandbox-image" {
  type = string
  default = "langgenius/dify-sandbox:main"
  #default = "langgenius/dify-sandbox:0.2.6"
}

variable "dify-web-image" {
  type = string
  default = "langgenius/dify-web:main"
  #default = "langgenius/dify-web:0.7.1"
}