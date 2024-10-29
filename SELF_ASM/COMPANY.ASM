assume cs:code, ds:data, ss:stack

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'
    ;以上是表示21年的21个字符串

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ;以上是表示21年公司总收入的21个dword型数据

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
    ;以上是表示21年公司雇员人数的21个word型数据

data ends

string segment 
    dw 32 dup(0)
string ends

stack segment
    db 512 dup(0)
stack ends

table segment
    db 21 dup('year summ ne ?? ')
table ends

code segment

    divdw:
    push bx
    
    push ax ; 存储传入的参数

    mov ax, dx ; 安排 H / N
    mov dx, 0  ; ax = H dx = 0
    div cx ; 此时ax已经为最终结果的高位, dx 为余数

    pop bx ; 取出被除数低位 L

    push ax ; 存储 H / N 结果的商
    
    mov ax, bx
    div cx ; 此时ax已经为最终结果的低位
    mov cx, dx ; 最终结果余数

    pop dx ; 设置最终结果的高位
    
    pop bx
    ret



    dtoc:
    push ax
    push bx
    push cx
    push dx
    push si

    mov bx, 0
    push bx

    dtoc_start:
    mov cx, 10
    call divdw
    add cx, 30h
    push cx
    mov bx, ax
    add bx, dx
    cmp bx, 0
    jne dtoc_start
    
    dtoc_reverse:
    pop cx
    mov [si], cl
    inc si
    cmp cx, 0
    jne dtoc_reverse

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret



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


    copy_company_table:
    push ax
    push cx
    push ds
    push es
    push si
    push di

    mov ax, data
    mov ds, ax

    mov ax, table
    mov es, ax

    mov cx, 21
    mov si, 0h
    mov di, 0h
    s0:
    mov ax, [si]
    mov es:[di], ax
    mov ax, [si + 2]
    mov es:[di + 2], ax
    add si, 4h
    add di, 10h
    loop s0

    mov cx, 21
    mov di, 5h
    s1:
    mov ax, [si]
    mov es:[di], ax
    mov ax, [si + 2]
    mov es:[di + 2], ax
    add si, 4h
    add di, 10h
    loop s1


    mov cx, 21
    mov di, 0ah
    s2:
    mov ax, [si]
    mov es:[di], ax
    add si, 2h
    add di, 10h
    loop s2


    mov cx, 21
    mov di, 5h
    s3:
    mov ax, es:[di]
    mov dx, es:[di + 2]
    div word ptr es:[di + 5]
    mov es:[di + 8], ax
    add di, 10h
    loop s3


    pop di
    pop si
    pop es
    pop ds
    pop cx
    pop ax
    ret



    start:
    mov ax, stack
    mov sp, 512

    call copy_company_table; 完成表格初始化

    
    mov di, 0
    
    mov cx, 5
    t0:
    push cx
    mov ax, table
    mov es, ax
    mov ds, ax
    mov si, di
    mov dl, 1
    mov dh, cl
    mov cx, 2
    call show_str ; 年份

    mov ax, string
    mov ds, ax
    mov si, 0
    mov ax, es:[di + 5]
    mov dx, es:[di + 7]
    call dtoc ; 转数字为字符串
    mov dl, 6
    pop cx
    push cx
    mov dh, cl
    mov cx, 2
    call show_str ; 收入

    mov ax, es:[di + 0ah]
    mov dx, 0h
    call dtoc ; 转数字为字符串
    mov dl, 20
    pop cx
    push cx
    mov dh, cl
    mov cx, 2
    call show_str ; 雇员

    mov ax, es:[di + 0dh]
    mov dx, 0h
    call dtoc ; 转数字为字符串
    mov dl, 30
    pop cx
    push cx
    mov dh, cl
    mov cx, 2
    call show_str ; 人均

    add di, 10h

    pop cx
    inc cx
    cmp cx, 26
    jne t0

    

    ; 打印

    mov ax, 4c00h
    int 21h

code ends

end start
