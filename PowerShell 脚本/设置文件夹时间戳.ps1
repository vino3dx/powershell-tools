# Set-FolderTimestamp.ps1

# 提示用户输入文件夹路径
$folderPath = Read-Host "请输入文件夹的完整路径（例如：D:\MyFolder）"

# 检查路径是否存在
if (-not (Test-Path -Path $folderPath -PathType Container)) {
    Write-Host "❌ 错误：指定的路径不存在或不是一个文件夹。" -ForegroundColor Red
    pause
    exit 1
}

# 提示用户输入目标时间
Write-Host "`n请输入要设置的日期和时间（格式：yyyy-MM-dd HH:mm:ss，例如：2023-05-15 14:30:00）" -ForegroundColor Cyan
$timeInput = Read-Host "目标时间"

# 验证时间格式
try {
    $newTime = [DateTime]::ParseExact($timeInput, "yyyy-MM-dd HH:mm:ss", $null)
} catch {
    Write-Host "❌ 错误：时间格式不正确。请使用 yyyy-MM-dd HH:mm:ss 格式。" -ForegroundColor Red
    pause
    exit 1
}

# 获取文件夹对象
$item = Get-Item -Path $folderPath

# 修改三个时间戳
$item.CreationTime = $newTime
$item.LastWriteTime = $newTime
$item.LastAccessTime = $newTime

# 成功提示
Write-Host "`n✅ 成功！已将文件夹的时间戳全部设置为：$newTime" -ForegroundColor Green
Write-Host "路径：$folderPath"
pause