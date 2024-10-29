assume cs:code, ss:stack

stack segment
    db 256 dup(0)
stack ends

code segment
    start:
    mov ax, stack
    mov ss, ax
    mov sp, 256

    mov ah, 2
    mov bh, 0
    mov dh, 5
    mov dl, 12
    int 10h

    mov ah, 9
    mov al, 'a'
    mov bl, 11001010b
    mov bh, 0
    mov cx, 3
    int 10h

    mov ax, 4c00h
    int 21h

code ends

end start