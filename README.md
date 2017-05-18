# wol-endpoint
simple node server running in docker to send WOL packets from local machine and run powershell sleep/shutdown commands on remote pc for use with [ha-bridge](https://github.com/aptalca/docker-ha-bridge) for alexa integration

## Example usage (http)
```
docker run -d --network="host" --restart=always \
	-e LISTEN_ON="127.0.0.1" -e LISTEN_PORT="9000" \
	-e WOL_MAC="xx:xx:xx:xx:xx:xx" -e WOL_BROADCAST_ADDR="x.x.x.x" \
	-e  USE_SSL="0" -e WINRM_USERNAME="some_username" \
	-e WINRM_PASSWORD="a_password" -e WINRM_ENDPOINT="http://x.x.x.x:5985/wsman" \
	--name wol-endpoint snipzwolf/wol-endpoint

```

## Example usage (https)
```
docker run -d --network="host" --restart=always \
	-e LISTEN_ON="127.0.0.1" -e LISTEN_PORT="9000" \
	-e WOL_MAC="xx:xx:xx:xx:xx:xx" -e WOL_BROADCAST_ADDR="x.x.x.x" \
	-e SSL_PEER_FINGERPRINT="<certificate (thumb/finger)print>" -e WINRM_USERNAME="some_username" \
	-e WINRM_PASSWORD="a_password" -e WINRM_ENDPOINT="https://x.x.x.x:5986/wsman" \
	--name wol-endpoint snipzwolf/wol-endpoint

```
