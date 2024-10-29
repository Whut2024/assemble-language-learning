assume cs:code, ds:data, ss:stack

data segment
    db '00/00/00 00:00:00', '$'
data ends

stack segment
    db 256 dup(0)
stack ends

code segment
    start:

    mov ax, data
    mov ds, ax

    mov si, 0
    mov al, 9
    call transport

    add si, 3h
    mov al, 8
    call transport

    add si, 3h
    mov al, 7
    call transport

    add si, 3h
    mov al, 4
    call transport

    add si, 3h
    mov al, 2
    call transport

    add si, 3h
    mov al, 0
    call transport


    mov ah, 2
    mov bh, 0
    mov dh, 5
    mov dl, 12
    int 10h

    mov dx, 0
    mov ah, 9
    int 21h

    mov ax, 4c00h
    int 21h
    

    transport:
    push ax
    push cx

    out 70h, al
    in al, 71h
    
    mov ah, al
    mov cl, 4
    shr ah, cl
    and al, 0fh
    add ah, 30h
    add al, 30h

    mov [si], ah
    mov [si + 1], al

    pop cx
    pop ax
    ret

code ends

end start