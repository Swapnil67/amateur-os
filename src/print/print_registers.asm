;; * ---------------------------------------------------------------
;; * Print Registers
;; * ---------------------------------------------------------------

print_registers: 
  mov si, regString
  call print_string
  call print_hex              ; * print dx

  mov BYTE [regString + 2], 'a'
  call print_string
  mov dx, ax
  call print_hex              ; * print ax

  mov BYTE [regString + 2], 'b'
  call print_string
  mov dx, bx
  call print_hex              ; * print bx

  mov BYTE [regString + 2], 'c'
  call print_string
  mov dx, cx
  call print_hex              ; * print cx

  mov WORD [regString + 2], 'si'
  call print_string
  mov dx, si
  call print_hex              ; * print si

  mov BYTE [regString + 2], 'd'
  call print_string
  mov dx, di
  call print_hex              ; * print di

  mov WORD [regString + 2], 'cs'
  call print_string
  mov dx, cs
  call print_hex              ; * print cs

  mov BYTE [regString + 2], 'd'
  call print_string
  mov dx, ds
  call print_hex              ; * print ds

  mov BYTE [regString + 2], 's'
  call print_string
  mov dx, ss
  call print_hex              ; * print ss  

  mov BYTE [regString + 2], 'e'
  call print_string
  mov dx, es
  call print_hex              ; * print es

  ret

;; * Variables
regString:	db 0xA, 0xD, 'dx                         ', 0	; * Register Name
