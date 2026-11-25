# BudgieOS V1.0 — x86_64 starter

BudgieOS is an experimental 64-bit operating-system project written in C++ and x86 assembly. Its design goal is a GNU-style userland and a custom desktop, with an independent kernel. It is **not a Linux distribution** and is not Windows NT.

## Current status

This repository contains the first kernel skeleton and build layout. It is a development starter, not a finished operating system. The kernel currently demonstrates a freestanding entry point and basic serial logging. It does not yet provide processes, memory management, drivers, a filesystem, networking, or a graphical desktop.

## Boot strategy

Limine is the planned first bootloader so the project can focus on kernel foundations before writing a native boot manager. The current files are only a compile-oriented kernel skeleton: Limine protocol requests and a verified bootable ISO have **not** been implemented yet. This means the current ELF should not be treated as bootable. A native BudgieOS boot manager can be developed later once the kernel has a stable boot contract.

## Source layout

- `kernel/main.cpp` — freestanding C++ kernel entry and serial output
- `kernel/arch/x86_64/boot.S` — assembly entry stub
- `linker.ld` — kernel linker layout
- `Makefile` — cross-compiler build rules
- `boot/limine.conf` — example Limine boot menu entry

## Build prerequisites

Use a Linux development environment (or WSL2 on Windows) with:

- an x86_64-elf GCC toolchain (GCC and binutils)
- NASM
- make
- xorriso
- Limine binary release files

The Makefile builds an ELF kernel. Creating a bootable ISO also requires installing the Limine BIOS/UEFI files into an ISO staging directory; the exact file names depend on the Limine release you install. See the build notes below.

## Build the kernel

From this directory:

```sh
make
```

The output is `build/budgieos.elf`.

## Next milestones

1. Verify boot in QEMU using a Limine ISO.
2. Add framebuffer text output and keyboard input.
3. Add physical and virtual memory management.
4. Add interrupt handling and timer support.
5. Add a basic heap, scheduler, and userspace ABI.
6. Add a filesystem and command shell.
7. Build the BudgieOS desktop after the kernel foundations are stable.

**Safety note:** Test experimental kernels in QEMU or another virtual machine first, not on your main PC.
