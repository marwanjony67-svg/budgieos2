; =====================================================================================
;  Project: BudgieOS Bootloader & Kernel Linker
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Central Manager: Lola (لولا) 🦜
;  Architecture: 100% Standalone Assembly (x86 Real -> Protected Mode)
; =====================================================================================

[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; العنوان الذي سيتم فيه تحميل نواة C في الذاكرة

start:
    ; 1. حفظ رقم محرك الإقلاع وتهيئة مسجلات الذاكرة
    mov [BOOT_DRIVE], dl
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    ; 2. مسح الشاشة وتطبيق ألوان VGA
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    ; 3. طباعة رسالة بدء الإقلاع
    mov si, MSG_BOOT
    call print_string_16

    ; 4. قراءة النواة من القرص إلى الذاكرة (Sector Reading)
    call load_kernel_from_disk

    ; 5. الانتقال إلى الوضع المتقدم 32-bit Protected Mode
    call switch_to_protected_mode

    jmp $                   ; حلقة أمان

; --- دالة طباعة النصوص المباشرة (16-bit) ---
print_string_16:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    mov bl, 0x0b            ; لون النص (Cyan)
    int 0x10
    jmp .loop
.done:
    popa
    ret

; --- دالة تحميل النواة من القطاعات التالية في القرص ---
load_kernel_from_disk:
    mov bx, KERNEL_OFFSET   ; التحميل إلى العنوان 0x1000
    mov dh, 32              ; قراءة 32 قطاعاً للنواة
    mov dl, [BOOT_DRIVE]
    
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00            ; Cylinder 0
    mov dh, 0x00            ; Head 0
    mov cl, 0x02            ; البدء من القطاع الثاني
    int 0x13
    jc disk_error
    ret

disk_error:
    mov si, MSG_DISK_ERR
    call print_string_16
    jmp $

; --- جدول وصف القطاعات (GDT) للتحويل إلى 32-bit ---
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x9a
    db 0xcf
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x92
    db 0xcf
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; --- التحويل إلى 32-bit Protected Mode ---
switch_to_protected_mode:
    cli                     ; إيقاف المقاطعات
    lgdt [gdt_descriptor]   ; تحميل جدول GDT

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax            ; تفعيل بت Protected Mode

    jmp CODE_SEG:init_pm    ; قفزة بعيدة لتفريغ الأنابيب في المعالج

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; تحديث كافة مسجلات الذاكرة
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; إعداد الـ Stack المتقدم
    mov esp, ebp

    call KERNEL_OFFSET      ; القفز المباشر لتشغيل دالة kernel_main بداخل C!
    jmp $

; --- البيانات والمتغيرات ---
BOOT_DRIVE  db 0
MSG_BOOT    db 'Booting BudgieOS PC... Managed by Lola 🦜', 0dh, 0ah, 0
MSG_DISK_ERR db 'Disk Read Error in BudgieOS Boot sector!', 0dh, 0ah, 0

times 510-($-$$) db 0   ; حشو بقية القطاع الأول بالأصفار
dw 0xaa55               ; التوقيع الرسمي للإقلاع للبيوس (Boot Signature)
