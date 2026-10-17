; =====================================================================================
;  Project: BudgieOS PC Edition (System Settings UI Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Settings Interface
; =====================================================================================

[bits 32]

global render_settings_app

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80

section .data
    settings_title db " === BudgieOS Settings / Settings Panel === ", 0
    option_1       db " [1] Display Resolution & Colors ", 0
    option_2       db " [2] Security & Password Settings ", 0
    option_3       db " [3] RAM & Performance Optimizer ", 0
    option_4       db " [4] System Information & Mascot (Lola 🦜) ", 0
    option_5       db " [0] Exit Settings ", 0

section .text

; --- دالة رسم واجهة الإعدادات ---
render_settings_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم عنوان الإعدادات في منتصف الشاشة (السطر 5)
    mov edi, VGA_TEXT_MEMORY + (5 * SCREEN_WIDTH + 18) * 2
    mov esi, settings_title
.draw_title:
    lodsb
    cmp al, 0
    je .draw_options
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; خلفية أزرق داكن ونصف أبيض ساطع
    add edi, 2
    jmp .draw_title

.draw_options:
    ; رسم خيار 1
    mov edi, VGA_TEXT_MEMORY + (8 * SCREEN_WIDTH + 20) * 2
    mov esi, option_1
    call draw_menu_item

    ; رسم خيار 2
    mov edi, VGA_TEXT_MEMORY + (10 * SCREEN_WIDTH + 20) * 2
    mov esi, option_2
    call draw_menu_item

    ; رسم خيار 3
    mov edi, VGA_TEXT_MEMORY + (12 * SCREEN_WIDTH + 20) * 2
    mov esi, option_3
    call draw_menu_item

    ; رسم خيار 4
    mov edi, VGA_TEXT_MEMORY + (14 * SCREEN_WIDTH + 20) * 2
    mov esi, option_4
    call draw_menu_item

    ; رسم خيار الخروج 0
    mov edi, VGA_TEXT_MEMORY + (16 * SCREEN_WIDTH + 20) * 2
    mov esi, option_5
    call draw_menu_item

    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

draw_menu_item:
.loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov byte [edi + 1], 0x07          ; لون رمادي لقياسي
    add edi, 2
    jmp .loop
.done:
    ret
