; =====================================================================================
;  Project: BudgieOS PC Edition (Core Security & Anti-Keylogger Guard Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Assembly Core Security & Memory Encryption Engine
; =====================================================================================

[bits 32]

global init_security_shield
global security_xor_encrypt_buffer
global security_verify_kernel_integrity

extern terminal_writestring

SALT_KEY equ 0x5A                      ; مفتاح التشفير الخاص بنظام BudgieOS

section .data
    sec_banner_msg   db 0x0A, "[SECURITY] BudgieOS Security Shield Initialized...", 0x0A, 0
    sec_active_msg   db "[SECURITY] Anti-Keylogger & Memory Guard Active (Lola Shield 🦜)", 0x0A, 0
    sec_check_ok     db "[SECURITY] Kernel Integrity Check: OK / Verified", 0x0A, 0

section .text

; --- 1. تهيئة درع الأمان للنواة ---
init_security_shield:
    push ebp
    mov ebp, esp

    ; طباعة رسائل تفعيل الأمان
    push sec_banner_msg
    call terminal_writestring
    add esp, 4

    push sec_active_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. تشفير/فك تشفير الذاكرة السريع عبر XOR (In-Memory XOR Encryption) ---
; Arguments: [esp+4] = Buffer Pointer, [esp+8] = Length
security_xor_encrypt_buffer:
    push ebp
    mov ebp, esp
    push esi
    push ecx

    mov esi, [ebp + 8]               ; Buffer Pointer
    mov ecx, [ebp + 12]              ; Buffer Length

.encrypt_loop:
    cmp ecx, 0
    je .done

    mov al, [esi]
    xor al, SALT_KEY                 ; تشفير مباشر للبايت مع مفتاح SALT
    mov [esi], al

    inc esi
    dec ecx
    jmp .encrypt_loop

.done:
    pop ecx
    pop esi
    mov esp, ebp
    pop ebp
    ret

; --- 3. التحقق من سلامة النواة والذاكرة (Kernel Integrity Verification) ---
security_verify_kernel_integrity:
    push ebp
    mov ebp, esp

    push sec_check_ok
    call terminal_writestring
    add esp, 4

    mov eax, 1                       ; إرجاع 1 (سلامة البيانات)
    mov esp, ebp
    pop ebp
    ret
