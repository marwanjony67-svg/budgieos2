# =====================================================================================
#  Project: BudgieOS PC Edition Automated Build System
#  Author & Lead Developer: Marwan
#  License: GPLbudgieos | Mascot: Lola 🦜
# =====================================================================================

# أدوات التجميع والربط
ASM = nasm
CC = gcc
LD = ld

# خيارات التجميع
ASMFLAGS = -f elf32
CCFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

# الهدف الرئيسي (إنشاء صورة النظام الكاملة)
all: budgieos_pc.img

# 1. تجميع البوتلودر كملف خام (Raw Binary)
boot.bin: boot.asm
	$(ASM) -f bin boot.asm -o boot.bin

# 2. تجميع ملفات الأسمبلي المتقدمة والنواة
kernel_entry.o: kernel_entry.asm
	$(ASM) $(ASMFLAGS) kernel_entry.asm -o kernel_entry.o

system.o: system.asm
	$(ASM) $(ASMFLAGS) system.asm -o system.o

# 3. تجميع كود الـ C الخاص بالنظام والتطبيقات
apps.o: apps.c
	$(CC) $(CCFLAGS) -c apps.c -o apps.o

# 4. ربط كافة ملفات الكائن (Object Files) في ملف النواة الثنائي
kernel.bin: kernel_entry.o system.o apps.o
	$(LD) $(LDFLAGS) -o kernel.bin kernel_entry.o system.o apps.o

# 5. دمج البوتلودر والنواة في صورة نظام جاهزة للإقلاع (Bootable OS Image)
budgieos_pc.img: boot.bin kernel.bin
	cat boot.bin kernel.bin > budgieos_pc.img

# تنظيف الملفات المؤقتة بعد التجميع
clean:
	rm -f *.o *.bin *.img

# تشغيل النظام مباشرة عبر محاكي QEMU للاختبار
run: budgieos_pc.img
	qemu-system-i386 -fda budgieos_pc.img
