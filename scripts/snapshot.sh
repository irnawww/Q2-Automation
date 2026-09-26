#!/bin/bash

API_URL="http://localhost:3000/usages"
OUTPUT_DIR="/path/to/Q2-automation/snapshots"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
OUTPUT_FILE="$OUTPUT_DIR/usage_${TIMESTAMP}.csv"

curl -s "$API_URL" -o "$OUTPUT_FILE"

echo "Snapshot saved: $OUTPUT_FILE"