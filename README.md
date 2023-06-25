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

## Create backups periodically
User can create a cron job to run the backup script periodically, for example:
```
42 4 * * * _SCRIPT_PATH_/pfsense_backup.sh
```

## Backup files and rotation
* Backup files are compressed by `gzip` and saved in `./backups/` directory.
* Backup files are named after `TARGET_HOST` with timestamp.
* Files older than `BACKUP_RETENTION_DAY` days will be removed automatically at
the next script invocation.

## Reference
1. https://docs.netgate.com/pfsense/en/latest/backup/remote-backup.html#using-curl
