# 🦜 BudgieOS PC Edition (v0.2)

![License](https://img.shields.io/badge/License-GPLbudgieos-brightgreen)
![Architecture](https://img.shields.io/badge/Architecture-x86_32--bit-blue)
![Language](https://img.shields.io/badge/Languages-C%20%7C%20NASM%20Assembly-orange)

An enterprise-level, standalone operating system built completely from scratch using pure **C** and **NASM Assembly**. **BudgieOS PC** is 100% independent of external operating systems, third-party kernels, or proprietary software platforms.

---

## 📌 Project Overview

* **Developer & Lead Architect:** Marwan
* **Project Repository:** `budgieos2`
* **License:** `GPLbudgieos`
* **Mascot & Central Manager:** Lola 🦜

---

## 🛠️ Core Architecture & Subsystems

1. **Bare-Metal Bootloader (`boot.asm`)**:
   * Initializes 16-bit real mode BIOS interfaces.
   * Clears video display, sets VGA color palette, and loads system sectors.
   * Switches CPU execution mode seamlessly to 32-bit Protected Mode.

2. **Low-Level Hardware Kernel (`kernel.asm` & `system.asm`)**:
   * Manages Global Descriptor Table (GDT) and Interrupt Descriptor Table (IDT).
   * Direct hardware port I/O handling for low-level keyboard matrix inputs.

3. **Pure C Kernel Core (`kernel.c`)**:
   * Direct VGA text frame-buffer rendering at `0xB8000`.
   * Enforces the **Anti-Keylogger Shield** for maximum security.
   * Implements **EATRAMSTOP Engine** for automatic memory buffer optimization.

4. **Ecosystem Applications Package (`apps.c`)**:
   * Integrated Gul GUI File Explorer.
   * High-performance video/media playback module.
   * Bare-metal accelerated gaming engine interface.
   * Google Chrome web engine runtime handler.

---

## 🚀 Building & Running BudgieOS

To compile and assemble the entire system binaries using the provided `Makefile`:

```bash
# Clone the repository
git clone [https://github.com/marwanjony67-svg/budgieos2.git](https://github.com/marwanjony67-svg/budgieos2.git)
cd budgieos2

# Build the bootable OS image (budgieos_pc.img)
make

# Run directly inside QEMU emulator
make run
