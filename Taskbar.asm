; =====================================================================================
;  Project: BudgieOS PC Edition (Desktop Taskbar & Window Manager Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Direct VGA Taskbar Controller
; =====================================================================================

[bits 32]

global init_desktop_taskbar
global update_taskbar_status

VGA_TEXT_MEMORY  equ 0xB8000
TASKBAR_ROW      equ 24               ; السطر رقم 25 (0-indexed) في شاشة VGA
SCREEN_WIDTH     equ 80

section .data
    start_button_txt db " [Start] ", 0
    mascot_badge_txt db " Lola 🦜 ", 0
    sys_status_txt   db "BudgieOS v0.2", 0
    clock_time_txt   db "12:00 PM", 0

section .text

; --- 1. تهيئة ورسم شريط المهام كاملاً ---
init_desktop_taskbar:
    push ebp
    mov ebp, esp
    push edi
    push esi
    push ecx
    push eax

    ; حساب عنوان الذاكرة للسطر الأخير (24 * 80 * 2)
    mov edi, VGA_TEXT_MEMORY
    mov eax, TASKBAR_ROW * SCREEN_WIDTH * 2
    add edi, eax

    ; تنظيف شريط المهام باللون الأزرق الداكن الداعم للتطبيقات (Attr: 0x17)
    mov ecx, SCREEN_WIDTH
.fill_background:
    mov byte [edi], ' '
    mov byte [edi + 1], 0x17          ; خلفية أزرق داكن ونصف أبيض
    add edi, 2
    loop .fill_background

    ; إعادة ضبط مؤشر الذاكرة لعنوان شريط المهام
    mov edi, VGA_TEXT_MEMORY
    add edi, TASKBAR_ROW * SCREEN_WIDTH * 2

    ; رسم زر البداية [Start]
    mov esi, start_button_txt
.draw_start:
    lodsb
    cmp al, 0
    je .draw_mascot
    mov [edi], al
    mov byte [edi + 1], 0x3F          ; خلفية سماوية ونص أبيض ساطع
    add edi, 2
    jmp .draw_start

.draw_mascot:
    ; رسم شارة لولا في منتصف الشريط (العمود 34)
    mov edi, VGA_TEXT_MEMORY
    add edi, (TASKBAR_ROW * SCREEN_WIDTH + 34) * 2
    mov esi, mascot_badge_txt
.draw_mascot_loop:
    lodsb
    cmp al, 0
    je .draw_clock
    mov [edi], al
    mov byte [edi + 1], 0x1E          ; خلفية أزرق داكن ونص أصفر
    add edi, 2
    jmp .draw_mascot_loop

.draw_clock:
    ; رسم الساعة في أقصى اليمين (العمود 70)
    mov edi, VGA_TEXT_MEMORY
    add edi, (TASKBAR_ROW * SCREEN_WIDTH + 70) * 2
    mov esi, clock_time_txt
.draw_clock_loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; نص أبيض ساطع
