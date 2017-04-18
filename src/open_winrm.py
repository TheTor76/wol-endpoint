#!/usr/bin/env python3

import winrm
import base64

p = winrm.protocol.Protocol(
        endpoint='https://192.168.56.50:5986/wsman',
        transport='ssl',
        username='administrator',
        password='P@s5w0rd',
        server_cert_validation='ignore')

shell_id = p.open_shell()
command_id = p.run_command(shell_id, 'ipconfig', ['/all'])
std_out, std_err, status_code = p.get_command_output(shell_id, command_id)
p.cleanup_command(shell_id, command_id)
p.close_shell(shell_id)
