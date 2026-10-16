; =====================================================================================
;  Project: BudgieOS PC Kernel Assembly Entry
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Central Manager: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Kernel Linker
; =====================================================================================

[bits 32]

section .text
global _start
extern kernel_main      ; استدعاء الدالة الرئيسية لنواة C (kernel.c / apps.c)

_start:
    ; 1. تهيئة مسجلات الذاكرة للوضع المتقدم 32-bit
    mov ax, 0x10        ; Data Segment Selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; 2. إعداد مكدس الذاكرة (Kernel Stack Pointer)
    mov esp, kernel_stack_top

    ; 3. القفز المباشر لتشغيل دالة kernel_main بداخل لغة C
    call kernel_main

    ; 4. حلقة أمان للمعالج في حال انتهاء تنفيذ النواة
kernel_halt:
    cli                 ; إيقاف المقاطعات
    hlt                 ; وضع المعالج في حالة خمول آمنة
    jmp kernel_halt

section .bss
align 16
kernel_stack_bottom:
    resb 16384          ; حجز مساحة 16 كيلوبايت للـ Stack
kernel_stack_top:
