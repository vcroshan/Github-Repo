variable "github_token" {
  type    = string
  default = ""
}

variable "is_template" {
  description = "(Optional) Whether or not to tell GitHub that this is a template repository. ( Default: false)"
  type        = bool
  }

variable "allowmergecommit" {
  type    = bool
}

variable "gitignore_template" {
  description = "(Optional) Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore"
  type        = string
  default     = null
}

variable "name" {
  description = "(Required) The name of the repository."
  type        = string
}

variable "template" {
  description = "(Optional) Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "branches" {
  description = "(Optional) A list of branches to be created in this repository."
   type = list(object({
     name          = string
     source_branch = optional(string)
     source_sha    = optional(string)
   }))
  default = []
}

variable "admin_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them admin (full) permission."
  type        = list(string)
  default     = []
}

variable "push_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them push (read-write) permission."
  type        = list(string)
  default     = []
}

variable "pull_collaborators" {
  description = "(Optional) A list of users to add as collaborators granting them pull (read-only) permission."
  type        = list(string)
  default     = []
}
variable "visibility" {
  description = "(Optional) Can be 'public', 'private' or 'internal' "
  type        = string
  default     = null
}
