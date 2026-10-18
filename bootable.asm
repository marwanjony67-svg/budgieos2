; =====================================================================================
;  Project: BudgieOS PC Edition (First-Stage Bootloader MBR)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 16-bit Real Mode to 32-bit Protected Mode Transition Bridge
; =====================================================================================

[org 0x7C00]                     ; عنوان التحميل القياسي لقطاع الإقلاع في الذاكرة
[bits 16]

start:
    cli                          ; إيقاف المقاطعات المؤقتة
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00               ; ضبط مؤشر الختم (Stack) أسفل عنوان التحميل

    ; طباعة رسالة الإقلاع الترحيبية عبر BIOS
    mov si, boot_msg
    call bios_print

    ; الانتقال لتهيئة حماية الوضع المحمي 32-bit
    cli                          ; تعطيل المقاطعات نهائياً قبل تحميل جدول GDT
    lgdt [gdt_descriptor]        ; تحميل جدول الوصف العام (Global Descriptor Table)

    mov eax, cr0
    or eax, 0x00000001           ; تفعيل بت Protected Mode في سجل CR0
    mov cr0, eax

    ; القفز بعيداً لتحديث خط أنابيب المعالج (Pipeline Flush) إلى الوضع 32-bit
    jmp 0x08:init_pm_32

; --- دالة طباعة النصوص في الوضع الحقيقي 16-bit ---
bios_print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp bios_print
.done:
    ret

section .data
    boot_msg db "[BOOT] Loading BudgieOS PC (Lola Guardian Active 🦜)...", 0x0D, 0x0A, 0

; --- جدول الوصف العام (GDT - Global Descriptor Table) ---
gdt_start:
    dq 0                         ; Null Descriptor (العنوان الفارغ الإلزامي)

gdt_code:
    dw 0xFFFF                    ; Limit (bits 0-15)
    dw 0x0000                    ; Base (bits 0-15)
    db 0x00                      ; Base (bits 16-23)
    db 10011010b                 ; Access byte (Present, Ring 0, Executable, Readable)
    db 11001111b                 ; Granularity (4KB blocks, 32-bit protected mode)
    db 0x00                      ; Base (bits 24-31)

gdt_data:
    dw 0xFFFF                    ; Limit (bits 0-15)
    dw 0x0000                    ; Base (bits 0-15)
    db 0x00                      ; Base (bits 16-23)
    db 10010010b                 ; Access byte (Present, Ring 0, Writable data)
    db 11001111b                 ; Granularity
    db 0x00                      ; Base (bits 24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; GDT Size (Limit)
    dd gdt_start                 ; GDT Base Address

; =====================================================================================
; 32-BIT PROTECTED MODE ENTRY
; =====================================================================================
[bits 32]
init_pm_32:
    mov ax, 0x10                 ; Data Segment Selector (مؤشر البيانات 0x10)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000             ; ضبط مؤشر الختم في الذاكرة المحمية

    ; هنا يتم القفز أو تحميل النواة الرئيسية (kernel_main_entry)
    hlt
    jmp $

; --- إكمال قطاع الإقلاع بالحجم القياسي 512 بايت وتوقيع MBR ---
times 510-($-$$) db 0
dw 0xAA55                        ; توقيع الإقلاع السحري (Boot Signature)
