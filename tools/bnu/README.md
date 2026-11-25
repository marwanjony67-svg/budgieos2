# BNU Toolkit 1.0

BNU (BudgieOS Native Utilities) is the host-side command-line toolkit for developing BudgieOS. It is written in portable C++20 and has no third-party library dependencies.

## Build BNU

From this directory:

    make

This creates the BNU executable (bnu or bnu.exe depending on the host toolchain).

## Commands

    bnu help
    bnu version
    bnu doctor
    bnu new hello-budgie
    bnu build
    bnu build ../..
    bnu clean
    bnu pkg list

- doctor checks for the host compiler, GNU Make, the i686-elf cross compiler, NASM, GRUB ISO tools, and QEMU.
- new creates a small C++ application project with a BNU manifest and Makefile.
- build looks for a Makefile in the selected directory. If it finds osdev/Makefile, it builds that BudgieOS kernel target.
- clean runs the project's Makefile clean target.
- pkg list shows the initial package catalog and clearly labels planned packages.

## Current limitations

This is an early developer toolkit. It is not yet a kernel, package downloader, package installer, compiler, or complete shell. The package catalog is informational only. BNU delegates kernel compilation to the Makefile and cross-toolchain in osdev/.

## Roadmap

1. BNU project manifest validation
2. Package metadata and dependency resolver
3. Local package archive creation and verification
4. BudgieOS image and ISO management
5. BNU shell and native system utilities

## License

Use the license selected by the parent BudgieOS repository. Add a recognized license file before distributing this toolkit.
