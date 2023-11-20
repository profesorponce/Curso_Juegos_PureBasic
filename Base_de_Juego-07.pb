; -----------------------------------------------------------------------
; Base_de_Juegos-07 en PureBasic
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

; Programa 07 Movimiento Rectilíneo Uniforme
;            (Soldado CON DISPARO, FOGONAZO y seguimiento de BALA  sobre césped)
;
; ESte programa es una versión mejorada del 06. Continuamos con el soldado, pero
; ahora la ventana es más grande. Además hemos incorporado un fondo (piso de 
; césped) para dar la visualización de que está trabajando en el exterior.
;
; Perfectamente en lugar del fondo de césped se podría haber agregado un escenario
; para ambientar el juego. El fondo de césped se incorporó como una capa de sprite
; que en este caso permanece estático (sin movimiento). El refresco constante de 
; la pantalla que obtenemos mediante clearscreen requiere que inmediatamente despues
; de la limpieza de pantalla que evita la persistencia de sprites superpuestos, se
; proceda a dibujar el césped.
;
; Una segunda modificación muy importante es la incorporación de una rutina que
; al momento de disparar, sigue el trayecto de la bala para dibujarla en la pantalla
; y dar un mejor efecto visual sobre la puntería de nuestro heroe en acción.
; 
; Podrá ver que después del fogonazo del disparo la bala sale del cañon de la pistola
; siguiendo un trayecto recto (Movimiento Rectilíneo Uniforme), que hace más entretenido 
; jugar con el soldado. Todo este efecto está "empaquetado" en la función MOVERBALA
;
; La función MOVERBALA es invocada dentro del bucle REPAT/UNTIL al momento de 
; ejecutarse el disparo. Vea las instrucciones que se ejecutan al presionarse
; la tecla TAB de disparo en:
;
;                     Case Key_TAB ;------------------------------DISPARO
;
; El procedimiento de mover la bala siguiendo su trayectoria a través de un sprite
; no es solamente un procedimiento estético. Se puede seguir extactamente la
; trayectoria de la bala y detectar la COLISION del sprite para determinar si 
; nuestro soldado acertó el disparo a un objeto o a un enemigo que todavía no
; hemos incorporado en el juego.
;
; NOTA IMPORTANTE: para que este programa funcione correctamente, necesitará
; cargar los siguientes archivo:
;
;    1) 9-mm-gunshot.wav -> el archivo de sonido del disparo
;    2) Soldado.bmp -> archivo de imagen del soldado
;    3) Fogonazo.bmp
;    4) Bullet.bmp

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
; La imagen original de la bala era un jpg que se transformó a bmp
; y se redimensionó a 45x34 pixels para el manejo directo del compilador. 
; Se puede descargar la imagen original desde:
; 
; https://static.wikia.nocookie.net/villains/images/7/7a/Bullet.png/revision/latest/scale-to-width-down/260?cb=20200617045537
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



; ------------------------------------------------------------------
; BLOQUES, DECLARACIONES, VARIABLES, INICIALIZACIONES, ETC  --------
;-------------------------------------------------------------------
;
Enumeration FormMenu
  #Ventana_Principal ; ventana principal del programa
  #CAPTURA           ; label que indica la tecla presionada
  #SPRITE            ; trabajaremos con un solo sprite
  #FOGONAZO
  #DISPARO           ; sonido de disparo
  #BALAS             ; label que indica la cantidad de balas disponibles
  #RECARGA           ; recarga de balas
  #CESPED            ; fondo de cesped
  ;#IMAGE_DISPLAY     ; display para visualizar el cesped
  #SPRITEFondo
  #BULLET            ;
EndEnumeration

; variable para detección del keyboard shortcut
ks.l=0

; dimensiones de la ventana principal
MaxAncho.l = 1000  ; maximo ancho de la ventana 450 pixeles
MaxAlto.l = 600   ; alto maximo de la ventana 300 pixeles 

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

OpenWindow(#Ventana_Principal, 0, 0, MaxAncho, MaxAlto + 50, "Movimiento Rectilineo Uniforme", #FLAGS) ;ventana principal
OpenWindowedScreen(WindowID(#Ventana_Principal),0,0,MaxAncho,MaxAlto) ;ventana grafica para trabajar con el sprite

TextGadget(#CAPTURA, 40, MaxAlto+10, 140, 25, "Tecla........") ; label que muestra que tecla se presionó
TextGadget(#BALAS, 200, MaxAlto+10, 140, 25, "[ "+Str(BalasActuales)+" balas ]")   ; label que muestra las balas disponibles
ButtonGadget(#RECARGA, 340, MaxAlto+10, 80, 20, "RECARGAR")

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

; carga del sprite del fogonazo de la pistola del soldado
LoadSprite(#FOGONAZO, "fogonazo.bmp",#PB_Sprite_PixelCollision | #PB_Sprite_AlphaBlending)

; carga de la imagen de fondo (cesped)
LoadSprite(#CESPED, "cesped.bmp") ; se carga como sprite

; carga la imagen de la bala 34x13 pixels
LoadSprite(#BULLET, "bullet.bmp") ; se carga como sprite
TransparentSpriteColor(#BULLET, RGB(255, 255, 255)) ; color blanco del sprite es transparente

Sprite_Velocidad.l=10 ; velocidad de movimiento del sprite (se puede variar)

; carga del sonido de disparo
InitSound()    ; Inicializa el sistema de sonido
LoadSound(#DISPARO, "9-mm-gunshot.wav") ; carga el sonido de la pistola


; ------------------------------------------------------------------
; FUNCIONES Y PROCECIMIENTOS DE SOPORTE ----------------------------
;-------------------------------------------------------------------

Procedure.i MoverBala (Orientacion.i,PosX.i,PosY.i,MaxX.i,MaxY.i) 
  
   ; movimientos posibles de la bala definen la orientación del sprite
   ; y las operaciones matemáticas del cálculo de la trayectoria de la
   ; bala en la pantalla
  
   ; #Mov_Up        = 1  ;             
   ; #Mov_UpRight   = 2  ;  0  1  2    los movimientos 
   ; #Mov_Right     = 3  ;   \ | /     siguen este patron
   ; #Mov_DownRight = 4  ; 7 -   - 3   segun se pulsan las 
   ; #Mov_Down      = 5  ;   / | \     teclas del  
   ; #Mov_DownLeft  = 6  ;  6  5  4    keypad numerico
   ; #Mov_Left      = 7  ;
  
   ; sentido del movimiento de la bala define las operaciones que
   ; deben hacerse sobre los valores de X e Y porque dependiendo
   ; de la posición actual el programa debe calcular la trayectoria
   ; rectilínea uniforme
   ;
   ; el sentido define primero la rotación del sprite de la bala
   ; lo sengundo que define el sentido es el ajuste de las 
   ; operaciones matematicas implicadas en la trayectoria
   ; 
   ; en cada posición inicial posible se hace necesario ajustar la 
   ; posición del sprite de la bala al iniciar el disparo para que
   ; la bala salga enfrentada al cañon de la pistola
  
   ; El procedimiento de mover la bala siguiendo su trayectoria a través de un sprite
   ; no es solamente un procedimiento estético. Se puede seguir extactamente la
   ; trayectoria de la bala y detectar la COLISION del sprite para determinar si 
   ; nuestro soldado acertó el disparo a un objeto o a un enemigo que todavía no
   ; hemos incorporado en el juego.
  
   ; variables auxiliares para los bucles que dibujan la trayectoria 
   ; de la bala
   auxX.i = 0  
   auxY.i = 0
   BulletX.i = 0
   BulletY.i = 0
            
   Select Orientacion
      Case #Mov_Right     
         PosX = PosX +15  ;corrección de posición del la bala
         PosY = PosY + 13 ;corrección de posición del la bala
         RotateSprite(#BULLET, 360, #PB_Absolute) ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > DERECHA")  
         For auxX = PosX To MaxX Step 10
            DisplayTransparentSprite(#BULLET,auxX, PosY) ; se dibuja la bala siguiendo su trayectoria
         Next   
      Case #Mov_Down    
         PosX = PosX + 8  ;corrección de posición del la bala
         PosY = PosY + 23 ;corrección de posición del la bala
         RotateSprite(#BULLET, 90, #PB_Absolute)  
         SetGadgetText(#CAPTURA,"BALA > ABAJO")  ; corrige la posición de la bala en la pantalla
         For auxY = PosY To MaxY Step 10
            DisplayTransparentSprite(#BULLET, PosX,auxY) ; se dibuja la bala siguiendo su trayectoria
         Next            
      Case #Mov_Up         
         PosX = PosX + 5 ;corrección de posición del la bala
         PosY = PosY + 5 ;corrección de posición del la bala
         RotateSprite(#BULLET, 270, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > ARRIBA")  
         For auxY = PosY To 0 Step -10  
            DisplayTransparentSprite(#BULLET, PosX,auxY) ; se dibuja la bala siguiendo su trayectoria
         Next            
      Case #Mov_Left      
         PosX = PosX - 3  ;corrección de posición del la bala
         PosY = PosY + 20 ;corrección de posición del la bala
         RotateSprite(#BULLET, 180, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > IZQUIERDA")  
         For auxX = PosX To 0 Step -10  
            DisplayTransparentSprite(#BULLET, auxX,PosY) ; se dibuja la bala siguiendo su trayectoria
         Next            
      Case #Mov_UpRight 
         PosX = PosX + 17 ;corrección de posición del la bala
         PosY = PosY + 9  ;corrección de posición del la bala     
         RotateSprite(#BULLET, 315, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > ARRIBA + DERECHA")  
         BulletX = PosX
         BulletY = PosY
         For auxX = PosX To MaxX Step 10
            For auxY = PosY To 0 Step -10
               BulletX = BulletX + 10
               BulletY = BulletY - 10
               DisplayTransparentSprite(#BULLET, BulletX,BulletY) ; se dibuja la bala siguiendo su trayectoria             
            Next  
         Next            
      Case #Mov_UpLeft
         PosX = PosX + 2 ;corrección de posición del la bala
         PosY = PosY + 3 ;corrección de posición del la bala
         RotateSprite(#BULLET, 225, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > ARRIBA + IZQUIERDA")  
         BulletX = PosX
         BulletY = PosY
         For auxX = PosX To 0 Step -10
            For auxY = PosY To 0 Step -10
               BulletX = BulletX - 10
               BulletY = BulletY - 10
               DisplayTransparentSprite(#BULLET, BulletX,BulletY) ; se dibuja la bala siguiendo su trayectoria             
            Next  
         Next                     
      Case #Mov_DownRight 
         PosX = PosX + 27 ;corrección de posición del la bala
         PosY = PosY + 30 ;corrección de posición del la bala
         RotateSprite(#BULLET, 45, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > ABAJO + DERECHA")  
         BulletX = PosX
         BulletY = PosY
         For auxX = PosX To MaxX Step 10
            For auxY = PosY To MaxY Step 10
               BulletX = BulletX + 10
               BulletY = BulletY + 10
               DisplayTransparentSprite(#BULLET, BulletX,BulletY) ; se dibuja la bala siguiendo su trayectoria             
            Next  
         Next   
      Case #Mov_DownLeft  
         PosX = PosX      ;corrección de posición del la bala
         PosY = PosY + 30 ;corrección de posición del la bala
         Sentido$ = "-+"
         RotateSprite(#BULLET, 135, #PB_Absolute)  ; corrige la posición de la bala en la pantalla
         SetGadgetText(#CAPTURA,"BALA > ABAJO + IZQUIERDA")  
         BulletX = PosX
         BulletY = PosY
         For auxX = PosX To 0 Step -10
            For auxY = PosY To MaxY Step 10
               BulletX = BulletX - 10
               BulletY = BulletY + 10
               DisplayTransparentSprite(#BULLET, BulletX,BulletY) ; se dibuja la bala siguiendo su trayectoria             
            Next  
         Next   
      Default
    EndSelect
   
  ProcedureReturn 1
EndProcedure 

; ------------------------------------------------------------------
; BUCLE PRINCIPAL DEL PROGRAMA -------------------------------------
;-------------------------------------------------------------------

;bucle principal de ejecución controlada
Repeat
  
   ; se limpia la pantalla refrescandola para dibujar el sprite sin superposición
   ClearScreen(RGB(255,255,255)) ;  se limpia fondo con color blanco
   
   ; se visualiza el sprite en la pantalla (si previamente no usa ClearScreen el
   ; sprite se superpone con el dibujo anterior
   
   ; se carga primero el piso de cesped que pisa el soldado (podría ser un plano)
   ; que a diferencia de un sprite normal, permanece estático y sin movimiento
   DisplaySprite(#CESPED,0,0) 
   
   ; luego se carga el sprite del soldado en la nueva posición luego de
   ;haberse movido
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
                       MoverBala (#Mov_Right, Sprite_Pos_X+180, Sprite_Pos_Y+134, MaxAncho, MaxAlto) 
                    Case #Mov_Down  
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+18,Sprite_Pos_Y+180)   
                       MoverBala (#Mov_Down, Sprite_Pos_X+18, Sprite_Pos_Y+180, MaxAncho, MaxAlto)
                    Case #Mov_Left
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X-25,Sprite_Pos_Y+19)   
                       MoverBala (#Mov_Left, Sprite_Pos_X-25, Sprite_Pos_Y+19, MaxAncho, MaxAlto)
                    Case #Mov_Up
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+132,Sprite_Pos_Y-25)   
                       MoverBala (#Mov_Up, Sprite_Pos_X+132, Sprite_Pos_Y-25, MaxAncho, MaxAlto)
                    Case #Mov_UpLeft
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+40,Sprite_Pos_Y-32)   
                       MoverBala (#Mov_UpLeft, Sprite_Pos_X+40, Sprite_Pos_Y-32, MaxAncho, MaxAlto)
                    Case #Mov_UpRight
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+185,Sprite_Pos_Y+42)   
                       MoverBala (#Mov_UpRight, Sprite_Pos_X+185,Sprite_Pos_Y+42, MaxAncho, MaxAlto)
                    Case #Mov_DownRight
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X+101,Sprite_Pos_Y+186)   
                       MoverBala (#Mov_DownRight, Sprite_Pos_X+101, Sprite_Pos_Y+186, MaxAncho, MaxAlto)
                    Case #Mov_DownLeft
                       DisplayTransparentSprite(#FOGONAZO,Sprite_Pos_X-39,Sprite_Pos_Y+104)   
                       MoverBala (#Mov_DownLeft, Sprite_Pos_X-39, Sprite_Pos_Y+104, MaxAncho, MaxAlto)
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
; CursorPosition = 283
; FirstLine = 3
; Folding = -
; EnableXP
; Executable = Programa07.exe