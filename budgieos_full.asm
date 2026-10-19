; =====================================================================================
;  Project: BudgieOS PC Edition (Unified Full Assembly Core)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos (Open System Architecture)
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Bare-Metal Protected Mode System
; =====================================================================================

[bits 32]

global _start
global kernel_main_entry

; VGA Memory & System Constants
VGA_TEXT_MEMORY  equ 0xB8000
SCREEN_WIDTH     equ 80
SCREEN_HEIGHT    equ 25
SALT_KEY         equ 0x5A
CLIPBOARD_SIZE   equ 1024
HEAP_START_ADDR  equ 0x00200000

section .data
    ; --- Banners & UI Text ---
    budgie_banner   db " === BudgieOS PC Edition (Bare-Metal Open System) === ", 0
    mascot_tag      db " Mascot & Security Supervisor: Lola 🦜 ", 0
    linux_topbar    db " Applications  Places  System  |  Budgie Kernel Open API  |  Lola 🦜 ", 0
    terminal_prompt db "marwan@budgieos-pc:~$ ", 0
    
    ; --- Apps & System Titles ---
    paint_title     db " === BudgieOS Paint / Al-Rassam === ", 0
    studio_title    db " === BudgieOS Studio IDE - Open OS Creator === ", 0
    taskbar_txt     db " [Start] | [1] Terminal  [2] Studio  [3] Paint  [4] Gallery ", 0

    ; --- Logs & Status Messages ---
    mem_clean_msg   db "[MEM] Clean Memory Allocator Active (Zero-Fill Safe)", 0
    sec_active_msg  db "[SEC] Anti-Keylogger & Encryption Shield Active 🦜", 0
    cb_active_msg   db "[CLIPBOARD] System Copy/Paste Buffer Ready", 0

section .bss
    heap_ptr          resd 1
    clipboard_buf     resb CLIPBOARD_SIZE
    clipboard_len     resd 1
    current_pen_color resb 1

section .text

; =====================================================================================
; 1. KERNEL ENTRY & INITIALIZATION
; =====================================================================================
_start:
kernel_main_entry:
    cli                             ; إيقاف المقاطعات مؤقتاً
    mov ax, 0x10                    ; Kernel Data Segment Selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000                ; ضبط مؤشر الختم (Stack Pointer)

    ; تهيئة النظام ومحركاته
    call init_clean_memory_engine
    call init_security_shield
    call init_clipboard_manager

    ; رسم سطح المكتب بأسلوب Linux المفتوح
    call render_linux_desktop
    call render_taskbar

    sti                             ; إعادة تفعيل المقاطعات
.kernel_loop:
    hlt                             ; وضع انتظار المعالج الآمن
    jmp .kernel_loop

; =====================================================================================
; 2. CLEAN MEMORY ALLOCATOR ENGINE (Zero-Fill / Linux-Style)
; =====================================================================================
init_clean_memory_engine:
    mov dword [heap_ptr], HEAP_START_ADDR
    ret

; حجز وتنظيف الذاكرة المباشر (Clean Memory Allocation)
alloc_clean_memory:
    push ebp
    mov ebp, esp
    push ecx
    push edi

    mov ecx, [ebp + 8]              ; Size in bytes
    mov eax, [heap_ptr]
    add dword [heap_ptr], ecx

    ; تصفير المساحة فوراً لتجنب تسريب البيانات (Zero-out memory)
    mov edi, eax
    push eax
    xor al, al
    rep stosb
    pop eax

    pop edi
    pop ecx
    mov esp, ebp
    pop ebp
    ret

; =====================================================================================
; 3. CLIPBOARD ENGINE (Copy & Paste Buffer)
; =====================================================================================
init_clipboard_manager:
    mov ecx, CLIPBOARD_SIZE
    mov edi, clipboard_buf
    xor al, al
    rep stosb
    mov dword [clipboard_len], 0
    ret

clipboard_copy:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx

    mov esi, [ebp + 8]              ; Source
    mov ecx, [ebp + 12]             ; Length
    mov [clipboard_len], ecx
    mov edi, clipboard_buf
    rep movsb                       ; نسخ النص إلى الحافظة

    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

clipboard_paste:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx

    mov edi, [ebp + 8]              ; Destination
    mov esi, clipboard_buf
    mov ecx, [clipboard_len]
    mov eax, ecx
    rep movsb                       ; لصق النص من الحافظة

    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret

; =====================================================================================
; 4. SECURITY & INTEGRITY GUARD (Lola Shield 🦜)
; =====================================================================================
init_security_shield:
    ret

security_encrypt_xor:
    push ebp
    mov ebp, esp
    push esi
    push ecx

    mov esi, [ebp + 8]              ; Buffer Pointer
    mov ecx, [ebp + 12]             ; Length
.enc_loop:
    cmp ecx, 0
    je .enc_done
    mov al, [esi]
    xor al, SALT_KEY                ; التشفير بمفتاح SALT
    mov [esi], al
    inc esi
    dec ecx
    jmp .enc_loop
.enc_done:
    pop ecx
    pop esi
    mov esp, ebp
    pop ebp
    ret

; =====================================================================================
; 5. UI & LINUX-STYLE DESKTOP RENDERER
; =====================================================================================
render_linux_desktop:
    push edi
    push esi

    ; 1. رسم الشريط العلوي Top Bar (رمادي)
    mov edi, VGA_TEXT_MEMORY
    mov esi, linux_topbar_txt
.draw_topbar:
    lodsb
    cmp al, 0
    je .draw_background
    mov [edi], al
    mov byte [edi + 1], 0x70        ; خلفية رمادية
    add edi, 2
    jmp .draw_topbar

.draw_background:
    ; 2. مسح خلفية سطح المكتب (أزرق داكن)
    mov edi, VGA_TEXT_MEMORY + (1 * SCREEN_WIDTH) * 2
    mov ecx, (23 * SCREEN_WIDTH)
.bg_loop:
    mov byte [edi], ' '
    mov byte [edi + 1], 0x17
    add edi, 2
    loop .bg_loop

    ; 3. رسم موجه الأوامر Terminal Prompt (أخضر)
    mov edi, VGA_TEXT_MEMORY + (4 * SCREEN_WIDTH + 4) * 2
    mov esi, terminal_prompt
.draw_prompt:
    lodsb
    cmp al, 0
    je .done_ui
    mov [edi], al
    mov byte [edi + 1], 0x0A        ; نص أخضر
    add edi, 2
    jmp .draw_prompt

.done_ui:
    pop esi
    pop edi
    ret

render_taskbar:
    mov edi, VGA_TEXT_MEMORY + (24 * SCREEN_WIDTH) * 2
    mov esi, taskbar_txt
.draw_tb:
    lodsb
    cmp al, 0
    je .tb_done
    mov [edi], al
    mov byte [edi + 1], 0x3F        ; خلفية سماوية
    add edi, 2
    jmp .draw_tb
.tb_done:
    ret
