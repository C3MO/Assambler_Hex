;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Startadresse für kleine MSDOS-Programme (.com)
    org 100h

    ; Datenzugriff über Datensegmentregister vorbereiten
    mov AX, CS
    mov DS, AX
    jmp start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Datenbereich
separator    db '<--------->',13,10,'$'
bit8         db '<--8 Bit (Byte)-->',13,10,'$'
bit16        db '<-16 Bit (Wort)-->',13,10,'$'
bit4a        db '<--4 Bit (Byte)-->',13,10,'$'
bit4b        db '<--4 Bit (Halbbyte)-->',13,10,'$'
newline      db 13,10,'$'

; Zahlenwerte für Beispielberechnungen
a    db 23h
b    db 85h
c    db 35h
d    db 27h
w    dw 89ABh
x    dw 1234h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hauptprogramm
start:
    ; 16-Bit Ausgabe Demo
    mov DX, bit16
    call outstring
    mov AX, [x]
    call outhexword
    call outnewline
    mov AX, [w]
    call outhexword
    call outnewline
    mov DX, separator
    call outstring
    call outnewline

    ; 8-Bit Ausgabe Demo
    mov DX, bit8
    call outstring
    mov AL, [w]
    call outhexbyte  
    call outnewline
    mov AL, [a] 
    add AL, [b]
    call outhexbyte
    call outnewline
    mov AL, [x]
    call outhexbyte  
    call outnewline
    mov AL, [c]
    add AL, [d]
    call outhexbyte
    call outnewline
    mov DX, separator
    call outstring
    call outnewline

    ; 4-Bit Ausgabe Demo
    mov DX, bit4a
    call outstring
    mov AL, [w]
    call outhexdigit 
    call outnewline
    mov DX, separator
    call outstring
    call outnewline
    mov DX, bit4b
    call outstring
    mov AL, [x]
    call outhexdigit_1 
    call outnewline
    mov DX, separator
    call outstring
    call outnewline

    ; Neue Dezimalausgabe-Funktionen demonstrieren
    mov DX, bit8
    call outstring
    mov AL, [a]
    call outdecbyte  ; Neue 8-Bit Dezimalausgabe
    call outnewline
    mov AX, [w]
    call outdecword  ; Neue 16-Bit Dezimalausgabe
    call outnewline

finish:
    mov AH, 4Ch
    int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Textausgabe Funktionen
outnewline:
    mov DX, newline
outstring:
    mov AH, 9
    int 21h
    ret

outchar:
    mov DL, AL
    mov AH, 2
    int 21h
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hexadezimale Ausgabe Funktionen
outhexword:
    push AX
    mov AL, AH
    call outhexbyte
    pop AX
    call outhexbyte
    ret

outhexbyte:
    push AX
    shr AL, 4
    call outhexdigit
    pop AX
    call outhexdigit
    ret

outhexdigit:
    and AL, 0Fh
    cmp AL, 10
    jl outhexdigit_1
    add AL, 'A'-10-'0'
outhexdigit_1:
    add AL, '0'
    jmp outchar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Neue Dezimalausgabe Funktionen (8-Bit und 16-Bit)
outdecbyte:
    ; Konvertiert AL (8-Bit) zu Dezimal und gibt aus
    mov AH, 0
    call outdecword  ; Wiederverwendung der 16-Bit Funktion
    ret

outdecword:
    ; Konvertiert AX (16-Bit) zu Dezimal und gibt aus
    pusha
    mov CX, 0       ; Zähler für Stellen
    mov BX, 10      ; Divisor

convert_loop:
    mov DX, 0
    div BX          ; AX / 10 -> Quotient in AX, Rest in DX
    push DX         ; Rest (Ziffer) speichern
    inc CX
    cmp AX, 0
    jnz convert_loop

print_loop:
    pop DX
    add DL, '0'     ; Ziffer in ASCII umwandeln
    mov AH, 02h
    int 21h
    loop print_loop

    popa
    ret

end
