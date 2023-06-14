# Seoul-RDS 파라미터 생성
resource "aws_db_parameter_group" "fourdollar_mysql" {
  name   = "fourdollar-mysql"
  family = "mysql8.0"

  parameter {
    name  = "time_zone"
    value = "Asia/Seoul"
  }
}

# Seoul-RDS 서브넷 그룹 생성
resource "aws_db_subnet_group" "seoul_subnet_group" {
  name       = "seoul-subnet group"
  subnet_ids = [aws_subnet.seoul_db_sn5.id, aws_subnet.seoul_db_sn6.id]

  tags = {
    Name = "seoul-subnet group"
  }
}

# Seoul-RDS-DB Snapshot 인스턴스 생성
resource "aws_db_instance" "seoul_rds" {
    identifier                = "seoul-rds"
    allocated_storage         = 20
    storage_type              = "gp2"
    engine                    = "mysql"
    engine_version            = "8.0.32"
    instance_class            = "db.t2.micro"
    name                      = ""
    username                  = ""
    password                  = ""
    port                      = 3306
    publicly_accessible       = false
    vpc_security_group_ids    = [aws_security_group.seoul_db_sg.id]
    db_subnet_group_name      = aws_db_subnet_group.seoul_subnet_group.name
    parameter_group_name      = "fourdollar-mysql"
    multi_az                  = true
    backup_retention_period   = 7
    backup_window             = "20:19-20:49"
    maintenance_window        = "wed:13:07-wed:13:37"
    final_snapshot_identifier = "seoul-rds-final"
    enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
    
    snapshot_identifier = "seoul-rds-snapshot"
}