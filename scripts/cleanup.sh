#!/bin/bash

SNAPSHOT_DIR="/path/to/Q2-automation/snapshots"

find "$SNAPSHOT_DIR" \
  -type f \
  -name "*.csv" \
  -mtime +30 \
  -delete