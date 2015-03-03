//////////////////////////////////////////////////////////////////////
// File: system.h

#ifndef __SYSTEM_H
#define __SYSTEM_H

/* Check if the compiler thinks if we are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif
 
/* This kernel only work for the 32-bit ix86 targets at the moment. */
#if !defined(__i386__)
#error "You need a ix86 compatible gcc cross-compiler to build this kernel."
#endif

/* gdt.c */
extern void gdt_install();
extern void gdt_set_gate(int num,
			 unsigned long base,
			 unsigned long limit,
			 unsigned char access,
			 unsigned char gran);

/* idt.c */
extern void idt_install();
extern void idt_set_gate(unsigned char num,
			 unsigned long base, 
			 unsigned short sel, 
			 unsigned char flags);

/* MAIN.C */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern unsigned char *memset(unsigned char *dest, unsigned char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern unsigned int strlen(const char *str);
extern unsigned char inportb (unsigned short _port);
extern void outportb (unsigned short _port, unsigned char _data);

/* SCRN.C */
extern  void cls();
extern void putch(unsigned char c);
extern void puts(unsigned char *str);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);
extern void init_video();
#endif

extern unsigned short has_cpuid();
