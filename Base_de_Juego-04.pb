; -----------------------------------------------------------------------
; Base_de_Juegos-04 en PureBasic
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

; ---------------------------------------------------
;
; Programa 04 - Perrito Hiperactivo 
;              (Sprite animado pero ahora con "movimiento continuo")
;
; Este programa es una versión optimizada de 03
;
; Optimización 1:
;
; Se reemplazó la captura de eventos del Loop principal (Repeat) 
; Ahora se usa WindowEvent() en lugar de WaitWindowEvent()
;
; WaitWindowEvent() es una función que detiene el programa hasta que
; se produce un evento. Eso hace que nuestro Sprite sólo se mueva 
; cuando movemos el ratón o presionamos una tecla
;
; Por el contrario, la función WindowEvent() verifica si se
; produce un evento y si no hay eventos, continua con la ejecución 
; del loop (Repeat) evitando que nuestro programa se detenga y por 
; eso el perrito tiene animacion continuada
;  
; Optimización 2:
;
; La operación Sprite_Mov_Secuencia_Actual = Sprite_Mov_Secuencia_Actual+1
; es una operación de actualización de secuencia de imagen que se incluye
; en la detección de cada tecla para animar la figura del sprite
;
; Ahora optimizamos el programa reemplazando todas las operaciones
; de actualización de secuencia que se hacían en cada detección
; de tecla, por una sola. Mejora la actividad del sprite y el
; programa se hace más eficiente al incluir esta operación:
;
;    Sprite_Mov_Secuencia_Actual = Sprite_Mov_Secuencia_Actual+1
; 
; después del FlipBuffers() y antes del UNTIL del loop REPEAT 
;
; Solamente estos dos cambios hacen mucho más agil y eficaz la 
; ejecución de nuestro programa. Por eso también notará que 
; mover al sprite no es tan "pesado" como en la versión anterior,
; que se notaba como una "inercia" que hacía que el movimiento
; fuera mas "pesado" al arrancar.
;
; Si el usuario desea SALIR, puede presionar la tecla ESCAPE 
;
; NOTA IMPORTANTE: para que este programa funcione correctamente, necesitará
; las 18 imagenes bmp animadas para que el perrito se vea activo como en el video
; todo el material esta disponible en nuestra web:
;
; https://profesorponce.blogspot.com/2023/11/curso-de-videojuegos-presentacion.html
;
; también puede descargar las imagenes desde nuestro GitHub:
;
; https://github.com/profesorponce/Curso_Juegos_PureBasic/blob/main/Imagenes%20Sprite%20del%20Perrito%20(Programa%203).rar
;

Enumeration FormMenu
  #Ventana_Principal ; ventana principal del programa
  #CAPTURA           ; label que indica la tecla presionada
  #SPRITE_D1         ; sprites para movimientos a la derecha
  #SPRITE_D2         ; van del D1 al D9 
  #SPRITE_D3         ; Controlado por 
  #SPRITE_D4
  #SPRITE_D5
  #SPRITE_D6
  #SPRITE_D7
  #SPRITE_D8
  #SPRITE_D9
  #SPRITE_I1         ; sprite para movimientos a la izquierda
  #SPRITE_I2         ; van del I1 al I9  
  #SPRITE_I3
  #SPRITE_I4
  #SPRITE_I5
  #SPRITE_I6
  #SPRITE_I7
  #SPRITE_I8
  #SPRITE_I9
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
Sprite_Ancho.l=50 ;50 pixeles de ancho
Sprite_Alto.l=65  ;65 pixeles de alto

;movimientos a derecha e izquierda que controlan 
; el dibujo del sprite
#Mov_Derecha = 0
#Mov_Izquierda = 1
#Mov_Secuencia_Maxima = 9 ;maxima secuencia (solo hay 9 figuras para movimientos a der e izq
Sprite_Mov_Secuencia_Actual = 1   ; empieza en secuencia de movimiento 1 de sprite
Sprite_Mov_Sentido = #Mov_Derecha ; empieza moviendose a la derecha


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

OpenWindow(#Ventana_Principal, 0, 0, MaxAncho, MaxAlto + 50, "Base de Juego-04 (Perrito Hiperactivo)", #FLAGS) ;ventana principal
OpenWindowedScreen(WindowID(#Ventana_Principal),0,0,MaxAncho,MaxAlto) ;ventana grafica para trabajar con el sprite

TextGadget(#CAPTURA, 40, 310, 140, 25, "Tecla........") ; label que muestra que tecla se presionó

;se agregan las keyboard shortcuts para deteactar teclas en el bucle REPEAT
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Left, Key_LEFT)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Up, Key_UP)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Right, Key_RIGHT)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Down, Key_DOWN)
AddKeyboardShortcut(#Ventana_Principal,#PB_Shortcut_Escape, Key_ESC)

SetFrameRate(60)        ; velocidad de movimiento del sprite

; ;se crea la imagen ram del sprite con limites precisos
; CreateSprite(#SPRITE,Sprite_Ancho,Sprite_Alto,#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
; 
; ;se dibuja el sprite en pantalla según las dimensiones declaradas
; StartDrawing(SpriteOutput(#SPRITE))
;    Box(0,0,Sprite_Ancho,Sprite_Alto,RGB(230,10,20)) ;sera de 32x32 pixeles
; StopDrawing()

; carga de sprites de movimiento hacia la derecha
LoadSprite(#SPRITE_D1, "perritod1.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D2, "perritod2.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D3, "perritod3.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D4, "perritod4.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D5, "perritod5.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D6, "perritod6.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D7, "perritod7.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D8, "perritod8.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_D9, "perritod9.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)

; carga de sprites de movimiento hacia la izquierda
LoadSprite(#SPRITE_I1, "perritoi1.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I2, "perritoi2.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I3, "perritoi3.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I4, "perritoi4.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I5, "perritoi5.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I6, "perritoi6.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I7, "perritoi7.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I8, "perritoi8.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)
LoadSprite(#SPRITE_I9, "perritoi9.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)

Sprite_Velocidad.l=20 ; velocidad de movimiento del sprite (se puede variar)

;bucle principal de ejecución controlada
Repeat
  
   ; se limpia la pantalla refrescandola para dibujar el sprite sin superposición
   ClearScreen(RGB(255,255,255)) ;fondo blanco para que sea igual al del sprite
  
   ; se visualiza el sprite en la pantalla (si previamente no usa ClearScreen el
   ; sprite se superpone con el dibujo anterior
   If Sprite_Mov_Sentido = #Mov_Derecha
     Select Sprite_Mov_Secuencia_Actual
       Case 1: DisplaySprite(#SPRITE_D1,Sprite_Pos_X,Sprite_Pos_Y)
       Case 2: DisplaySprite(#SPRITE_D2,Sprite_Pos_X,Sprite_Pos_Y)
       Case 3: DisplaySprite(#SPRITE_D3,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 4: DisplaySprite(#SPRITE_D4,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 5: DisplaySprite(#SPRITE_D5,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 6: DisplaySprite(#SPRITE_D6,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 7: DisplaySprite(#SPRITE_D7,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 8: DisplaySprite(#SPRITE_D8,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 9: DisplaySprite(#SPRITE_D9,Sprite_Pos_X,Sprite_Pos_Y)  
     EndSelect         
   EndIf
   
   If Sprite_Mov_Sentido = #Mov_Izquierda
     Select Sprite_Mov_Secuencia_Actual
       Case 1: DisplaySprite(#SPRITE_I1,Sprite_Pos_X,Sprite_Pos_Y)
       Case 2: DisplaySprite(#SPRITE_I2,Sprite_Pos_X,Sprite_Pos_Y)
       Case 3: DisplaySprite(#SPRITE_I3,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 4: DisplaySprite(#SPRITE_I4,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 5: DisplaySprite(#SPRITE_I5,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 6: DisplaySprite(#SPRITE_I6,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 7: DisplaySprite(#SPRITE_I7,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 8: DisplaySprite(#SPRITE_I8,Sprite_Pos_X,Sprite_Pos_Y)  
       Case 9: DisplaySprite(#SPRITE_I9,Sprite_Pos_X,Sprite_Pos_Y)  
     EndSelect    
   EndIf  
  
   Event.l = WindowEvent() ;WaitWindowEvent() es una función que detiene el programa hasta que
                           ;se produce un evento. Por el contrario, WindowEvent() verifica si se
                           ;produce un evento y si no hay eventos, continua con la ejecución 
                           ;del loop (Repeat) evitando que nuestro programa se detenga y por 
                           ;eso el perrito tiene animacion continuada
   
  
   Select Event
      Case #PB_Event_Menu

         ks=EventMenu() ;Captura de  los keyboard shortcut's
         
         If ks=Key_LEFT ;#PB_Shortcut_Left ------------------
           
           Sprite_Mov_Sentido = #Mov_Izquierda
           SetGadgetText(#CAPTURA,"MOV > Izquierda")
           
           If (Sprite_Pos_X - Sprite_Velocidad) >= Mov_Max_LEFT
             Sprite_Pos_X = Sprite_Pos_X - Sprite_Velocidad
           Else 
             Sprite_Pos_X = Mov_Max_LEFT
           EndIf  

         EndIf
         
         If ks=Key_UP ;#PB_Shortcut_Up --------------------
           
           SetGadgetText(#CAPTURA,"MOV > Arriba")
           
           If (Sprite_Pos_Y - Sprite_Velocidad) >= Mov_Max_UP
             Sprite_Pos_Y = Sprite_Pos_Y - Sprite_Velocidad
           Else 
             Sprite_Pos_Y = Mov_Max_UP
           EndIf  
           
         EndIf
         
         If ks=Key_RIGHT ;#PB_Shortcut_Right -----------------
           
           Sprite_Mov_Sentido = #Mov_Derecha
           SetGadgetText(#CAPTURA,"MOV > Derecha")
           
           If (Sprite_Pos_X + Sprite_Velocidad) <= Mov_Max_RIGHT
             Sprite_Pos_X = Sprite_Pos_X + Sprite_Velocidad
           Else 
             Sprite_Pos_X = Mov_Max_RIGHT
           EndIf  
  
         EndIf
         
         If ks=Key_DOWN ;#PB_Shortcut_Down ------------------
           
           SetGadgetText(#CAPTURA,"MOV > Abajo")
           
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
    
    ;optimizamos el programa reemplazando todas las operaciones
    ;de actualización de secuencia que se hacían en cada detección
    ;de tecla, por una sola. Mejora la actividad del sprite y el
    ;programa se hace más eficiente
    Sprite_Mov_Secuencia_Actual = Sprite_Mov_Secuencia_Actual+1
    
    If Sprite_Mov_Secuencia_Actual > #Mov_Secuencia_Maxima
      Sprite_Mov_Secuencia_Actual = 1
    EndIf  
              
 Until Event = #PB_Event_CloseWindow Or Quit = #True
 
 End

; IDE Options = PureBasic 5.70 LTS (Windows - x86)
; CursorPosition = 62
; FirstLine = 21
; EnableXP
; Executable = Base_de_juego.exe