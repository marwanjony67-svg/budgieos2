; =====================================================================================
;  Project: BudgieOS PC Edition (Studio IDE & OS Creator Core)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode OS Module Creator & Compiler Environment
; =====================================================================================

[bits 32]

global render_studio_app
global init_os_creator_subsystem
global compile_kernel_module

VGA_TEXT_MEMORY equ 0xB8000
SCREEN_WIDTH    equ 80
SCREEN_HEIGHT   equ 25

section .data
    studio_title_txt  db " === BudgieOS Studio IDE (Operating System Creator) === ", 0
    linux_topbar_txt  db " Applications  Places  System  |  Budgie Kernel 6.x  |  Lola 🦜 ", 0
    terminal_prompt   db "marwan@budgieos-studio:~/kernel_build$ ", 0
    os_status_msg     db "[OS CREATOR] Kernel Module Builder Active. Ready to Compile.", 0
    studio_tools_txt  db " [F5] Compile Kernel  |  [F6] Test OS in QEMU  |  [GPLbudgieos] ", 0

section .text

; --- 1. تهيئة النظام الفرعي لبناء وتعديل نظام التشغيل ---
init_os_creator_subsystem:
    push ebp
    mov ebp, esp

    ; تجهيز بيئة تجميع واستدعاءات النواة
    nop

    mov esp, ebp
    pop ebp
    ret

; --- 2. دالة محاكاة تجميع وحدات النواة (Kernel Module Compiler) ---
compile_kernel_module:
    push ebp
    mov ebp, esp
    
    ; معالجة وتجميع ملفات NASM المباشرة
    mov eax, 1                      ; إرجاع 1 (تم التجميع بنجاح)

    mov esp, ebp
    pop ebp
    ret

; --- 3. رسم واجهة سطح المكتب المتكاملة الشبيهة بـ GNU/Linux ---
render_linux_style_desktop:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم الشريط العلوي لنظام التشغيل (السطر 0)
    mov edi, VGA_TEXT_MEMORY
    mov esi, linux_topbar_txt
.draw_topbar:
    lodsb
    cmp al, 0
    je .draw_body
    mov [edi], al
    mov byte [edi + 1], 0x70          ; خلفية رمادية فاتحة
    add edi, 2
    jmp .draw_topbar

.draw_body:
    ; مسح منتصف الشاشة لخلفية سطح المكتب
    mov edi, VGA_TEXT_MEMORY + (1 * SCREEN_WIDTH) * 2
    mov ecx, (23 * SCREEN_WIDTH)
.clear_desktop:
    mov byte [edi], ' '
    mov byte [edi + 1], 0x17          ; خلفية داكنة كلاسيكية
    add edi, 2
    loop .clear_desktop

    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret

; --- 4. رسم تطبيق Studio المطور لتطوير أنظمة التشغيل ---
render_studio_app:
    push ebp
    mov ebp, esp
    push edi
    push esi

    ; رسم سطح المكتب الأساسي
    call render_linux_style_desktop

    ; رسم شريط عنوان Studio OS Creator (السطر 2)
    mov edi, VGA_TEXT_MEMORY + (2 * SCREEN_WIDTH + 6) * 2
    mov esi, studio_title_txt
.draw_studio_header:
    lodsb
    cmp al, 0
    je .draw_prompt
    mov [edi], al
    mov byte [edi + 1], 0x1F          ; خلفية أزرق داكن ونصف أبيض
    add edi, 2
    jmp .draw_studio_header

.draw_prompt:
    ; رسم محرر الأوامر البرمجية لبناء النواة (السطر 6)
    mov edi, VGA_TEXT_MEMORY + (6 * SCREEN_WIDTH + 4) * 2
    mov esi, terminal_prompt
.draw_prompt_loop:
    lodsb
    cmp al, 0
    je .draw_footer
    mov [edi], al
    mov byte [edi + 1], 0x0A          ; نص أخضر لتطوير النواة
    add edi, 2
    jmp .draw_prompt_loop

.draw_footer:
    ; رسم شريط أدوات التطوير السفلي (السطر 22)
    mov edi, VGA_TEXT_MEMORY + (22 * SCREEN_WIDTH + 5) * 2
    mov esi, studio_tools_txt
.draw_tools_loop:
    lodsb
    cmp al, 0
    je .done
    mov [edi], al
    mov byte [edi + 1], 0x3F          ; خلفية سماوية ونصف أبيض
    add edi, 2
    jmp .draw_tools_loop

.done:
    pop esi
    pop edi
    mov esp, ebp
    pop ebp
    ret
