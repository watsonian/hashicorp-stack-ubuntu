# Read all job attributes and the job logs

namespace "default" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

namespace "dev-*" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

namespace "xit-*" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

namespace "sb-*" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

namespace "stg-*" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

namespace "prd-*" {
policy = "read"
capabilities = ["read-logs", "read-job", "list-jobs", "read-fs"]
}

node {
  policy = "read"
}