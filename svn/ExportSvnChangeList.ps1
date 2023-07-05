# �л��� SVN ��������Ŀ¼
cd -d D:\wis\WisCode\WebService

# ���� SVN ��������Ͳ���
$svnExportCmd = "export"
$svnExportArgs = "--force"

# ���嵼��·�����ļ�������
$exportPath = "C:\Users\Administrator\Desktop"
$exportFolder = "$(Get-Date -Format 'yyyyMMdd-HHmm')"

# ���嵼���ļ��Ĺ�������
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
            # �� $dir д�� log.txt �ļ�
            $logFilePath = Join-Path $exportPath ($exportFolder + "\" + "log.txt")
            Add-Content -Path $logFilePath -Value "�ѵ����ļ���$((Join-Path $dir $filename))"
        }
    }
}

# ��ȡ�û�����ı���б�����
$changelist = Read-Host "���������б����ƣ�ֱ�ӻس�������"

# �������޸ĵ��ļ�
Export-SvnChanges $changelist

#�򿪵����ļ���Ŀ¼
#$exportFullPath = Join-Path $exportPath $exportFolder
#Invoke-Item $exportFullPath

#���س��رմ���
#Read-Host "������ɣ����س��رմ���"