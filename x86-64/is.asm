; Hand-written. In this exercise we sort using the insertion sort alg.
; the array numbers and we print out the result
; This exercise allows me to gain some confidence in asm writing and to
; appreciate the work that has been done by the human race with the
; introduction of compilers and AI.
; However you have got to know your stuff to check what AI produces.
BITS 64
section .data
	numbers dq 9, 8, 7, 6, 5, 4, 3, 2
	numbers_length equ ($ - numbers) / 8
	space db " "
	newline db 10
	
section .bss
	buffer resb 128

section .text
	global _start

_start:
	call _print_buffer
        call _sort
	call _print_buffer
	jmp _end	


_print_buffer:
	; Loop throug the array and print it out
	xor rbx, rbx ; i = 0
	mov rcx, numbers_length ; length
	mov rsi, numbers

.loop_start:
	cmp rbx, rcx
	jge .loop_end
	mov rax, [rsi + rbx * 8]
	
	; Translate to ASCII
	add rax, 0x30
	mov [buffer + rbx], rax
	inc rbx
	jmp .loop_start

.loop_end:

	; Write null terminator character
	mov byte [buffer + rbx], 0x0

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, numbers_length
	syscall
	ret

_sort:
	xor rsi, rsi ; i = 0
	xor rdi, rdi ; j = 0
	mov rcx, numbers
	
.sort_loop_begin_rsi:
	cmp rsi, numbers_length
	jge .sort_loop_end
	mov rax, [numbers + rsi * 8]
	mov rdi, rsi ; j = i

.sort_loop_begin_rdi:
	cmp rdi, numbers_length
	jge .sort_loop_increment_rsi
	cmp rax, [numbers + rdi * 8]
	jle .sort_loop_increment_rdi ; Nothing to be done alreay sorted
	
	; swap positions
	mov rdx, [numbers + rdi * 8] 
	mov [numbers + rdi * 8], rax
	mov [numbers + rsi * 8], rdx

.sort_loop_increment_rdi:
	inc rdi
	jmp .sort_loop_begin_rdi

.sort_loop_increment_rsi:
	inc rsi
	jmp .sort_loop_begin_rsi

.sort_loop_end:
	ret
	

_end:
	; exit(0)
	mov rax, 0x3c
	mov rdi, 0x00
	syscall
	



