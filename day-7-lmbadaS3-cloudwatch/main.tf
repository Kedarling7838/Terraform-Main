# IAM Role for Lambda Execution

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach AWS-Managed Policy for Basic Execution
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}




# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role    = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"
  timeout    = 900
  memory_size = 128
  filename         = "lambda_function.zip" # Ensure this file exists
  source_code_hash = filebase64sha256("lambda_function.zip")
}

#S3 Bucket for Lambda Uploads
resource "aws_s3_bucket" "uploads" {
  bucket = "kedar-lambda-upload-bucket-12345"
}

# Permission for S3 to Invoke Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.uploads.arn
}

# S3 Bucket Notification to Trigger Lambda on Object Creation
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.uploads.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3]
}