# WireGuard_On_Windows
Necessary PowerShell scripts to deploy WireGuard on windows server

# How to use
Download all files and create a folder inside C:\wireguard\ drive.

Change VPN server and clients (peers) public keys and IP in wgserver.conf file.

Change WireGuard server IP at PreConfigureWindowsSettings.ps1 file.

Run below two windows batch files with administrator right
1.setup_prequisite_configuration.bat 
2.start_wgserver.bat

Or run below two PowerShell scripts with administrator right
PreConfigureWindowsSettings.ps1
InstallWireGuardAdaptor.ps1

# Take note
If you want to place in different folder path or file name, please change those updated information inside PowerShell scripts file and batch file accordingly.

