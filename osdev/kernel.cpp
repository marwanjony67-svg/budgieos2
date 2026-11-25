#include <stddef.h>
#include <stdint.h>

namespace video {
constexpr size_t WIDTH = 80;
constexpr size_t HEIGHT = 25;
constexpr uint8_t COLOR = 0x1F;
volatile uint16_t* const VGA = reinterpret_cast<volatile uint16_t*>(0xB8000);
size_t row = 0;
size_t column = 0;

void clear() {
    for (size_t i = 0; i < WIDTH * HEIGHT; ++i)
        VGA[i] = static_cast<uint16_t>(COLOR << 8) | ' ';
    row = 0;
    column = 0;
}
void put(char c) {
    if (c == '\n') {
        column = 0;
        if (++row >= HEIGHT) row = 0;
        return;
    }
    VGA[row * WIDTH + column] =
        static_cast<uint16_t>(COLOR << 8) | static_cast<uint8_t>(c);
    if (++column >= WIDTH) {
        column = 0;
        if (++row >= HEIGHT) row = 0;
    }
}
void write(const char* text) {
    for (size_t i = 0; text[i] != '\0'; ++i) put(text[i]);
}
}

extern "C" void kernel_main() {
    video::clear();
    video::write("========================================\n");
    video::write("          WELCOME TO BUDGIEOS           \n");
    video::write("========================================\n\n");
    video::write("BudgieOS V2.0 - BNU kernel started.\n");
    video::write("Architecture: x86 32-bit protected mode\n");
    video::write("Kernel: C++20 + Assembly\n");
    video::write("Boot: GRUB / Multiboot v1\n\n");
    video::write("Next: interrupts, memory, keyboard, BudgieFS.\n");
    for (;;) __asm__ volatile ("hlt");
}
