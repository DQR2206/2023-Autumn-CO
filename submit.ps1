# 桌面路径
$desktop = [System.Environment]::GetFolderPath('Desktop')

# 当前目录路径
$currentDir = Get-Location

# 目标文件夹路径
$srcPath = "$desktop\src"

# 创建目标文件夹（如果不存在）
if (-not (Test-Path -Path $srcPath)) {
    New-Item -Path $srcPath -ItemType Directory
}
# 复制文件
Copy-Item -Path "$currentDir\*.v" -Destination $srcPath

$zipPath = "$desktop\src.zip"

# 压缩src文件夹为zip文件
Compress-Archive -LiteralPath $srcPath -DestinationPath $zipPath -Force

Write-Host "done"