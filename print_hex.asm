;; *
;; * Prints hex value using register DX and print_string.asm
;; *

;; * Ascii '0'-'9' = hex 0x30 - 0x39
;; * Ascii 'A'-'F' = hex 0x41 - 0x46
;; * Ascii 'a'-'f' = hex 0x61 - 0x66

print_hex:
	pusha 			; * Save all registers to the stack
	mov cx, 0		; * Initialize loop counter

hex_loop:
	cmp cx, 4		; * Are we at end of loop
	je hex_loop_end		; * End loop

	;; * Convert the hex values to ascii
	mov ax, dx		; * dx register contains hex value
	and ax, 0x000F		; * Get the last digit in ax register
				; * 0x12AB & 0x000F -> 0x000B 

	add al, 0x30		; * get ascii number value by default
	cmp al, 0x39		; * Is hex value 0 - 9 or A - F
	jle move_intobx		

	add al, 0x07 		; * To get ascii 'A' - 'F'
	
	;; * Move ascii character into bx string
move_intobx:
	mov bx, hexString + 5 	; * base address of hexString + length of string
	sub bx, cx		; * Get the position to insert current hex digit
	mov [bx], al		; * Put the ascii into hexString position
	ror dx, 4		; * Rotate right by 4 bits (Shift Right)
				; * 0x12AB  -> 0xB12A -> 0xAB12 -> 0x2AB1 -> 0x12AB
	
	add cx, 1		; * Increment the counter
	jmp hex_loop		; * Loop for next hex digit
	
hex_loop_end:
	mov bx, hexString
	call print_string
	
	popa			; * restore all the registers from the stack
	ret

	;; Data
hexString:	db '0x0000', 0	; * Base hex string
