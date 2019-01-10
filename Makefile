Work_Matrix.o: Work_Matrix.asm
	nasm -f elf -dOS_LINUX Work_Matrix.asm
Work_Files.o: Work_Files.asm
	nasm -f elf -dOS_LINUX Work_Files.asm
Interface.o: Interface.asm
	nasm -f elf -dOS_LINUX Interface.asm
2048.o: 2048.asm
	nasm -f elf -dOS_LINUX 2048.asm
2048: Work_Matrix.o Work_Files.o Interface.o 2048.o
	ld -m elf_i386 Work_Matrix.o Work_Files.o Interface.o 2048.o -o 2048
