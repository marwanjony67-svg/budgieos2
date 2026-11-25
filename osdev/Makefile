CXX := i686-elf-g++
AS := nasm
QEMU := qemu-system-i386

CXXFLAGS := -std=c++20 -m32 -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti -fno-use-cxa-atexit -fno-stack-protector -fno-pie -fno-threadsafe-statics
LDFLAGS := -m32 -T linker.ld -ffreestanding -O2 -nostdlib -no-pie

.PHONY: all iso run clean check
all: iso

boot.o: boot.asm
	$(AS) -f elf32 $< -o $@

kernel.o: kernel.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

budgieos.elf: boot.o kernel.o linker.ld
	$(CXX) $(LDFLAGS) -o $@ boot.o kernel.o -lgcc

check: budgieos.elf
	grub-file --is-x86-multiboot budgieos.elf

iso: budgieos.elf grub.cfg
	mkdir -p isodir/boot/grub
	cp budgieos.elf isodir/boot/budgieos.elf
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o budgieos-v2.iso isodir

run: iso
	$(QEMU) -cdrom budgieos-v2.iso -m 128M

clean:
	rm -rf *.o *.elf *.iso isodir
