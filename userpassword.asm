; =====================================================================================
;  Project: BudgieOS PC Edition (Integrated User Session & Password Shield)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode User Security & Context Switcher
; =====================================================================================

[bits 32]

global init_user_password_shield
global asm_verify_user_password
global asm_switch_to_ring3

extern terminal_writestring

SALT_KEY equ 0x5A                      ; مفتاح التشفير الخاص بـ BudgieOS

section .data
    sec_init_msg    db 0x0A, "[SECURITY] Initializing User & Password Auth Engine...", 0x0A, 0
    sec_auth_ok_msg db "[SECURITY] Authentication Successful! Entering User Session.", 0x0A, 0
    sec_auth_err_msg db "[SECURITY] Access Denied! Invalid Password.", 0x0A, 0

section .bss
    temp_pass_buf   resb 64             ; ذاكرة مؤقتة لمعالجة كلمة المرور

section .text

; --- 1. تهيئة درع حماية الحسابات وكلمات المرور ---
init_user_password_shield:
    push ebp
    mov ebp, esp

    push sec_init_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. التحقق من كلمة المرور المشفّرة في الذاكرة (Fast XOR Verification) ---
; Arguments: [esp+4] = Input Buffer, [esp+8] = Stored Hash Buffer, [esp+12] = Length
asm_verify_user_password:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx
    push ebx

    mov esi, [ebp + 8]               ; Input Buffer Pointer
    mov edi, [ebp + 12]              ; Stored Hash Pointer
    mov ecx, [ebp + 16]              ; Length

.verify_loop:
    cmp ecx, 0
    je .match_success

    mov al, [esi]
    xor al, SALT_KEY                 ; التشفير المباشر في المسجل
    mov bl, [edi]

    cmp al, bl
    jne .match_failed

    inc esi
    inc edi
    dec ecx
    jmp .verify_loop

.match_success:
    push sec_auth_ok_msg
    call terminal_writestring
    add esp, 4
    mov eax, 1                       ; إرجاع 1 (مطابقة صحيحة)
    jmp .done

.match_failed:
    push sec_auth_err_msg
    call terminal_writestring
    add esp, 4
    mov eax, 0                       ; إرجاع 0 (خطأ)

.done:
    pop ebx
    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

; --- 3. الانتقال الآمن إلى وضع المستخدِم (Switch to Ring 3 User Mode) ---
asm_switch_to_ring3:
    cli                              ; إيقاف المقاطعات مؤقتاً أثناء التبديل
    mov ax, 0x23                     ; User Data Segment Selector (0x20 | RPL 3)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov eax, esp
    push 0x23                        ; SS (User Data Segment)
    push eax                         ; ESP (User Stack Pointer)
    pushf                            ; EFLAGS

    ; تفعيل المقاطعات داخل EFLAGS (IF Flag)
    pop eax
    or eax, 0x200
    push eax

    push 0x1B                        ; CS (User Code Segment 0x18 | RPL 3)
    push .user_space                 ; EIP
    iret                             ; القفز الانتهاء المباشر لوضع المستخدم Ring 3

.user_space:
    ret
