terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}


# Configure the GitHub Provider
provider "github" {
  token = var.github_token
}

locals {
  template = var.template == null ? [] : [var.template]
}
resource "github_repository" "githubrepo" {
  name               = var.name
  description        = "My awesome codebase"
  is_template        = var.is_template
  allow_merge_commit = var.allowmergecommit
  gitignore_template = var.gitignore_template
  visibility         = var.visibility
  dynamic "template" {
    for_each = local.template

    content {
      owner      = template.value.owner
      repository = template.value.repository
    }
  }
}

locals {
  branches_map = { for b in var.branches : b.name => b }
  develop_branch = [ for k,v  in local.branches_map : k ]
}

resource "github_branch" "branch" {
  count = length(var.branches)

  repository    = github_repository.githubrepo.name
  branch        = var.branches[count.index]
}


resource "github_branch_default" "default"{
  repository = github_repository.githubrepo.name
  branch     = contains(local.develop_branch, "develop") ? "develop" : "main"
}

