; =====================================================================================
;  Project: BudgieOS PC Edition (Paint & Canvas Application Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Interactive Paint Engine
; =====================================================================================

[bits 32]

global render_paint_app
global paint_draw_pixel
global paint_clear_canvas

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80

section .data
    paint_title_txt  db " === BudgieOS Paint / application Al-Rassam === ", 0
    paint_tools_txt  db " Tools: [P] Pen  |  [C] Clear  |  [1-4] Colors  |  [ESC] Exit ", 0
    mascot_tag_txt   db " Supervisor: Lola 🦜 ", 0

section .bss
    current_color    resb 1            ; لون الفرشاة الحالي

section .text

; --- 1. رسم واجهة تطبيق الرسام ---
render_paint_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; ضبط اللون الافتراضي للفرشاة (أصفر 0x0E)
    mov byte [current_color], 0x0E

    ; رسم الشريط العلوي لعنوان الرسام (السطر 0)
    mov edi, VGA_TEXT_MEMORY
    mov esi, paint_title_txt
.draw_title:
    lodsb
    cmp al, 0
    je .draw_tools
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; خلفية أزرق داكن ونصف أبيض ساطع
    add edi, 2
    jmp .draw_title

.draw_tools:
    ; رسم شريط الأدوات بالأحمر الداكن (السطر 1)
    mov edi, VGA_TEXT_MEMORY + (1 * SCREEN_WIDTH) * 2
    mov esi, paint_tools_txt
.draw_tools_loop:
    lodsb
    cmp al, 0
    je .draw_footer
    mov [edi], al
    mov byte [edi + 1], 0x4F          ; خلفية حمراء ونصف أبيض
    add edi, 2
    jmp .draw_tools_loop

.draw_footer:
    ; رسم شارة Lola في السطر الأخير (السطر 23)
    mov edi, VGA_TEXT_MEMORY + (23 * SCREEN_WIDTH + 55) * 2
    mov esi, mascot_tag_txt
.draw_footer_loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov byte [edi + 1], 0x1E          ; خلفية أزرق داكن ونصف أصفر
    add edi, 2
    jmp .draw_footer_loop

.done:
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- 2. رسم بكسل/رمز في اللوحة عند إحداثيات (X, Y) ---
; Arguments: EAX = X (Column), EBX = Y (Row), CL = Character/Pixel
paint_draw_pixel:
    push ebp
    mov ebp, esp
    push edi
    push edx

    ; حساب العنوان: (Y * 80 + X) * 2
    mov edx, ebx
    imul edx, SCREEN_WIDTH
    add edx, eax
    shl edx, 1
    mov edi, VGA_TEXT_MEMORY
    add edi, edx

    ; رسم النقطة باللون الحالي
    mov [edi],
