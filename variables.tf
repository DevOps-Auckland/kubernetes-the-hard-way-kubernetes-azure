variable "tenant_id" {
  type        = string
  description = "Tenant id of Azure AD"
  nullable    = false
  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.tenant_id))
    error_message = "This is not a valid tenant id. Here is an example of what it should look like: ab12c345-678d-910e-11fg-abc4d49d3992"
  }
}
