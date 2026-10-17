; =====================================================================================
;  Project: BudgieOS PC Edition (Command Line Interface & Terminal Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Assembly Interactive CLI Prompt
; =====================================================================================

[bits 32]

global init_cmd_prompt
global process_cmd_input

extern terminal_writestring
extern system_halt

section .data
    prompt_str      db  0x0A, "BudgieOS> ", 0
    help_cmd_str    db  "help", 0
    clear_cmd_str   db  "clear", 0
    halt_cmd_str    db  "halt", 0
    
    msg_help        db  0x0A, "Available Commands: help, clear, halt, apps, status", 0x0A, 0
    msg_unknown     db  0x0A, "Unknown command! Type 'help' for available commands.", 0x0A, 0

section .bss
    cmd_buffer      resb 64

section .text

; --- 1. عرض موجه الأوامر الخاص بـ BudgieOS ---
init_cmd_prompt:
    push prompt_str
    call terminal_writestring
    add esp, 4
    ret

; --- 2. معالجة وتفسير الأوامر المدخلة ---
process_cmd_input:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp + 8]          ; Pointer to input command string

    ; فحص أمر المساعدة 'help'
    mov edi, help_cmd_str
    call strcmp_asm
    cmp eax, 0
    je .cmd_help

    ; فحص أمر الإيقاف 'halt'
    mov edi, halt_cmd_str
    call strcmp_asm
    cmp eax, 0
    je .cmd_halt

    ; أمر غير معروف
    push msg_unknown
    call terminal_writestring
    add esp, 4
    jmp .done

.cmd_help:
    push msg_help
    call terminal_writestring
    add esp, 4
    jmp .done

.cmd_halt:
    call system_halt

.done:
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

; --- دالة مقارنة النصوص بالأسمبلي ---
strcmp_asm:
.loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .not_equal
    cmp al, 0
    je .equal
    inc esi
    inc edi
    jmp .loop
.not_equal:
    mov eax, 1
    ret
.equal:
    xor eax, eax
    ret
