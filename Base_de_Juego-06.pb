; -----------------------------------------------------------------------
; Base_de_Juegos-06 en PureBasic
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
; 1. Versión actual del curso:
;      Este curso se orienta a mostrarle como se realiza una PRODUCCION COMPLETA de
;      un videojuego. Se compone de varios elementos: Teoría, Práctica, Archivos, 
;      Código fuente, Manejo de herramientas, etc. 
;      No se compones ólo de videos. Muchos tópicos se incluirán en nuestra página
;      web. Si quiere recorrer las lecciones completas de este curso visite la 
;      página principal para ver todas las lecciones:
;
;      https://profesorponce.blogspot.com/2023/11/curso-de-videojuegos-presentacion.html
;
; 2. GitHub de ProfesorPonce:
;      https://github.com/profesorponce/
;
; 3.YouTube de ProfesorPonce
;      https://www.youtube.com/@RicardoPonceArgentina
;
; 4. Versión anterior del Curso:
;      Si quiere recorrer la versión obsoleta del curso de videojuegos, que incluye
;      la posibilidad de descargar del código fuente, ingrese a esta página de mi web:
;
;      https://profesorponce.blogspot.com/2016/05/curso-de-juegos-1.html

; Programa 06 (Rotación de Sprite Soldado CON DISPARO Y FOGONAZO)
;
; La función de este programa es mostrarle una perspectica diferente el control de
; sprites. En esta coasión, le muestro como controlar a un sprite desde una vista 
; axial (desde arriba). El soldado esta controlado por teclado mediante las teclas
; del keypad numerico. Si prueba este programa en una computadora portatil, asegúrese
; de tener activadas las teclas del keypad para los controles.
;
; Para el control de los movimientos del soldado, se usan las teclas 0 (cero) a
; 7 (siete) según este esquema:
;
;              0  1  2    los movimientos 
;               \ | /     siguen este patron
;             7 -   - 3   segun se pulsan las 
;               / | \     teclas del  
;              6  5  4    keypad numerico
;
; Adicionalemnte el programa controla estas otras dos teclas:
; 
;     ESCAPE -> permite abandonar el programa
;     TAB    -> permite disparar la pistola que lleva el soldado. Al disparar
;               se produce una detonación
;
; El programa cuenta con un control de disparos (el soldado puede cargar un 
; máximo de 50 balas) y un botón de recarga automático cuando se queda sin
; municiones.
;
; Como verá el control del movimiento es muy rapido. En este programa 
; (el numero 6 de la serie de este curso), el efecto del disparo se completa
; con un FOGONAZO en la punta del la pistola. Esto se logra a través de un 
; sencilla rutina que se activa al momento en el que el soldado dispara.
;
; NOTA IMPORTANTE: para que este programa funcione correctamente, necesitará
; cargar los siguientes archivo:
;
;    1) 9-mm-gunshot.wav -> el archivo de sonido del disparo
;    2) Soldado.bmp -> archivo de imagen del soldado
;    3) Fogonazo.bmp
;
; La imagen original del soldado es de Fernando Perdigao 
; (Original disponible en -> https://ar.pinterest.com/pin/35817759520162174/)
; 
; La imagen del fogonazo fue modificada para usar en los disparos de cualquier
; posición el mismo grafico para no complicar la comprensión del diseñp y el
; desarrollo para los programadores menos experimentados.
;
; El mp3 original del sonido del disparo esta disponible 
; desde este sitio web -> http://www.sonidosmp3gratis.com/disparo
; este archivo fue transformado a formato wav para trabajarlo dentro 
; del compilador
;
; Todo el material necesario para correr este progrma esta disponible 
; empaquetado bajo el nombre de "PROGRAMA05.RAR" en nuestra web:
;
; https://profesorponce.blogspot.com/2023/11/curso-de-videojuegos-presentacion.html
;
; También puede descargar estematerial desde nuestro GitHub en la 
; seccion "Curso_Juegos_PureBasic":
;
; https://github.com/profesorponce/
;

Enumeration FormMenu
  #Ventana_Principal ; ventana principal del programa
  #CAPTURA           ; label que indica la tecla presionada
  #SPRITE            ; trabajaremos con un solo sprite
  #FOGONAZO
  #DISPARO           ; sonido de disparo
  #BALAS             ; label que indica la cantidad de balas disponibles
  #RECARGA           ; recarga de balas
EndEnumeration

; variable para detección del keyboard shortcut
ks.l=0

; dimensiones de la ventana principal
MaxAncho.l = 450  ; maximo ancho de la ventana 450 pixeles
MaxAlto.l = 300   ; alto maximo de la ventana 300 pixeles 

MaxBalas.l = 50 ;maxima cantidad de balas disponibles por recarga
BalasActuales.l = MaxBalas ; cantidad de balas actuales del soldado

; definición de las keyboard shorcuts para detección de teclas
Key_ESC.i     = 105    ; TECLA ESCAPE (salir del programa)
Key_Pad7.i    = 106    ;
Key_Pad8.i    = 107    ;
Key_Pad9.i    = 108    ;  0  1  2    los movimientos 
Key_Pad6.i    = 109    ;   \ | /     siguen este patron
Key_Pad3.i    = 110    ; 7 -   - 3   segun se pulsan las 
Key_Pad2.i    = 111    ;   / | \     teclas del  
Key_Pad1.i    = 112    ;  6  5  4    keypad numerico
Key_Pad4.i    = 113    ;
Key_TAB.i     = 114    ; TECLA DE DISPARO

;dimensiones del sprite
Sprite_Ancho.l=200 ;200 pixeles de ancho
Sprite_Alto.l=200  ;200 pixeles de alto

; movimientos que controlan el dibujo del sprite
#Mov_UpLeft    = 0  ;             
#Mov_Up        = 1  ;             
#Mov_UpRight   = 2  ;  0  1  2    los movimientos 
#Mov_Right     = 3  ;   \ | /     siguen este patron
#Mov_DownRight = 4  ; 7 -   - 3   segun se pulsan las 
#Mov_Down      = 5  ;   / | \     teclas del  
#Mov_DownLeft  = 6  ;  6  5  4    keypad numerico
#Mov_Left      = 7  ;

Sprite_Mov_Sentido = #Mov_Right ; empieza moviendose a la derecha

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

OpenWindow(#Ventana_Principal, 0, 0, MaxAncho, MaxAlto + 50, "Sprite de Soldado con FOGONAZO", #FLAGS) ;ventana principal
OpenWindowedScreen(WindowID(#Ventana_Principal),0,0,MaxAncho,MaxAlto) ;ventana grafica para trabajar con el sprite

TextGadget(#CAPTURA, 40, 310, 140, 25, "Tecla........") ; label que muestra que tecla se presionó
TextGadget(#BALAS, 200, 310, 140, 25, "[ "+Str(BalasActuales)+" balas ]")   ; label que muestra las balas disponibles
ButtonGadget(#RECARGA, 340, 310, 80, 20, "RECARGAR")

;se agregan las keyboard shortcuts para deteactar teclas en el bucle REPEAT
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Escape, Key_ESC)     ; salir del programa
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad7, Key_Pad7)      ;
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad8, Key_Pad8)      ;
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad9, Key_Pad9)      ;   0  1  2    los movimientos 
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad6, Key_Pad6)      ;    \ | /     siguen este patron
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad3, Key_Pad3)      ;  7 -   - 3   segun se pulsan las 
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad2, Key_Pad2)      ;    / | \     teclas del  
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad1, Key_Pad1)      ;   6  5  4    keypad numerico
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Pad4, Key_Pad4)      ;
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Tab,  Key_TAB)       ; disparo

SetFrameRate(60)        ; velocidad de movimiento del sprite

; carga del sprite del soldado
LoadSprite(#SPRITE, "soldado.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
TransparentSpriteColor(#SPRITE, RGB(255, 255, 255)) ; color blanco del sprite es transparente


LoadSprite(#FOGONAZO, "fogonazo.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)

Sprite_Velocidad.l=10 ; velocidad de movimiento del sprite (se puede variar)

; carga del sonido de disparo
InitSound()    ; Inicializa el sistema de sonido
LoadSound(#DISPARO, "9-mm-gunshot.wav") ; carga el sonido de la pistola

;bucle principal de ejecución controlada
Repeat
  
   ; se limpia la pantalla refrescandola para dibujar el sprite sin superposición
   ClearScreen(RGB(00,99,00)) ; RGB(255,255,255)) es fondo blanco
   ; se visualiza el sprite en la pantalla (si previamente no usa ClearScreen el
   ; sprite se superpone con el dibujo anterior
   ;DisplaySprite(#SPRITE,Sprite_Pos_X,Sprite_Pos_Y)
   DisplayTransparentSprite(#SPRITE,Sprite_Pos_X,Sprite_Pos_Y)

       
   Event.l = WindowEvent() ;se leen los eventos
  
   Select Event
      Case #PB_Event_Gadget ;controles          
         If EventGadget() = #RECARGA 
            BalasActuales = MaxBalas ;se recarga la maxima cantidad de balas permitidas
            SetGadgetText(#BALAS,"[ "+Str(BalasActuales)+" balas ] ")    
         EndIf
              
      Case #PB_Event_Menu

         ks=EventMenu() ;Captura de  los keyboard shortcut's
         
         Select ks
           Case Key_ESC ;------------------------------SALIR
              Quit = #True 
           Case Key_TAB ;------------------------------DISPARO
              
              If BalasActuales > 0
                 SetGadgetText(#CAPTURA,"DISPARO") 
                 PlaySound(#DISPARO)
                 
                 Select Sprite_Mov_Sentido
                    Case #Mov_Right 
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+180,Sprite_Pos_Y+134) 
                    Case #Mov_Down  
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+18,Sprite_Pos_Y+180)   
                    Case #Mov_Left
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X-25,Sprite_Pos_Y+19)   
                    Case #Mov_Up
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+132,Sprite_Pos_Y-25)   
                    Case #Mov_UpLeft
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+40,Sprite_Pos_Y-32)   
                    Case #Mov_UpRight
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+185,Sprite_Pos_Y+42)   
                    Case #Mov_DownRight
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+101,Sprite_Pos_Y+186)   
                    Case #Mov_DownLeft
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X-39,Sprite_Pos_Y+104)   
                    Default  
                 EndSelect    
                 
                 BalasActuales = BalasActuales -1
                 SetGadgetText(#BALAS,"[ "+Str(BalasActuales)+" balas ] ")   
              Else 
                 SetGadgetText(#CAPTURA,"SIN BALAS")    
              EndIf
           Case Key_Pad6 ;-----------------------------ESTE
              SetGadgetText(#CAPTURA,"MOV > ESTE")   
              Sprite_Mov_Sentido = #Mov_Right
              RotateSprite(#SPRITE, 360, #PB_Absolute)
              If (Sprite_Pos_X + Sprite_Velocidad) <= Mov_Max_RIGHT
                 Sprite_Pos_X = Sprite_Pos_X + Sprite_Velocidad
              Else 
                  Sprite_Pos_X = Mov_Max_RIGHT
              EndIf  
           Case Key_Pad2 ;-----------------------------SUR
              SetGadgetText(#CAPTURA,"MOV > SUR")   
              Sprite_Mov_Sentido = #Mov_Down
              RotateSprite(#SPRITE, 90, #PB_Absolute)         
              If (Sprite_Pos_Y + Sprite_Velocidad) <= Mov_Max_DOWN
                 Sprite_Pos_Y = Sprite_Pos_Y + Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_DOWN
              EndIf  
           Case Key_Pad4 ;-----------------------------OESTE
              SetGadgetText(#CAPTURA,"MOV > SUR")   
              Sprite_Mov_Sentido = #Mov_Left
              RotateSprite(#SPRITE, 180, #PB_Absolute)         
              If (Sprite_Pos_X - Sprite_Velocidad) >= Mov_Max_LEFT
                 Sprite_Pos_X = Sprite_Pos_X - Sprite_Velocidad
              Else 
                 Sprite_Pos_X = Mov_Max_LEFT
              EndIf  
           Case Key_Pad8 ;-----------------------------NORTE
              SetGadgetText(#CAPTURA,"MOV > NORTE")   
              Sprite_Mov_Sentido = #Mov_Up
              RotateSprite(#SPRITE, 270, #PB_Absolute)         
              If (Sprite_Pos_Y - Sprite_Velocidad) >= Mov_Max_UP
                 Sprite_Pos_Y = Sprite_Pos_Y - Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_UP
              EndIf  
           Case Key_Pad9 ;-----------------------------NORESTE
              SetGadgetText(#CAPTURA,"MOV > NORESTE")   
              Sprite_Mov_Sentido = #Mov_UpRight
              RotateSprite(#SPRITE, 315, #PB_Absolute)         
              If (Sprite_Pos_X + Sprite_Velocidad) <= Mov_Max_RIGHT
                 Sprite_Pos_X = Sprite_Pos_X + Sprite_Velocidad
              Else 
                  Sprite_Pos_X = Mov_Max_RIGHT
              EndIf  
              If (Sprite_Pos_Y - Sprite_Velocidad) >= Mov_Max_UP
                 Sprite_Pos_Y = Sprite_Pos_Y - Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_UP
              EndIf                
           Case Key_Pad7 ;-----------------------------NOROESTE
              SetGadgetText(#CAPTURA,"MOV > NOROESTE")   
              Sprite_Mov_Sentido = #Mov_UpLeft
              RotateSprite(#SPRITE, 225, #PB_Absolute)         
              If (Sprite_Pos_Y - Sprite_Velocidad) >= Mov_Max_UP
                 Sprite_Pos_Y = Sprite_Pos_Y - Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_UP
              EndIf  
              If (Sprite_Pos_X - Sprite_Velocidad) >= Mov_Max_LEFT
                 Sprite_Pos_X = Sprite_Pos_X - Sprite_Velocidad
              Else 
                 Sprite_Pos_X = Mov_Max_LEFT
              EndIf  
           Case Key_Pad1 ;-----------------------------SUROESTE
              SetGadgetText(#CAPTURA,"MOV > SUROESTE")   
              Sprite_Mov_Sentido = #Mov_DownLeft
              RotateSprite(#SPRITE, 135, #PB_Absolute)         
              If (Sprite_Pos_Y + Sprite_Velocidad) <= Mov_Max_DOWN
                 Sprite_Pos_Y = Sprite_Pos_Y + Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_DOWN
              EndIf  
              If (Sprite_Pos_X - Sprite_Velocidad) >= Mov_Max_LEFT
                 Sprite_Pos_X = Sprite_Pos_X - Sprite_Velocidad
              Else 
                 Sprite_Pos_X = Mov_Max_LEFT
              EndIf  
           Case Key_Pad3 ;-----------------------------SURESTE
              SetGadgetText(#CAPTURA,"MOV > SURESTE")   
              Sprite_Mov_Sentido = #Mov_DownRight
              RotateSprite(#SPRITE, 45, #PB_Absolute)         
              If (Sprite_Pos_Y + Sprite_Velocidad) <= Mov_Max_DOWN
                 Sprite_Pos_Y = Sprite_Pos_Y + Sprite_Velocidad
              Else 
                 Sprite_Pos_Y = Mov_Max_DOWN
              EndIf  
              If (Sprite_Pos_X + Sprite_Velocidad) <= Mov_Max_RIGHT
                 Sprite_Pos_X = Sprite_Pos_X + Sprite_Velocidad
              Else 
                  Sprite_Pos_X = Mov_Max_RIGHT
              EndIf                
           Default
         EndSelect    
         
      Default            
    EndSelect ;Event
    
    FlipBuffers()  
    
              
 Until Event = #PB_Event_CloseWindow Or Quit = #True
 
 End

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 103
; FirstLine = 75
; EnableXP
; Executable = Base_de_juego.exe