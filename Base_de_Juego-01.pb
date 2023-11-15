; -----------------------------------------------------------------------
; Base_de_Juegos-01 en PureBasic
; (c) 2023 por Ricardo Ponce
; https://profesorponce.blogspot.com/
; -----------------------------------------------------------------------
; Curso Programación de Juegos en PureBasic
; con Código Fuente descargable desde nuestro GitHub
; 
; Esta serie de programas forma parte del Curso de Programación de VideoJuegos
; en PureBasic. Muestra la secuenciainicial de como crear paso a paso un
; un progrma de juegos usando como base de programción al compilador PureBasic
;
; Por si usted no lo sabe, soy un programador e investigador que desarrolla
; soluciones de software de diversos tipos (banco de datos, bases de datos, 
; lenguajes de programación, IDEs, analizadores sintáctivos, bots conversacionales.
; webs, etc.
; 
; Hace unos años atrás, desarrollé un mini-curso de programación de videojuegos
; con herramientas que quedaron "viejas" rápidamente. Este curso se centraba
; en la creación de un sistema completo de soporte para videojuegos basados en
; sistemas D.O.S. Por temas de tiempo (la investigación en desarrollo de software
; consume muchisimo tiempo), el desarrollo de ese curso demoró y terminó quedando
; incompleto y obsoleto.
;
; Este es un curso nuevo, desde cero pero con herramientas modernas, en el que 
; intentaré mostrarle a los jóvenes programadores cómo crear un sistema de soporte
; para sus desarrollos que además incluya diversos niveles de I.A.
;
; LINKS --------------------------------------------
;
; 1. Versión anterior del Curso:
;      Si quiere recorrer la versión obsoleta del curso de videojuegos, que incluye
;      la posibilidad de descargar del código fuente, ingrese a esta página de mi web:
;
;      https://profesorponce.blogspot.com/2016/05/curso-de-juegos-1.html
;
; 2. GitHub de ProfesorPonce:
;      https://github.com/profesorponce/
;
; 3.YouTube de ProfesorPonce
;      https://www.youtube.com/@RicardoPonceArgentina
;
; ---------------------------------------------------
;
; Programa 01
;
; Vea la nota (1) de nuestra web y el video en youtube que contienen explicaciones detalladas
;
; Este programa implementa una estructura básica que permite crear una ejecución en
; bucle controlada que permite detectar las teclas presionadas.
;
; Si el usuario desea SALIR, puede presionar la tecla ESCAPE
;
; En el proximo programa (02) esas teclas permitirán controlar el movimiento 
; del sprite.
; 

;enumeración de las constantes principales

Enumeration FormMenu
  #Ventana_Principal ; ventana principal del programa
  #CAPTURA           ; label que indicará el momento que se presiona una tecla
EndEnumeration

; variable que permite capturar los eventos de 
; presión de teclas definidas por el usuario
; durante la ejecución del programa

ks.l=0 ; ks = keyboard shortcut

;flags para configurar la ventan principal

#FLAGS =  #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget

OpenWindow(#Ventana_Principal, x, y, 450, 300, "Base de Juego", #FLAGS) ; ventana principal
TextGadget(#CAPTURA, 40, 40, 140, 25, "Tecla........") ; label que indicara que te cla se presionó

; este programa detectara presión de las teclas de 
; FLECHA DE CURSOR = para detectar movimiento del futuro sprite
; ESCAPE = apara salir del programa

AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Left, 101)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Up, 102)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Right, 103)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Down, 104)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Escape, 105)

; bucle repeat de ejecución controlada

Repeat
  
  Event.l = WaitWindowEvent() ; detecta los eventos de windows
  
   Select Event
      Case #PB_Event_Menu  ; AddKeyboardShortcut agrega la detección de teclas a los eventos de menú
       
         ks = EventMenu() ; se detecta la tecla presionada
        
         ; cuando se presiona una tecla, el programa lo anuncia 
         ; reescribiendo la label #CAPTURA 
         
         If ks=101 ;#PB_Shortcut_Left ------------------
           SetGadgetText(#CAPTURA,"Flecha Izquierda")
         EndIf
         
         If ks=102 ;#PB_Shortcut_Up --------------------
           SetGadgetText(#CAPTURA,"Flecha Arriba")
         EndIf
         
         If ks=103 ;#PB_Shortcut_Right -----------------
           SetGadgetText(#CAPTURA,"Flecha Derecha")
         EndIf
         
         If ks=104 ;#PB_Shortcut_Down ------------------
           SetGadgetText(#CAPTURA,"Flecha Abajo")
         EndIf
         
         If z=105 ;#PB_Shortcut_Escape ----------------
           Quit = #True ; si el usuario presiona la tecla ESCAPE se termina
         EndIf          ; la ejecución del bucle REPEAT
         
      Case #PB_Event_Gadget ;controles          
      Default      
    EndSelect ;Event
    
 ; el Until espera a que el usuario presione el control CERRAR VENTANA             
 ; o presione la tecla ESCAPE
    
 Until Event = #PB_Event_CloseWindow Or Quit = #True
 
 End
 
 
; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 51
; FirstLine = 35
; EnableXP