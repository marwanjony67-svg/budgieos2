; =====================================================================================
;  Project: BudgieOS Kernel Entry & App Linker
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos | Mascot: Lola 🦜
; =====================================================================================

[bits 32]
[extern kernel_main]    ; استدعاء الدالة الرئيسية المكتوبة بلغة C

global _start
_start:
    call kernel_main    ; القفز لتشغيل كود C
    jmp $               ; حلقة أمان للنظام
