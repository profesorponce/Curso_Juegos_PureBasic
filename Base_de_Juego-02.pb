; -----------------------------------------------------------------------
; Base_de_Juegos-01 en PureBasic
; (c) 2023 por Ricardo Ponce
; https://profesorponce.blogspot.com/
; -----------------------------------------------------------------------
;
; Control de SPRITE
;
; Este programa muestra un modelo básico de control de un sprite mediante
; la lectura de algunas teclas seleccionadas por el programador
;
;
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
; Programa 02
;
; Vea la nota (2) de nuestra web y el video en youtube que contienen explicaciones detalladas
;
; Este programa usa la estructura del programa 01 ejecutando el programa en un
; bucle controlado y permite mover un sprite por la pantalla al detectar las 
; teclas presionadas.
;
; Si el usuario presiona las teclas de movimiento del CURSOR el sprite se mueve por
; la pantalla.
;
; Si el usuario desea SALIR, puede presionar la tecla ESCAPE 

; enumeración de la constantes principales

Enumeration FormMenu
  #Ventana_Principal ; ventana principal del programa
  #CAPTURA           ; label que indica la tecla presionada
  #SPRITE            ; sprite con control del movimiento
EndEnumeration

; variable para detección del keyboard shortcut
ks.l=0

; dimensiones de la ventana principal
MaxAncho.l = 450  ; maximo ancho de la ventana 450 pixeles
MaxAlto.l = 300   ; alto maximo de la ventana 300 pixeles 

; definición de las keyboard shorcuts para detección de teclas
Key_LEFT.i = 101   ; CURSOR IZQUIERDA
Key_UP.i = 102     ; CURSOR ARRIBA
Key_RIGHT.i = 103  ; CURSOR DERECHA
Key_DOWN.i = 104   ; CURSOR ABAJO
Key_ESC.i = 105    ; TECLA ESCAPE

;dimensiones del sprite
Sprite_Ancho.l=32 ;32 pixeles de ancho
Sprite_Alto.l=32  ;32 pixeles de alto

;maximos movimentos posibles del sprite según las dimensiones de la ventana
;los valores de las variables de control evitan que el sprite se salga de
;los límites actuales de la pantalla
Mov_Max_UP.l = 0
Mov_Max_LEFT.l = 0
Mov_Max_DOWN.l = MaxAlto - Sprite_Alto 
Mov_Max_RIGHT.l = MaxAncho - Sprite_Ancho

;posición actual del sprite que empieza en x=1 / y=1
Sprite_Pos_X.l = 1
Sprite_Pos_Y.l = 1

; flags generales para la ventana principal del juego
#FLAGS =  #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget

InitSprite() ; inicia el engine de sprites

OpenWindow(#Ventana_Principal, 0, 0, MaxAncho, MaxAlto, "Base de Juego-02", #FLAGS) ;ventana principal
OpenWindowedScreen(WindowID(#Ventana_Principal),0,0,MaxAncho,MaxAlto) ;ventana grafica para trabajar con el sprite

TextGadget(#CAPTURA, 40, 40, 140, 25, "Tecla........") ; label que muestra que tecla se presionó

;se agregan las keyboard shortcuts para deteactar teclas en el bucle REPEAT
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Left, Key_LEFT)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Up, Key_UP)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Right, Key_RIGHT)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Down, Key_DOWN)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Escape, Key_ESC)

SetFrameRate(60)        ; velocidad de movimiento del sprite

;se crea la imagen ram del sprite con limites precisos
CreateSprite(#SPRITE,Sprite_Ancho,Sprite_Alto,#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)

;se dibuja el sprite en pantalla según las dimensiones declaradas
StartDrawing(SpriteOutput(#SPRITE))
   Box(0,0,Sprite_Ancho,Sprite_Alto,RGB(32,10,20)) ;sera de 32x32 pixeles
StopDrawing()

Sprite_Velocidad.l=10 ; velocidad de movimiento del sprite (se puede variar)

;bucle principal de ejecución controlada
Repeat
  
   ; se limpia la pantalla refrescandola para dibujar el sprite sin superposición
   ClearScreen(RGB(255,0,255))
  
   ; se visualiza el sprite en la pantalla (si previamente no usa ClearScreen el
   ; sprite se superpone con el dibujo anterior
   DisplaySprite(#SPRITE,Sprite_Pos_X,Sprite_Pos_Y) 
  
   Event.l = WaitWindowEvent() ;se capturan los eventos
  
   Select Event
      Case #PB_Event_Menu

         ks=EventMenu() ;Captura de  los keyboard shortcut's
         
         If ks=Key_LEFT ;#PB_Shortcut_Left ------------------
           
           SetGadgetText(#CAPTURA,"Flecha Izquierda")
           
           If (Sprite_Pos_X - Sprite_Velocidad) >= Mov_Max_LEFT
             Sprite_Pos_X = Sprite_Pos_X - Sprite_Velocidad
           Else 
             Sprite_Pos_X = Mov_Max_LEFT
           EndIf  

         EndIf
         
         If ks=Key_UP ;#PB_Shortcut_Up --------------------
           
           SetGadgetText(#CAPTURA,"Flecha Arriba")
           
           If (Sprite_Pos_Y - Sprite_Velocidad) >= Mov_Max_UP
             Sprite_Pos_Y = Sprite_Pos_Y - Sprite_Velocidad
           Else 
             Sprite_Pos_Y = Mov_Max_UP
           EndIf  
           
         EndIf
         
         If ks=Key_RIGHT ;#PB_Shortcut_Right -----------------
           
           SetGadgetText(#CAPTURA,"Flecha Derecha")
           
           If (Sprite_Pos_X + Sprite_Velocidad) <= Mov_Max_RIGHT
             Sprite_Pos_X = Sprite_Pos_X + Sprite_Velocidad
           Else 
             Sprite_Pos_X = Mov_Max_RIGHT
           EndIf  
  
         EndIf
         
         If ks=Key_DOWN ;#PB_Shortcut_Down ------------------
           
           SetGadgetText(#CAPTURA,"Flecha Abajo")
           
           If (Sprite_Pos_Y + Sprite_Velocidad) <= Mov_Max_DOWN
             Sprite_Pos_Y = Sprite_Pos_Y + Sprite_Velocidad
           Else 
             Sprite_Pos_Y = Mov_Max_DOWN
           EndIf  
  
         EndIf
         
         If ks=Key_ESC ;#PB_Shortcut_Escape ----------------
           Quit = #True 
         EndIf

      Case #PB_Event_Gadget ;controles          
      Default      
    EndSelect ;Event
    
    FlipBuffers()  
              
 Until Event = #PB_Event_CloseWindow Or Quit = #True
 
 End

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 125
; FirstLine = 108
; EnableXP