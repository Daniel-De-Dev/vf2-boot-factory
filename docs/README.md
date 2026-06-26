---
id: DOC-IDX-001
kind: reference
topic: project_navigation
status: active
applies_to:
  - /**
last_updated: 2026-06-25
---

> [!summary]
> Entrypoint for VisionFive 2 (VF2) boot factory documentation.

# 1. Purpose

This repository builds the U-Boot and OpenSBI bootchain for the VisionFive 2
RISC-V board using Nix. It provides reproducible firmware bundles and a
development environment for flashing via USART.

# 2. Reading Order

1. `docs/architecture/ARCH-001-boot-factory.md`: Understand Nix derivation structure and boot phases.
2. `docs/runbooks/RUN-001-flash-usart.md`: Learn how to flash board via serial cable.
