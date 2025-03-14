output "oidc_provider" {
    description = "oidc provider for cluster"
    value = module.eks.oidc_provider
}