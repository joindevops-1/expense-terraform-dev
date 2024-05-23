resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project_name}/${var.environment}/db_host"
  type  = "String"
  value = module.db.db_instance_endpoint
}