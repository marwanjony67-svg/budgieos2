// BNU Toolkit 1.0 - BudgieOS Native Utilities
// Host-side developer tool. C++20, no third-party libraries.
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

namespace fs = std::filesystem;
static constexpr const char* VERSION = "1.0.0";

void help() {
    std::cout << "BNU - BudgieOS Native Utilities " << VERSION << "\n\n"
      << "Usage:\n"
      << "  bnu help                  Show this help\n"
      << "  bnu version               Show version\n"
      << "  bnu doctor                Check development tools\n"
      << "  bnu new <project-name>    Create a starter C++ project\n"
      << "  bnu build [directory]     Build the BudgieOS kernel or current project\n"
      << "  bnu clean [directory]     Clean generated build files\n"
      << "  bnu pkg list              Show the initial package catalog\n\n"
      << "BNU is a host-side tool; it does not replace the BNU kernel.\n";
}

bool command_exists(const std::string& name) {
#ifdef _WIN32
    const std::string cmd = "where " + name + " >nul 2>nul";
#else
    const std::string cmd = "command -v " + name + " >/dev/null 2>&1";
#endif
    return std::system(cmd.c_str()) == 0;
}

int doctor() {
    struct Check { const char* name; const char* purpose; };
    const Check checks[] = {
        {"c++", "C++ compiler for the BNU host utility"},
        {"make", "GNU Make build runner"},
        {"i686-elf-g++", "32-bit x86 freestanding cross compiler"},
        {"nasm", "Assembly compiler"},
        {"grub-mkrescue", "Bootable ISO creator"},
        {"qemu-system-i386", "PC emulator"}
    };
    int missing = 0;
    std::cout << "BNU Doctor - development environment\n";
    for (const auto& check : checks) {
        const bool found = command_exists(check.name);
        std::cout << (found ? "[OK]      " : "[MISSING] ")
                  << check.name << " - " << check.purpose << "\n";
        if (!found) ++missing;
    }
    std::cout << "\nMissing tools: " << missing << "\n";
    return missing == 0 ? 0 : 1;
}

int create_project(const std::string& name) {
    if (name.empty() || name == "." || name == ".." ||
        name.find('/') != std::string::npos ||
        name.find('\\') != std::string::npos) {
        std::cerr << "BNU: choose a simple project name (no path separators).\n";
        return 2;
    }
    const fs::path root = fs::current_path() / name;
    if (fs::exists(root)) {
        std::cerr << "BNU: destination already exists: " << root.string() << "\n";
        return 2;
    }
    try {
        fs::create_directories(root / "src");
        std::ofstream manifest(root / "bnu.toml");
        manifest << "name = \"" << name << "\"\n"
                 << "version = \"0.1.0\"\nkind = \"application\"\nlanguage = \"cpp\"\n";
        std::ofstream source(root / "src" / "main.cpp");
        source << "#include <iostream>\n\nint main() {\n"
               << "    std::cout << \"Hello from " << name << "!\\\\n\";\n"
               << "    return 0;\n}\n";
        std::ofstream makefile(root / "Makefile");
        makefile << "CXX ?= c++\nCXXFLAGS ?= -std=c++20 -O2 -Wall -Wextra\n"
                 << "TARGET := " << name << "\n\nall: $(TARGET)\n\n"
                 << "$(TARGET): src/main.cpp\n\t$(CXX) $(CXXFLAGS) $< -o $@\n\n"
                 << "clean:\n\t$(RM) $(TARGET) $(TARGET).exe\n\n.PHONY: all clean\n";
        std::cout << "Created BNU project: " << root.string() << "\n"
                  << "Next: cd " << name << " && bnu build\n";
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "BNU: project creation failed: " << error.what() << "\n";
        return 1;
    }
}

int run_make(const std::string& action, const fs::path& requested) {
    std::error_code ec;
    const fs::path target = fs::weakly_canonical(requested, ec);
    if (ec || !fs::is_directory(target)) {
        std::cerr << "BNU: project directory does not exist.\n";
        return 2;
    }
    fs::path build_dir = target;
    if (fs::exists(target / "osdev" / "Makefile"))
        build_dir = target / "osdev";
    else if (!fs::exists(target / "Makefile")) {
        std::cerr << "BNU: no Makefile or osdev/Makefile found in "
                  << target.string() << "\n";
        return 2;
    }
    const fs::path previous = fs::current_path();
    try {
        fs::current_path(build_dir);
        const int result = std::system(action == "clean" ? "make clean" : "make");
        fs::current_path(previous);
        if (result != 0) {
            std::cerr << "BNU: " << action << " failed (exit code " << result << ").\n";
            return result;
        }
        std::cout << "BNU: " << action << " completed.\n";
        return 0;
    } catch (const std::exception& error) {
        fs::current_path(previous);
        std::cerr << "BNU: " << error.what() << "\n";
        return 1;
    }
}

void package_list() {
    struct Package { const char* name; const char* state; const char* description; };
    const Package packages[] = {
        {"bnu-core", "included", "BNU command-line toolkit"},
        {"bnu-kernel", "in development", "BudgieOS kernel build target"},
        {"budgiefs", "planned", "Native BudgieOS filesystem tools"},
        {"bnu-shell", "planned", "BudgieOS command shell"},
        {"bnu-gui", "planned", "BudgieOS graphical desktop toolkit"}
    };
    std::cout << "BNU package catalog (initial local catalog)\n";
    for (const auto& p : packages)
        std::cout << p.name << " [" << p.state << "] - " << p.description << "\n";
    std::cout << "\nPackage download/install is not implemented in this version.\n";
}

int main(int argc, char** argv) {
    if (argc < 2) { help(); return 0; }
    const std::string command = argv[1];
    if (command == "help" || command == "--help" || command == "-h") {
        help(); return 0;
    }
    if (command == "version" || command == "--version") {
        std::cout << "BNU Toolkit " << VERSION << "\n"; return 0;
    }
    if (command == "doctor") return doctor();
    if (command == "new") {
        if (argc < 3) { std::cerr << "Usage: bnu new <project-name>\n"; return 2; }
        return create_project(argv[2]);
    }
    if (command == "build" || command == "clean") {
        const fs::path directory = argc >= 3 ? fs::path(argv[2]) : fs::current_path();
        return run_make(command, directory);
    }
    if (command == "pkg" && argc >= 3 && std::string(argv[2]) == "list") {
        package_list(); return 0;
    }
    std::cerr << "BNU: unknown command: " << command << "\n";
    help();
    return 2;
}
