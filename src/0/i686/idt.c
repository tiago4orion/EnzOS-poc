#include <enzos/system.h>

/* Defines an IDT entry */
struct idt_entry
{
    unsigned short base_lo;
    unsigned short sel;        /* Our kernel segment goes here! */
    unsigned char always0;     /* This will ALWAYS be set to 0! */
    unsigned char flags;       /* Set using the above table! */
    unsigned short base_hi;
} __attribute__((packed));

struct idt_ptr
{
    unsigned short limit;
    unsigned int base;
} __attribute__((packed));

/* Declare an IDT of 256 entries. Although we will only use the
*  first 32 entries in this tutorial, the rest exists as a bit
*  of a trap. If any undefined IDT entry is hit, it normally
*  will cause an "Unhandled Interrupt" exception. Any descriptor
*  for which the 'presence' bit is cleared (0) will generate an
*  "Unhandled Interrupt" exception */
struct idt_entry idt[256];
struct idt_ptr idtp;

/* This exists in 'idt.s', and is used to load our IDT */
extern void idt_load(unsigned int);
extern void isr0();
extern void isr1();
extern void isr2();
extern void isr32();

/* Use this function to set an entry in the IDT. Alot simpler
*  than twiddling with the GDT ;) */
void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags)
{
	idt[num].base_lo = base & 0xFFFF;
	idt[num].base_hi = (base >> 16) & 0xFFFF;

	idt[num].sel     = sel;
	idt[num].always0 = 0;

	// We must uncomment the OR below when we get to using user-mode.
	// It sets the interrupt gate's privilege level to 3.
	idt[num].flags   = flags /* | 0x60 */;
}

/* Installs the IDT */
void idt_install()
{
	int i = 0;
    /* Sets the special IDT pointer up, just like in 'gdt.c' */
    idtp.limit = (sizeof (struct idt_entry) * 256) - 1;
    idtp.base = (unsigned int)&idt;

    /* Clear out the entire IDT, initializing it to zeros */
    memset((unsigned char *)&idt, 0, sizeof(struct idt_entry) * 256);

    idt_set_gate(0, (unsigned int)isr0 , 0x08, 0x8E);
    idt_set_gate(1, (unsigned int)isr1 , 0x08, 0x8E);
    idt_set_gate(2, (unsigned int)isr2 , 0x08, 0x8E);

    for (i = 3; i < 32; i++) {
	    idt_set_gate(i, (unsigned int)isr0 , 0x08, 0x8E);
    }

    /* Points the processor's internal register to the new IDT */
    idt_load((unsigned int)&idtp);
}
