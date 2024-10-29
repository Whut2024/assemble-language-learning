assume cs:code, ss:stack

stack segment
    db 256 dup(0)
stack ends

code segment
    start:
    mov ax, cs
    mov ds, ax
    mov ax, offset over_flow
    mov si, ax

    mov ax, 0
    mov es, ax
    mov ax, 200h
    mov di, ax

    mov cx, offset over_flow_ends - offset over_flow
    cld
    rep movsb

    mov ax, 0
    mov ds, ax
    mov ds:[2], ax
    mov ax, 200h
    mov ds:[0], ax

    mov ax, 4c00h
    int 21h


    over_flow:
    jmp short over_flow_start
    db 'Over Flow!'

    over_flow_start:
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov ax, 0
    mov ds, ax
    mov si, 202h

    mov ax, 0b800h
    mov es, ax
    mov di, 12 * 160 + 36 * 2

    mov cx, 10
    over_flow_translate:
    mov al, [si]
    mov es:[di], al
    mov byte ptr es:[di + 1], 2
    inc si
    add di, 2h
    loop over_flow_translate

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    over_flow_ends: nop

code ends

end start