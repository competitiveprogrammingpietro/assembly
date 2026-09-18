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
	
	; exit(0)
	mov rax, 0x3c
	mov rdi, 0x00
	syscall

; Trivial routine which prints out the numbers array in ASCII format
_print_buffer:

	; Loop through the array and print it out
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

	; Write a separator '\n'
	mov byte [buffer + rbx], 0x0a

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, numbers_length + 1 ; One for the '='
	syscall
	ret

; End _print_buffer

; Insertion sort algorithm
_sort:
	xor rsi, rsi ; i = 0
	xor rdi, rdi ; j = 0
	mov rcx, numbers
	mov rsi, 0x1 ; i = 1
	
.sort_loop_begin_rsi:
	cmp rsi, numbers_length + 1
	jge .sort_loop_end
	lea rdi, [rsi - 1] ; j = i - 1

.sort_loop_begin_rdi:
	cmp rdi, 0
	jl .sort_loop_increment_rsi
	mov rax, [numbers + rdi * 8]
	mov rbx, [numbers + (rdi -1) * 8]
	cmp rax, rbx
	jge .sort_loop_decrement_rdi ; Nothing to be done alreay sorted
	
	; swap positions
	mov [numbers + (rdi -1) * 8], rax
	mov [numbers + rdi * 8], rbx

.sort_loop_decrement_rdi:
	dec rdi
	jmp .sort_loop_begin_rdi

.sort_loop_increment_rsi:
	inc rsi
	jmp .sort_loop_begin_rsi

.sort_loop_end:
	ret
	

	



