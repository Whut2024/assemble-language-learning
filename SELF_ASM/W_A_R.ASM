assume cs:code, ss:stack

stack segment
    db 512 dup(0)
stack ends

code segment
    int7ch:

    cmp ah, 1
    ja int7ch_ends

    push ax
    push bx
    push cx
    push dx

    add ah, 2 ; 写入或者读取
    mov al, 1 ; 操作扇区的数量
    push ax
    push bx

    mov ax, dx
    mov dx, 0
    mov bx, 1440
    div bx
    push dx ; 盘面号
    mov ax, dx
    mov dx, 0
    mov bx, 18
    div bx
    mov ch, al ; 磁道号
    inc dx
    mov cl, dl ; 扇区号
    
    pop dx
    mov dh, dl ; 盘面号
    mov dl, 0 ; 驱动号
    pop bx
    pop ax

    int 13h

    pop dx
    pop cx
    pop bx
    pop ax
    int7ch_ends:
    iret
    int7ch_nop:
    nop  

    start:
    mov ax, stack
    mov ss, ax
    mov sp, 512

    mov ax, cs
    mov ds, ax
    mov si, offset int7ch

    mov ax, 0
    mov es, ax
    mov di, 200h

    mov cx, offset int7ch_nop - offset int7ch
    cld
    rep movsb

    cli
    mov word ptr es:[7ch * 4 + 2], 0
    mov word ptr es:[7ch * 4], 200h
    sti


    mov dx, 80h
    mov ax, 073fh
    mov es, ax
    mov bx, 100h
    mov ax, 0
    int 7ch

    mov ax, 4c00h
    int 21h

code ends

end start