# * Create the OS.bin file
OS: bootSect.bin fileTable.bin kernel.bin
	cat bootSect.bin fileTable.bin kernel.bin > OS.bin

# * Create bootSector binary file
bootSect.bin:
	nasm ../src/asm/bootSect.asm -o ./bootSect.bin

# * Create file table binary file
fileTable.bin:
	nasm ../src/asm/fileTable.asm -o ./fileTable.bin

# * Create kernel binary file
kernel.bin:
	nasm ../src/asm/kernel.asm -o ./kernel.bin

# * Clean up binary files
clean:
	rm *.bin