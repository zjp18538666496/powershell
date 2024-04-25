# ��ȡ��ǰ���ڲ���ʽ��ΪyyyyMMdd
$currentDate = Get-Date -Format "yyyyMMdd"

# Ҫѹ�����ļ���·��
$sourceFolderPaths = @("D:\wis\WisCode\Wis.ApplicationServer\Wis.ApplicationServer\bin\Debug", "D:\wis\WisCode\Wis.ServiceInterface\Wis.ServiceInterface\bin")
Write-Host "Ҫѹ�����ļ���: $sourceFolderPaths"

# Ҫѹ�����ļ���ʽ
$fileFormats = @("*.pdb", "*.dll", "*.xml", "*.config")
Write-Host "Ҫѹ�����ļ���ʽ: $fileFormats"

# ѹ�����ļ���
$zipDestinationFolderPath = "D:\data\wis\"
Write-Host "ѹ�����ļ���: $zipDestinationFolderPath"

# ѹ��������
$zipFileName = "dll.$currentDate.update.zip"
Write-Host "ѹ��������: $zipFileName"

# �����ļ���
$destinationFolderPath = "D:\data\wis\dll"

Write-Host "��ʼ���������ļ���..."
# ����Ŀ���ļ���
if (-not (Test-Path $destinationFolderPath)) {
    New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
}
Write-Host "���������ļ�����..."

Write-Host "��ʼ�����ļ��������ļ���..."
# ����Դ�ļ���
foreach ($sourceFolderPath in $sourceFolderPaths) {
    # �����ļ���ʽ
    foreach ($format in $fileFormats) {
        # ��ȡ��ǰ�ļ���ʽ���ļ��б�
        $files = Get-ChildItem -Path $sourceFolderPath -Filter $format -File
        
        # ����Ƿ��з����ļ���ʽ���ļ�
        if ($files.Count -gt 0) {
            # ���ļ����Ƶ�Ŀ���ļ��У������������ļ�
            Copy-Item -Path $files.FullName -Destination $destinationFolderPath -Force
        }
    }
}
Write-Host "�����ļ��������ļ������"

Write-Host "��ʼѹ���ļ�..."
# ��Ŀ���ļ����е��ļ�ѹ����һ���µ�ѹ����
Compress-Archive -Path "$destinationFolderPath\*" -DestinationPath "$zipDestinationFolderPath\$zipFileName" -Force -NoProgress
Write-Host "ѹ���ļ����"

Write-Host "��ʼɾ�������ļ���..."
# ɾ��ָ�����ļ���
Remove-Item -Path $destinationFolderPath -Recurse -Force
Write-Host "ɾ�������ļ������"

# ��ʾ�û�����
$userInput = Read-Host "��1��ѹ���ļ�·�����˳������κ��������˳�"

# ����û�����Ϊ1�����ѹ����·��
if ($userInput -eq "1") {
    Invoke-Item "$zipDestinationFolderPath"
}

# ����û�����Ϊ����ֵ��ֱ�ӹرմ���
Write-Host "�رմ���..."
Start-Sleep -Seconds 2
exit