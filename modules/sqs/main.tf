resource "aws_sqs_queue" "priority_1_queue" {
  name = var.priority_1_queue_name
  fifo_queue = var.fifo_queues
  message_retention_seconds = var.retention_period
  visibility_timeout_seconds = var.visibility_timeout
}

resource "aws_sqs_queue" "priority_2_queue" {
  name = var.priority_2_queue_name
  fifo_queue = var.fifo_queues
  message_retention_seconds = var.retention_period
  visibility_timeout_seconds = var.visibility_timeout
}

resource "aws_sqs_queue" "priority_3_queue" {
  name = var.priority_3_queue_name
  fifo_queue = var.fifo_queues
  message_retention_seconds = var.retention_period
  visibility_timeout_seconds = var.visibility_timeout

}
