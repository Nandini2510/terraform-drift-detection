resource "local_file" "example" {
    content = "This is a test file for drift detection."
    filename = "${path.module}/example.txt"
}

output "file_content" {
    value = local_file.example.content
}