module "mysql" {
  source = "../../terraform-aws-securitygroup"
  project_name = var.project_name
  sg_name = "${var.project_name}-${var.environment}-mysql"
  sg_description = "SG for MySQL servers"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

module "backend" {
  source = "../../terraform-aws-securitygroup"
  sg_description = "SG for Backend servers"
  project_name = var.project_name
  sg_name = "${var.project_name}-${var.environment}-backend"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

module "frontend" {
  source = "../../terraform-aws-securitygroup"
  sg_description = "SG for Frontend servers"
  project_name = var.project_name
  sg_name = "${var.project_name}-${var.environment}-frontend"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

module "vpn" {
  source = "../../terraform-aws-securitygroup"
  sg_description = "SG for VPN servers"
  project_name = var.project_name
  sg_name = "${var.project_name}-${var.environment}-vpn"
  vpc_id = data.aws_vpc.default.id
  common_tags = var.common_tags
}

resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.backend.sg_id
  security_group_id = module.mysql.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id       = module.frontend.sg_id
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}