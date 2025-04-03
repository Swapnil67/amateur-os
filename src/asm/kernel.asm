;; * kernel.asm: basic 'kernel` loaded from our bootsector

; org 0x0000		; * 'origin' of Boot Code; helps make sure addresses don't change

;; * Set Video Mode
mov ah, 0x00		; * int 0x10/ ah 0x00 = set video mode
mov al, 0x01		; * 40x25 text mode
int 0x10

;; * Change color/pallete
mov ah, 0x0B
mov bh, 0x00
mov bl, 0x01
int 0x10

;; * Print textString to terminal
mov si, testString	
call print_string

.die:
hlt 			; * halt the cpu	
jmp .die

print_string: 
	mov ah, 0x0e	; * int 10/ ah 0x0e BIOS teletype output
	mov bh, 0x0	  ; * page number
  mov bl, 0x01  ; * color 

print_char: 
  mov al, [si]
  cmp al, 0
  je end_print
  int 0x10
  add si, 1
  jmp print_char

end_print:
  ret


;; * Variables
testString:	db 'Kernel Booted, Welcome.', 0xA, 0xD, 0	; * 0/null to null terminate

;; * Boot sector magic
times 510-($-$$) db 0

; * nasm kernel.asm -o kernel.bin 
; * qemu-system-i386 -boot a -fda kernel.bin