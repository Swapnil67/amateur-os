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
  xor ax, ax        ; * ah = 0x00
  int 0x16          ; * BIOS int get keystroke, character goes into al

  mov ah, 0x0e       ; * BIOS int 10h/ah=0x0e, teletype output
  cmp al, 0x0D       ; * did user print 'enter' key
  je run_command    ; *
  int 0x10          ; * if not, print input character to screen
  mov [di], al
  inc di
  jmp keyloop       ; * Loop for next char from user

run_command:
  mov byte [di], 0         ; * null terminate cmdString
  mov al, [cmdString]
  cmp al, 'F'              ; * file table command/menu option
  je filebrowser

  cmp al, 'R'              
  je reboot                ; * 'warm' reboot option

  cmp al, 'N'              ; * file table command/menu option
  je end_program
  mov si, failure
  call print_string
  jmp get_input

  ;; * ---------------------------------------------------------------
  ;; * Menu F) - File/Program browser & loader
  ;; * ---------------------------------------------------------------

filebrowser: 
  ;; * Reset screen state
  ;; * --------------------
  ;; * Set Video Mode
  mov ah, 0x00		; * int 0x10/ ah 0x00 = set video mode
  mov al, 0x01		; * 40x25 text mode
  int 0x10

  ;; * Change color/pallete
  mov ah, 0x0B
  mov bh, 0x00
  mov bl, 0x01
  int 0x10

  ;; * Load file Table string from it's memory location (0x1000), print file
  ;; * and program names & sector numbers to screen, for user to choose.
  mov ax, 0x1000
  mov es, ax
  mov bx, 0
  mov ah, 0x0e	      ; * BIOS int 10h/ah=0x0e, teletype output
  mov si, [ES:BX]
  call print_string

  jmp halt_cpu

  ;; * ---------------------------------------------------------------
  ;; * Menu R) - Reboot: far jump to reset vector
  ;; * ---------------------------------------------------------------
reboot: 
  jmp 0xFFFF:0x0000



  ;; * ---------------------------------------------------------------
  ;; * Menu N) - End Program
  ;; * ---------------------------------------------------------------
end_program:
  cli       ; * clear interrupts

halt_cpu:
  hlt 			; * halt the cpu	
  jmp halt_cpu

  ;; * ---------------------------------------------------------------
  ;; * End Main Logic
  ;; * ---------------------------------------------------------------

  ;; * ---------------------------------------------------------------
  ;; * Print String
  ;; * ---------------------------------------------------------------
print_string: 
	mov ah, 0x0e	      ; * BIOS int 10h/ah=0x0e, teletype output
	mov bh, 0x0	        ; * page number
  mov bl, 0x01        ; * color 

print_char: 
  mov al, [si]        ; * Move character value at address in si into al
  cmp al, 0                   
  je end_print        ; * jmp if equal (al = 0) to halt label
  int 0x10            ; * Print character in al
  add si, 1           ; * move 1 byte forward/ get next character
  jmp print_char

end_print:
  ret

  ;; * ---------------------------------------------------------------
  ;; * Variables
  ;; * ---------------------------------------------------------------
menuString:	db '----------------------------------------', 0xA, 0xD, \
  'Kernel Booted, Welcome.', 0xA, 0xD,\
  '----------------------------------------', 0xA, 0xD, 0xA, 0xD,\
  'F) File Browser', 0xA, 0xD, \
  'R) Reboot', 0xA, 0xD, 0
  success: db 0xA, 0xD, 'Command ran successfully!', 0xA, 0xD, 0
  failure: db 0xA, 0xD, 'Oops! something went wrong :(', 0xA, 0xD, 0
  cmdString: db ''

  ;; * Boot sector magic
  times 510-($-$$) db 0

; * nasm kernel.asm -o kernel.bin 
; * qemu-system-i386 -boot a -fda kernel.bin