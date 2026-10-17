; =====================================================================================
;  Project: BudgieOS PC Edition (BIOS Interrupts & Hardware Services Module)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 16-bit / 32-bit Real & Protected Mode BIOS Bridge
; =====================================================================================

[bits 16]

global bios_print_string
global bios_read_keystroke
global bios_get_memory_map

section .data
    bios_init_msg db "[BIOS] BudgieOS Low-Level BIOS Bridge Initialized (Lola Shield Active 🦜)", 0x0D, 0x0A, 0

section .text

; --- 1. طباعة سلسلة نصية عبر مقاطعة BIOS INT 0x10 ---
; Arguments: SI = Pointer to Null-Terminated String
bios_print_string:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E                     ; BIOS Teletype Function
    mov bh, 0x00                     ; Page Number
    mov bl, 0x07                     ; Light Gray Text
    int 0x10
    jmp .loop
.done:
    popa
    ret

; --- 2. قراءة ضغطة مفتاح مباشرة من لوحة المفاتيح عبر INT 0x16 ---
; Returns: AL = ASCII Code, AH = Scan Code
bios_read_keystroke:
    mov ah, 0x00                     ; Read Key Interrupt Function
    int 0x16
    ret

; --- 3. قراءة حجم الذاكرة العشوائية RAM عبر BIOS INT 0x12 ---
; Returns: AX = Memory Size in KB
bios_get_memory_size:
    int 0x12
    ret
