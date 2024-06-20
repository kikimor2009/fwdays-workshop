terraform {
  required_version = ">= 1.7.0"

  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.2"
    }
    github = {
      source  = "integrations/github"
      version = "< 6.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.4"
    }
  }
}

# ==========================================
# Construct KinD cluster
# ==========================================

resource "kind_cluster" "this" {
  name = "flux-e2e"
}

# ==========================================
# Initialise a Github project
# ==========================================

module "github_repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.18.0"

  name               = var.github_repository
  description        = var.github_repository
  visibility         = "public"
}

# ==========================================
# Bootstrap KinD cluster
# ==========================================

resource "flux_bootstrap_git" "this" {
  depends_on = [ module.github_repository ]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}
