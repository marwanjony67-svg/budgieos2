# BudgieOS V2.0 — OSDev starter

This folder is the OSDev-based kernel starter for BudgieOS. It is a custom, freestanding operating-system project; it is not a Linux distribution. GNU GCC, Binutils and GRUB are development and boot tools, not a Linux kernel.

## Current milestone

- 32-bit x86 protected-mode kernel entry
- NASM assembly startup and 16 KiB kernel stack
- Freestanding C++20 kernel
- VGA text output with BudgieOS blue styling
- GRUB Multiboot v1 boot and QEMU ISO target

This is an early kernel milestone, not a complete desktop OS. Networking, USB, sound, graphics acceleration, accounts, BudgieFS, and the Windows-style desktop are future milestones.

## Build environment

Use a GNU/Linux development environment or WSL with these tools installed:

- i686-elf-gcc and i686-elf-g++ cross compiler, including libgcc
- NASM, GNU Make, GRUB utilities, xorriso, and QEMU

The OSDev Wiki explains why a cross-compiler is required: the host compiler normally targets the host operating system, not your new kernel.

## Build and run

From this directory:

    make
    make check
    make run

The ISO is written to budgieos-v2.iso. QEMU runs it as a virtual CD-ROM; it does not install anything on your computer.

## Planned roadmap

1. IDT and exception reporting
2. PIC/APIC interrupt handling and PS/2 keyboard input
3. Physical memory manager and paging
4. Heap allocator and kernel C++ runtime support
5. Timer and scheduler
6. Block-device layer and BudgieFS
7. Graphics framebuffer and window manager
8. User mode, system calls, and native applications
9. Networking, audio, USB, and broader hardware drivers

## References

- OSDev Wiki: https://wiki.osdev.org/Bare_Bones
- OSDev Wiki: https://wiki.osdev.org/Multiboot
- GNU GRUB manual: https://www.gnu.org/software/grub/manual/grub/grub.html

## License

Add the repository's chosen OSI-approved license before redistributing. Do not assume the informal label GPLbudgieos is a recognized license identifier.
