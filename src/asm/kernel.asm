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

  mov si, filetableHeading
  call print_string

  ;; * Load file Table string from it's memory location (0x1000), print file
  ;; * and program names & sector numbers to screen, for user to choose.

  xor cx, cx 
  mov ax, 0x1000      ; * File table location
  mov es, ax          ; * ES = 0x1000
  xor bx, bx          ; * ES:BX = 0x1000:0x0000
  mov ah, 0x0e	      ; * BIOS int 10h/ah=0x0e, teletype output

fileprogramLoop:
  inc bx
  mov al, [ES:BX]
  cmp al, '}'           ; * At the end of the filetable
  je halt_cpu

  cmp al, '-'
  je .sectorSpaces

  cmp al, ','
  je .fileTableNextElement
  inc cx
  int 0x10
  jne fileprogramLoop

;; * Print static number of spaces after program name
.sectorSpaces: 
  cmp cx, 30
  je fileprogramLoop
  mov al, 0x20
  int 0x10
  inc cx,
  jmp .sectorSpaces

.fileTableNextElement:
  xor cx, cx
  mov al, 0xA
  int 0x10
  mov al, 0xD
  int 0x10
  mov al, 0xA
  int 0x10
  mov al, 0xD
  int 0x10
  jmp fileprogramLoop

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
  ;; * Include Files
  ;; * ---------------------------------------------------------------

  %include "./src/print/print_string.asm"

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

filetableHeading:	db '---------------        --------------', 0xA, 0xD, \
  '  File/Program             Sector', 0xA, 0xD, \
  '---------------        --------------', 0xA, 0xD, 0
  cmdString: db '', 0

  ;; * Boot sector magic
  times 510-($-$$) db 0

; * nasm kernel.asm -o kernel.bin 
; * qemu-system-i386 -boot a -fda kernel.bin