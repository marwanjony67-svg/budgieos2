; =====================================================================================
;  Project: BudgieOS PC Edition (This PC / System Properties Application)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode System Properties & Storage Viewer
; =====================================================================================

[bits 32]

global render_this_pc_app

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80

section .data
    pc_title_txt    db " === This PC / Al-Kombuyutar Al-Shakhsi === ", 0
    pc_os_info_txt   db " Operating System : BudgieOS PC (32-bit Open System Kernel) ", 0
    pc_mascot_txt   db " System Guardian  : Lola (لولا) 🦜 ", 0
    pc_cpu_info_txt  db " Processor (CPU)  : x86 Compatible Architecture (Protected Mode) ", 0
    pc_ram_info_txt  db " Memory (RAM)     : Clean Zero-Fill Memory Engine Active ", 0
    pc_drive_c_txt   db " Drive (C:)       : Budgie System Partition [GPLbudgieos] ", 0
    pc_footer_txt    db " Press [ESC] to Close Window ", 0

section .text

; --- 1. رسم نافذة تطبيق "هذا الكمبيوتر الشخصي" ---
render_this_pc_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم شريط عنوان النافذة (السطر 3)
    mov edi, VGA_TEXT_MEMORY + (3 * SCREEN_WIDTH + 15) * 2
    mov esi, pc_title_txt
.draw_title:
    lodsb
    cmp al, 0
    je .draw_body
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; خلفية أزرق داكن ونص أبيض ساطع
    add edi, 2
    jmp .draw_title

.draw_body:
    ; رسم تفاصيل النظام والقرص (الأسطر من 6 إلى 14)
    mov edi, VGA_TEXT_MEMORY + (6 * SCREEN_WIDTH + 8) * 2
    mov esi, pc_os_info_txt
    call print_info_line

    mov edi, VGA_TEXT_MEMORY + (8 * SCREEN_WIDTH + 8) * 2
    mov esi, pc_mascot_txt
    call print_info_line

    mov edi, VGA_TEXT_MEMORY + (10 * SCREEN_WIDTH + 8) * 2
    mov esi, pc_cpu_info_txt
    call print_info_line

    mov edi, VGA_TEXT_MEMORY + (12 * SCREEN_WIDTH + 8) * 2
    mov esi, pc_ram_info_txt
    call print_info_line

    mov edi, VGA_TEXT_MEMORY + (14 * SCREEN_WIDTH + 8) * 2
    mov esi, pc_drive_c_txt
    call print_info_line

    ; رسم الشريط السفلي (السطر 20)
    mov edi, VGA_TEXT_MEMORY + (20 * SCREEN_WIDTH + 24) * 2
    mov esi, pc_footer_txt
    call print_info_line

    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- دالة مساعدة لطباعة الأسطر بداخل النافذة ---
print_info_line:
.line_loop:
    lodsb
    cmp al, 0
    je .line_done
    mov [edi], al
    mov byte [edi + 1], 0x70          ; خلفية رمادية ونص أسود (Windows / Linux Dialog Style)
    add edi, 2
    jmp .line_loop
.line_done:
    ret
