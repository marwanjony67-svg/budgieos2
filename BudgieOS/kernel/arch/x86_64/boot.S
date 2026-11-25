.section .text
.global _start
.type _start, @function
.extern kernel_main

_start:
    cli
    call kernel_main

1:
    hlt
    jmp 1b

.size _start, . - _start
