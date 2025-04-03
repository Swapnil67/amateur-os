;; *
;; * Disk Load: Read DH sectors into ES:BX memory location from drive DL
;; *

;; * https://www.ctyme.com/intr/rb-0607.htm

;; * DISK - READ SECTOR(S) INTO MEMORY
;; * Int 13/AH=02h 

;; * DH -> head number
;; * AL -> number of sectors to read (must be nonzero)
;; * ES:BX -> data buffer

;; * On Return
;; * AH -> status
;; * AL -> no of sectors read 

disk_load:
  push dx              ; * Store DX on stack so we can check no of sector actually read later

  mov ah, 0x02      ; * int 13/ah=02h, BIOS read disk sector into memory
  mov al, dh        ; * No of sectors we want to read ex: 1
  mov ch, 0x0       ; * Cylinder 0
  mov dh, 0x00      ; * head 0
  mov cl, 0x02      ; * start reading at CL sector 2 in this case. right after our bootsector

  int 0x13        ; * BIOS interrupts for disk functions

  ;; * If no carry set then disk read successful
  jc disk_error   ; * jump if disk read error (carry flag set/ = 1)

  pop dx        ; * restore DX from the stack

  ; * for checking the value in register ax
  ; mov dx, ax
  ; call print_hex
  ; mov ah, 0x0e
  ; mov al, 10
  ; int 0x10

  cmp dh, al      ; * if AL (# sectors actually read) != DH (# sectors we wanted to read)
  jne disk_error  ; * sectors read not equal to no. we want to read
  ret
  
disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  ;; * halts the CPU, putting it into a low-power state, until an external interrupt occurs
.die:
  hlt
  jmp .die

DISK_ERROR_MSG: db 'Disk read error!!!!!', 0
TIMEOUT: db 'TIMEOUT ...', 0

;; * cylinder & head are 0 based index
;; * sector are 1 based index
;; * 1 sector is always resversed for first 512 bytes of BIOS