
#include <video.h>
#include <multiboot2.h>
#include <bootconstants.h>
#include <kernel.h>
#include <system.h>

void kmain(void * multiboot_structure){
	UNUSED(multiboot_structure);

	system_init();

	kernel_puts("Hello, world!\n");
	// asm volatile ("int $1");

	// int a = 0;
	// int b = 0;
	// printf("%i,%i,%i\n",a,b,b/a);

	// struct multiboot_header mbheader = *((struct multiboot_header *)multiboot_structure);
	// // printf("%x\n",mbheader->magic);
	// int b = 0;
	// int * a = &b;
	// printf("%x\n",mbheader);
	// printf("%x\n",(int)a);



}