
resource "aws_ecr_repository" "ecr_repos" {
  for_each             = toset(var.ecr_repos) # Convert the list to a set for unique keys
  name                 = each.key
  image_tag_mutability = "MUTABLE"
}

# resource "aws_ecr_repository" "ecr-repo-1" {
#   name                 = "erb-web"
#   image_tag_mutability = "MUTABLE"
# }

