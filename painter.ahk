#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
dela := 1000
MapBounds := Array()
MapBounds[1] := 34			;x_begin_map
MapBounds[2] := 273		;X_end_map
MapBounds[3] := 793		;y_begin_map
MapBounds[4] := 1033		;y_end_map


Line(x,y,dx,dy)
{
	MouseMove, x+dx, y+dy
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
}


; draws a circle with center at x,y radius of r [skalar # of dots,start = degree of start bow (math. negativ), end = dgree of end bow(math. negativ)]
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
			Dot(dot[1],dot[2])
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


;print "flowerstamp" with center at courser
#z::
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

;print smiley
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
