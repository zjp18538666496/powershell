# �л��� SVN ��������Ŀ¼
cd -d D:\wis\WisCode
#cd -d D:\wis\WisGroup

# ���� SVN ��������Ͳ���
$svnExportCmd = "export"
$svnExportArgs = "--force"

# ���嵼��·�����ļ�������
$exportPath = "C:\Users\Administrator\Desktop"
$exportFolder = "WisCode"

# ������־�ļ�·��
$logFilePath = Join-Path $exportPath ($exportFolder + "\" + "log.txt")

# ���嵼���ļ��Ĺ�������������б�
$excludeFiles = ""

# ���嵼������
function Export-SvnChanges {
    param (
        [string]$changelist = "",
        [string]$excludeFiles = "û�й�������"
    )

    # ���ݱ���б����ƻ�ȡ���޸ĵ��ļ��б�
    if ($changelist) {
        $changes = & svn status --changelist $changelist
    } else {
        $changes = & svn status
    }

    # �������޸ĵ��ļ�
    $changes | Select-String "^(M|A)" | ForEach-Object {
        $filename = $_.Line -replace "^[MA+\s]*", ""
        if ($filename -notmatch $excludeFiles) {
            $path = Join-Path $exportPath ($exportFolder + "\" + $filename)
            $dir = Split-Path $path -Parent
            New-Item -ItemType Directory -Force -Path $dir > $null
            svn $svnExportCmd $filename $path $svnExportArgs > $null
            Write-Host "�ѵ����ļ���" $filename
            # ��ȡ��ǰ���ں�ʱ��
            $timestamp = Get-Date -Format 'yyyy/MM/dd HH:mm:ss'
            # �� $dir д�� log.txt �ļ�
            Add-Content -Path $logFilePath -Value "$timestamp  �ѵ����ļ���$((Join-Path $dir $filename))"
        }
    }
    # ����֮��ӷָ���
    Add-Content -Path $logFilePath -Value "------------------------------------------------------------------------------------------------------------------------------------------------------------------"
}
# ��ȡ�û�����ı���б�����
$changelist = Read-Host "���������б����ƣ�ֱ�ӻس�������"

#���嵼�����б�
#$changelist = ""

# �������޸ĵ��ļ�
Export-SvnChanges $changelist

# ѹ�����޸�Ϊzip�ļ�
#$destinationPath = Join-Path $exportPath "$exportFolder.zip"
#Compress-Archive -Path $exportPath\$exportFolder -DestinationPath $destinationPath  -Update

#�򿪵����ļ���Ŀ¼
#$exportFullPath = Join-Path $exportPath $exportFolder
#Invoke-Item $exportFullPath

#���س��رմ���
#Read-Host "������ɣ����س��رմ���"