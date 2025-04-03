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

  ;; * Print Screen heading and Menu options
  mov si, menuString	
  call print_string

  ;; * Get user input, print to screen & choose menu option or run command
get_input:
  mov di, cmdString   ; * di is now pointing to cmdString
keyloop:
  xor ax, ax
  int 0x16          ; * BIOS int get keystroke, character goes into al

  mov ah, 0x0e
  cmp al, 0xD       ; * did user print 'enter' key
  je run_command    ; *
  int 0x10          ; * if not, print input character to screen
  mov [di], al
  inc di
  jmp keyloop       ; * Loop for next char from user

run_command:
  mov byte [di], 0      ; * null terminate cmdString
  mov al, [cmdString]
  cmp al, 'F'    ; * file table command/menu option
  jne not_found
  cmp al, 'N'    ; * file table command/menu option
  je end_program
  mov si, success
  call print_string
  jmp get_input

not_found:
  mov si, failure
  call print_string
  jmp get_input

end_program:
  cli       ; * clear interrupts
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
  menuString:	db '----------------------------------------', 0xA, 0xD, \
  'Kernel Booted, Welcome.', 0xA, 0xD,\
  '----------------------------------------', 0xA, 0xD, 0xA, 0xD,\
  'F) File Browser', 0xA, 0xD, 0
  success: db 0xA, 0xD, 'Command ran successfully!', 0xA, 0xD, 0
  failure: db 0xA, 0xD, 'Oops! something went wrong :( successfully', 0xA, 0xD, 0
  cmdString: db ''

  ;; * Boot sector magic
  times 510-($-$$) db 0

; * nasm kernel.asm -o kernel.bin 
; * qemu-system-i386 -boot a -fda kernel.bin