param (
    [Parameter(Mandatory=$true)]
    [string]$inputFile
)

# 检查文件是否存在
if (-not (Test-Path $inputFile)) {
    Write-Host "错误：文件不存在 - $inputFile"
    exit 1
}

# 获取CSV文件名，无扩展名
$filename = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)

# 创建输出文件夹，和CSV同目录，文件夹名同CSV文件名
$outputDir = Join-Path -Path (Split-Path -Parent $inputFile) -ChildPath $filename

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "输出目录：$outputDir"
Write-Host ""

# 读取CSV内容，编码用 Default(GBK/ANSI)防止乱码
# 若你确认CSV是UTF8编码，这里改成 -Encoding UTF8
$lines = Get-Content -Path $inputFile -Encoding Default

# 逐行处理
$counter = 0
foreach ($line in $lines) {
    # 用逗号分割每行，最多两列
    $parts = $line -split ',', 2

    if ($parts.Length -lt 2) {
        Write-Warning "第 $($counter+1) 行格式错误，跳过： $line"
        continue
    }

    $nameRaw = $parts[0].Trim()
    $content = $parts[1].Trim()

    # 替换文件名非法字符
    $illegalChars = '[\\\/:\*\?"<>\|]'
    $safeName = [regex]::Replace($nameRaw, $illegalChars, '_')

    # 构建完整文件路径
    $outFile = Join-Path -Path $outputDir -ChildPath "$safeName.txt"

    # 写文件，UTF8无BOM编码
    Set-Content -Path $outFile -Value $content -Encoding UTF8

    Write-Host "生成文件：$safeName.txt"
    $counter++
}

Write-Host ""
Write-Host "完成！共生成 $counter 个TXT文件，均存放于文件夹：$outputDir"
