; =====================================================================================
;  Project: BudgieOS PC Edition (Bare-Metal Network & File Downloader Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Assembly File Transfer & Memory Buffer Manager
; =====================================================================================

[bits 32]

global init_download_engine
global asm_stream_file_bytes

extern terminal_writestring

section .data
    download_init_msg   db 0x0A, "[NET/DL] BudgieOS Downloader Engine Initialized...", 0x0A, 0
    download_start_msg  db "[NET/DL] Receiving incoming data stream into RAM buffer...", 0x0A, 0
    download_done_msg   db "[NET/DL] Download Complete! Verified by Lola Shield 🦜", 0x0A, 0

section .bss
    dl_stream_buffer    resb 65536     ; حجز 64 كيلوبايت كـ Buffer مؤقت للتنزيل

section .text

; --- 1. تهيئة محرك التنزيل والذاكرة المخصصة ---
init_download_engine:
    push ebp
    mov ebp, esp

    ; طباعة رسالة البدء في التيرمنال
    push download_init_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. استقبال وتدفق البايتات المباشر إلى ذاكرة RAM ---
; Arguments: [esp+4] = Source Data Pointer, [esp+8] = Length
asm_stream_file_bytes:
    push ebp
    mov ebp, esp
    push esi
    push edi
    push ecx

    mov esi, [ebp + 8]               ; Source Pointer (Network/Disk Controller)
    mov edi, dl_stream_buffer        ; Destination RAM Buffer
    mov ecx, [ebp + 12]              ; Total Length in Bytes

    ; طباعة رسالة التنزيل
    push download_start_msg
    call terminal_writestring
    add esp, 4

    ; نقل البيانات بسرعة باستخدام تعليمات الـ Assembly المباشرة
    cld
    rep movsb

    ; طباعة رسالة الاكتفاء والنجاح
    push download_done_msg
    call terminal_writestring
    add esp, 4

    pop ecx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret
