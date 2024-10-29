assume cs:code, ss:stack

stack segment
    db 512 dup(0)
stack ends

code segment
    int7ch:

    cmp ah, 0
    je d1
    cmp ah, 1
    je d2
    cmp ah, 2
    je d3
    cmp ah, 3
    je d4

    d1:
    call int7ch_s1
    jmp short int7ch_ends
    d2:
    call int7ch_s2
    jmp short int7ch_ends
    d3:
    call int7ch_s3
    jmp short int7ch_ends
    d4:
    call int7ch_s4
    jmp short int7ch_ends
    ; 调用自定义子程序

    
    int7ch_ends:
    iret

    int7ch_s1:
    push ax
    push bx
    push cx
    push ds

    mov ax, 0b800h
    mov ds, ax
    mov bx, 0
    mov cx, 2000
    clear_screen:
    mov byte ptr [bx], ' '
    add bx, 2h
    loop clear_screen

    pop ds
    pop cx
    pop bx
    pop ax
    ret

    int7ch_s2:
    push ax
    push bx
    push cx
    push ds

    push ax
    mov ax, 0b800h
    mov ds, ax
    pop ax
    mov bx, 1
    mov cx, 2000
    set_front_color:
    and byte ptr [bx], 11111000b
    or [bx], al
    add bx, 2
    loop set_front_color

    pop ds
    pop cx
    pop bx
    pop ax
    ret

    int7ch_s3:
    push ax
    push bx
    push cx
    push ds

    push ax
    mov ax, 0b800h
    mov ds, ax
    pop ax
    mov bx, 1
    mov cx, 2000
    set_bg_color:
    and byte ptr [bx], 10001111b
    or [bx], al
    add bx, 2
    loop set_bg_color

    pop ds
    pop cx
    pop bx
    pop ax
    ret

    int7ch_s4:
    push ax
    push bx
    push cx
    push si
    push di
    push ds
    push es

    mov cx, 24

    mov ax, 0b800h
    mov ds, ax
    mov es, ax

    mov si, 160
    mov di, 0
    cld

    up_one_line:
    push cx
    mov cx, 160
    rep movsb

    add si, 160h
    pop cx
    loop up_one_line

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret

    int7ch_nop:
    nop



    start:
    ; 1 迁移代码

    mov ax, cs
    mov ds, ax
    mov ax, offset int7ch
    mov si, ax

    mov ax, 0
    mov es, ax
    mov di, 204h

    mov cx, offset int7ch_nop - offset int7ch
    cld
    rep movsb

    ; 2 设置中断向量表
    mov ax, 0
    mov ds, ax
    push ds:[7ch * 4]
    push ds:[7ch * 4 + 2]
    pop ds:[202h]
    pop ds:[200h] ; 保存默认中断的程序地址

    cli
    mov word ptr ds:[7ch * 4], 204h
    mov word ptr ds:[7ch * 4 + 2], 0h
    sti

    mov ah, 3
    mov al, 01000000b
    int 7ch

    mov ax, 4c00h
    int 21h
    
code ends

end start

