---
id: ARCH-001
kind: architecture
topic: system_architecture
status: active
applies_to:
  - flake.nix
  - nix/parts/**
last_updated: 2026-07-04
---

> [!summary]
> Explains Nix module boundaries and data flow for building VF2 boot firmware.

# 1. Responsibilities

- **OpenSBI (`opensbi.nix`)**: Defines build steps for OpenSBI as dynamic firmware.
- **U-Boot (`uboot.nix`)**: Defines build steps for U-Boot SPL and U-Boot bootloader.
- **Bundle (`bundle.nix`)**: Glues OpenSBI and U-Boot output into unified flashable bundle.
- **Devshells (`devshells.nix`)**: Provides shell environment with tools and helper script to boot using USART.

# 2. Data and Dependency Flow

1. Fetch upstream sources as Nix flake inputs.
2. Compile firmwares from source directly.
3. `bundle.nix` collects Phase 1 SPL and Phase 2 payload into final flashable targets directory.

# 3. Boundaries

Implement standard bootchain (U-Boot SPL -> OpenSBI -> U-Boot proper).
