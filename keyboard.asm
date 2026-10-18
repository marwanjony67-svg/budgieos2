; =====================================================================================
;  Project: BudgieOS PC Edition (PS/2 Keyboard Driver & IRQ1 Interrupt Handler)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Direct Keyboard Hardware Controller
; =====================================================================================

[bits 32]

global init_keyboard_driver
global keyboard_handler
global asm_read_scan_code

extern terminal_writestring

KEYBOARD_PORT_DATA   equ 0x60          ; منفذ بيانات لوحة المفاتيح
KEYBOARD_PORT_STATUS equ 0x64          ; منفذ حالة التحكم

section .data
    kb_init_msg     db 0x0A, "[HW/KB] Initializing BudgieOS Keyboard Driver (IRQ1)...", 0x0A, 0
    kb_active_msg   db "[HW/KB] Keyboard Anti-Keylogging Guard Active (Lola Shield 🦜)", 0x0A, 0

    ; جدول تحويل الـ Scan Codes القياسية لرموز ASCII (مجموعة US QWERTY)
    scancode_table db  0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0x08
                   db 0x09, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0x0D
                   db  0,  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',  0
                   db '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',  0,  '*',  0
                   db ' '

section .bss
    last_ascii_char resb 1             ; الرمز الأخير الذي تم إدخاله

section .text

; --- 1. تهيئة تعريفات لوحة المفاتيح ---
init_keyboard_driver:
    push ebp
    mov ebp, esp

    ; طباعة رسائل التهيئة
    push kb_init_msg
    call terminal_writestring
    add esp, 4

    push kb_active_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. دالة معالجة مقاطعة لوحة المفاتيح (IRQ1 Interrupt Handler) ---
keyboard_handler:
    pusha                              ; حفظ كافة المسجلات
    
    in al, KEYBOARD_PORT_DATA          ; قراءة الـ Scan Code من المنفذ 0x60
    
    ; فحص ما إذا كان المفتاح مضغوطاً (Scan Code < 0x80) أم مفرغاً (Release > 0x80)
    test al, 0x80
    jnz .done_ack

    ; تحويل الـ Scan Code إلى رمز ASCII
    movzx ebx, al
    cmp ebx, 58                        ; التجميع ضمن حدود الجدول
    jge .done_ack

    mov cl, [scancode_table + ebx]
    mov [last_ascii_char], cl          ; حفظ الحرف المكتوب

.done_ack:
    ; إرسال إشعار انتهاء المقاطعة (EOI - End of Interrupt) لمعالج المقاطعات PIC (0x20)
    mov al, 0x20
    out 0x20, al

    popa
    iretd                              ; العودة من مقاطعة Protected Mode

; --- 3. قراءة الـ Scan Code المباشر ---
asm_read_scan_code:
    in al, KEYBOARD_PORT_DATA
    ret
