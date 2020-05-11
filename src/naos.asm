    BITS 16

start:
    ; Set up 4k of stack space
    mov ax, 07C0h
    add ax, 288
    mov ss, ax
    mov sp, 4069

    ; Set data segment
    mov ax, 07C0h
    mov ds, ax

    mov si, loading_string
    call print_string
    mov bh, 09h
    call wait_dot

    mov si, welcome_string
    call print_string

    call wait_for_key

    mov si, exit_string
    call print_string
    mov bh, 05h
    call wait_dot

    call shutdown

    mov si, error_string
    call print_string

    jmp $

    newline db 0x0D, 0x0A, 0
    loading_string db 'Loading', 0
    welcome_string db 'Welcome to NaOS!', 0x0D, 0x0A, 'Press any key to continue...', 0x0D, 0x0A, 0
    exit_string db 'Thank you for using NaOS!', 0x0D, 0x0A, 'Exiting', 0
    error_string db 'If you can read this something has gone terribly wrong. Blame the devs or something.', 0x0D, 0x0A, 0

print_string:
    mov ah, 0Eh
.loop:
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .loop
.done:
    ret

wait_dot:
    mov al, 0
    mov dx, 0
.loop:
    dec bh
    cmp bh, 0
    je .done

    mov ah, 86h
    mov cx, 09h
    int 15h

    mov al, '.'
    mov ah, 0Eh
    int 10h

    jmp .loop
.done:
    mov si, newline
    call print_string
    ret

wait_for_key:
    mov ah, 00h
    int 16h
    ret

shutdown:
    mov ax, 0x1000
    mov ax, ss
    mov sp, 0xF000
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 15h
    ret

end:
    times 510-($-$$) db 0
    dw 0xAA55