output "args" {
  value = nonsensitive({
    for key, value in local.final_args : nonsensitive(sensitive(key)) => nonsensitive(sensitive(value))
  })
}

output "tags" {
  value = nonsensitive({
    for key, value in local.final_tags : nonsensitive(sensitive(key)) => nonsensitive(sensitive(value))
  })
}