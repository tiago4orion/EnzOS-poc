CC := i686-elf-gcc
CFLAGS ?= -O2 -g

# Mandatory options
CFLAGS := $(CFLAGS) -nostdlib -ffreestanding -Isrc/include
LD := i686-elf-ld
LDFLAGS := 

AS := nasm
ASFLAGS := -felf32

LIBK = $(patsubst %.c,%.o,$(wildcard src/libk/*.c))

LEVEL0_I686_C = $(patsubst %.c,%.o,$(wildcard src/0/i686/*.c))
LEVEL0_I686_S = $(patsubst %.s,%.o,$(wildcard src/0/i686/*.s))
LEVEL0_I686 = $(LEVEL0_I686_S) $(LEVEL0_I686_C)

LEVEL0_X86_64_C = $(patsubst %.c,%.o,$(wildcard src/0/x86-64/*.c))
LEVEL0_X86_64_S = $(patsubst %.s,%.o,$(wildcard src/0/x86-64/*.s))
LEVEL0_X86_64 = $(LEVEL0_X86_64_S) $(LEVEL0_X86_64_C)

LEVEL1_C = $(patsubst %.c,%.o,$(wildcard src/1/*.c))
LEVEL1_S = $(patsubst %.s,%.o,$(wildcard src/1/*.s))
LEVEL1 = $(LEVEL1_S) $(LEVEL1_C)

MODULES_I686 = $(LEVEL0_I686) $(LEVEL1) $(LIBK)
MODULES_X86_64 = $(LEVEL0_X86_64) $(LEVEL1) $(LIBK)

all: i686-kernel
	@echo "Kernel built successfully"

i686-kernel: $(MODULES_I686)
	$(LD) -T link.ld $(LDFLAGS) -n -o $@ $^ 

ix86-64: $(MODULES_X86_64)
	@echo "Not implemented!!!"

%.o: %.c
	$(CC) $(CFLAGS) -c -o "$@" "$^"

%.o: %.s
	$(AS) $(ASFLAGS) -o "$@" "$^"

image: i686-kernel
	-@sudo umount /dev/loop0
	-@sudo losetup -d /dev/loop0 2>/dev/null
	sudo losetup -f -o $(shell expr 2048 \* 512) enzos.img
	sudo mount /dev/loop0 /mnt
	sudo cp i686-kernel /mnt/grub/kernel
	sudo cp grub.cfg /mnt/grub/grub.cfg
	sync && sudo umount /mnt
	sudo losetup -d /dev/loop0

run: image
	qemu-system-i386 -hda enzos.img -m 1024

clean:
	rm -f $(MODULES_I686) $(MODULES_X86_64) i686-kernel x86-64-kernel 
