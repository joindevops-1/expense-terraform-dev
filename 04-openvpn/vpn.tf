module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_id.id
  name                   = "open-vpn"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
  user_data = file("openvpn.sh")
  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
    },
    {
      Name = "vpn"
    }
  )
}