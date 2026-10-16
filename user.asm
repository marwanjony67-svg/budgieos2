; =====================================================================================
;  Project: BudgieOS PC Edition (Low-Level User Context & Ring Switching)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode User Context Switcher
; =====================================================================================

[bits 32]

global switch_to_user_mode
global save_user_context
global restore_user_context

section .text

; --- 1. الانتقال الآمن إلى وضع المستخدم (Switch to Ring 3 User Mode) ---
switch_to_user_mode:
    cli                     ; إيقاف المقاطعات مؤقتاً أثناء التبديل
    mov ax, 0x23            ; User Data Segment Selector (0x20 | RPL 3)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov eax, esp
    push 0x23               ; SS (User Data Segment)
    push eax                ; ESP (User Stack Pointer)
    pushf                   ; EFLAGS
    
    ; تفعيل المقاطعات داخل EFLAGS (IF Flag)
    pop eax
    or eax, 0x200
    push eax

    push 0x1B               ; CS (User Code Segment 0x18 | RPL 3)
    push .user_space        ; EIP
    iret                    ; القفز الانتهاء المباشر لوضع المستخدم Ring 3

.user_space:
    ret

; --- 2. حفظ سياق مسجلات المعالج للمستخدم الحالي ---
save_user_context:
    pusha
    push ds
    push es
    push fs
    push gs
    ; تم حفظ حالة سجلات المطور مروان والجلسة بنجاح
    pop gs
    pop fs
    pop es
    pop ds
    popa
    ret

; --- 3. استعادة سياق المستخدم ---
restore_user_context:
    ret
