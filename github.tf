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
data "github_repository" "github_repo" {
  count = var.create_repo == "true" ? 0 : 1
  name = var.name
}

locals {
  template = var.template == null ? [] : [var.template]
}
resource "github_repository" "githubrepo" {
  count = var.create_repo ? 1 : 0
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
  for_each = local.branches_map

  repository    = var.create_repo == "true" ? github_repository.githubrepo[0].name: data.github_repository.github_repo[0].name
  branch        = each.key
}


output "githubrepo" {
value = data.github_repository.github_repo.*.name
}
resource "github_branch_default" "default"{
  count = var.set_default_branch ? 1 : 0
  repository = var.create_repo? github_repository.githubrepo[count.index].name: data.github_repository.github_repo[count.index].name
  branch     = contains(local.develop_branch, "develop") ? "develop" : "main"
}
