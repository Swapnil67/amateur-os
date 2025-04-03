	;; *
	;; * Prints character string in BX register
	;; *
	
print_string:
	pusha		; * Store all Register value onto the stack
	;; Tele-type output
	mov ah, 0x0e	; * int 10/ ah 0x0e BIOS teletype output
	
print_char:	
	mov al, [bx]	; * mov character value at address in bx int al
	cmp al, 0
	je .print_string_end
	int 0x10	; * print character in al
	add bx, 1	; * move 1 byte forward/ get to next cursor
	jmp print_char	; * loop
	
.print_string_end:
	popa
	ret

