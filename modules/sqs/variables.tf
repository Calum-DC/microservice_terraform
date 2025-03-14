variable "fifo_queues" {
  description = "Flag to determine if FIFO queues should be used"
  type = bool
  default = false
}

variable "retention_period" {
  description = "Retention period for the SQS queue in seconds"
  type = number
  default = 345600 
}

variable "visibility_timeout" {
  description = "Visibility timeout for the SQS queue in seconds"
  type = number
  default = 30
}

variable "priority_1_queue_name" {
  description = "Name for the priority 1 SQS queue"
  type = string
  default = "cal-priority-1-queue"
}

variable "priority_2_queue_name" {
  description = "Name for the priority 2 SQS queue"
  type = string
  default = "cal-priority-2-queue"
}

variable "priority_3_queue_name" {
  description = "Name for the priority 3 SQS queue"
  type = string
  default = "cal-priority-3-queue"
}