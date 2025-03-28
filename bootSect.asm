	;;  Basic bootsector that will jump continuously


	org 0x7c00		; * 'origin' of Boot Code; helps make sure addresses don't change

	;; * Set Video Mode
	mov ah, 0x00
	mov al, 0x03
	int 0x10

	;; Change color/pallete
	mov ah, 0x0B
	mov bh, 0x00
	mov bl, 0x01
	int 0x10
	
	mov bx, testString	; * mov the memory address of testString into bx register
	call print_string
	
	mov dx, 0x12AB	        ; * sample hex no. to print
	call print_hex
	
	jmp $ 			; * Keep jumping to here; neverending loop	
	
	;; * Included Files
	%include "print_string.asm"
	%include "print_hex.asm"

	
	;; Variables
testString:	db 'This is a hex string', 0xA, 0xD, 0	; * 0/null to null terminate
testString2:	db 'This is awesome!', 0	; * 0/null to null terminate

	times 510-($-$$) db 0

	dw 0xaa55		; BIOS magic number
	

; * nasm bootSect.asm -o bootSect
; * qemu-system-i386 bootSect


	;; References
	;;  Text Modes
	;;  https://en.wikipedia.org/wiki/VGA_text_mode

	;;  Video Modes
	;;  https://mendelson.org/wpdos/videomodes.txt

	;; Colors in BIOS
	;; https://en.wikipedia.org/wiki/BIOS_color_attributes
