CXX ?= c++
CXXFLAGS ?= -std=c++20 -O2 -Wall -Wextra -pedantic
TARGET := bnu
SOURCE := bnu.cpp

.PHONY: all clean install
all: $(TARGET)

$(TARGET): $(SOURCE)
	$(CXX) $(CXXFLAGS) $(SOURCE) -o $(TARGET)

clean:
	$(RM) $(TARGET) $(TARGET).exe

install: $(TARGET)
	@echo "Copy bnu to a directory on your PATH manually."
