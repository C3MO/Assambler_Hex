;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Programm zur Ausgabe von Linien im Grafikmodus

; Programmbeginn: Datenzugriff vorbereiten, zum Programmcode springen
	org 100h
	mov AX,CS
	mov DS,AX
	jmp start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Daten definieren

; Anfangstext
moin	db 'Moin',13,10,'$'

; Parameter für Routine linie:
s_beg	dw 0	; Anfangsspalte
s_end	dw 0	; Endspalte
z_beg	dw 0	; Anfangszeile
z_end	dw 0	; Endzeile

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hauptprogramm

start:

	; Moin ausgeben
	mov DX,moin
	mov AH,9	; DOS-Fkt: Zeichenkette ausgeben
	int 21h		; Aufruf DOS

	; auf Eingabe einer Taste warten
	call lieszeichen

	; Grafikmodus setzen
	mov AH,0h	; VGA-Fkt: Grafikmodus setzen
	mov AL,12h	; VGA-Grafik-Modus 640x480 16 Farben
	int 10h		; Aufruf Video-BIOS
	mov AH,0Bh	; VGA-Fkt: Rahmen/Hintergrundfarbe
	mov BX,1	; blau
	int 10h		; Aufruf Video-BIOS

	; 45° Linie zeichnen
	mov word [z_beg],10	; Beginn der Linie in Zeile 10
	mov word [s_beg],10	; Beginn der Linie in Spalte 10
	mov word [z_end],100	; Ende der Linie in Zeile 100
	mov word [s_end],100	; Ende der Linie in Spalte 100
	call linie

	; flache Linie zeichnen
	mov word [z_beg],10	; Beginn der Linie in Zeile 10
	mov word [s_beg],10	; Beginn der Linie in Spalte 10
	mov word [z_end],100	; Ende der Linie in Zeile 100
	mov word [s_end],300	; Ende der Linie in Spalte 100
	call liniex

    	; flache Linie zeichnen
	mov word [z_beg],50	; Beginn der Linie in Zeile 10
	mov word [s_beg],50	; Beginn der Linie in Spalte 10
	mov word [z_end],500	; Ende der Linie in Zeile 100
	mov word [s_end],600	; Ende der Linie in Spalte 100
	call liniex

	; auf Eingabe einer Taste warten
	call lieszeichen

	; VGA-Mode wieder auf Text setzen
	mov AH,0h	; VGA-Fkt: Grafikmodus setzen
	mov AL,03h	; VGA-Text-Modus 80x25
	int 10h		; Aufruf Video-BIOS

	; Programm beenden
	mov AH,4Ch	; DOS-Fkt: Programm beenden
	int 21h		; Aufruf DOS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Unterprogramme

; Unterprogramm Lesen eines Zeichens
; Parameter: keine
lieszeichen:
	mov AH,6	; DOS-Fkt: Zeichen lesen
	mov DL,0FFh	; ... ohne Warten
	int 21h		; Aufruf DOS
	jz lieszeichen
	ret

; Unterprogramm Zeichnen einer Linie
linie:
	; Lade Koordinaten des Anfangspunkts in Register
	mov DX,[z_beg]
	mov CX,[s_beg]
	; Schreibe einen Punkt
zeichne:
	mov AH,0Ch	; VGA-Fkt: Grafikpunkt schreiben
			; DX = Bildschirmzeile
			; CX = Bildschirmspalte
			; AL = Farbe
	mov AL,2	; grün
	int 10h		; Aufruf Video-BIOS
	; Benutze AL als Flag: 0 'stop', 1 'weiter'
	mov AL,0	; initialisiere Flag auf 'stop'
	cmp CX,[s_end]	; vergleiche aktuelle Spalte mit End-Spalte
	jz zeile	; wenn gleich, springe ...
	add CX,1	; erhöhe Spalte
	mov AL,1	; setze Flag auf 'weiter'
zeile:	cmp DX,[z_end]	; vergleiche aktuelle Zeile mit End-Zeile
	jz spalte	; wenn gleich, springe ...
	add DX,1	; erhöhe Zeile
	mov AL,1	; setze Flag auf 'weiter'
spalte:	cmp AL,1	; weiter?
	jz zeichne	; dann springe zu 'zeichne'
	ret		; Rückkehr zum aufrufenden Programm

; Unterprogramm Zeichnen einer Geraden
; Parameter von liniex sind dieselben wie für linie
; lokale Variablen:
s_delta	dw 0	; [s_end] - [s_beg]
z_delta	dw 0	; [z_end] - [z_beg]
; Start der Routine:
liniex:
	; Lade Koordinaten des Anfangspunkts in Register
	mov DX,[z_beg]
	mov CX,[s_beg]
	; Bereite Funktionsberechnung vor:
	; s - s_beg / z - z_beg = (s_end - s_beg) / (z_end - z_beg)
	; s = s_beg + (s_end - s_beg) * (z - z_beg) / (z_end - z_beg)
	; s_delta = s_end - s_beg
	; z_delta = z_end - z_beg
	; s = (z - z_beg) * s_delta / z_delta + s_beg
	mov AX,[s_end]
	sub AX,[s_beg]
	mov [s_delta],AX
	mov AX,[z_end]
	sub AX,[z_beg]
	mov [z_delta],AX
	; Schreibe einen Punkt
zeichnex:
	mov AH,0Ch	; VGA-Fkt: Grafikpunkt schreiben
			; DX = Bildschirmzeile
			; CX = Bildschirmspalte
			; AL = Farbe
	mov AL,2	; grün
	int 10h		; Aufruf Video-BIOS
	; Benutze AL als Flag: 0 'stop', 1 'weiter'
	mov AL,0	; initialisiere Flag auf 'stop'
	cmp DX,[z_end]	; vergleiche aktuelle Zeile mit End-Zeile
	jz endex	; wenn gleich, springe ...
	add DX,1	; erhöhe Zeile
	; Berechne s
	mov BX,DX	; rette Zeile in BX
	mov AX,DX
	sub AX,[z_beg]
	mov CX,[s_delta]
	imul CX		; Ergebnis in DX:AX
	mov CX,[z_delta]
	idiv CX		; Quotient in AX (Rest in DX)
	add AX,[s_beg]
	; Parameter bereitstellen
	mov CX,AX
	mov DX,BX
	jmp zeichnex
endex:	ret		; Rückkehr zum aufrufenden Programm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ende des Programmcodes
;	end