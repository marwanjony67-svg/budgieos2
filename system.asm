; =====================================================================================
;  Project: BudgieOS Hardware & System Interrupt Handler
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Central Manager: Lola (لولا) 🦜
;  Architecture: 100% Standalone Assembly Low-Level System Control
; =====================================================================================

[bits 32]

global gdt_flush
global idt_load
global keyboard_handler
global system_halt

; --- 1. تحميل جدول وصف القطاعات المتقدم (GDT Flush) ---
gdt_flush:
    mov eax, [esp + 4]
    lgdt [eax]

    mov ax, 0x10        ; Kernel Data Segment (0x10)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:.flush     ; Kernel Code Segment (0x08)
.flush:
    ret

; --- 2. تحميل جدول المقاطعات (IDT Load) ---
idt_load:
    mov eax, [esp + 4]
    lidt [eax]
    ret

; --- 3. معالج إشارات لوحة المفاتيح والعتاد المباشر ---
keyboard_handler:
    pusha
    in al, 0x60         ; قراءة الكود المباشر من منفذ لوحة المفاتيح 0x60
    
    ; معالجة الإشارة وإرسال إشارة التأكيد للعتاد (EOI)
    mov al, 0x20
    out 0x20, al
    out 0xa0, al
    popa
    iretd

; --- 4. إيقاف آمن للمعالج (System Halt) ---
system_halt:
    cli
    hlt
    ret
