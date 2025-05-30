;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Grafikprogramm für Linien und Formen
    org 100h
    mov AX, CS
    mov DS, AX
    jmp start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Datenbereich
moin        db 'Grafikmodus Demo - Druecke eine Taste',13,10,'$'
separator   db '--------------------',13,10,'$'
s_beg       dw 0        ; Anfangsspalte
s_end       dw 0        ; Endspalte
z_beg       dw 0        ; Anfangszeile
z_end       dw 0        ; Endzeile
farbe       db 2        ; Standardfarbe (grün)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hauptprogramm
start:
    ; Startnachricht ausgeben
    mov DX, moin
    mov AH, 9
    int 21h

    ; Auf Tastendruck warten
    call wait_key

    ; Grafikmodus setzen (640x480 16 Farben)
    mov AX, 12h
    int 10h
    mov BX, 1        ; Hintergrundfarbe (blau)
    mov AH, 0Bh
    int 10h

    ; Linien demonstrieren
    call demo_linien

    ; Rechteck demonstrieren
    call demo_rechteck

    ; Kreis demonstrieren
    call demo_kreis

    ; Auf Tastendruck warten
    call wait_key

    ; Zurück zum Textmodus
    mov AX, 03h
    int 10h

    ; Programmende
    mov AH, 4Ch
    int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Demoroutinen
demo_linien:
    ; Diagonale Linie
    mov word [z_beg], 10
    mov word [s_beg], 10
    mov word [z_end], 100
    mov word [s_end], 100
    call draw_line

    ; Horizontale Linie
    mov word [z_beg], 50
    mov word [s_beg], 50
    mov word [z_end], 50
    mov word [s_end], 300
    call draw_line

    ; Vertikale Linie
    mov word [z_beg], 100
    mov word [s_beg], 400
    mov word [z_end], 300
    mov word [s_end], 400
    call draw_line
    ret

demo_rechteck:
    ; Rechteck zeichnen (x1, y1, x2, y2)
    mov word [s_beg], 400
    mov word [z_beg], 50
    mov word [s_end], 500
    mov word [z_end], 150
    call draw_rect
    ret

demo_kreis:
    ; Kreis zeichnen (Mittelpunkt x, y, Radius)
    mov word [s_beg], 300
    mov word [z_beg], 200
    mov word [s_end], 50    ; Radius
    call draw_circle
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Grafikfunktionen

; Wartet auf Tastendruck
wait_key:
    mov AH, 6
    mov DL, 0FFh
    int 21h
    jz wait_key
    ret

; Zeichnet eine Linie zwischen (s_beg, z_beg) und (s_end, z_end)
draw_line:
    pusha
    mov CX, [s_beg]
    mov DX, [z_beg]
    mov SI, [s_end]
    mov DI, [z_end]

    ; Delta berechnen
    mov AX, SI
    sub AX, CX
    mov [s_delta], AX
    mov AX, DI
    sub AX, DX
    mov [z_delta], AX

    ; Entscheide, welche Richtung mehr Schritte hat
    mov AX, [s_delta]
    cmp AX, 0
    jge dx_positive
    neg AX
dx_positive:
    mov BX, [z_delta]
    cmp BX, 0
    jge dy_positive
    neg BX
dy_positive:
    cmp AX, BX
    jg x_dominant

y_dominant:
    ; Y-dominante Linie
    call draw_line_y
    jmp line_done

x_dominant:
    ; X-dominante Linie
    call draw_line_x

line_done:
    popa
    ret

; Hilfsfunktion für x-dominante Linien
draw_line_x:
    ; Implementierung hier...
    ret

; Hilfsfunktion für y-dominante Linien
draw_line_y:
    ; Implementierung hier...
    ret

; Zeichnet ein Rechteck zwischen (s_beg, z_beg) und (s_end, z_end)
draw_rect:
    pusha
    ; Obere Linie
    mov CX, [s_beg]
    mov DX, [z_beg]
    mov SI, [s_end]
    mov DI, [z_beg]
    call draw_line_segment

    ; Rechte Linie
    mov CX, [s_end]
    mov DX, [z_beg]
    mov SI, [s_end]
    mov DI, [z_end]
    call draw_line_segment

    ; Untere Linie
    mov CX, [s_end]
    mov DX, [z_end]
    mov SI, [s_beg]
    mov DI, [z_end]
    call draw_line_segment

    ; Linke Linie
    mov CX, [s_beg]
    mov DX, [z_end]
    mov SI, [s_beg]
    mov DI, [z_beg]
    call draw_line_segment

    popa
    ret

; Zeichnet einen Kreis mit Mittelpunkt (s_beg, z_beg) und Radius s_end
draw_circle:
    pusha
    ; Midpoint circle algorithm
    mov CX, [s_beg]    ; x_center
    mov DX, [z_beg]    ; y_center
    mov SI, 0          ; x
    mov DI, [s_end]    ; y = radius
    mov AX, DI
    mov BX, 1
    sub BX, AX         ; p = 1 - radius

circle_loop:
    ; 8 Punkte zeichnen (Symmetrie)
    call draw_circle_points

    inc SI
    cmp BX, 0
    jg circle_skip_y
    add BX, SI
    add BX, SI
    inc BX
    jmp circle_next
circle_skip_y:
    dec DI
    mov AX, SI
    sub AX, DI
    add AX, AX
    add BX, AX
    inc BX
circle_next:
    cmp SI, DI
    jle circle_loop
    popa
    ret

; Hilfsfunktion für Kreis: Zeichnet 8 Punkte
draw_circle_points:
    ; Implementierung hier...
    ret

; Setzt einen Pixel an Position (CX, DX)
; Farbe: [farbe]
set_pixel:
    mov AH, 0Ch
    mov AL, [farbe]
    int 10h
    ret

end
