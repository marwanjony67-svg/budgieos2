; =====================================================================================
;  Project: BudgieOS PC Edition (Low-Level Password Buffer & Register Encryption)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Secure Input Buffer
; =====================================================================================

[bits 32]

global asm_secure_wipe_buffer
global asm_fast_xor_encrypt

section .text

; --- 1. مسح ذاكرة إدخال كلمة المرور آمنياً (Zero Memory Buffer) ---
; Arguments: [esp+4] = Buffer Pointer, [esp+8] = Length
asm_secure_wipe_buffer:
    push ebp
    mov ebp, esp
    push edi
    push ecx

    mov edi, [ebp + 8]      ; مؤشر الـ Buffer
    mov ecx, [ebp + 12]     ; الطول
    xor eax, eax            ; القيمة 0 للمسح

    cld
    rep stosb               ; كتابة الأصفار في الذاكرة لتطهيرها من كلمة المرور

    pop ecx
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- 2. تشفير سريع للمسجلات وسلسلة الأحرف (Fast Hardware XOR Cipher) ---
; Arguments: [esp+4] = Buffer Pointer, [esp+8] = Length, [esp+12] = Key
asm_fast_xor_encrypt:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ecx
    push ebx

    mov esi, [ebp + 8]      ; Input Buffer
    mov ecx, [ebp + 12]     ; Length
    mov bl,  [ebp + 16]     ; Key (XOR Key)

.encrypt_loop:
    cmp ecx, 0
    je .done
    
    mov al, [esi]
    xor al, bl              ; تشفير الحرف المباشر
    mov [esi], al
    
    inc esi
    dec ecx
    jmp .encrypt_loop

.done:
    pop ebx
    pop ecx
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret
