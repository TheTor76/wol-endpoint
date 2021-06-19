# wol-endpoint
simple node server running in docker to send WOL packets from local machine and run powershell sleep/shutdown commands on remote pc for use with [homebridge](https://github.com/homebridge/homebridge) for alexa integration. Requires 2 plugins [homebridge-alexa](https://github.com/NorthernMan54/homebridge-alexa) and [homebridge-http-switch](https://github.com/Supereg/homebridge-http-switch). Also requires enabling the [homebridge](https://www.amazon.co.uk/Northern-Man-54-Homebridge/dp/B07B9QMTFQ) Alexa skill.

## Example usage (http)
```
docker run -d --network="host" --restart=always \
	-e LISTEN_IP="127.0.0.1" -e LISTEN_PORT="9000" \
	-e WOL_MAC="xx:xx:xx:xx:xx:xx" -e WOL_BROADCAST_ADDR="x.x.x.x" \
	-e  USE_SSL="0" -e WINRM_USERNAME="some_username" \
	-e WINRM_PASSWORD="a_password" -e WINRM_ENDPOINT="http://x.x.x.x:5985/wsman" \
	--name wol-endpoint thetor76/wol-endpoint#homebridge-support
```

## Example usage (https)
```
docker run -d --network="host" --restart=always \
	-e LISTEN_IP="127.0.0.1" -e LISTEN_PORT="9000" \
	-e WOL_MAC="xx:xx:xx:xx:xx:xx" -e WOL_BROADCAST_ADDR="x.x.x.x" \
	-e SSL_PEER_FINGERPRINT="<certificate (thumb/finger)print>" -e WINRM_USERNAME="some_username" \
	-e WINRM_PASSWORD="a_password" -e WINRM_ENDPOINT="https://x.x.x.x:5986/wsman" \
	--name wol-endpoint thetor76/wol-endpoint#homebridge-support

```
