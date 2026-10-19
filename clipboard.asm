; =====================================================================================
;  Project: BudgieOS PC Edition (System Clipboard & Copy/Paste Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Clipboard Buffer & Buffer Transfer
; =====================================================================================

[bits 32]

global init_system_clipboard
global clipboard_copy_text
global clipboard_paste_text

CLIPBOARD_BUFFER_SIZE equ 1024         ; حجم الحافظة (1 كيلوبايت للنصوص)

section .data
    cb_init_msg     db 0x0A, "[CLIPBOARD] Initializing System Copy/Paste Engine...", 0x0A, 0
    cb_ready_msg    db "[CLIPBOARD] Clipboard Manager Active (Lola Shield 🦜)", 0x0A, 0

section .bss
    clipboard_storage resb CLIPBOARD_BUFFER_SIZE  ; الذاكرة المؤقتة للنسخ واللصق (Clipboard Buffer)
    clipboard_length  resd 1                      ; طول النص المنسخ حالياً

section .text

; --- 1. تهيئة مدير الحافظة (Clipboard Manager) ---
init_system_clipboard:
    push ebp
    mov ebp, esp

    ; تصفير الذاكرة المؤقتة للحافظة عند البداية
    mov ecx, CLIPBOARD_BUFFER_SIZE
    mov edi, clipboard_storage
    xor al, al
    rep stosb
    mov dword [clipboard_length], 0

    push cb_init_msg
    call terminal_writestring
    add esp, 4

    push cb_ready_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. عملية النسخ (Copy Text to System Clipboard) ---
; Arguments: [esp+4] = Source Text Pointer, [esp+8] = Length
clipboard_copy_text:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx

    mov esi, [ebp + 8]             ; مصدر النص المراد نسخه
    mov ecx, [ebp + 12]            ; طول النص

    cmp ecx, CLIPBOARD_BUFFER_SIZE
    jge .limit_exceeded            ; التأكد من عدم تجاوز حجم الحافظة

    mov edi, clipboard_storage
    mov [clipboard_length], ecx    ; حفظ طول النص الجديد

.copy_loop:
    cmp ecx, 0
    je .done
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp .copy_loop

.limit_exceeded:
    ; في حال تجاوز الحجم المسموح
    nop

.done:
    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

; --- 3. عملية اللصق (Paste Text from System Clipboard) ---
; Arguments: [esp+4] = Destination Buffer Pointer
; Returns: EAX = Length of pasted text
clipboard_paste_text:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx

    mov edi, [ebp + 8]             ; الوجهة المراد لصق النص فيها
    mov esi, clipboard_storage     ; الحافظة المركزية
    mov ecx, [clipboard_length]    ; طول النص المنسخ

    mov eax, ecx                   ; إرجاع الطول كنتيجة

.paste_loop:
    cmp ecx, 0
    je .done_paste
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    jmp .paste_loop

.done_paste:
    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
