; =====================================================================================
;  Project: BudgieOS PC Edition (Open Source Subsystem & Syscall Registry)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos (Open System Standard)
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Assembly Open System API & Kernel Call Dispatcher
; =====================================================================================

[bits 32]

global init_open_source_subsystem
global syscall_dispatcher
global register_open_syscall

extern terminal_writestring

MAX_SYSCALLS equ 64

section .data
    os_init_msg     db 0x0A, "[OPEN-SOURCE] Initializing GPLbudgieos System Call Engine...", 0x0A, 0
    os_license_msg  db "[OPEN-SOURCE] BudgieOS Core Licensed under GPLbudgieos Standard 🦜", 0x0A, 0
    os_ready_msg    db "[OPEN-SOURCE] Modular API & Open Developer Extensions Active.", 0x0A, 0

section .bss
    syscall_table   resd MAX_SYSCALLS     ; جدول حفظ عناوين استدعاءات النظام المفتوحة

section .text

; --- 1. تهيئة النظام الفرعي للمصدر المفتوح ---
init_open_source_subsystem:
    push ebp
    mov ebp, esp

    ; تصفير جدول الاستدعاءات
    mov ecx, MAX_SYSCALLS
    mov edi, syscall_table
    xor eax, eax
    rep stosd

    ; طباعة معلومات الترخيص والنظام المفتوح
    push os_init_msg
    call terminal_writestring
    add esp, 4

    push os_license_msg
    call terminal_writestring
    add esp, 4

    push os_ready_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. تسجيل دالة استدعاء مفتوحة جديدة (Register Open Syscall) ---
; Arguments: [esp+4] = Syscall ID, [esp+8] = Function Pointer
register_open_syscall:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]                   ; ID رقم الاستدعاء
    cmp eax, MAX_SYSCALLS
    jge .invalid_id

    mov edx, [ebp + 12]                  ; عنوان الدالة
    mov [syscall_table + eax * 4], edx

.invalid_id:
    mov esp, ebp
    pop ebp
    ret

; --- 3. موزع استدعاءات النظام (Syscall Dispatcher Engine) ---
; Arguments: EAX = Syscall Number
syscall_dispatcher:
    cmp eax, MAX_SYSCALLS
    jge .bad_syscall

    mov edx, [syscall_table + eax * 4]
    cmp edx, 0
    je .bad_syscall

    call edx                             ; تنفيذ دالة النظام المفتوحة المطلوبة
    ret

.bad_syscall:
    mov eax, -1                          ; إرجاع خطأ في حال عدم وجود الاستدعاء
    ret
