	;; Simple functions to detect and get informations
	;; of processor.

	[BITS 32]

	section .text
	global has_cpuid
has_cpuid:
	push ebp
	mov ebp, esp
	
	pushfd               ; Store the FLAGS-register.
	pop eax              ; Restore the A-register.
	mov ecx, eax         ; Set the C-register to the A-register.
	xor eax, 1 << 21     ; Flip the ID-bit, which is bit 21.
	push eax             ; Store the A-register.
	popfd                ; Restore the FLAGS-register.
	pushfd               ; Store the FLAGS-register.
	pop eax              ; Restore the A-register.
	push ecx             ; Store the C-register.
	popfd                ; Restore the FLAGS-register.
	xor eax, ecx         ; Do a XOR-operation on the A-register and the C-register.
	jz .NoCPUID          ; The zero flag is set, no CPUID.

	; CPUID is available for use.
	xor eax, eax
	mov ax, 0x01
	leave
	ret
.NoCPUID:
	xor eax, eax
	leave	
	ret
	
