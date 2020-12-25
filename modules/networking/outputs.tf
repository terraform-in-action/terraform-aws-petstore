output "sg" {
  value = {
    lambda = module.lambda_sg.security_group.id
  }
}