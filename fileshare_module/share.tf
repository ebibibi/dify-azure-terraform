resource "azurerm_storage_share" "fileshare" {
  name                 = var.share_name
  storage_account_name = var.storage_account_name
  quota                = var.quota
}

data "local_file" "files" {
  for_each = fileset(var.local_mount_dir, "**/*")
  filename = "${var.local_mount_dir}/${each.value}"
}

locals {
  # ファイルの相対パスを取得
  relative_paths = {
    for f in data.local_file.files :
    f.filename => replace(replace(f.filename, "${var.local_mount_dir}/", ""), "\\", "/")
  }
}

locals {
  # ディレクトリのリストを作成
  all_directories = distinct(sort([
    for path in local.relative_paths : dirname(path)
    if dirname(path) != "."
  ]))
}

# ディレクトリの作成
resource "azurerm_storage_share_directory" "directories" {
  for_each = toset(local.all_directories)
  name     = each.value
  storage_share_id = azurerm_storage_share.fileshare.id
  depends_on       = [azurerm_storage_share.fileshare]
}

# ファイルの作成
resource "azurerm_storage_share_file" "files" {
  for_each = data.local_file.files

  name             = local.relative_paths[each.value.filename]
  storage_share_id = azurerm_storage_share.fileshare.id
  source           = each.value.filename

  depends_on       = [azurerm_storage_share_directory.directories]
}

output "share_name" {
  value       = azurerm_storage_share.fileshare.name
  description = "The name of the file share"
}

output "share_id" {
  value       = azurerm_storage_share.fileshare.id
  description = "The ID of the file share"
}
