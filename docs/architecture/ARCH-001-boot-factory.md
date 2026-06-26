---
id: ARCH-001
kind: architecture
topic: system_architecture
status: active
applies_to:
  - flake.nix
  - nix/parts/**
last_updated: 2026-06-25
---

> [!summary]
> Explains Nix module boundaries and data flow for building VF2 boot firmware.

# 1. Responsibilities

- **OpenSBI (`opensbi.nix`)**: Defines build steps for OpenSBI as a dynamic
  firmware (`fw_dynamic.bin`).
- **U-Boot (`uboot.nix`)**: Defines build steps for U-Boot SPL and U-Boot
  bootloader.
- **Combinations (`combinations.nix`)**: Glues OpenSBI and U-Boot output into
  unified flashable bundle.
- **Devshells (`devshells.nix`)**: Provides shell environment with tools and
  helper scripts to boot using usart.

# 2. Data and Dependency Flow

1. Fetch upstream sources as Nix flake inputs.
2. Compile the firmwares from source directly.
3. `mkBootBundle` collects SPL and payload into final flashable targets directory.

_Currently only a single bundle if implemented_

# 3. Boundaries

Dilebiratly implement in a modular way to allow for swapping out the individual
implementations.
