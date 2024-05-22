resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/db_sg_id"
  type  = "String"
  value = module.mysql.sg_id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.environment}/vpn_sg_id"
  type  = "String"
  value = module.vpn.sg_id
}