; =====================================================================================
;  Project: BudgieOS PC Edition (Image & Media Gallery App Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Media & Gallery Viewer
; =====================================================================================

[bits 32]

global render_gallery_app
global gallery_next_image

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80

section .data
    gallery_title   db " === BudgieOS Gallery / Photo Viewer === ", 0
    img_info_1      db " Image 1: Lola_Mascot.bmp (320x240 - 24bit) ", 0
    img_info_2      db " Image 2: BudgieOS_Wallpaper.bmp (640x480) ", 0
    controls_txt    db " [<-] Prev  |  [->] Next  |  [ESC] Exit ", 0
    mascot_tag      db " Supervisor: Lola 🦜 ", 0

section .text

; --- 1. رسم واجهة معرض الصور ---
render_gallery_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم العنوان في السطر 4
    mov edi, VGA_TEXT_MEMORY + (4 * SCREEN_WIDTH + 18) * 2
    mov esi, gallery_title
.draw_title:
    lodsb
    cmp al, 0
    je .draw_content
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; خلفية أزرق داكن ونصف أبيض ساطع
    add edi, 2
    jmp .draw_title

.draw_content:
    ; رسم معلومات الصورة الحالية (السطر 8)
    mov edi, VGA_TEXT_MEMORY + (8 * SCREEN_WIDTH + 16) * 2
    mov esi, img_info_1
    call print_gallery_text

    ; رسم أدوات التحكم (السطر 18)
    mov edi, VGA_TEXT_MEMORY + (18 * SCREEN_WIDTH + 18) * 2
    mov esi, controls_txt
    call print_gallery_text

    ; رسم توقيع Lola (السطر 20)
    mov edi, VGA_TEXT_MEMORY + (20 * SCREEN_WIDTH + 26) * 2
    mov esi, mascot_tag
.draw_mascot:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov byte [edi + 1], 0x1E          ; خلفية أزرق داكن ونص أصفر
    add edi, 2
    jmp .draw_mascot

.done:
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- دالة طباعة النصوص داخل تطبيق المعرض ---
print_gallery_text:
.loop:
    lodsb
    cmp al, 0
    je .done_print
    mov [edi], al
    mov byte [edi + 1], 0x07          ; لون نص رمادي قياسي
    add edi, 2
    jmp .loop
.done_print:
    ret

; --- 2. التنقل للصورة التالية ---
gallery_next_image:
    ret
