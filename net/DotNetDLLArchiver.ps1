# 获取当前日期并格式化为yyyyMMdd
$currentDate = Get-Date -Format "yyyyMMdd"

# 要压缩的文件夹路径
$sourceFolderPaths = @("D:\wis\WisCode\Wis.ApplicationServer\Wis.ApplicationServer\bin\Debug", "D:\wis\WisCode\Wis.ServiceInterface\Wis.ServiceInterface\bin")
Write-Host "要压缩的文件夹: $sourceFolderPaths"

# 要压缩的文件格式
$fileFormats = @("*.pdb", "*.dll", "*.xml", "*.config")
Write-Host "要压缩的文件格式: $fileFormats"

# 压缩包文件夹
$zipDestinationFolderPath = "D:\data\wis\"
Write-Host "压缩包文件夹: $zipDestinationFolderPath"

# 压缩包名称
$zipFileName = "dll.$currentDate.update.zip"
Write-Host "压缩包名称: $zipFileName"

# 虚拟文件夹
$destinationFolderPath = "D:\data\wis\dll"

Write-Host "开始创建虚拟文件夹..."
# 创建目标文件夹
if (-not (Test-Path $destinationFolderPath)) {
    New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
}
Write-Host "创建虚拟文件夹完..."

Write-Host "开始复制文件到虚拟文件夹..."
# 遍历源文件夹
foreach ($sourceFolderPath in $sourceFolderPaths) {
    # 遍历文件格式
    foreach ($format in $fileFormats) {
        # 获取当前文件格式的文件列表
        $files = Get-ChildItem -Path $sourceFolderPath -Filter $format -File
        
        # 检查是否有符合文件格式的文件
        if ($files.Count -gt 0) {
            # 将文件复制到目标文件夹，并覆盖现有文件
            Copy-Item -Path $files.FullName -Destination $destinationFolderPath -Force
        }
    }
}
Write-Host "复制文件到虚拟文件夹完成"

Write-Host "开始压缩文件..."
# 将目标文件夹中的文件压缩成一个新的压缩包
Compress-Archive -Path "$destinationFolderPath\*" -DestinationPath "$zipDestinationFolderPath\$zipFileName" -Force -NoProgress
Write-Host "压缩文件完成"

Write-Host "开始删除虚拟文件夹..."
# 删除指定的文件夹
Remove-Item -Path $destinationFolderPath -Recurse -Force
Write-Host "删除虚拟文件夹完成"

# 提示用户输入
$userInput = Read-Host "按1打开压缩文件路径并退出，或按任何其他键退出"

# 如果用户输入为1，则打开压缩包路径
if ($userInput -eq "1") {
    Invoke-Item "$zipDestinationFolderPath"
}

# 如果用户输入为其他值，直接关闭窗口
Write-Host "关闭窗口..."
Start-Sleep -Seconds 2
exit