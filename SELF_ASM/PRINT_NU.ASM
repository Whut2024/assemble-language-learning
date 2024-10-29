assume cs:code, ss:stack

string segment
    db 256 dup(0)
string ends

stack segment
    db 64 dup(0)
stack ends


code segment
    dtoc:
    push ax
    push cx
    push dx
    push si

    mov bx, 0
    push bx
    
    mov cx, 1h
    mov bx, 10

    dtoc_start:
    jcxz dtoc_reverse
    div bx
    add dx, 30h
    push dx
    mov dx, 0
    mov cx, ax
    jmp short dtoc_start

    dtoc_reverse:
    pop cx
    jcxz dtoc_end
    mov [si], cl
    inc si
    jmp short dtoc_reverse

    dtoc_end:
    mov ah, 0
    mov [si], ah

    pop si
    pop dx
    pop cx
    pop ax
    ret


    start:
    mov ax, stack
    mov ss, ax
    mov sp, 64

    mov ax, string
    mov ds, ax
    mov si, 0h

    mov ax, 0h
    mov dx, 1h

    call dtoc

    mov ax, 4c00h
    int 21h 

code ends

end start