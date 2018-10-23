# 1 "src/x86/kernel/interrupts/interrupts.S"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "src/x86/kernel/interrupts/interrupts.S"


# 1 "src/x86/kernel/include/kernel.h" 1
# 4 "src/x86/kernel/interrupts/interrupts.S" 2

.macro name
 .extern \name_handler
 .global \name_handler
 .global \name
 \name:
  pusha
  call \name_handler
  popa
  iret
.endm

interrupt irq0
interrupt irq1
interrupt irq2
interrupt irq3
interrupt irq4
interrupt irq5
interrupt irq6
interrupt irq7
interrupt irq8
interrupt irq9
interrupt irq10
interrupt irq11
interrupt irq12
interrupt irq13
interrupt irq14
interrupt irq15


.global load_idt
load_idt:
 cli
 movl 4(%esp), %edx
 lidt (%edx)
 sti
 ret
