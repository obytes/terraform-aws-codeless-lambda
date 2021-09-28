###############################################
#                  Dummy Code                 |
###############################################
data "archive_file" "dummy" {
  output_path = "${path.module}/dist.zip"
  type        = "zip"
  source {
    content  = "dummy dummy"
    filename = "dummy.txt"
  }
}
