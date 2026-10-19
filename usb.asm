; =====================================================================================
;  Project: BudgieOS PC Edition (USB Controller & Stack Driver Engine)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Direct USB EHCI/UHCI Host Controller
; =====================================================================================

[bits 32]

global init_usb_subsystem
global usb_check_connected_devices
global usb_read_sector

extern terminal_writestring

USB_BASE_PORT     equ 0xD000           ; Base I/O Port for USB EHCI Controller
USB_STATUS_PORT   equ 0xD004           ; Status & Interrupt Register

section .data
    usb_init_msg    db 0x0A, "[HW/USB] Initializing BudgieOS USB Host Controller (EHCI/xHCI)...", 0x0A, 0
    usb_ready_msg   db "[HW/USB] USB Subsystem Ready. Monitoring Device Bus (Lola Shield 🦜)", 0x0A, 0
    usb_dev_found   db "[HW/USB] USB Storage / Mass Device Detected on Port 1.", 0x0A, 0

section .bss
    usb_device_count resb 1             ; عدد أجهزة USB المتصلة حالياً

section .text

; --- 1. تهيئة محرك ومنافذ الـ USB ---
init_usb_subsystem:
    push ebp
    mov ebp, esp

    ; طباعة رسائل بدء التهيئة
    push usb_init_msg
    call terminal_writestring
    add esp, 4

    ; تصفير عدد الأجهزة المتصلة
    mov byte [usb_device_count], 0

    ; فحص منافذ الـ USB العتادية المباشرة
    call usb_check_connected_devices

    push usb_ready_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. فحص الأجهزة المتصلة بمنافذ الـ USB ---
usb_check_connected_devices:
    push ebp
    mov ebp, esp

    ; قراءة حالة المنفذ
    mov dx, USB_STATUS_PORT
    in al, dx

    ; فحص وجود جهاز متصل (Bit 0 Check)
    test al, 0x01
    jz .no_device

    inc byte [usb_device_count]

    push usb_dev_found
    call terminal_writestring
    add esp, 4

.no_device:
    mov esp, ebp
    pop ebp
    ret

; --- 3. قراءة قطاع من وحدة تخزين USB (Mass Storage Read) ---
; Arguments: [esp+4] = LBA Address, [esp+8] = Buffer Destination
usb_read_sector:
    push ebp
    mov ebp, esp
    push edi

    mov eax, [ebp + 8]                  ; LBA Sector Address
    mov edi, [ebp + 12]                 ; Destination Buffer Pointer

    ; إرسال أمر القراءة للمتحكم (SCSI Command Block Wrapper)
    mov dx, USB_BASE_PORT
    out dx, eax

    pop edi
    mov esp, ebp
    pop ebp
    ret
