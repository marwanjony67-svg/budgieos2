; =====================================================================================
;  Project: BudgieOS PC Edition (Interactive Start Menu Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Direct VGA Window Renderer
; =====================================================================================

[bits 32]

global render_start_menu
global hide_start_menu

VGA_TEXT_MEMORY  equ 0xB8000
SCREEN_WIDTH     equ 80

; إحداثيات وأبعاد نافذة قائمة البداية
MENU_START_ROW   equ 12               ; السطر الأول للقائمة
MENU_HEIGHT      equ 12               ; ارتفاع القائمة (12 سطر)
MENU_WIDTH       equ 26               ; عرض القائمة (26 عمود)
MENU_START_COL   equ 0                ; تبدأ من أقصى اليسار فوق زر Start

section .data
    menu_title_txt  db " === BudgieOS Menu === ", 0
    menu_item1_txt  db " [1] Terminal / CLI      ", 0
    menu_item2_txt  db " [2] Gul GUI Explorer    ", 0
    menu_item3_txt  db " [3] Chrome Web Engine   ", 0
    menu_item4_txt  db " [4] Media & Games Engine", 0
    menu_item5_txt  db " [5] EATRAMSTOP Optimizer ", 0
    menu_item6_txt  db " [6] Security & Shield   ", 0
    menu_item7_txt  db " [7] System Shutdown     ", 0
    menu_footer_txt db " Supervisor: Lola 🦜     ", 0

section .text

; --- 1. رسم نافذة قائمة البداية عند الفتح ---
render_start_menu:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ecx
    push ebx
    push eax

    ; رسم خلفية النافذة والحدود (خلفية رمادية داكنة 0x70)
    mov ebx, MENU_START_ROW

.draw_rows_loop:
    cmp ebx, (MENU_START_ROW + MENU_HEIGHT)
    je .draw_content

    ; حساب عنوان الذاكرة لكل سطر من القائمة
    mov edi, VGA_TEXT_MEMORY
    mov eax, ebx
    imul eax, SCREEN_WIDTH
    add eax, MENU_START_COL
    shl eax, 1                        ; ضرب في 2 (الحرف + اللون)
    add edi, eax

    mov ecx, MENU_WIDTH
.draw_cols_loop:
    mov byte [edi], ' '
    mov byte [edi + 1], 0x70          ; خلفية رمادية فاتحة ونص أسود
    add edi, 2
    loop .draw_cols_loop

    inc ebx
    jmp .draw_rows_loop

.draw_content:
    ; رسم عنوان القائمة
    mov esi, menu_title_txt
    mov edx, MENU_START_ROW
    call print_menu_line_attr, 0x1F   ; أزرق داكن مع نص أبيض

    ; رسم الخيارات والأدوات
    mov esi, menu_item1_txt
    mov edx, MENU_START_ROW + 2
    call print_menu_line

    mov esi, menu_item2_txt
    mov edx, MENU_START_ROW + 3
    call print_menu_line

    mov esi, menu_item3_txt
    mov edx, MENU_START_ROW + 4
    call print_menu_line

    mov esi, menu_item4_txt
    mov edx, MENU_START_ROW + 5
    call print_menu_line

    mov esi, menu_item5_txt
    mov edx, MENU_START_ROW + 6
    call print_menu_line

    mov esi, menu_item6_txt
    mov edx, MENU_START_ROW + 7
    call print_menu_line

    mov esi, menu_item7_txt
    mov edx, MENU_START_ROW + 9
    call print_menu_line_attr, 0x4F   ; خلفية حمراء لإيقاف التشغيل

    ; رسم التوقيع الشرفي لـ Lola 🦜
    mov esi, menu_footer_txt
    mov edx, MENU_START_ROW + 11
    call print_menu_line_attr, 0x7E   ; نص أصفر مميز

    pop eax
    pop ebx
    pop ecx
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- دالة طباعة السطر داخل القائمة ---
print_menu_line:
    push 0x70                         ; اللون الافتراضي للقائمة
    call print_menu_line_attr
    ret

print_menu_line_attr:
    push ebp
    mov ebp, esp
    push edi
    push eax

    mov edi, VGA_TEXT_MEMORY
    mov eax, edx                      ; edx يحتوي على رقم السطر
    imul eax, SCREEN_WIDTH
    add eax, MENU_START_COL
    shl eax, 1
    add edi, eax

.loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov ah, [ebp + 8]                 ; جلب خاصية اللون من الـ Stack
    mov [edi + 1], ah
    add edi, 2
    jmp .loop

.done:
    pop eax
    pop edi
    mov esp, ebp
    pop ebp
    ret 4

; --- 2. إخفاء قائمة البداية وإعادة الشاشة لحالتها ---
hide_start_menu:
    ; يمكن استدعاء دالة إعادة رسم خلفية الشاشة الأصلية هنا
    ret
