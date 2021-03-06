$wireguard_exe_path = "C:\Program Files\WireGuard\wireguard.exe"
$adaptorname ="wgserver"


# Create dynamic module for NetShare
# Network Sharing and Internet Access
New-Module -ScriptBlock {
    Function Set-NetConnectionSharing
    {
        Param
        (
            [Parameter(Mandatory=$true)]
            [string]
            $LocalConnection,

            [Parameter(Mandatory=$true)]
            [bool]
            $Enabled        
        )

        Begin
        {
            $netShare = $null

            try
            {
                # Create a NetSharingManager object
                $netShare = New-Object -ComObject HNetCfg.HNetShare
            }
            catch
            {
                # Register the HNetCfg library (once)
                regsvr32 /s hnetcfg.dll

                # Create a NetSharingManager object
                $netShare = New-Object -ComObject HNetCfg.HNetShare
            }
        }

        Process
        {
		    #Clear Existing Share	       
		    $oldConnections = $netShare.EnumEveryConnection |? { $netShare.INetSharingConfigurationForINetConnection.Invoke($_).SharingEnabled -eq $true}           
		    foreach($oldShared in $oldConnections)
            {
                $oldConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($oldShared)
                $oldConfig.DisableSharing()                        
            }        
	
            # Find connections
            $InternetConnection = Get-NetRoute | ? DestinationPrefix -eq '0.0.0.0/0' | Get-NetIPInterface | Where ConnectionState -eq 'Connected'        
            $publicConnection = $netShare.EnumEveryConnection |? { $netShare.NetConnectionProps.Invoke($_).Name -eq $InternetConnection.InterfaceAlias }
            $privateConnection = $netShare.EnumEveryConnection |? { $netShare.NetConnectionProps.Invoke($_).Name -eq $LocalConnection }

            # Get sharing configuration
            $publicConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($publicConnection)
            $privateConfig = $netShare.INetSharingConfigurationForINetConnection.Invoke($privateConnection)

            if ($Enabled)
            { 			
                $publicConfig.EnableSharing(0)
                $privateConfig.EnableSharing(1)
            }
            else
            {
                $publicConfig.DisableSharing()
                $privateConfig.DisableSharing()
            }
        }
    
    }
}

#Enable NAT
Set-NetConnectionSharing $adaptorname $false

# Uninstall WireGuard Adaptor name "wgserver"
Start-Process -Wait -FilePath $wireguard_exe_path -ArgumentList  "/uninstalltunnelservice",$adaptorname 

