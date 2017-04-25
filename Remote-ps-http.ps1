winrm quickconfig
winrm set 'winrm/config/service/auth' '@{Basic="true"}'
winrm set 'winrm/config/service' '@{AllowUnencrypted="true"}'

#enable remote powershell
Enable-PSRemoting -SkipNetworkProfileCheck -Force

#remove al listeners
Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

#add https listener
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTP -Address * -Force

#allow https through firewall
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5985 -Protocol TCP
