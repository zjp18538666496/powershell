# 切换到 SVN 工作副本目录
cd -d D:\wis\WisCode
#cd -d D:\wis\WisGroup

# 定义 SVN 导出命令和参数
$svnExportCmd = "export"
$svnExportArgs = "--force"

# 定义导出路径和文件夹名称
$exportPath = "C:\Users\Administrator\Desktop"
$exportFolder = "WisCode"

# 定义日志文件路径
$logFilePath = Join-Path $exportPath ($exportFolder + "\" + "log.txt")

# 定义导出文件的过滤条件（变更列表）
$excludeFiles = ""

# 定义导出函数
function Export-SvnChanges {
    param (
        [string]$changelist = "",
        [string]$excludeFiles = "没有过滤条件"
    )

    # 根据变更列表名称获取被修改的文件列表
    if ($changelist) {
        $changes = & svn status --changelist $changelist
    } else {
        $changes = & svn status
    }

    # 导出被修改的文件
    $changes | Select-String "^(M|A)" | ForEach-Object {
        $filename = $_.Line -replace "^[MA+\s]*", ""
        if ($filename -notmatch $excludeFiles) {
            $path = Join-Path $exportPath ($exportFolder + "\" + $filename)
            $dir = Split-Path $path -Parent
            New-Item -ItemType Directory -Force -Path $dir > $null
            svn $svnExportCmd $filename $path $svnExportArgs > $null
            Write-Host "已导出文件：" $filename
            # 获取当前日期和时间
            $timestamp = Get-Date -Format 'yyyy/MM/dd HH:mm:ss'
            # 将 $dir 写入 log.txt 文件
            Add-Content -Path $logFilePath -Value "$timestamp  已导出文件：$((Join-Path $dir $filename))"
        }
    }
    # 导出之后加分割线
    Add-Content -Path $logFilePath -Value "------------------------------------------------------------------------------------------------------------------------------------------------------------------"
}
# 获取用户输入的变更列表名称
$changelist = Read-Host "请输入变更列表名称（直接回车跳过）"

#定义导出的列表
#$changelist = ""

# 导出被修改的文件
Export-SvnChanges $changelist

# 压缩被修改为zip文件
#$destinationPath = Join-Path $exportPath "$exportFolder.zip"
#Compress-Archive -Path $exportPath\$exportFolder -DestinationPath $destinationPath  -Update

#打开导出文件的目录
#$exportFullPath = Join-Path $exportPath $exportFolder
#Invoke-Item $exportFullPath

#按回车关闭窗口
#Read-Host "导出完成，按回车关闭窗口"