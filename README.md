# Q2 - Usage Snapshot Automation

This project implements an automated usage snapshot process using a Linux cron job.

The automation calls the usage retrieval endpoint from Q1 three times a day and saves the response as a CSV file. It also includes a separate cleanup script to remove CSV snapshots older than 30 days.

## Requirements

* Linux / Unix-based system
* `curl`
* `cron`
* Access to the Q1 backend API

## Project Structure

```text
Q2-automation/
├── scripts/
│   ├── snapshot.sh
│   └── cleanup.sh
├── snapshots/
└── README.md
```

## Snapshot Automation

The `snapshot.sh` script calls the usage retrieval endpoint and saves the response as a CSV file.

### API Endpoint

The script expects the Q1 API to provide a usage retrieval endpoint:

```text
GET http://localhost:3000/usages
```

The endpoint URL can be changed in `scripts/snapshot.sh`.

### File Naming Convention

Snapshot files use the following format:

```text
usage_YYYY-MM-DD_HHMM.csv
```

Example:

```text
usage_2026-09-26_0800.csv
usage_2026-09-26_1200.csv
usage_2026-09-26_1500.csv
```

This makes the snapshot date and execution time easy to identify.

## Make Scripts Executable

Run:

```bash
chmod +x scripts/snapshot.sh
chmod +x scripts/cleanup.sh
```

## Test Snapshot Manually

Before configuring cron, run the script manually:

```bash
./scripts/snapshot.sh
```

A successful execution should create a CSV file inside the `snapshots/` directory.

Example:

```text
snapshots/
└── usage_2026-09-26_0800.csv
```

## Configure Linux Cron

Open the user's crontab:

```bash
crontab -e
```

Add the following entries:

```cron
0 8 * * * /path/to/Q2-automation/scripts/snapshot.sh
0 12 * * * /path/to/Q2-automation/scripts/snapshot.sh
0 15 * * * /path/to/Q2-automation/scripts/snapshot.sh
```

The jobs run at:

| Time      | Purpose        |
| --------- | -------------- |
| 08:00 WIB | Usage snapshot |
| 12:00 WIB | Usage snapshot |
| 15:00 WIB | Usage snapshot |

The server should use the `Asia/Jakarta` timezone so that the cron schedule matches WIB.

Check the server timezone with:

```bash
timedatectl
```

If necessary:

```bash
sudo timedatectl set-timezone Asia/Jakarta
```

Verify the configured cron jobs:

```bash
crontab -l
```

## Cleanup Automation

The `cleanup.sh` script removes CSV files older than 30 days.

Run it manually:

```bash
./scripts/cleanup.sh
```

The cleanup command targets only CSV files inside the snapshot directory.

```bash
find "$SNAPSHOT_DIR" -type f -name "*.csv" -mtime +30 -delete
```

## Schedule Cleanup

The cleanup script can also be scheduled using Linux cron.

For example, to run it every day at 01:00 WIB:

```cron
0 1 * * * /path/to/Q2-automation/scripts/cleanup.sh
```

The complete crontab configuration becomes:

```cron
0 8 * * * /path/to/Q2-automation/scripts/snapshot.sh
0 12 * * * /path/to/Q2-automation/scripts/snapshot.sh
0 15 * * * /path/to/Q2-automation/scripts/snapshot.sh
0 1 * * * /path/to/Q2-automation/scripts/cleanup.sh
```

## CSV Format

The generated CSV contains the usage fields from Q1:

```csv
subscriberId,callMinutes,smsCount,dataUsageMB,timestamp
SUB01,40,10,1500,2026-09-26 08:00
SUB02,90,20,6000,2026-09-26 08:00
```

The CSV structure is kept consistent with the usage data required by Q3.

## Error Handling

The snapshot script should fail when the API request cannot be completed instead of creating an invalid snapshot.

Recommended checks include:

* API availability
* HTTP response status
* Response content
* CSV output creation

Cron output can be redirected to a log file if required:

```cron
0 8 * * * /path/to/Q2-automation/scripts/snapshot.sh >> /path/to/Q2-automation/snapshot.log 2>&1
```

## Summary

Q2 consists of two automated tasks:

1. **Usage Snapshot**

   * Calls the Q1 retrieval API
   * Runs at 08:00, 12:00, and 15:00 WIB
   * Saves the response as a timestamped CSV file

2. **Snapshot Cleanup**

   * Runs daily
   * Removes CSV snapshots older than 30 days

The scheduling is handled by the Linux `cron` service rather than an application-level scheduler.