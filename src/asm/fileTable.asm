;;; *
;;; * Basic file table made with db, strings consist of  '{filename1-sector#, filename2-sector#,... filenameN-sector#}'
;;; *


db '{calculator-04,program2-06}'

;; * sector padding magic
times 512-($-$$) db 0 ; * pad rest of file to 0s till 512th byte/end of sector

; * nasm fileTable.asm -o fileTable.bin 
; * qemu-system-i386 -boot a -fda kernel.bin
