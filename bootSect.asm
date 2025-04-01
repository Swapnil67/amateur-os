;; *
;; * Simple Boot loader that uses INT13 AH=2 to read from disk into memory
;; *

org 0x7c00		; * 'origin' of Boot Code; helps make sure addresses don't change

mov bx, 0x1000    ; * load the sector to memory addr 0x1000
mov es, bx 
mov bx, 0x0      ; * ES:BX = 0x1000:0x0000

; * Set up disk read
mov dh, 0x0       ; * head 0
mov dl, 0x0       ; * drive 0
mov ch, 0x0       ; * cylinder 0
mov cl, 0x02      ; * starting sector to read from disk

read_disk:
  mov ah, 0x02      ; * int 13/ah=02h, BIOS read disk sector into memory
  mov al, 0x01      ; * No of sectors we want to read ex: 1
  int 0x13          ; * BIOS interrupts for disk functions

  jc read_disk   ; * retry if disk read error (carry flag set/ = 1)

  ;; * Reset segment registers for RAM
  mov ax, 0x1000
  mov ds, ax        ; * data segment
  mov es, ax        ; * extra segment
  mov fs, ax        ; * ""
  mov gs, ax        ; * ""
  mov ss, ax        ; * stack segment

  jmp 0x1000:0x0

  ;; * Boot sector magic
  times 510-($-$$) db 0

  dw 0xaa55		; * BIOS magic number

; * nasm bootSect.asm -o bootSect.bin
; * cat bootSect.bin kernel.bin > OS.bin
; * qemu-system-i386 -boot a -fda OS.bin

;; References
;;  Text Modes
;;  https://en.wikipedia.org/wiki/VGA_text_mode

;;  Video Modes
;;  https://mendelson.org/wpdos/videomodes.txt

;; Colors in BIOS
;; https://en.wikipedia.org/wiki/BIOS_color_attributes
