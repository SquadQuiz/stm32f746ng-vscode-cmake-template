# Use CMakeLists.txt to apply user changes
cmake_minimum_required(VERSION 3.22)

# Core MCU flags, CPU, instruction set and FPU setup
set(cpu_PARAMS ${cpu_PARAMS}
	-mthumb

	# Other parameters
	# -mcpu, -mfloat, -mfloat-abi, ...
	-mcpu=cortex-m7
	-mfpu=fpv5-sp-d16
	-mfloat-abi=hard
)

# Linker script
set(linker_script_SRC
	${CMAKE_CURRENT_SOURCE_DIR}/STM32F746NGHx_FLASH.ld
)

# Sources
set(sources_SRCS ${sources_SRCS}
	
)

# Include directories
set(include_c_DIRS ${include_c_DIRS}
    
)

set(include_cxx_DIRS ${include_cxx_DIRS}
    
)

set(include_asm_DIRS ${include_asm_DIRS}
    
)

# Symbols definition
set(symbols_c_SYMB ${symbols_c_SYMB}
    $<$<COMPILE_LANGUAGE:C>: ${symbols_c_SYMB}>
    $<$<COMPILE_LANGUAGE:CXX>: ${symbols_cxx_SYMB}>
    $<$<COMPILE_LANGUAGE:ASM>: ${symbols_asm_SYMB}>

    # Configuration specific
    $<$<CONFIG:Debug>:DEBUG>
    $<$<CONFIG:Release>: >
)

set(symbols_cxx_SYMB ${symbols_cxx_SYMB}
	
)

set(symbols_asm_SYMB ${symbols_asm_SYMB}
	
)

# Link directories
set(link_DIRS ${link_DIRS}
    
)

# Link libraries
set(link_LIBS ${link_LIBS}
    
)

# Compiler options
set(compiler_OPTS ${compiler_OPTS}
    # General
    -std=gnu11            # Language Standard GNU11(ISO C11)
    # Warning
    -Wall                 # Enable all warnings
    -Wextra               # Enable extra warning
    -Wpedantic            # Issues all warnings demanded by strict ISO c and ISO C++
    -Wno-unused-parameter # Enable warning for un-used parameter

    $<$<COMPILE_LANGUAGE:C>: >
    $<$<COMPILE_LANGUAGE:CXX>:
    # -Wno-volatile
    # -Wold-style-cast
    # -Wuseless-cast
    # -Wsuggest-override
    >

    # Miscellaneous
    -fstack-usage             # Enable stack usage analysis
    -fcyclomatic-complexity   # Cyclomatic Complexity
    # -v                        # Verbose
    
    $<$<COMPILE_LANGUAGE:ASM>:
    -x assembler-with-cpp     # Always preprocess assembler
    -MMD 
    -MP
    >
    
    # Debug config
    $<$<CONFIG:Debug>:
    -Og # optimize for debug
    -g3 # maximum debug level
    -ggdb
    >
    $<$<CONFIG:Release>:
    -O0 # none optimize
    -g0 # none debug
    >
)

# Linker options
set(linker_OPTS ${linker_OPTS}
    -Wl,-Map=${CMAKE_PROJECT_NAME}.map # Generate map file
    # -u _printf_float # STDIO float formatting support (remove if not used)
    --specs=nosys.specs # Standard C Runtime library
    # --specs=nano.specs # Reduced C Runtime library
    # -Wl,--gc-sections # Discard unused sections
    # -Wl,--verbose # Verbose
    -Wl,-z,max-page-size=8 # Allow good software remapping across address space (with proper GCC section making)
    -Wl,--print-memory-usage
    
    # Use C Math library
    $<$<COMPILE_LANGUAGE:C>: 
    -Wl,--start-group
    -lc
    -lm
    -Wl,--end-group
    >

    $<$<COMPILE_LANGUAGE:CXX>:
    -Wl,--start-group
    -lstdc++
    -lsupc++
    -Wl,--end-group
    >
)
