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
;there are still issus around 360||0 degree work around with overflow of 10 degree
Circle(x,y,r,skalar:=0.003,start:=0,end:=370)
{
	setformat,float, 0.10
	skalar := r * skalar
	counter := (end-start) * skalar
	begin_bow := CircleEdge(x,y,r,start)
	MouseMove, begin_bow[1], begin_bow[2]
	Click down left
	sleep, 100
	Loop, %counter%{
		rad := ((A_Index-start)*(0.01745329252 /skalar)) 	;convert degree to rad
		x2 := x+r*Cos(rad)						;get next x/y 
		y2 := y+r*Sin(rad)
		if ((round(x2) != x) && (round(y2) != y)){ 		;cut out zeros (centerdots on limmited plane)
			;msgbox % x2 "," y2 "," x "," y
			sleep, 1
			Dot(x2,y2)
			}
		}

	sleep, 100
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
Circle(x,y,100,0.002)
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
Circle(x,y,40)
Loop, 6{
	coords := CircleEdge(x,y,40,A_Index * 60)
	; Msgbox % A_Index * 60  ; "," coords[1] "," coords[2]
	Circle(coords[1],coords[2],50)
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
Print_a(x+51,y,1)
Print_b(x+102,y,1)

Send {Ctrl Up}
return

