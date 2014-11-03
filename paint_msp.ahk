#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;win+a=flowerstamp, win+s=grinsmiley, win+d=sadsmiley, win+f=terminate
MapBounds := Array()
MapBounds[1] := 34			;x_begin_map
MapBounds[2] := 273		;X_end_map
MapBounds[3] := 793		;y_begin_map
MapBounds[4] := 1033		;y_end_map


Line(x,y,dx,dy)
{
	MouseMove, x, y
	sleep 60
	Click down left
	sleep 60
	MouseMove dx,dy
	sleep 60
	Click up left
	;MouseClickDrag, L, x, y, x+dx, y+dy , 100
}

DotLine(x,y)
{
	MouseMove, x+1, y+1, 100
	MouseMove, x,y
	;MouseClickDrag, L, x, y, x+dx, y+dy , 100
}

Dot(x,y)
{
	
	MouseMove, x,y
	Click down left
	sleep 5
	Click up left
}


; draws a circle with center at x,y radius of r [skalar # of dots,start = degree of start bow (math. negativ), end = dgree of end bow(math. negativ)] (lower skalar means more pixel/better resolution)
; with low skalar (fast circle) problem with closing of circle
Circle(x,y,r,skalar:=100,start:=0,end:=380)
{
	setformat,float, 0.10
	skalar := 1/r * skalar
	begin_bow := CircleEdge(x,y,r,start)
	MouseMove, begin_bow[1], begin_bow[2]
	Click down left
	sleep, 80
	position := start
	while (position < end){
		dot  := CircleEdge(x,y,r,(position)) 
		if ((round(dot[1]) != x) && (round(dot[2]) != y)){ 		;cut out zeros (centerdots on limmited plane)
			;msgbox % x2 "," y2 "," x "," y
			sleep, 1
			MouseMove, dot[1],dot[2]
			}
		position := position  + skalar
		}

	sleep, 80
	Click up left
	
}

CircleEdge(x,y,r,t)							;get edge of circle with center at x,y radius r at postition t (0-360)
{
	a := Array()
	rad := (t*0.01745329252)					;convert degree to rad
	a[1] := x+r*Cos(rad)						;get next x/y 	
	a[2] := y+r*Sin(rad)
	;msgbox % a[1]
	return a
}

msp_starke(x)								;stellt strichstärke in paint ein (1-50)
{
if (x < 1 or x > 50){
	x := 1
	}
Loop, 51{	;strichstärke auf ganz dünn
	Send {LControl down}{NumpadSub}{LControl up}
	}
	x := x-1
Loop %x%{	;strichstärke auf x stellen	
	Send {LControl down}{NumpadAdd}{LControl up}
	}


}

; h is complete heigh
soak(x,y,h)
{
center := Array()
center[1] := x+h/2
center[2] := y+h/2
num_bows := h/8 ;max every 4 px 1 line
loop, %num_bows%{
	;msgbox % num_bows
	actual_bow := A_Index
	num_arcs := actual_bow * 3.1415 +10
	loop, %num_arcs%{
		coords1 := CircleEdge(center[1],center[2],h/2-num_arcs+A_Index*3.1415+10,(A_Index/num_arcs)*360) ;tangente am aktuellen kreissegment
		coords2 := CircleEdge(center[1],center[2],h/2,((A_Index+1)/num_arcs)*360) ;tangente am nächsten kreissegment
		line(coords1[1],coords1[2],coords2[1],coords2[2])
	}
}
}
; h is complete heigh
triforce(x,y,h)
{
	Line(x+h/4,y+h/2,x+h*3/4,y+h/2)
	Sleep 10
	Line(x+h*3/4,y+h/2,x+h/2,y)
	Sleep 10
	Line(x+h/2,y,x,y+h)
	Sleep 10
	Line(x,y+h,x+h,y+h)
	Sleep 10
	Line(x+h,y+h,x+h*3/4,y+h/2)
	Sleep 10
	Line(x+h*3/4,y+h/2,x+h/2,y+h)
	Sleep 10
	Line(x+h/2,y+h,x+h/4,y+h/2)
	Sleep 10
}

; h is complete heigh
notriforce(x,y,h)
{
	Line(x+h/4,y,x,y+h/2)
	Sleep 10
	Line(x,y+h/2,x+h/4,y+h/2)
	Sleep 10
	Line(x+h/4,y+h/2,x,y+h)
	Sleep 10
	Line(x,y+h,x+h,y+h)
	Sleep 10
	Line(x+h,y+h,x+h*3/4,y+h/2)
	Sleep 10
	Line(x+h*3/4,y+h/2,x+h/2,y+h)
	Sleep 10
	Line(x+h/2,y+h,x+h/4,y+h/2)
	Sleep 10
	Line(x+h/4,y+h/2,x+h/2,y+h/2)
	Sleep 10
	Line(x+h/2,y+h/2,x+h/4,y)
	Sleep 10
}


#f::
ExitApp

 
 
#n::
MouseGetPos, x , y
Send {Control Down}
;Line(x,y,0,+20)
;msgbox %x% %y%
Circle(x,y,100)
Send {Ctrl Up}
MouseMove, x,y
return

#t::
MouseGetPos, x , y
Send {Control Down}
Circle(x,y,50)
Loop, 6{
	coords := CircleEdge(x,y,65,A_Index * 60)
	; Msgbox % A_Index * 60  ; "," coords[1] "," coords[2]
	Circle(coords[1],coords[2],75)
}
Send {Ctrl Up}
return

;print circle of r=30px with center at courser
#u::
MouseGetPos, x , y
Send {Control Down}
;Line(x,y,30,0)
;DotLine(x,y)
Circle(x,y,30)
Send {Ctrl Up}
return


;"fills" map
#i::
MouseMove, MapBounds[1], MapBounds[3]
Send {Control Down}
Click down left
Sleep, 100
delta := MapBounds[4]-MapBounds[3]
While delta > 0{
	delta := delta -4 
	Sleep, 50
	MouseMove, MapBounds[2], MapBounds[3]+A_Index*4
	Sleep, 50
	MouseMove, MapBounds[1], MapBounds[3]+A_Index*4
}
Sleep 100
Click up left
Send {Ctrl Up}
return


Print_a(x,y,c:=1)
{
	if (c=0){
		Circle(x+25,y+25,20)
		Sleep 100
		Click up left
		MouseMove,x+40,y+10
		Click down left
		Sleep 100
		MouseMove,x+40,y+50
		Sleep 100
		Click up left
	} else{
		MouseMove,x+5,y+50
		Click down left
		Sleep 100
		MouseMove,x+20,y
		Sleep 50
		MouseMove,x+40,y+50
		Sleep 50
		MouseMove,x+30,y+25
		Sleep 50
		MouseMove,x+5,y+25
		Sleep 100
		Click up left
		
	}

}

Print_b(x,y,c:=1)
{
	if (c=0){
		Circle(x+25,y+25,20)
		Sleep 100
		Click up left
		MouseMove,x+40,y+10
		Click down left
		Sleep 100
		MouseMove,x+40,y+50
		Sleep 100
		Click up left
	} else{
		MouseMove,x+5,y+50
		Click down left
		Sleep 100
		MouseMove,x+5,y
		Sleep 50
		MouseMove,x+45,y
		Sleep 50
		MouseMove,x+45,y+20
		Sleep 50
		MouseMove,x+5,y+20
		Sleep 50
		MouseMove,x+45,y+20
		Sleep 50
		MouseMove,x+45,y+50
		Sleep 50
		MouseMove,x+5,y+50
		Sleep 50
		Click up left
		Sleep 100
		
	}

}

#o::
MouseGetPos, x , y
Send {Control Down}
;print_a(x,y+10,0)
;Print_a(x+51,y,1)
;Print_b(x+102,y,1)
Send {Ctrl Up}
Sleep 100
Send {Ctrl Down}
Circle(x-24,y-15,15,0.003,10,90)
Send {Ctrl Up}
Sleep 100
return

;print grin smiley
#s::
MouseGetPos, x, y
Send {Ctrl Down}
Circle(x,y,70,400,0,370)		;kopf
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-25,y-15,15,120,0,400)			;auge <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+25,y-15,15,120,0,400)			;auge >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+15,y-12,15,120,275,410)	;iris >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-15,y-12,15,120,130,265)	;iris <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+15,y-12,5,,230,500)	;pupile >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-15,y-12,5,,30,320)	;pupile <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x,y+10,35,120,60,160)		;mouth
Send {Ctrl Up}
grin := CircleEdge(x,y+10,35,160) 
Sleep 10
Send {Ctrl Down}
Circle(grin[1]-6,grin[2]-6,10,,20,100)	;grin
Send {Ctrl Up}
Sleep 10
return

;print sad smiley
#d::
MouseGetPos, x, y
Send {Ctrl Down}
Circle(x,y,70,400,0,370)		;kopf
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-25,y-15,15,120,0,400)			;auge <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+25,y-15,15,120,0,400)			;auge >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+15,y-12,15,120,275,410)	;iris >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-15,y-12,15,120,130,265)	;iris <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x+15,y-12,5,,230,500)	;pupile >
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x-15,y-12,5,,30,320)	;pupile <
Send {Ctrl Up}
Sleep 10
Send {Ctrl Down}
Circle(x,y+70,35,120,230,320)		;mouth
Send {Ctrl Up}
return


;one can not simply triforce into Dota
#y::
MouseGetPos, x, y
h := 120
Send {Ctrl down}
notriforce(x,y,h)
Send {Ctrl up}
return
#x::
MouseGetPos, x, y
h := 120
Send {Ctrl down}
triforce(x,y,h)
Send {Ctrl up}
return

;print "flowerstamp" with center at courser
#a::
MouseGetPos, x , y
Send {Control Down}
Circle(x,y,40,300)
Loop, 6{
	coords := CircleEdge(x,y,40,A_Index * 60)
	; Msgbox % A_Index * 60  ; "," coords[1] "," coords[2]
	Circle(coords[1],coords[2],50,350)
}
Send {Ctrl Up}
return

;soaks path ZeroOfFour
#c::
MouseGetPos, x, y
h := 300
Send {Ctrl down}
soak(x,y,h)
Send {Ctrl up}
return


;soak2 
#v::
MouseGetPos, x, y
objekte_array := Object()
dim := 500 ;dimension 300x300
start := 210 ;startpunkt kreisausschnitt
wideness := 1 ;weite in grad des bogenausschnittes
end := start+wideness ;ein grad, kreisausschnitt
number_bows := 100 ;anzahl der zu zeichnenden segmetausschnitte
radius := dim/2 ;entfernung vom zentrum
starke := 1 ;strichstärke
msp_starke(1) ;strichstärke 1
line(x-dim/2,y,x+dim/2,y) ;horizontale line
line(x,y-dim/2,x,y+dim/2) ;vertikale line
msp_starke(starke) ;strichstärke 5
Loop, %number_bows%{
	dot_data := Object()	
	random, start, 0, 359
	end := start+wideness
	random, radius, 1, dim/2
		;dynamische punktgröße. erstes drittel 3px, 2. 5px,3. 7px
	if (radius <= dim/6)
		starke := 3
	else if (radius >= dim/3)
		starke := 7
		else
			starke := 5
	dot_data[1] := "c"
	dot_data[2] := starke
	dot_data[3] := x
	dot_data[4] := y
	dot_data[5] := radius
	dot_data[6] := 150
	dot_data[7] := start
	dot_data[8] := end
	objekte_array.Insert(dot_data)
}
paint_array(objekte_array)
return


;zeichnet das übergebene array jeder eintrag im array ist ein object() mit dem 
;- ersten eintrag l(line),d(dot),c(circle)
;- zweiten eintrag strichstärke 1-50 
;- startkoordinaten x,y
;- bei line endkoordiante x,y
;- bei circle radius, punkthäufigkeit,start,ende


paint_array(dots_array){
	loop,50{
		starke := a_index
		for index, element in dots_array{
			if (element[2] = starke){
				if (aktuelle_starke != starke){
					aktuelle_starke := starke
					msp_starke(starke)
					}
				if (element[1] = "d"){
					;msgbox % "zeichne element #" . index  . " mit " .  element[1] . " " . element[2] . " " . element[3] . " " . element[4]
					Dot(element[3] , element[4])
				}
				if (element[1] = "l"){
					;msgbox % "zeichne element #" . index  . " mit " .  element[1] . " " . element[2] . " " . element[3] . " " . element[4] . " " . element[5] . " " . element[6]
					Line(element[3] , element[4], element[5] , element[6])
				}
				if (element[1] = "c"){
					;msgbox % "zeichne element #" . index  . " mit " .  element[1] . " " . element[2] . " " . element[3] . " " . element[4] . " " . element[5] . " " . element[6] . " " . element[7] . " " . element[8]
					Circle(element[3] , element[4], element[5] , element[6], element[7] , element[8])
				}
			}
		}
	}
}

#b:: ;arraytest
dots_array := Object()
Loop, 10{
	dot_data := Object()	;muss im loop stehen, damit immer wieder ein neues object erzeugt wird
	random, zahl,1,5
	dot_data[1] := "d"
	dot_data[2] := zahl
	dot_data[3] := 100
	dot_data[4] := 200
	;msgbox % "dotdata " . dot_data[1] . " " . dot_data[2] . " " . dot_data[3] . " " . dot_data[4] 
	dots_array.Insert(dot_data)
}
paint_array(dots_array)
for index, element in dots_array{
	;msgbox % "element #" . %index%  . " ist " .  element[1] . " " . element[2] . " " . element[3] . " " . element[4]
}
return
