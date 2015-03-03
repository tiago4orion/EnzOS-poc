#include <enzos/system.h>

// This gets called from our ASM interrupt handler stub.
void isr_handler(registers_t regs)
{
   puts("recieved interrupt: ");
   putch(regs.int_no);
   puts("\n");
}
