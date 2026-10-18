; =====================================================================================
;  Project: BudgieOS PC Edition (Clean Memory Allocation & Dynamic Heap Manager)
;  Author & Lead Developer: Marwan
;  License: GPLbudgieos
;  Mascot & Supervisor: Lola (لولا) 🦜
;  Architecture: 32-bit Protected Mode Memory Allocation & Cleaning
; =====================================================================================

[bits 32]

global init_memory_manager
global asm_alloc_clean_memory
global asm_memset_zero

extern terminal_writestring

HEAP_START_ADDRESS equ 0x00200000        ; بداية مساحة الذاكرة المخصصة (2MB Mark)
HEAP_MAX_SIZE      equ 0x01000000        ; الحد الأقصى للمساحة (16MB)

section .data
    mem_init_msg    db 0x0A, "[MEM] Initializing Clean Dynamic Heap Manager...", 0x0A, 0
    mem_ready_msg   db "[MEM] Memory Allocation Engine Ready (Lola Guard Active 🦜)", 0x0A, 0

section .bss
    heap_curr_ptr   resd 1               ; المؤشر الحالي للمساحة المتاحة بالذاكرة

section .text

; --- 1. تهيئة مدير المساحات وتصفير مؤشر الذاكرة ---
init_memory_manager:
    push ebp
    mov ebp, esp

    mov dword [heap_curr_ptr], HEAP_START_ADDRESS

    push mem_init_msg
    call terminal_writestring
    add esp, 4

    push mem_ready_msg
    call terminal_writestring
    add esp, 4

    mov esp, ebp
    pop ebp
    ret

; --- 2. حجز مساحة نظيفة من الذاكرة (Alloc Clean Memory Space) ---
; Arguments: [esp+4] = Requested Size in Bytes
; Returns: EAX = Memory Pointer
asm_alloc_clean_memory:
    push ebp
    mov ebp, esp
    push ebx
    push ecx

    mov ecx, [ebp + 8]                   ; الحجم المطلوب للبايتات
    mov eax, [heap_curr_ptr]             ; العنوان الحالي المؤشر للذاكرة
    mov ebx, eax
    add ebx, ecx                         ; تحديث مؤشر الذاكرة الجديد

    ; التأكد من عدم تجاوز الحدود القصوى للذاكرة
    cmp ebx, HEAP_START_ADDRESS + HEAP_MAX_SIZE
    jge .out_of_memory

    mov [heap_curr_ptr], ebx             ; حفظ العنوان الجديد بالذاكرة

    ; تنظيف المساحة المحجوزة بالكامل (Zero-Out Memory)
    push ecx
    push eax
    call asm_memset_zero
    add esp, 8

    jmp .done

.out_of_memory:
    mov eax, 0                           ; إرجاع NULL في حال امتلاء الذاكرة

.done:
    pop ecx
    pop ebx
    mov esp, ebp
    pop ebp
    ret

; --- 3. دالة تنظيف وتصفير البايتات بالذاكرة (Clean Zero Fill) ---
; Arguments: [esp+4] = Buffer Pointer, [esp+8] = Length
asm_memset_zero:
    push ebp
    mov ebp, esp
    push edi
    push ecx

    mov edi, [ebp + 8]                   ; Buffer Pointer
    mov ecx, [ebp + 12]                  ; Length
    mov al, 0                            ; القيمة المراد التنظيف بها (Zero)

    rep stosb                            ; تنظيف وتصفير البايتات مباشرة بأقصى سرعة معالج

    pop ecx
    pop edi
    mov esp, ebp
    pop ebp
    ret
