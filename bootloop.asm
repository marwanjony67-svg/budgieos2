; =====================================================================================
;  Project: BudgieOS PC Edition (Bootloop Prevention & Recovery Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 16-bit / 32-bit Assembly Bootloader Recovery Handler
; =====================================================================================

[bits 16]

global check_bootloop_counter
global reset_bootloop_counter

BOOT_ATTEMPTS_PORT equ 0x70           ; من منفذ CMOS حجز بابت لإحصاء الإقلاع
MAX_BOOT_ATTEMPTS  equ 3              ; الحد الأقصى لمحاولات الإقلاع الفاشلة

section .text

; --- 1. فحص عدد محاولات الإقلاع لتجنب الـ Bootloop ---
check_bootloop_counter:
    push ax
    
    ; قراءة قيمة العداد من ذاكرة CMOS
    mov al, 0x10                      ; عنوان السجل في CMOS
    out BOOT_ATTEMPTS_PORT, al
    in al, 0x71
    
    cmp al, MAX_BOOT_ATTEMPTS
    jge .trigger_recovery_mode

    ; زيادة العداد بمقدار 1 وإعادة كتابته
    inc al
    push ax
    mov al, 0x10
    out BOOT_ATTEMPTS_PORT, al
    pop ax
    out 0x71, al

    pop ax
    ret

.trigger_recovery_mode:
    ; تفعيل وضع التعافي الآمن لـ BudgieOS
    mov si, msg_bootloop_detected
    call print_string_16
    
    ; القفز لوضع إصلاح النظام Safe Recovery Mode
    jmp bootloop_recovery_handler

; --- 2. تصفير العداد عند نجاح تحميل النواة بالكامل ---
reset_bootloop_counter:
    push ax
    mov al, 0x10
    out BOOT_ATTEMPTS_PORT, al
    mov al, 0x00                      ; إعادة القيمة إلى 0
    out 0x71, al
    pop ax
    ret

; --- معالج وضع التعافي الآمن ---
bootloop_recovery_handler:
    mov si, msg_recovery_prompt
    call print_string_16
    
.halt_loop:
    cli
    hlt
    jmp .halt_loop

; --- دالة طباعة النصوص في الوضع الحقيقي 16-bit ---
print_string_16:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string_16
.done:
    ret

section .data
    msg_bootloop_detected db 0x0D, 0x0A, "[CRITICAL] Bootloop Detected! Exceeded maximum boot attempts.", 0x0D, 0x0A, 0
    msg_recovery_prompt   db "[RECOVERY] BudgieOS Safe Recovery Mode Active (Lola Shield Enabled).", 0x0D, 0x0A, 0
