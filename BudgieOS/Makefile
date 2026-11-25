CXX      := x86_64-elf-g++
AS       := x86_64-elf-gcc
LD       := x86_64-elf-g++
BUILD    := build
KERNEL   := $(BUILD)/budgieos.elf

CXXFLAGS := -std=c++20 -O2 -Wall -Wextra -Werror \
            -ffreestanding -fno-exceptions -fno-rtti \
            -fno-stack-protector -fno-pic -fno-pie \
            -mno-red-zone -mcmodel=kernel -m64
ASFLAGS  := -ffreestanding -fno-pic -fno-pie -m64
LDFLAGS  := -T linker.ld -nostdlib -static -m elf_x86_64

CPP_SOURCES := kernel/main.cpp
ASM_SOURCES := kernel/arch/x86_64/boot.S
OBJECTS := $(BUILD)/main.o $(BUILD)/boot.o

.PHONY: all clean toolchain-check

all: toolchain-check $(KERNEL)

toolchain-check:
	@command -v $(CXX) >/dev/null || (echo "Missing x86_64-elf-g++ cross compiler"; exit 1)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/main.o: kernel/main.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD)/boot.o: $(ASM_SOURCES) | $(BUILD)
	$(AS) $(ASFLAGS) -c $< -o $@

$(KERNEL): $(OBJECTS) linker.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS)

clean:
	rm -rf $(BUILD)
