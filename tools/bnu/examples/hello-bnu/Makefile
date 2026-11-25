CXX ?= c++
CXXFLAGS ?= -std=c++20 -O2 -Wall -Wextra
TARGET := hello-bnu

all: $(TARGET)

$(TARGET): src/main.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	$(RM) $(TARGET) $(TARGET).exe

.PHONY: all clean
