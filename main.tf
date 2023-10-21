terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  owner = "Practical-DevOps-GitHub"
  token = "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"
}

resource "github_repository_collaborator" "a_repo_collaborator" {
  repository = "github-terraform-task-artemvoloshyn"
  username   = "softservedata"
  permission = "maintain"
}

resource "github_branch" "develop" {
  repository = "github-terraform-task-artemvoloshyn"
  branch     = "develop"
  source_branch = "main"
}

resource "github_branch_default" "default"{
  repository = "github-terraform-task-artemvoloshyn"
  branch     = github_branch.develop.branch
}






resource "github_branch_protection" "main" {
  repository_id = "github-terraform-task-artemvoloshyn"
  pattern         = "main"
  required_pull_request_reviews {
    require_code_owner_reviews      = true
    required_approving_review_count = 0
  }
}

resource "github_branch_protection" "develop" {
  repository_id = "github-terraform-task-artemvoloshyn"
  pattern         = "develop"
  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}


resource "github_repository_file" "code_owners" {
     repository = "github-terraform-task-artemvoloshyn"
     branch     = "main"
     file       = ".github/CODEOWNERS"
     content    = "* @softservedata"
   }

resource "github_repository_file" "pull_request_template" {
     repository = "github-terraform-task-artemvoloshyn"
     branch     = "develop"
     file       = ".github/pull_request_template.md"
     content    = <<EOF
   # Describe your changes
   # Issue ticket number and link
   # Checklist before requesting a review
   - [ ] I have performed a self-review of my code
   - [ ] If it is a core feature, I have added thorough tests
   - [ ] Do we need to implement analytics?
   - [ ] Will this be part of a product update? If yes, please write one phrase about this update
   EOF
   }

# Add a deploy key
resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "github_repository_deploy_key" "deploy_key" {
  title      = "DEPLOY_KEY"
  repository = "github-terraform-task-artemvoloshyn"
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = "false"
}

resource "github_actions_secret" "pat" {
  repository      = "github-terraform-task-artemvoloshyn"
  secret_name     = "PAT"
  plaintext_value = "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"
}

