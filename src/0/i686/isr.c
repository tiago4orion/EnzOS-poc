#include <enzos/system.h>

// This gets called from our ASM interrupt handler stub.
void isr_handler(registers_t regs)
{
	puts("recieved interrupt: ");
	char regbuf[10];
	memset(regbuf, 0, 10);
	itoa(regs.int_no, regbuf);
	puts(regbuf);

	puts("\n");

	puts("error received: ");
	itoa(regs.err_code, regbuf);
	puts(regbuf);
	puts("\n");
}
