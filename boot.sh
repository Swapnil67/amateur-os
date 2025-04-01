#!/bin/sh

set -xe

nasm bootSect.asm -o bootSect.bin
nasm kernel.asm -o kernel.bin

cat bootSect.bin kernel.bin > OS.bin
qemu-system-i386 -boot a -fda OS.bin