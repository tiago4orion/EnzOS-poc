
	[BITS 32]
	
	; This will set up our new segment registers. We need to do
	; something special in order to set CS. We do what is called a
	; far jump. A jump that includes a segment as well as an offset.
	; This is declared in C as 'extern void gdt_flush();'
	section .text
	global gdt_flush     ; Allows the C code to link to this
gdt_flush:
	push ebp
	mov ebp, esp
	
	mov eax, [esp+8]  ; Get the pointer to the GDT, passed as a parameter.
	lgdt [eax]        ; Load the new GDT pointer
	mov ax, 0x10      ; 0x10 is the offset in the GDT to our data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp 0x08:flush2   ; 0x08 is the offset to our code segment: Far jump!
flush2:
	leave
	ret               ; Returns back to the C code!
