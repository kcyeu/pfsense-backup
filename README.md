# pfSense Backup

## Prerequisites
* curl

## Setup

Edit `${HOME}/.config/rc`, and set the following environment variables:
* `PASSWORD`: password of pfSense.
* `USERNAME`: username of pfSense, default value is `admin`.
* `TARGET_HOST`: hostname or IP address of the target server, default value is `192.168.1.1`
* `TARGET_PORT`: port of the target server, this is optional, default value is `80`.
* `TARGET_PROTOCOL`: http of https, default value is `http`.

For example:
```bash
export PASSWORD=NOT_A_REAL_PASSWORD
export USERNAME=NOT_A_REAL_USERNAME
export TARGET_HOST=example.com
export TARGET_PORT=8443
export TARGET_PROTOCOL=https
```
## Run

```bash
./pfsense_backup.sh
```

## Reference
1. https://docs.netgate.com/pfsense/en/latest/backup/remote-backup.html#using-curl
