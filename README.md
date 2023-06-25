# pfSense Backup

## Setup

Edit `${HOME}/.config/rc`, and set the following environment variables:
* `PASSWORD`: password of pfsense
* `TARGET_HOST`: hostname or IP address of the target server
* `TARGET_PORT`: port of the target server
* `TARGET_PROTOCOL`: http of https

For example:
```
export PASSWORD=NOT_A_REAL_PASSWORD
export TARGET_HOST=example.com
export TARGET_PORT=8443
export TARGET_PROTOCOL=https
```
