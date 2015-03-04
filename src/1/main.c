/**
 * EnzOS
 *
 * Level 1 - Configures the hardware using level 0 primitives.
 *     - Initialize the video
 *     - Detect the hardware (cpuid)
 */
#include <enzos/system.h>

/**
 * inportb can be used to read data from I/O ports, such as the keyboard.
 */
unsigned char inportb (unsigned short _port)
{
    unsigned char rv;
    __asm__ __volatile__ ("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}

/**
 * Same as inputb, but for writing
 */
void outportb (unsigned short _port, unsigned char _data)
{
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}

void banner()
{
  	puts("EnzOS - The Boy Operating System!\n");
	puts("Author: Tiago Natel de Moura\n");
	puts("License: BSD\n");
}
 
void _1entry()
{
	idt_install();
	init_video();

	banner();

	if (has_cpuid()) {
		puts("Supports CPUID\n");
	} else {
		puts("Don't support CPUID.\n");
	}

	asm volatile ("int $0x3");
	asm volatile ("int $0x4");
}

