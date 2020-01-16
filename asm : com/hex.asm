;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Startadresse für kleine MSDOS-Programme (.com)
	org 100h

	; Programm startet hier

	; Datenzugriff über Datensegmentregister vorbereiten
	mov AX, CS
	mov DS, AX

	; Sprung zum Hauptprogramm
	jmp start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Datenbereich

	; ein paar Beispieltexte mit Zeilenwechseln,
	; terminiert mit '$' zur Ausgabe mit DOS-Funktion 9
	; separators wurden hinzugefügt für die Übersicht
separator	db '<--------->',13,10,'$'
bit	db '<--8 Bit (Byte)-->',13,10,'$'
bit2 db '<-16 Bit (Wort)-->',13,10,'$'
bit3 db '<--4 Bit (Byte)-->',13,10,'$'
bit4 db '<--4 Bit (Halbbyte)-->',13,10,'$'
newline	db 13,10,'$'

	; ein paar Zahlenwerte für Beispielberechnungen
	; neue Werte die zufällig gewählt wurden, wurden hinzugefügt
a	db 23h
b	db 85h
c   db 35h
d   db 27h
e   db 1h
f   db 2h

w	dw 89ABh
x   dw 1234h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hauptprogramm
; Konvention zur Parameterübergabe (Subroutinen s.u.) in diesem Programm:
; Register AX bzw. AL für Daten (Zahlenwerte)
; Register DX für Adressen
start:

	; Ausgabe 16Bit Einfache Ausgabe der 16 bit Pfeile
	; Dient lediglich zum veranschaulichen 
	mov DX, bit2
	call outstring

	; Hex-Wort ausgeben
	; Als Methode wird outhexword aufgerufen (Funktion steht unten)
	mov AX, [x]
	call outhexword
	call outnewline

	; Hex-Wort aus Speicher-Variable laden und ausgeben
	; Als Methode wird outhexword aufgerufen (Funktion steht unten)
	mov AX, [w]
	call outhexword
	call outnewline

	; Ausgbe der Separator String
	; Dient lediglich zum veranschaulichen 
	mov DX, separator
	call outstring
	call outnewline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Ausgabe 8Bit Einfache Ausgabe der 8 bit Pfeile
	; Dient lediglich zum veranschaulichen 
	mov DX, bit
	call outstring

	; Hex-Wort aus Byte (8 Bit) hexadezimal ausgeben (2 Ziffern)
	mov AL, [w]	Ausgabewert
	call outhexbyte  
	call outnewline

	; Die Werte werden entnommen und mit der Methode 'outhexbyte' verarbeitet
	; Als Methode wird outhexbyte aufgerufen (Funktion steht unten)
	mov AL, [a] 
	add AL, [b]
	call outhexbyte
	call outnewline

	; Hex-Wort aus Byte (8 Bit) hexadezimal ausgeben (2 Ziffern)
	mov AL, [x]	Ausgabewert
	call outhexbyte  
	call outnewline
	
	; Die Werte werden entnommen und mit der Methode 'outhexbyte' verarbeitet
	; Als Methode wird outhexbyte aufgerufen (Funktion steht unten)
	mov AL, [c]
	add AL, [d]
	call outhexbyte
	call outnewline

	; Ausgbe der Separator String
	; Dient lediglich zum veranschaulichen 
	mov DX, separator
	call outstring
	call outnewline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Ausgabe 4Bit Einfache Ausgabe der 4 bit Pfeile
	; Dient lediglich zum veranschaulichen 
	mov DX, bit3
	call outstring
	
	; Hex-Wort aus Byte (4 Bit) hexadezimal ausgeben (2 Ziffern)
	; Als Methode wird outhexdigit aufgerufen (Funktion steht unten)
	mov AL, [w]	Ausgabewert
	call outhexdigit 
	call outnewline

	; Ausgbe der Separator String
	; Dient lediglich zum veranschaulichen 
	mov DX, separator
	call outstring
	call outnewline

	; Ausgabe 4Bit Einfache Ausgabe der 4 bit Pfeile
	; Dient lediglich zum veranschaulichen 
	mov DX, bit4
	call outstring

	; Hex-Wort aus Byte (4 Bit) hexadezimal ausgeben (2 Ziffern)
	; Als Methode wird outhexdigit_1 aufgerufen (Funktion steht unten)
	mov AL, [x]	Ausgabewert
	call outhexdigit_1 
	call outnewline

	; Ausgbe der Separator String 
	; Dient lediglich zum veranschaulichen
	mov DX, separator
	call outstring
	call outnewline

finish:	; terminate program
	mov AH, 4Ch
	int 21h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subroutinen (Unterprogramme)
; Konvention zur Parameterübergabe in diesem Programm:
; Register AX bzw. AL für Daten (Zahlenwerte)
; Register DX für Adressen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Textausgabe

; outnewline: Zeilenwechsel ausgeben (CR and LF)
outnewline:
	mov DX, newline
	; fall-through
	; v
	; v
; outstring: Textstring ausgeben, terminiert mit '$'
; DX: Adresse des Strings
outstring:
	mov AH, 9	; DOS-Funktion 9: '$'-terminierten String ausgeben
	int 21h		; DOS aufrufen
	ret

; outchar: Zeichen ausgeben
; AL: Code des Zeichens
outchar:
	mov DL, AL
	mov AH, 2	; DOS-Funktion 2: Zeichen aus DL ausgeben
	int 21h		; DOS aufrufen
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routinen zur Zahlenausgabe

; outhexword: Wort (16 Bit) hexadezimal ausgeben (4 Ziffern)
; AX: Ausgabewert
outhexword:
	push AX		; zweites Byte retten
	mov AL, AH	; erstes Byte als Parameter bereitstellen
	call outhexbyte	; erstes Byte ausgeben
	pop AX		; zweites Byte zurückholen
	call outhexbyte	; zweites Byte ausgeben
	ret

; outhexbyte: Byte (8 Bit) hexadezimal ausgeben (2 Ziffern)
; AL: Ausgabewert
outhexbyte:
	push AX		; zweite Ziffer retten
	shr AL, 4	; erste Ziffer (Halbbyte) zurechtschieben
	call outhexdigit
	pop AX		; zweite Ziffer zurückholen
	call outhexdigit
	ret

; outhexdigit: Halbbyte (4 Bit) hexadezimal ausgeben (1 Ziffer)
; AL (bits 3..0): Ausgabewert
outhexdigit:
	and AL, 0Fh	; maskieren: obere 4 Bits auf 0000 setzen
	cmp AL, 10	; prüfen ob dezimal (< 10)
	jl outhexdigit_1	; falls ja, Hexadezimalanpassung überspringen
	add AL, 'A'-10-'0'	; addiere zusätzlichen Offset für Hex-Ziffern
outhexdigit_1:
	add AL, '0'	; addiere Offset für ASCII Ziffern-Zeichen
	jmp outchar	; Zeichen ausgeben (return von outchar)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Funktion wurden aus den nächsten Übungen entnommen, jedoch nicht verwendet
outdecAL1loop:
	mov AH, 0	; clear upper byte for division
	mov BL, 10	; prepare for division by 10
	div BL
	mov DL,AH
	dec DI
	add DL, '0'
	mov [DI], DL
	cmp AL, 0
	jnz outdecAL1loop
	mov DX, DI
	jmp outstring

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ende der Übersetzung
	end