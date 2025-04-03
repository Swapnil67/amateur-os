# * Create the OS.bin file
OS: bootSect.bin kernel.bin
	cat bootSect.bin kernel.bin > OS.bin

# * Create bootSector binary file
bootSect.bin:
	nasm ../src/asm/bootSect.asm -o bootSect.bin

# * Create kernel binary file
kernel.bin:
	nasm ../src/asm/kernel.asm -o kernel.bin

# * Clean up binary files
clean:
	rm *.bin