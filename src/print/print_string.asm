;; * ---------------------------------------------------------------
;; * Print String in SI register
;; * ---------------------------------------------------------------

print_string: 
	pusha
	mov ah, 0x0e	        ; * BIOS int 10h/ah=0x0e, teletype output
	mov bh, 0x00	        ; * page number
  mov bl, 0x01          ; * color 

print_char: 
  ; mov al, [si]        ; * Move character value at address in si into al
	lodsb               ; * Move byte at si into alx
  cmp al, 0                   
  je end_print        ; * jmp if equal (al = 0) to halt label
  int 0x10            ; * Print character in al
  ; add si, 1           ; * move 1 byte forward/ get next character
  jmp print_char

end_print:
	popa
  ret

