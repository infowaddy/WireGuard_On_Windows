$wireguard_IP = "10.8.0.1"

# Change windows default share net address to wireguard server IP
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\SharedAccess\Parameters" -Name "ScopeAddress" -Value $wireguard_IP

# Set windows Internet Sharing Service startup type as Auto and make run
Set-Service -Name SharedAccess -StartupType Automatic -Status Running -PassThru

# Change windows default share net address to wireguard server IP
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\SharedAccess" -Name "EnableRebootPersistConnection" -Value 1
