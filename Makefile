version = 0.0.1
arch ?= x86_64

#names
kernel_fullname := kernel-$(arch).bin
kernel := build/$(kernel_fullname)
iso := build/kernel-$(version)-$(arch).iso
img := build/kernel-$(version)-$(arch).img

#include paths
dirs = $(shell find src/arch/$(arch)/kernel -type d -print)
includedirs :=  $(sort $(foreach dir, $(foreach dir1, $(dirs), $(shell dirname $(dir1))), $(wildcard $(dir)/include)))

#linker
linker_script := src/$(arch)/kernel/link.ld
LFLAGS := -nostdlib

#flags
CFLAGS= -Wall -O -fno-pie -fstrength-reduce -fomit-frame-pointer	\
		-finline-functions -nostdinc -fno-builtin -ffreestanding	\
		-fno-stack-protector -c -Wno-unused-variable -Wno-maybe-uninitialized -Wno-error=varargs \
		-Wno-error=unused-function -std=gnu11
# Wunused-variable will be ignored!

#automatically include any header in dirs called include
CFLAGS += $(foreach dir, $(includedirs), -I./$(dir))

#support for both .s and .S
assembly_source_files := $(foreach dir,$(dirs),$(wildcard $(dir)/*.s))
assembly_object_files := $(patsubst src/$(arch)/kernel/%.s, \
	build/$(arch)/kernel/%.o, $(assembly_source_files))

assembly_source_files += $(foreach dir,$(dirs),$(wildcard $(dir)/*.S))
assembly_object_files += $(patsubst src/$(arch)/kernel/%.S, \
	build/$(arch)/kernel/%.o, $(assembly_source_files))

c_source_files := $(foreach dir,$(dirs),$(wildcard $(dir)/*.c))
c_object_files := $(patsubst src/$(arch)/kernel/%.c, \
    build/$(arch)/kernel/%.o, $(c_source_files))
#qemu

qemumem := 1
qemuflags := -device isa-debug-exit,iobase=0xf4,iosize=0x04 -serial stdio

.PHONY: all clean run runrel iso

all: $(kernel)

install:
	@sudo apt-get install qemu nasm

clean:
	@rm -r build

run: $(kernel)
	@echo starting emulator...
	@qemu-system-x86_64 -m $(qemumem)G -kernel $(kernel) $(qemuflags)


$(kernel): $(assembly_object_files) $(c_object_files) $(linker_script)
	@echo linking...
	@ld -m $(LFLAGS) -T $(linker_script) -o $(kernel) $(assembly_object_files) $(c_object_files)


# compile assembly files
build/$(arch)/%.o: src/$(arch)/kernel/%.s src/$(arch)/kernel/%.S
	@mkdir -p $(shell dirname $@)
	@echo compiling $<
	@gcc $< -o $@

# compile c files
build/$(arch)/%.o: src/$(arch)/kernel/%.c
	@mkdir -p $(shell dirname $@)
	@echo compiling $<
	@gcc $(CFLAGS) $< -o $@