output "CW_ami_id" {
  value = data.aws_ssm_parameter.CW_ami.value
}

output "CW_pub_sub_id" {
  value = aws_subnet.CW_sub_public.id
}