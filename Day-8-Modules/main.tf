module "name" {
    source = "../Day-8-basic-code-for-module-source"
    ami_id = "ami-00e801948462f718a"
    type = "t3.micro"
    key="new_key"
    region="us-east-1"
}