module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.project_name}-bastion-${var.environment}"
  ami = data.aws_ami.ami_info.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  subnet_id              = element(split(",", data.aws_ssm_parameter.public_subnet_ids.value),0)

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-bastion-${var.environment}"
    }
  )
  user_data = file("bastion.sh")
}