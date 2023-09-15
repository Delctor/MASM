.data
array DWORD 10, 20, 30, 40, 50
index DWORD  3

.code
func proc
	mov r8, OFFSET array
	mov r9d, index

	mov r10d, DWORD PTR [r8 + r9 * 4]

	mov eax, r10d

	ret
func endp
end