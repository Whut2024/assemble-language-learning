assume cs:code, ss:stack, ds:data

data segment
    db 'Hello World!', 0
data ends

stack segment
    db 512 dup(0)
stack ends

code segment
    letterc:

    push ax
    push bx
    push cx
    push ds

    mov ax, data
    mov ds, ax

    mov bx, 0

    mov cx, 0
    transform:
    mov cl, [bx]
    jcxz transform_over
    cmp cl, 97
    jl next_char
    cmp cl, 122
    jg next_char
    and cl, 11011111b
    mov [bx], cl
    next_char:
    inc bx
    jmp short transform

    transform_over:

    pop ds
    pop cx
    pop bx
    pop ax

    mov ax, 4c00h
    int 21h

code ends

end letterc