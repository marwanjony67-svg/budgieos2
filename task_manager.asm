; =====================================================================================
;  Project: BudgieOS PC Edition (Task Manager & Process Scheduler)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Active Process Viewer & Task Controller
; =====================================================================================

[bits 32]

global render_task_manager_app
global init_task_scheduler

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80

section .data
    tm_title_txt    db " === BudgieOS Task Manager / Idarat Al-Maham === ", 0
    tm_header_txt   db " PID   Process Name            Status      Memory      Priority ", 0
    tm_p1_txt       db " 001   kernel_core.bin         RUNNING     256 KB      CRITICAL ", 0
    tm_p2_txt       db " 002   lola_security_shield    ACTIVE      128 KB      HIGH     ", 0
    tm_p3_txt       db " 003   clean_memory_alloc      IDLE        64 KB       NORMAL   ", 0
    tm_p4_txt       db " 004   budgie_studio_ide       ACTIVE      512 KB      NORMAL   ", 0
    tm_p5_txt       db " 005   system_clipboard        IDLE        32 KB       LOW      ", 0
    tm_footer_txt   db " [F9] Kill Task  |  [F5] Refresh List  |  [ESC] Close ", 0

section .text

; --- 1. تهيئة جدول وجدولة المهام ---
init_task_scheduler:
    push ebp
    mov ebp, esp

    ; تهيئة مصفوفة العمليات بالنواة
    nop

    mov esp, ebp
    pop ebp
    ret

; --- 2. رسم واجهة تطبيق "إدارة المهام" ---
render_task_manager_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم شريط العنوان الرئيسي (السطر 2)
    mov edi, VGA_TEXT_MEMORY + (2 * SCREEN_WIDTH + 14) * 2
    mov esi, tm_title_txt
    call draw_tm_header_line

    ; رسم شريط ترويسة الجدول (السطر 5)
    mov edi, VGA_TEXT_MEMORY + (5 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_header_txt
    call draw_tm_table_header

    ; رسم قائمة العمليات النشطة (الأسطر 7 إلى 15)
    mov edi, VGA_TEXT_MEMORY + (7 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_p1_txt
    call draw_tm_row

    mov edi, VGA_TEXT_MEMORY + (9 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_p2_txt
    call draw_tm_row

    mov edi, VGA_TEXT_MEMORY + (11 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_p3_txt
    call draw_tm_row

    mov edi, VGA_TEXT_MEMORY + (13 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_p4_txt
    call draw_tm_row

    mov edi, VGA_TEXT_MEMORY + (15 * SCREEN_WIDTH + 5) * 2
    mov esi, tm_p5_txt
    call draw_tm_row

    ; رسم الشريط السفلي للتحكم (السطر 21)
    mov edi, VGA_TEXT_MEMORY + (21 * SCREEN_WIDTH + 10) * 2
    mov esi, tm_footer_txt
    call draw_tm_footer

    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- دوال مساعدة للتنسيق والرسم ---
draw_tm_header_line:
.h_loop:
    lodsb
    cmp al, 0
    je .h
