	;; EnzOS - The Boy Operating System
	;;
	;; Author: Tiago Natel de Moura
	;;
	;; References:
	;; 	- Modern Operating Systems - Andrew S. Tanembaum
	;; 	- Computer Organization and Architecture - William Stallings

	;; This is the most low level of EnzOS, and the only hardware specific.
	;; Here, at the level 0, we have no chance of abstractions! We need to
	;; talk directly with the hardware. The above levels are more human
	;; friendly.

	;; Level0
	;;     - Load/configure GDT;
	;;     - Load/configure basic IDT;
	;;     - Scale for next level;

	[BITS 32]
	
	;; Declare some constants for setup the multiboot
	MBALIGN     equ  1<<0		   ; Align modules on page boundaries
	MEMINFO     equ  1<<1		   ; support memory map
	FLAGS       equ  MBALIGN | MEMINFO ; Multiboot flag, setting MBALIGN and MEMINFO
	MAGIC       equ  0x1BADB002        ; GRUB/multiboot Magic number
	CHECKSUM    equ -(MAGIC + FLAGS)   ; Checksum of the informations above
	 
	;; Declare a new section for multiboot. This section should be in the
	;; front of .text to ensure that the multiboot struct will exists
	;; insinde the first 8192 bytes of the OS image.
	section .multiboot
	align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM
	 
	;; At the moment, we don't have a stack, so, we need set up a small temporary
	;; stack here to be safe using the stack pointer register (esp).
	section .bootstrap_stack
	align 4
	stack_bottom:
	times 16384 db 0
	stack_top:
	 
	;; The EnzOS entrypoint
	section .text	
	global start
start:	
	; To set up a stack, we simply set the esp register to point to the top of
	; our stack (as it grows downwards).
	;; Set the esp register to point to the top of our stack.
	;; The stack grows downwards (See the .bootstrap_stack section)
	mov esp, stack_top

	extern gdt_install
	call gdt_install

	extern idt_install
	call idt_install

	;; WTF is _1entry ? Every level has a entrypoint function. A function
	;; that starts the new floor, _1entry initialize the level 1 and
	;; _2entry initialize the 2nd floor and so on.
	extern _1entry
	call _1entry
	 
	;; Put the computer into an infinite loop, but only if _1entry
	;; function returns.
	cli
.hang:
	hlt
	jmp .hang
