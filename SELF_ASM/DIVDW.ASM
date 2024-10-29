assume cs:code, ds:data, ss:stack

data segment

data ends

stack segment
    db 32 dup('0')
stack ends

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




    start:
    mov ax, 0ah
    mov dx, 0h
    mov cx, 4h
    call divdw

    mov ax, 4c00h
    int 21h

code ends

end start