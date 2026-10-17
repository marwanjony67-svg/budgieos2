; =====================================================================================
;  Project: BudgieOS PC Edition (VGA Mode 13h Desktop Wallpaper Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Direct Video Framebuffer (0xA0000)
; =====================================================================================

[bits 32]

global draw_budgie_wallpaper

VGA_GRAPHICS_RAM equ 0xA0000
SCREEN_WIDTH     equ 320
SCREEN_HEIGHT    equ 200

section .text

; --- دالة رسم خلفية سطح المكتب المباشرة ---
draw_budgie_wallpaper:
    push ebp
    mov ebp, esp
    push edi
    push ecx
    push eax

    mov edi, VGA_GRAPHICS_RAM   ; العنوان المباشر لذاكرة الرسم VGA Mode 13h
    mov ecx, SCREEN_WIDTH * SCREEN_HEIGHT

.fill_background:
    ; رسم خلفية متدرجة أنيقة تعبر عن ألوان BudgieOS
    mov eax, ecx
    shr eax, 8                  ; تدرج ألوان أزرق وسماوي
    add eax, 11                 ; لون سماوي متناسق مع شعار Lola
    
    mov [edi], al               ; كتابة اللون مباشرة في ذاكرة العرض
    inc edi
    loop .fill_background

    pop eax
    pop ecx
    pop edi
    mov esp, ebp
    pop ebp
    ret
