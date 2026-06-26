---
id: RUN-001
kind: runbook
topic: firmware_booting
status: active
applies_to:
  - nix/parts/scripts/boot-usart.sh
last_updated: 2026-06-26
---

> [!summary]
> Procedure for booting with U-Boot and OpenSBI to the VisionFive 2 over serial USART connection.

# 1. Preconditions

- VisionFive 2 board connected via USB-to-TTL serial adapter.
- Nix installed and flake support enabled.
- Default serial device is `/dev/ttyUSB0` (override by passing arg if different).
- Ensure user has neccesaary permissions (dialout)

# 2. Procedure

1. Enter Nix development environment:

   ```bash
      nix develop
   ```

2. Run standard boot flash script:
   ```bash
   boot-usart-standard
   ```
3. When prompted by script, ensure VisionFive 2 DIP switches are set to `11` (UART boot mode).
4. Press board RESET button to begin Phase 1 transfer (XMODEM).
5. Wait for DDR initialization. Script will automatically start Phase 2 transfer (YMODEM).

# 3. Verification

When Phase 2 completes, script drops into `tio` serial monitor. Verify U-Boot prompt appears.

# 4. Failure Handling

- **Transfer hangs at Phase 1**: Ensure DIP switches are exactly `11` and RESET was pressed exactly when XMODEM started polling.
- **Permission denied `/dev/ttyUSB0**`: Add user to `dialout` group, or run script with appropriate permissions.
