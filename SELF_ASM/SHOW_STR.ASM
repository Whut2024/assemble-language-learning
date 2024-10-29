assume cs:code

data segment
    db 'Hello World', 0
data ends

position segment
    db '1', 0
    db '2', 0
    db '3', 0
    db '4', 0
    db '5', 0
    db '6', 0
    db '7', 0
    db '8', 0
position ends

code segment
    show_str:
    push ax
    push es
    push bx
    push si

    mov ax, 0b800h
    mov es, ax

    mov ax, 0
    mov al, 0a0h
    dec dh
    mul dh
    inc dh
    mov bx, ax
    
    mov ax, 0
    mov al, 2
    dec dl
    mul dl
    inc dl
    add bx, ax

    print:
    mov al, [si]
    cmp al, 0
    je show_str_end
    mov es:[bx], al
    mov es:[bx + 1], cl
    inc si
    add bx, 2h
    jmp short print
    
    show_str_end:
    pop si
    pop bx
    pop es
    pop ax
    ret


    start:
    mov dh, 8
    mov dl, 3
    mov cl, 2

    mov ax, data
    mov ds, ax
    mov si, 0

    call show_str

    mov bx, 1
    mov dl, 1
    mov ax, position
    mov ds, ax
    s:
    mov dh, bl

    call show_str
    add si, 2h
    inc bl

    cmp bl, 9
    jne s

    mov ax, 4c00h
    int 21h
code ends

end start