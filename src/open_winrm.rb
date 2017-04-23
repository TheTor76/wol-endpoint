require 'winrm'

command = ''
if ARGV[0] == 'shutdown' then
	command = 'shutdown /s /f /t 0'
elsif ARGV[0] == 'psshutdown/sleep'
	command = 'psshutdown -d -t 0'
else
	command = '"$env:windir\System32\rundll32.exe powrprof.dll,SetSuspendState Standby"'
end


opts = {
	locale: 'en-gb',
	endpoint: ENV['WINRM_ENDPOINT'],
	user: ENV['WINRM_USERNAME'],
	password: ENV['WINRM_PASSWORD'],
	disable_sspi: true
}

if ENV['USE_SSL'] == '1' then
	opts[:transport] = :ssl
	opts[:ssl_peer_fingerprint] = ENV['SSL_PEER_FINGERPRINT']
else
	opts[:transport] = :plaintext
end

print opts

conn = WinRM::Connection.new(opts)
session1 = conn.shell(:powershell)

session1.run(command) do |stdout, stderr|
  STDOUT.print stdout
  STDERR.print stderr
end
