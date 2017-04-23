$dnsName = "SOME_NAME,SOME_IP";
$certPath = "c:\ps-cert.crt";

#create and export cert
$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $dnsName;
Export-Certificate -Cert $Cert -FilePath $certPath;

#enable remote powershell
Enable-PSRemoting -SkipNetworkProfileCheck -Force

#remove al listeners
Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

#add https listener
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

#allow https through firewall
New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP
Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"
