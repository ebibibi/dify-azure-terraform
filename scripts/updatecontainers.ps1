# 設定
$acrName = "youracrname"   # ここにAzure Container Registryの名前を指定
$resourceGroup = "yourResourceGroup"  # ここにリソースグループ名を指定

# Azureにログイン（未ログイン時）
if (-not (Get-AzContext)) {
    Connect-AzAccount
}

# ACRのログインサーバー取得
$acrLoginServer = (Get-AzContainerRegistry -ResourceGroupName $resourceGroup -Name $acrName).LoginServer

# ACRにログイン
az acr login --name $acrName

# イメージリスト
$images = @(
    @{source="langgenius/dify-api:main"; target="$acrLoginServer/dify-api:main"},
    @{source="langgenius/dify-sandbox:main"; target="$acrLoginServer/dify-sandbox:main"},
    @{source="langgenius/dify-web:main"; target="$acrLoginServer/dify-web:main"}
)

# 最新のイメージを取得してACRにPush
foreach ($image in $images) {
    $sourceImage = $image.source
    $targetImage = $image.target

    Write-Host "Pulling $sourceImage..."
    docker pull $sourceImage

    Write-Host "Tagging $sourceImage as $targetImage..."
    docker tag $sourceImage $targetImage

    Write-Host "Pushing $targetImage to ACR..."
    docker push $targetImage

    Write-Host "Cleaning up local images..."
    docker rmi $sourceImage
    docker rmi $targetImage
}

Write-Host "All images have been updated successfully!"
