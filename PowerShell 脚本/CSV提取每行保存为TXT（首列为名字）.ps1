# 提示用户输入 CSV 文件路径
Write-Host ">> 请将 CSV 文件路径粘贴或拖拽到此处 | 例如:C:\Users\Documents\class.csv <<" -ForegroundColor Red
$inputFile = Read-Host "CSV 文件路径"

# 检查文件是否存在
if (-not (Test-Path $inputFile)) {
    Write-Host "错误：文件不存在 - $inputFile" -ForegroundColor Red
    Pause
    exit 1
}

# 获取CSV文件名，无扩展名
$filename = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)

# 创建输出文件夹，和CSV同目录，文件夹名同CSV文件名
$outputDir = Join-Path -Path (Split-Path -Parent $inputFile) -ChildPath $filename
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "输出目录：$outputDir" -ForegroundColor Green
Write-Host ""

# 用 Import-Csv 读取，确保按列处理
$rows = Import-Csv -Path $inputFile -Encoding Default

$counter = 0
foreach ($row in $rows) {
    $nameRaw = $row.'条名'.Trim()
    $content = $row.'内容'.Trim()

    # 替换文件名非法字符
    $illegalChars = '[\\\/:\*\?"<>\|]'
    $safeName = [regex]::Replace($nameRaw, $illegalChars, '_')

    # 构建完整文件路径
    $outFile = Join-Path -Path $outputDir -ChildPath "$safeName.txt"

    # 写文件，UTF8无BOM编码
    Set-Content -Path $outFile -Value $content -Encoding UTF8

    Write-Host "生成文件：$safeName.txt" -ForegroundColor Green
    $counter++
}

Write-Host ""
Write-Host "完成！共生成 $counter 个TXT文件，均存放于文件夹：$outputDir" -ForegroundColor Green
Pause
