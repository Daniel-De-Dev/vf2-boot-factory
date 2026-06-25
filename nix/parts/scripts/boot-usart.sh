#!/usr/bin/env bash
set -euo pipefail

# Provided by Nix
BUNDLE="${BUNDLE:?BUNDLE environment variable must be set}"
SPL_NAME="${SPL_NAME:-phase1-spl.bin}"
PAYLOAD_NAME="${PAYLOAD_NAME:-phase2-payload.bin}"

TTY="${1:-/dev/ttyUSB0}"
SLEEP_TIME=3
BAUD_RATE=115200

echo "Configuring serial port ${TTY}..."
stty -F "${TTY}" "${BAUD_RATE}" raw -echo -echoe -echok -echoctl -echoke

echo "Starting Phase 1: Uploading ${SPL_NAME}..."
echo "Ensure DIP switches are 11 and press reset button."

sx -vv --xmodem "${BUNDLE}/flash-targets/phase1-spl.bin" <>"${TTY}" 1>&0

echo "Phase 1 complete. Wait ${SLEEP_TIME} seconds for DDR..."
sleep "${SLEEP_TIME}"

echo "Starting Phase 2: Uploading ${PAYLOAD_NAME}..."
sb -vv --ymodem "${BUNDLE}/flash-targets/phase2-payload.bin" <>"${TTY}" 1>&0

echo "Transfer complete. Open terminal..."
exec tio "${TTY}" -b "${BAUD_RATE}"
