	[BITS 32]

	section .text
	global idt_load
idt_load:
	push ebp
	mov ebp, esp
	mov eax, [esp+8]
	lidt [eax]
	leave
	ret
