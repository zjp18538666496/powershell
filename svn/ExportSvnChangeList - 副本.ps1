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
        }
    }
}

# ��ȡ�û�����ı���б�����
$changelist = Read-Host "���������б����ƣ�ֱ�ӻس�������"

# �������޸ĵ��ļ�
Export-SvnChanges $changelist

# ����Ŀ¼�ṹͼ��д��log.txt
$logFilePath = Join-Path $exportPath ($exportFolder + "\" + "log.txt")

# ����Ŀ¼�ṹͼ��д��log.txt
function Generate-DirectoryStructure($path, $indentation = "")
{
   $content = Get-ChildItem $path |
    Sort-Object -Property Name


    foreach ($item in $content)
    {
        $line = "$indentation"

        if ($item.PSIsContainer)
        {
            $line += "������ $item"
            Add-Content -Path $logFilePath -Value $line
            Write-Host $line

            $subIndentation = $indentation + "��  "
            $subPath = Join-Path $path $item
            Generate-DirectoryStructure $subPath -indentation $subIndentation
        }
        else
        {
            $line += "������ $item"
            Add-Content -Path $logFilePath -Value $line
            Write-Host $line
        }
    }
}

# ����Ŀ¼�ṹͼ��д��log.txt
Generate-DirectoryStructure (Join-Path $exportPath $exportFolder)

# ���س��رմ���
Read-Host "������ɣ����س��رմ���"
