# EFS 생성
resource "aws_efs_file_system" "efs_fourdollar" {
  creation_token = "EFS-Fourdollar"
  encrypted      = true
  performance_mode = "generalPurpose"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "EFS-Fourdollar"
  }
}

# EFS 마운트 타겟
resource "aws_efs_mount_target" "target" {
  file_system_id = aws_efs_file_system.efs_fourdollar.id
  subnet_id      = aws_subnet.seoul_pri_sn3.id
# ip 지정하려면 입력하기
  ip_address     = ""
}