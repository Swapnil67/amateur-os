#!/bin/sh

set -xe

nasm ./src/asm/bootSect.asm -o ./bin/bootSect.bin
nasm ./src/asm/kernel.asm -o ./bin/kernel.bin

cat ./bin/bootSect.bin ./bin/kernel.bin > ./bin/OS.bin
qemu-system-i386 -boot a -fda ./bin/OS.bin