#include <stdint.h>

namespace serial {
static constexpr uint16_t COM1 = 0x3F8;

static inline void outb(uint16_t port, uint8_t value) {
    asm volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t value;
    asm volatile ("inb %1, %0" : "=a"(value) : "Nd"(port));
    return value;
}

void initialize() {
    outb(COM1 + 1, 0x00);
    outb(COM1 + 3, 0x80);
    outb(COM1 + 0, 0x03);
    outb(COM1 + 1, 0x00);
    outb(COM1 + 3, 0x03);
    outb(COM1 + 2, 0xC7);
    outb(COM1 + 4, 0x0B);
}

void write_char(char c) {
    for (uint32_t timeout = 0; timeout < 1000000; ++timeout) {
        if (inb(COM1 + 5) & 0x20) {
            outb(COM1, static_cast<uint8_t>(c));
            return;
        }
    }
}

void write(const char* text) {
    while (*text) write_char(*text++);
}
}

extern "C" [[noreturn]] void kernel_main() {
    serial::initialize();
    serial::write("\r\nBudgieOS V1.0 x86_64 kernel started.\r\n");
    serial::write("BudgieOS--$ kernel is alive; more systems are coming.\r\n");

    for (;;) {
        asm volatile ("hlt");
    }
}
