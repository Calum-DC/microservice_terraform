output "queue_1_name" {
  description = "Queue 1 Name Output"
  value = aws_sqs_queue.priority_1_queue.arn
}

output "queue_2_name" {
  description = "Queue 2 Name Output"
  value = aws_sqs_queue.priority_2_queue.arn
}

output "queue_3_name" {
  description = "Queue 3 Name Output"
  value = aws_sqs_queue.priority_3_queue.arn
}

output "queue_1_url" {
  description = "Queue 1 Name Output"
  value = aws_sqs_queue.priority_1_queue.url
}

output "queue_2_url" {
  description = "Queue 2 Name Output"
  value = aws_sqs_queue.priority_2_queue.url
}

output "queue_3_url" {
  description = "Queue 3 Name Output"
  value = aws_sqs_queue.priority_3_queue.url
}
