# 执行命令：powershell -ExecutionPolicy Bypass -File '.\chardetect .ps1'

$folderPath = "F:\repo\PES101"  # 替换为要匹配文件的文件夹路径
$pattern = "*.c"  # 替换为你的匹配模式，例如 *.c 表示匹配所有以 .c 结尾的文件

Get-ChildItem -Path $folderPath -Recurse -Filter $pattern | ForEach-Object {
    $filePath = $_.FullName
    $encoding = chardetect $filePath
    Write-Output "${filePath}: ${encoding}"
}

pause

# "ascii with confidence 1.0" 表示该文件或文本内容被检测为 ASCII 编码，并且置信度为 1.0，表示非常确定它是 ASCII 编码。
# "utf-8 with confidence 0.99" 表示该文件或文本内容被检测为 UTF-8 编码，并且置信度为 0.99，表示在一定程度上确定它是 UTF-8 编码，但存在一定程度的不确定性。