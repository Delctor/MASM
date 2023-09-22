.data
array QWORD 10, 20, 30, 40

masks REAL8 19342813113834066795298816.0, 4503599627370496.0, 19342813118337666422669312.0

divisor REAL8 18446744073709551615.0;

.code
random_generator proc
	

	; Get seed directions
	lea rbx, array

	; For remaining elements

	mov r10, rdx

	mov r9, 4
	mov rax, rdx
	xor rdx, rdx

	div r9
	
	sub r10, rdx

	; Individual seed

	mov r11, rcx

	mov rsi, r11
	shl rsi, 10
	xor r11, rsi
	mov rsi, r11
	shr rsi, 5
	xor r11, rsi
	mov rsi, r11
	shl rsi, 16
	xor r11, rsi

	xor r9, r9
setSeedsLoop:
	mov rsi, rcx
	shl rsi, 13
	xor rcx, rsi
	mov rsi, rcx
	shr rsi, 7
	xor rcx, rsi
	mov rsi, rcx
	shl rsi, 17
	xor rcx, rsi
	
	mov QWORD PTR [rbx + r9 * 8], rcx

	inc r9

	cmp r9, 4

	jl setSeedsLoop

	vmovapd ymm0, ymmword PTR [rbx]

	lea rbx, masks

	vbroadcastsd ymm4, REAL8 PTR [rbx]

	vbroadcastsd ymm5, REAL8 PTR [rbx + 8]

	vbroadcastsd ymm6, REAL8 PTR [rbx + 16]

	lea rbx, divisor

	vbroadcastsd ymm7, REAL8 PTR [rbx]

	;----

	xor r9, r9

	cmp r9, r10
	
	je fillArrayLoopSimdFinished
	
fillArrayLoopSimd:
	; 1
	vpsllq ymm1, ymm0, 13
	vpxor ymm0, ymm0, ymm1
	; 2
	vpsrlq ymm1, ymm0, 7
	vpxor ymm0, ymm0, ymm1
	; 3
	vpsllq ymm1, ymm0, 17
	vpxor ymm0, ymm0, ymm1

	; uint64 to double

	vpsrlq ymm1, ymm0, 32

	vpor ymm1, ymm1, ymm4

	vpblendw ymm0, ymm0, ymm5, 204

	vsubpd ymm1, ymm1, ymm6

	vaddpd ymm0, ymm1, ymm0

	vdivpd ymm0, ymm0, ymm7

	; Store

	vmovupd ymmword PTR [r8 + r9 * 8], ymm0
	
	add r9, 4

	cmp r9, r10
	
	jl fillArrayLoopSimd
	
fillArrayLoopSimdFinished:


	add r10, rdx

	cmp r9, r10
	
	je fillArrayLoopNoSimdFinished

fillArrayLoopNoSimd:
	; 1
	mov rsi, r11
	shl rsi, 13
	xor r11, rsi
	; 2
	mov rsi, r11
	shr rsi, 7
	xor r11, rsi
	; 3
	mov rsi, r11
	shl rsi, 17
	xor r11, rsi

	; uint64 to double

	movddup xmm1, xmm0

	pinsrq xmm0, r11, 0

	psrlq xmm0, 32

	por xmm0, xmm4

	pblendw xmm1, xmm5, 204

	subpd xmm0, xmm6

	addpd xmm0, xmm1

	divpd xmm0, xmm7

	; Store

	movsd REAL8 PTR [r8 + r9 * 8], xmm0

	inc r9

	cmp r9, r10

	jl fillArrayLoopNoSimd

fillArrayLoopNoSimdFinished:

	ret
random_generator endp

end
