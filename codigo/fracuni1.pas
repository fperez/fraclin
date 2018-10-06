Unit FracUni1;    { Esta unidad contiene todas las rutinas y variables
                   usadas por el programa FRACTALES .
                   Fue creada 'pegando' las unidades  VARI, WIN, WIN1,
                   DEFDEMO, AYUDA y GRFRAC.                        } 

Interface

Uses

  Dos, Crt, Graph;

Type

  Modo         =  (Geo, Cart);
  Palabra75    =  String[75];
  Letras80     =  String[80];
  Ventanas     =  (Dem,Ecua,Pant,Graf,Disk);
  Vector5      =  Array [1..5] of Integer;

  Localizacion = Record
    Ventana : Ventanas;
    Renglon : Integer;
  End;

{ Window title string }

  TitleStr = string[63];

{ Window frame characters }

  FrameChars = array[1..8] of Char;

{ Window state record }

  WinState = record
    WindMin, WindMax: Word;
    WhereX, WhereY: Byte;
    TextAttr: Byte;
  end;


  TitleStrPtr = ^TitleStr;

  WinRecPtr = ^WinRec;
  WinRec = Record
    Next: WinRecPtr;
    State: WinState;
    Title: TitleStrPtr;
    TitleAttr, FrameAttr: Byte;
    Buffer: Pointer;
  End;


Const

  F1 = #1 ;
  CtrlF1 = #2;
  Esc = #27;
  CRight  = ^D;
  CUp     = ^E;
  CEnter  = ^M;
  CLeft   = ^S;
  CDown   = ^X;
  CExit   = ^Q;
  Si      = True;
  No      = False;

{ Standard frame character sets }

  SingleFrame: FrameChars = 'ÚÄ¿³³ÀÄÙ';
  DoubleFrame: FrameChars = 'ÉÍ»ººÈÍ¼';




VAR

    Esquinas              : Vector5;
    Textos                : Array [Dem..Disk,1..12] Of String;
    Posicion              : Localizacion;
    RenglonActivo         : String;
    RenglonAnterior       : String;
    Renglon               : Integer;
    VentActiva            : Ventanas;
    NuevaVent             : Boolean;
    Done                  : Boolean;
    Ch                    : Char;
    Opcion                : Char;
    CaminoControl         : String;
    Titulo                : String[30];
    XMax,YMax,Xcen,Ycen,
    X0,Xa,Xb,Y0,Ya,Yb,
    DXp,DYp               : Integer;
    ControlGrafico,
    ModoGrafico,Fila,Colum,
    CodError,TotTran      : Integer;
    ColorCaja,ColorPuntos,
    ColorFondo            : Byte;
    ColorEjes,ColorTexto  : Byte;
    ColorMaximo           : Word;
    GrAbierta,PanPeq,
    TrEjes                : Boolean;
    Escx,Escy,CenX,CenY,
    Xcom,Xfin,Ycom,Yfin,
    Aleat,Rasp,DXm,DYm    : Real;
    ModoActivo            : Modo;
    MatTran               : Array [1..8,1..6] of Real;
    MatTranG              : Array [1..8,1..6] of Real;
    ProbTran              : Array [1..8] of Real;

    DirInfo               : SearchRec;
    Directorio            : DirStr;
    Camino                : String;

    TxLinPpales, FonLinPpales,
    TxVenNor, FonVenNor,
    TxRes, FonRes, TxVenEsp, FonVenEsp      : Byte;

    TitVenAct, MarVenAct, BorVenAct,
    TitVenAy, MarVenAy, BorVenAy,
    TitVenErr, MarVenErr, BorVenErr,
    TitVenEcVig, MarVenEcVig, BorVenEcVig,
    TitVenEcua, MarVenEcua, BorVenEcua,
    TitVenPres, MarVenPres, BorVenPres      : Byte;
    TopWindow                               : WinRecPtr;
    WindowCount                             : Integer;

             { Termina la declaraci¢n de variables }



{ Direct write routines }

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ Window handling routines }

procedure FillWin(Ch: Char; Attr: Byte);
procedure ReadWin(var Buf);
procedure WriteWin(var Buf);
function WinSize: Word;
procedure SaveWin(var W: WinState);
procedure RestoreWin(var W: WinState);
procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
procedure UnFrameWin;
Procedure ActiveWindow(Active: Boolean);
Procedure OpenWindow(X1, Y1, X2, Y2: Byte; T: TitleStr;
                     TAttr, FAttr: Byte);
Procedure CloseWindow;

{ Procedimientos de demostracion : } 
Procedure Sierpinski;
Procedure VonKoch;
Procedure Bronchi;
Procedure Helecho;
Procedure Hoja;
Procedure Arbol;
Procedure Caracoles;
Procedure Molinos;

{ Procedimientos de ayuda:  }
Procedure W(Texto : String);
Procedure EspereTecla;
Procedure EspereEsc;
Procedure Instrucciones;
Procedure Ayude(Pos : Localizacion);

{ Procedimientos Gr ficos: }
Procedure IniGraf;
Procedure DefModGraf;
Procedure Escriba(Xx,Yy: Real; Texto: Letras80);
Procedure Marco;
Procedure DefEjes(Peq : Boolean);
Procedure DefPantalla;
Procedure Pantalla(Xm,Ym : Real; Var Xp,Yp : Integer);
Procedure MarcoEjes;
Procedure TrazaEjes(Peq : Boolean);
Procedure PantallaInicial;
Procedure CierreGraf;


IMPLEMENTATION

{$L WIN}

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);
external {WIN};

procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);
external {WIN};

procedure FillWin(Ch: Char; Attr: Byte);
external {WIN};

procedure WriteWin(var Buf);
external {WIN};

procedure ReadWin(var Buf);
external {WIN};

function WinSize: Word;
external {WIN};

procedure SaveWin(var W: WinState);
begin
  W.WindMin := WindMin;
  W.WindMax := WindMax;
  W.WhereX := WhereX;
  W.WhereY := WhereY;
  W.TextAttr := TextAttr;
end;

procedure RestoreWin(var W: WinState);
begin
  WindMin := W.WindMin;
  WindMax := W.WindMax;
  GotoXY(W.WhereX, W.WhereY);
  TextAttr := W.TextAttr;
end;

procedure FrameWin(Title: TitleStr; var Frame: FrameChars;
  TitleAttr, FrameAttr: Byte);
var
  W, H, Y: Word;
begin
  W := Lo(WindMax) - Lo(WindMin) + 1;
  H := Hi(WindMax) - Hi(WindMin) + 1;
  WriteChar(1, 1, 1, Frame[1], FrameAttr);
  WriteChar(2, 1, W - 2, Frame[2], FrameAttr);
  WriteChar(W, 1, 1, Frame[3], FrameAttr);
  if Length(Title) > W - 2 then Title[0] := Chr(W - 2);
  WriteStr((W - Length(Title)) shr 1 + 1, 1, Title, TitleAttr);
  for Y := 2 to H - 1 do
  begin
    WriteChar(1, Y, 1, Frame[4], FrameAttr);
    WriteChar(W, Y, 1, Frame[5], FrameAttr);
  end;
  WriteChar(1, H, 1, Frame[6], FrameAttr);
  WriteChar(2, H, W - 2, Frame[7], FrameAttr);
  WriteChar(W, H, 1, Frame[8], FrameAttr);
  Inc(WindMin, $0101);
  Dec(WindMax, $0101);
end;

procedure UnFrameWin;
begin
  Dec(WindMin, $0101);
  Inc(WindMax, $0101);
end;


Procedure ActiveWindow;
  Begin
    if TopWindow <> nil then
    begin
      UnFrameWin;
      with TopWindow^ do
        if Active then
          FrameWin(Title^, DoubleFrame, TitleAttr, FrameAttr)
        else
          FrameWin(Title^, SingleFrame, FrameAttr, FrameAttr);
    End;
  End;   { Termina ActiveWindow }


Procedure OpenWindow;
  Var
    W: WinRecPtr;
  Begin
    ActiveWindow(False);
    New(W);
    with W^ do
    begin
      Next := TopWindow;
      SaveWin(State);
      GetMem(Title, Length(T) + 1);
      Title^ := T;
      TitleAttr := TAttr;
      FrameAttr := FAttr;
      Window(X1, Y1, X2, Y2);
      GetMem(Buffer, WinSize);
      ReadWin(Buffer^);
      FrameWin(T, DoubleFrame, TAttr, FAttr);
    end;
    TopWindow := W;
    Inc(WindowCount);
  End;    { Termina OpenWindow }


Procedure CloseWindow;
  Var
    W: WinRecPtr;
  Begin
    if TopWindow <> nil then
    begin
      W := TopWindow;
      with W^ do
      begin
        UnFrameWin;
        WriteWin(Buffer^);
        FreeMem(Buffer, WinSize);
        FreeMem(Title, Length(Title^) + 1);
        RestoreWin(State);
        TopWindow := Next;
      end;
      Dispose(W);
      ActiveWindow(True);
      Dec(WindowCount);
    End;
  End;   { Termina CloseWindow }


Procedure Sierpinski;
  Begin
    Xcom:=0;
    Xfin:=1;
    Ycom:=0;
    Yfin:=1.1;
    Titulo:='Triangulo de Sierpinski';
    Tottran:=3;
    Probtran[1]:=0.333;
    Probtran[2]:=0.333;
    Probtran[3]:=0.334;
    Mattran[1,1]:=0.5 ;Mattran[1,2]:=0;
    Mattran[1,3]:=0   ;Mattran[1,4]:=0.5;
    Mattran[1,5]:=0   ;Mattran[1,6]:=0;
    Mattran[2,1]:=0.5 ;Mattran[2,2]:=0;
    Mattran[2,3]:=0   ;Mattran[2,4]:=0.5;
    Mattran[2,5]:=0.5 ;Mattran[2,6]:=0;
    Mattran[3,1]:=0.5 ;Mattran[3,2]:=0;
    Mattran[3,3]:=0   ;Mattran[3,4]:=0.5;
    Mattran[3,5]:=0.25;Mattran[3,6]:=0.5;
  End;


Procedure VonKoch;
  Begin
    Xcom:=0.33;
    Xfin:=0.67;
    Ycom:=0;
    Yfin:=0.4;
    Titulo:='Curva de Von Koch';
    Tottran:=4;
    Probtran[1]:=0.25;
    Probtran[2]:=0.25;
    Probtran[3]:=0.25;
    Probtran[4]:=0.25;
    Mattran[1,1]:=0.33333  ; Mattran[1,2]:=0        ;
    Mattran[1,3]:=0        ; Mattran[1,4]:=0.33333  ;
    Mattran[1,5]:=0        ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.33333  ; Mattran[2,2]:=0        ;
    Mattran[2,3]:=0        ; Mattran[2,4]:=0.33333  ;
    Mattran[2,5]:=0.66666  ; Mattran[2,6]:=0        ;
    Mattran[3,1]:=0.16667  ; Mattran[3,2]:=-0.28867 ;
    Mattran[3,3]:=0.28867  ; Mattran[3,4]:=0.16667  ;
    Mattran[3,5]:=0.33333  ; Mattran[3,6]:=0        ;
    Mattran[4,1]:=-0.16667 ; Mattran[4,2]:=0.28867  ;
    Mattran[4,3]:=0.28867  ; Mattran[4,4]:=0.16667  ;
    Mattran[4,5]:=0.66666  ; Mattran[4,6]:=0        ;
  End;


Procedure Bronchi;
  Begin
    Xcom:=-1.3;
    Xfin:=1.3;
    Ycom:=0;
    Yfin:=1.45;
    Titulo:='Curva de Bronchi';
    Tottran:=4;
    Probtran[1]:=0.15;
    Probtran[2]:=0.15;
    Probtran[3]:=0.35;
    Probtran[4]:=0.35;
    Mattran[1,1]:=0.05     ; Mattran[1,2]:=0        ;
    Mattran[1,3]:=0        ; Mattran[1,4]:=0.5      ;
    Mattran[1,5]:=0        ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.05     ; Mattran[2,2]:=0        ;
    Mattran[2,3]:=0        ; Mattran[2,4]:=-0.5     ;
    Mattran[2,5]:=0        ; Mattran[2,6]:=0.8      ;
    Mattran[3,1]:=0        ; Mattran[3,2]:=-0.8     ;
    Mattran[3,3]:=0.5      ; Mattran[3,4]:=0        ;
    Mattran[3,5]:=0        ; Mattran[3,6]:=0.8      ;
    Mattran[4,1]:=0        ; Mattran[4,2]:=0.8      ;
    Mattran[4,3]:=-0.5     ; Mattran[4,4]:=0        ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=0.85     ;
  End;


Procedure Helecho;
  Begin
    Xcom:=-4;
    Xfin:=4;
    Ycom:=0;
    Yfin:=20;
    Titulo:='Helecho';
    Tottran:=4;
    Probtran[1]:=0.0572;
    Probtran[2]:=0.5724;
    Probtran[3]:=0.1852;
    Probtran[4]:=0.1852;
    Mattran[1,1]:=0   ;Mattran[1,2]:=0;
    Mattran[1,3]:=0   ;Mattran[1,4]:=0.17;
    Mattran[1,5]:=0   ;Mattran[1,6]:=0;
    Mattran[2,1]:=0.84962;Mattran[2,2]:=0.0255;
    Mattran[2,3]:=-0.0255;Mattran[2,4]:=0.84962;
    Mattran[2,5]:=0 ;Mattran[2,6]:=3;
    Mattran[3,1]:=-0.1554 ;Mattran[3,2]:=0.235;
    Mattran[3,3]:=0.19583 ;Mattran[3,4]:=0.18648;
    Mattran[3,5]:=0;Mattran[3,6]:=1.2;
    Mattran[4,1]:=0.1554;Mattran[4,2]:=-0.235;
    Mattran[4,3]:=0.19583;Mattran[4,4]:=0.18648;
    Mattran[4,5]:=0;Mattran[4,6]:=3;
  End;


Procedure Hoja;
  Begin
    Xcom:=0;
    Xfin:=1.05;
    Ycom:=0;
    Yfin:=1;
    Titulo:='Hoja';
    Tottran:=4;
    Probtran[1]:=0.3333;
    Probtran[2]:=0.3333;
    Probtran[3]:=0.1667;
    Probtran[4]:=0.1667;
    Mattran[1,1]:=0.64987  ; Mattran[1,2]:=-0.013   ;
    Mattran[1,3]:=0.013    ; Mattran[1,4]:=0.64987  ;
    Mattran[1,5]:=0.175    ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.64948  ; Mattran[2,2]:=-0.026   ;
    Mattran[2,3]:=0.026    ; Mattran[2,4]:=0.64948  ;
    Mattran[2,5]:=0.165    ; Mattran[2,6]:=0.325    ;
    Mattran[3,1]:=0.3182   ; Mattran[3,2]:=-0.3182  ;
    Mattran[3,3]:=0.3182   ;Mattran[3,4]:=0.3182    ;
    Mattran[3,5]:=0.2      ; Mattran[3,6]:=0        ;
    Mattran[4,1]:=0.3182   ; Mattran[4,2]:=-0.3182  ;
    Mattran[4,3]:=0.3182   ; Mattran[4,4]:=0.3182   ;
    Mattran[4,5]:=0.8      ; Mattran[4,6]:=0        ;
  End;


Procedure Arbol;
  Begin
    Xcom:=-1;
    Xfin:=1;
    Ycom:=0;
    Yfin:=2.25;
    Titulo:='Arbol';
    Tottran:=6;
    Probtran[1]:=0.1   ;
    Probtran[2]:=0.1   ;
    Probtran[3]:=0.2   ;
    Probtran[4]:=0.2   ;
    Probtran[5]:=0.2   ;
    Probtran[6]:=0.2   ;
    Mattran[1,1]:=0.05     ; Mattran[1,2]:=0        ;
    Mattran[1,3]:=0        ; Mattran[1,4]:=0.6      ;
    Mattran[1,5]:=0        ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.05     ; Mattran[2,2]:=0        ;
    Mattran[2,3]:=0        ; Mattran[2,4]:=-0.5     ;
    Mattran[2,5]:=0        ; Mattran[2,6]:=1        ;
    Mattran[3,1]:=0.46     ; Mattran[3,2]:=-0.32    ;
    Mattran[3,3]:=0.39     ;Mattran[3,4]:=0.38      ;
    Mattran[3,5]:=0        ; Mattran[3,6]:=0.6      ;
    Mattran[4,1]:=0.47     ; Mattran[4,2]:=-0.15    ;
    Mattran[4,3]:=0.17     ; Mattran[4,4]:=0.42     ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=1.1      ;
    Mattran[5,1]:=0.43     ; Mattran[5,2]:=0.28     ;
    Mattran[5,3]:=-0.25    ; Mattran[5,4]:=0.45     ;
    Mattran[5,5]:=0        ; Mattran[5,6]:=1        ;
    Mattran[6,1]:=0.42     ; Mattran[6,2]:=0.26     ;
    Mattran[6,3]:=-0.35    ; Mattran[6,4]:=0.31     ;
    Mattran[6,5]:=0        ; Mattran[6,6]:=0.7      ;
  End;


Procedure Caracoles;
  Begin
    Xcom:=-6;
    Xfin:=4;
    Ycom:=-5.5;
    Yfin:=7;
    Titulo:='Caracoles';
    Tottran:=2;
    Probtran[1]:=0.42 ;
    Probtran[2]:=0.58 ;
    Mattran[1,1]:=0.5      ; Mattran[1,2]:=-0.2     ;
    Mattran[1,3]:=0.2      ; Mattran[1,4]:=0.6      ;
    Mattran[1,5]:=-1       ; Mattran[1,6]:=-2       ;
    Mattran[2,1]:=0.8      ; Mattran[2,2]:=0.5      ;
    Mattran[2,3]:=-0.6     ; Mattran[2,4]:=0.4      ;
    Mattran[2,5]:=-1       ; Mattran[2,6]:=2        ;
  End;


Procedure Molinos;
  Begin
    Xcom:=-2.15;
    Xfin:=1.5;
    Ycom:=-0.6;
    Yfin:=2.9;
    Titulo:='Molinos';
    Tottran:=4;
    Probtran[1]:=0.145;
    Probtran[2]:=0.145;
    Probtran[3]:=0.426;
    Probtran[4]:=0.284;
    Mattran[1,1]:=0.02     ; Mattran[1,2]:=0        ;
    Mattran[1,3]:=0        ; Mattran[1,4]:=0.5      ;
    Mattran[1,5]:=0        ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.02     ; Mattran[2,2]:=0        ;
    Mattran[2,3]:=0        ; Mattran[2,4]:=-0.5     ;
    Mattran[2,5]:=0        ; Mattran[2,6]:=0.5      ;
    Mattran[3,1]:=0.64952  ; Mattran[3,2]:=-0.375   ;
    Mattran[3,3]:=0.375    ; Mattran[3,4]:=0.64952  ;
    Mattran[3,5]:=0        ; Mattran[3,6]:=1        ;
    Mattran[4,1]:=0        ; Mattran[4,2]:=0.5      ;
    Mattran[4,3]:=-0.5     ; Mattran[4,4]:=0        ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=1.2      ;
  End;


Procedure W;
  Begin
    Writeln(' '+Texto);
  End;


Procedure VentAyuda(X1,Y1,X2,Y2 : Integer);
  Begin
    OpenWindow(X1,Y1,X2,Y2,'AYUDA',
        TitVenAy+ BorVenAy*16, MarVenAy+ BorVenAy*16);
    TextAttr:=TxVenEsp + FonVenEsp*16;
    ClrScr;
  End;


Procedure EspereTecla;
  Var
    Tecla : Char;
  Begin
    Tecla:=Readkey;
    If  Tecla = #0 then Tecla:=Readkey;
  End;     { Termina EspereTecla }


Procedure EspereEsc;
  Var
    Te : Char;
  Begin
    Repeat Te:= Readkey Until Te=Esc;
  End;


Procedure Cierre;
  Begin
    CloseWindow;
    TextAttr:=TxVenNor + FonVenNor*16;
  End;


Procedure Instrucciones;
  Begin
    OpenWindow(4,3,77,24,'PRESENTACION', TitVenPres + BorVenPres*16,
                MarVenPres + BorVenPres*16);
    TextAttr:=TxVenEsp + FonVenEsp*16;
    ClrScr;
    Writeln;
    W('Este es un programa interactivo para trabajar con objetos Fractales.');
    W('En particular, est  dise¤ado para manejar fractales lineales generados');
    W('por iteraci¢n de un conjunto de transformaciones afines del plano.');
    W('Permite manipular un m ximo de 8 transformaciones, alterar cualquiera');
    W('de sus par metros, y escoger el formato de graficaci¢n (es decir, ');
    W('la presentaci¢n en pantalla) que se desee para observar la gr fica');
    W('del fractal.');
    Writeln;
    W('Para manejarlo, use las flechas del teclado para desplazar la barra');
    W('de color por las diferentes opciones y ventanas del programa. Para ');
    W('ejecutar alguna operaci¢n, pulse <ENTER> cuando tenga la barra de ');
    W('color sobre dicha opci¢n.');
    Writeln;
    W('Si desea informaci¢n adicional sobre alg£n punto, pulse la tecla F1.');
    W('Aparecer  en el centro de su pantalla una ventana que le dar  detalles');
    W('sobre la parte del programa donde se encuentre ubicado en ese momento.');
    Write(' Para cerrar estas ventanas de ayuda y volver al trabajo normal, simple-');
    Write(' mente pulse cualquier tecla, a menos que se le den otras instrucciones.');
    Writeln;
    Write('          Pulse cualquier tecla para regresar al programa.');
    EspereTecla;
    Cierre;
  End;  { Termina Instrucciones }


Procedure Ayude;

  Begin
    With Pos do
      Case Ventana of

        Dem : Begin
                 VentAyuda(10,7,70,16);
                 Writeln;
                 W('En esta ventana se le presentan algunos fractales listos');
                 W('para ser graficados. Seleccione con el cursor el nombre ');
                 W('del que desee ver y pulse <ENTER>. La graficaci¢n se ');
                 W('efectuar  inmediatamente. A continuaci¢n, si lo desea,');
                 W('puede manipular las ecuaciones y la presentaci¢n en pan-');
                 Write(' talla empleando los men£s correspondientes.');
                 EspereTecla;
                 Cierre;
               End;      { Fin de la opcion Dem }

        Ecua : Case Renglon of
                 2 : Begin
                       VentAyuda(10,9,70,15);
                       Writeln;
                       W('Esta opci¢n le permite ver las ecuaciones actualmente');
                       W('vigentes, simult neamente en modo Cartesiano y en modo');
                       Write(' Geom‚trico.');
                       EspereTecla;
                       Cierre;
                     End;
                 3 : Begin
                       VentAyuda(10,3,70,20);
                       Writeln;
                       W('Aqu¡, puede Ud. introducir sus propias transformaciones');
                       W('afines del plano (hasta 8) para que el programa las ');
                       W('grafique.');
                       Writeln;
                       W('Recuerde que una TA est  definida como:');
                       W(' ');
                       W('                     T : Rý --> Rý');
                       W('                     Ú          ¿   Ú   ¿   Ú    ¿');
                       W('                     ³ A11  A12 ³   ³ x ³   ³ B1 ³');
                       W('  (x,y) --> T(x,y) = ³          ³ * ³   ³ + ³    ³');
                       W('                     ³ A21  A22 ³   ³ y ³   ³ B2 ³');
                       W('                     À          Ù   À   Ù   À    Ù');
                       W(' ');
                       Write('          Pulse cualquier tecla para continuar.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(8,4,72,22);
                       Writeln;
                       W('Tambi‚n se le ofrece la alternativa de emplear par metros');
                       W('geom‚tricos para manipular las ecuaciones. Esto es, usar');
                       W('las variables r, s, é y í, relacionadas as¡ con las A11..A22:');
                       W(' ');
                       W('      |r| = û(A11ý+A21ý), con signo(r) = signo(A11);');
                       W('      |s| = û(A12ý+A22ý), con signo(s) = signo(A22);');
                       W('       é = arctan(A21/A11),  í = arctan(-A12/A22).');
                       W(' ');
                       W('Se interpretan as¡:');
                       W(' r : Factor de multiplicaci¢n de las distancias en el eje X.');
                       W(' s : Factor de multiplicaci¢n de las distancias en el eje Y.');
                       W(' é : Angulo que rota el eje X.');
                       W(' í : Angulo que rota el eje Y.');
                       W(' ');
                       Write('            Pulse cualquier tecla para continuar.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(10,7,70,17);
                       Writeln;
                       W('Si escoge el modo geom‚trico, exprese los  ngulos en ');
                       W('grados. Finalmente, para garantizar que todas las trans-');
                       W('formaciones sean contractoras, el programa rechazar ');
                       W('aquellas para las que ³r³ò1 ¢ ³s³ò1, y le solicitar  que');
                       W('las digite de nuevo.');
                       W(' ');
                       Write('          Pulse <Esc> para volver al programa.');
                       EspereEsc;
                       Cierre;
                     End;
                 4 : Begin
                       VentAyuda(10,6,70,19);
                       Writeln;
                       W('Desde aqu¡ es posible alterar cualquier par metro en ');
                       W('las ecuaciones vigentes. Simplemente digite los n£meros');
                       W('de la transformaci¢n y el par metro (1-6) que desea');
                       W('alterar, y luego entre el nuevo valor.');
                       Writeln;
                       W('Recuerde que los rangos son:');
                       Writeln;
                       W('                       ³Aij³ < 1;');
                       Writeln;
                       Write('               ³r³ y ³s³ < 1, ³é³ y ³í³ ó 90ø;');
                       EspereTecla;
                       Cierre;
                     End;
                 5 : Begin
                       VentAyuda(10,10,70,17);
                       Writeln;
                       W('Para alterar el modo en que se le presentan las ecua-');
                       W('ciones vigentes en la parte inferior de su pantalla,');
                       W('simplemente pulse <ENTER>. Esto conmutar  el modo activo');
                       Write(' entre las opciones Cartesiano y Geom‚trico.');
                       EspereTecla;
                       Cierre;
                     End;
               End;  { Fin del Case Renglon of para Ecuaciones }

        Pant : Begin
                 VentAyuda(9,4,73,19);
                 Writeln;
                 W('Este men£ le  permite manipular la presentaci¢n de las');
                 W('gr ficas en pantalla:');
                 W(' - Con las primeras cuatro opciones, seleccione qu‚ regi¢n');
                 W('del plano XY desea ver, definiendo los intervalos en los ');
                 W('ejes X y Y que enmarcan dicha regi¢n.');
                 W(' - En "Ejes", escoja si desea o no ver trazados los ejes XY');
                 W('en la pantalla. Estos llevan indicadas divisiones num‚ricas');
                 W('para facilitarle la elecci¢n de una regi¢n de graficaci¢n.');
                 W(' - En "Zona", escoja qu‚ porci¢n de la pantalla se usa para');
                 W('presentar la gr fica (las opciones son Grande o Peque¤a).');
                 W(' - Finalmente, la £ltima alternativa le permite cambiar el ');
                 Write(' nombre a la figura.');
                 EspereTecla;
                 Cierre;
               End;     { Fin de la opci¢n Pant }

        Graf : Begin
                 VentAyuda(10,7,71,18);
                 Writeln;
                 W('Pulsando <ENTER>, comenzar  la graficaci¢n de las ');
                 W('ecuaciones actualmente vigentes, de acuerdo con las con-');
                 W('diciones de presentaci¢n indicadas en el men£ "Pantalla".');
                 W('Para suspender la graficaci¢n, pulse cualquier tecla. ');
                 W('Esto le permitir  ver cu ntas iteraciones se han realizado');
                 W('hasta el momento. En ese punto, pulse la letra C para ');
                 W('continuar graficando, o la tecla <Esc> para regresar al ');
                 Write(' programa principal.');

                 EspereTecla;
                 Cierre;
               End;     { Fin de la opci¢n Graf }

        Disk : Case Renglon Of

                 2 : Begin
                       VentAyuda(10,7,70,16);
                       Writeln;
                       W('Esta opci¢n le muestra cu l es el directorio actualmente');
                       W('vigente, y le permite alterarlo si lo desea. Dicho direc-');
                       W('torio es el empleado por el programa para sus operaciones');
                       W('de grabaci¢n y lectura de archivos. Por lo tanto, si ');
                       W('desea manejar sus figuras en un directorio de su elecci¢n');
                       Write(' deber  especific rselo al programa desde aqu¡.');
                       EspereTecla;
                       Cierre;
                     End;

                 3 : Begin
                       VentAyuda(10,8,71,16);
                       Writeln;
                       W('Aqu¡ ver  una lista de todas las figuras grabadas en el');
                       W('directorio activo. Si desea cambiar ‚ste, utilice para');
                       W('ello la opci¢n "DIRECTORIO".');
                       W('Recuerde que el programa graba autom ticamente las figuras');
                       Write(' con extensi¢n .FRA .');
                       EspereTecla;
                       Cierre;
                     End;


                 4 : Begin
                       VentAyuda(10,6,70,17);
                       Writeln;
                       W('Para grabar en disco las ecuaciones y la regi¢n de grafi-');
                       W('caci¢n de una figura cualquiera, teclee el nombre (de ');
                       W('m ximo 8 letras) del archivo donde se almacenar  dicha ');
                       W('informaci¢n. La grabaci¢n quedar  en el directorio ');
                       W('actualmente vigente, y el archivo ser  autom ticamente');
                       W('creado con extensi¢n .FRA. Si desea grabar en otro ');
                       W('directorio diferente, use la opci¢n "DIRECTORIO" del');
                       Write(' men£ ARCHIVO.');
                       EspereTecla;
                       Cierre;
                     End;

                 5 : Begin
                       VentAyuda(10,7,71,18);
                       Writeln;
                       W('Para recuperar una figura previamente grabada, teclee el');
                       W('nombre del archivo donde se encuentra. La lectura se har ');
                       W('en el directorio actualmente vigente. ');
                       W('Para ver qu‚ figuras hay all¡, use la opci¢n "VER DIR".');
                       W('Para leer en otro lugar, emplee "DIRECTORIO", y defina un');
                       W('nuevo camino de lectura.');
                       W('Al conclu¡r la lectura, ejecute la opci¢n "GRAFICAR" para');
                       Write(' obtener la figura en pantalla.');
                       EspereTEcla;
                       Cierre;
                     End;

                 6 : Begin
                       VentAyuda(20,9,60,16);
                       Writeln;
                       W('Aqu¡, puede usted abandonar FRACTALES');
                       W('y regresar al DOS. Antes de salir, el');
                       W('programa le pedir  que confirme su');
                       Write(' decisi¢n.');
                       EspereTEcla;
                       Cierre;
                     End;

               End;  { Fin del Case Renglon Of de la opcion Disk }

      End;  { Fin del Case Ventana Of }

End; { Fin del Proc. ayude }


Procedure IniGraf;     { Inicializa el modo gr fico,                  }
                       { y reporta cualquier error que pueda occurir. }

  Begin
    Repeat

    {$IFDEF Use8514}                     { Verifica Use8514 $DEFINE }
      ControlGrafico := IBM8514;
      ModoGrafico := IBM8514Hi;
    {$ELSE}
      ControlGrafico := Detect;                { Use autodetecci¢n }
    {$ENDIF}

      InitGraph(ControlGrafico, ModoGrafico, CaminoControl);
      CodError:= GraphResult;             { Preserva la condici¢n de error }
      If CodError<> grOK then             { Error? }
        begin
          Writeln;Writeln;
          Writeln('Error gr fico : ', GraphErrorMsg(CodError));
          Halt(1);                  { Error: Termine el programa }
        end;
    Until CodError= grOK;
    GrAbierta:=true;
  End; { Termina el proc. Inigraf }


Procedure DefModGraf;     { Encuentra los ppales par metros }
                          { del modo gr fico activo.        }
  Var
    Xasp,Yasp: Word;

  Begin
    GetAspectRatio(Xasp,Yasp);
    Rasp:=xasp/yasp;
    Xmax := GetMaxX;
    Ymax := GetMaxY;
    Xcen:=round(Xmax/2);
    Ycen:=round(Ymax/2);
    ColorMaximo:=GetMaxColor;
    Fila:=Round(Ymax/25);
    Colum:=Round(Xmax/90);
  End;   { Termina DefModGraf }


Procedure Escriba;
  Begin
    SetTextJustify(LeftText,BottomText);
    Outtextxy(Round(Xx*Colum),Round(Yy*Fila),Texto);
  End;   { Termina Escriba }


Procedure Marco;    {Le dibuja un marco a la pantalla}
  Begin
    Rectangle(3,3,Xmax-3,Ymax-3);
  End;


Procedure DefEjes;
 { Define los extremos del sistema de coordenadas en que vamos a trabajar. }
 { Previamente, deben haber sido llamados IniGraf y DefModGraf. }

  Begin
    If Peq Then
      Begin
        Xb:=Round((25*Xmax)/26);
        Xa:=Round(Xb-((0.7*Ymax)/Rasp));
        Ya:=Round(0.9*Ymax);
        Yb:=Round(0.1*Ymax);
      End
    Else
      Begin
        Xb:=Xmax-10;
        Xa:=Round(Xb-(0.68*Xmax));
        Yb:=8;
        Ya:=Ymax-TextHeight('M')-20;
      End;
  End;         { Termina DefEjes }


Procedure DefPantalla;

  Begin
    DXp:=Xb-Xa;
    DYp:=Yb-Ya;
    DXm:=Xfin-Xcom; { # de 'unidades de mundo' equivalentes a DXp (de pantalla) }
    DYm:=Yfin-Ycom; { # de 'unidades de mundo' equivalentes a DYp (de pantalla) }
    X0:=Round (Xb-((DXp*Xfin)/DXm));
    Y0:=Round (Yb-((DYp*Yfin)/DYm));
  End;      { Termina DefPantalla }


Procedure Pantalla(Xm,Ym : Real; Var Xp,Yp : Integer);
  { Transforma las coordenadas de 'mundo' (Xm,Ym) en coordenadas de
    pantalla (Xp,Yp), usando el sistema definido en Defejes  }

  Begin
    Xp:=Round (((DXp*Xm)/DXm) + X0);
    Yp:=Round (((DYp*Ym)/DYm) + Y0);
  End;     { Termina Pantalla }


Procedure Linea(X1,Y1,X2,Y2: Real);
                 { Permite trazar una l¡nea usando coord. de 'mundo' }
  Var
    X1p,Y1p,X2p,Y2p : Integer;

  Begin
    DefPantalla;
    Pantalla(X1,Y1,X1p,Y1p);
    Pantalla(X2,Y2,X2p,Y2p);
    Line(X1p,Y1p,X2p,Y2p);
  End;   { Termina el Proc. Linea }


Procedure MarcoEjes;  { Traza un marco alrededor de los ejes }
  Begin
    Rectangle(Xa-7, Yb-5, Xb+7, Ya+5);
  End;


Procedure TrazaEjes;   { Traza los ejes Xm-Ym (de 'mundo') en pantalla }

  Var
    I,Posx,Posy   : Integer;
    Division      : String[6];

  Begin
    DefPantalla;
    SetColor(ColorEjes);
    SetLineStyle(SolidLn,0,ThickWidth);
    If (Y0>=Yb) and (Y0<=Ya) Then Line(Xa,Y0,Xb,Y0);
    If (X0>=Xa) and (X0<=Xb) Then Line(X0,Ya,X0,Yb);
    If Peq Then
      Begin
        Line(Xa,Y0+3,Xa,Y0-3);
        Line(Xb,Y0+3,Xb,Y0-3);
        Line(X0-3,Ya,X0+3,Ya);
        Line(X0-3,Yb,X0+3,Yb);
      End;
    If Not(Peq) Then        { Si la pantalla activa es la grande,  }
      Begin                 { se colocan las divisiones y escalas. }
        Posx:=Xa;
        Posy:=Ya;
        SetTextJustify(CenterText,CenterText);
        For I:=1 to 8 do
          Begin
            SetColor(ColorEjes);
            If (Y0>=Yb) and (Y0<=Ya) Then Line(Posx,Y0+3,Posx,Y0-3);
            SetColor(ColorTexto);
            Str(Xcom+(I-1)*((Xfin-Xcom)/8):6:3,Division);
            OutTextXY(Posx,Round((Ymax+Ya+2)/2),Division);
            Inc(Posx,Round((Xb-Xa)/8));
          End;
        SetTextJustify(RightText,CenterText);
        SetColor(ColorEjes);
        If (Y0>=Yb) and (Y0<=Ya) Then Line(Xb,Y0+3,Xb,Y0-3);
        SetColor(ColorTexto);
        Str(Xfin:3:1,Division);
        OutTextXY(Xmax-4,Round((Ymax+Ya+2)/2),Division);
        SetTextJustify(RightText,CenterText);
        For I:=1 to 11 do
          Begin
            SetColor(ColorEjes);
            If (X0>=Xa) and (X0<=Xb) Then Line(X0-4,Posy,X0+4,Posy);
            SetColor(ColorTexto);
            Str(Ycom+(I-1)*((Yfin-Ycom)/11):6:3,Division);
            OutTextXY(Xa-12,Posy,Division);
            Inc(Posy,Round((Yb-Ya)/11));
          End;
        SetColor(ColorEjes);
        If (X0>=Xa) and (X0<=Xb) Then Line(X0-4,Yb,X0+4,Yb);
        SetTextJustify(RightText,TopText);
        SetColor(ColorTexto);
        Str(Yfin:6:3,Division);
        OutTextXY(Xa-12,Yb,Division);
        SetLineStyle(SolidLn,0,NormWidth);
      End;
  End;    { Termina TrazaEjes }


Procedure PantallaInicial;  { Genera la pantalla de presentaci¢n del programa }

  Var
    Tam : Array[1..3,1..4] of Integer;


  Procedure Tamanos;  { Este es un subproc. de PantallaInicial }
    Begin

      Case Xmax of
         0..350 : Begin             { CGA }
                   Tam[1,1]:=40;  Tam[1,2]:=10;
                   Tam[2,1]:=8 ;  Tam[2,2]:=10;
                   Tam[3,1]:=6 ;  Tam[3,2]:=10;
                  End;
       351..700 : Begin             { VGA }
                   Tam[1,1]:=38;  Tam[1,2]:=10;
                   Tam[2,1]:=90;  Tam[2,2]:=100;
                   Tam[3,1]:=60;  Tam[3,2]:=100;
                  End;
      701..1000 : Begin             { Herc }
                   Tam[1,1]:=42;  Tam[1,2]:=10;
                   Tam[2,1]:=75;  Tam[2,2]:=100;
                   Tam[3,1]:=60;  Tam[3,2]:=100;
                  End;
     1001..2000 : Begin             { 8514 }
                   Tam[1,1]:=24;  Tam[1,2]:=10;
                   Tam[2,1]:=56;  Tam[2,2]:=100;
                   Tam[3,1]:=38;  Tam[3,2]:=100;
                  End;

      End;        { Fin del Case Xmax Of }

      Case Ymax of
         0..210 : Begin             { CGA }
                   Tam[1,3]:=18;  Tam[1,4]:=10;
                   Tam[2,3]:=40;  Tam[2,4]:=100;
                   Tam[3,3]:=3 ;  Tam[3,4]:=10;
                  End;
       211..360 : Begin             { Herc }
                   Tam[1,3]:=30;  Tam[1,4]:=10;
                   Tam[2,3]:=60;  Tam[2,4]:=100;
                   Tam[3,3]:=27;  Tam[3,4]:=100;
                  End;
       361..500 : Begin             { VGA }
                   Tam[1,3]:=38;  Tam[1,4]:=10;
                   Tam[2,3]:=8 ;  Tam[2,4]:=10;
                   Tam[3,3]:=4 ;  Tam[3,4]:=10;
                  End;
      501..1000 : Begin             { 8514 }
                   Tam[1,1]:=24;  Tam[1,2]:=10;
                   Tam[2,1]:=5 ;  Tam[2,2]:=10;
                   Tam[3,1]:=25;  Tam[3,2]:=100;
                  End;

      End;        { Fin del Case Ymax Of }

    End;      { Fin del subproc. Tamanos }


 Begin            { Comienza el proc. Pantalla Inicial }

   Tamanos;

   SetTextJustify(CenterText,CenterText);
   SetBkColor(ColorFondo);
   SetColor(ColorPuntos);
   SetLineStyle(SolidLn,0,ThickWidth);
   Rectangle(0,0,Xmax,Ymax);

   SetUserCharSize(Tam[1,1],Tam[1,2],Tam[1,3],Tam[1,4]);
   SetTextStyle(GothicFont, HorizDir, UserCharSize);
   OutTextXY(Xcen+1,Round((3*YMax)/8),'Fractales');
   OutTextXY(Xcen,Round((3*YMax)/8),'Fractales');

   SetUserCharSize(Tam[2,1],Tam[2,2],Tam[2,3],Tam[2,4]);
   SetTextStyle(TriplexFont, HorizDir, UserCharSize);
   OutTextXY(Xcen,Round((4.8*YMax)/8),'Version 1.0');

   SetUserCharSize(Tam[3,1],Tam[3,2],Tam[3,3],Tam[3,4]);
   SetTextStyle(SansSerifFont, HorizDir, UserCharSize);
   OutTextXY(Xcen,Round((9.2*YMax)/10),'FERNANDO PEREZ');
   OutTextXY(Xcen,Round((9.6*YMax)/10),'   DPTO. DE FISICA, U. DE ANTIOQUIA, 1991.');

   Delay(3000);

 End;    { Termina PantallaInicial }


Procedure CierreGraf;       { Cierra la unidad Graph y actualiza la     }
  Begin                     { variable de control (GrAbierta, boolean). }
    CloseGraph;
    GrAbierta:=False;
  End;



BEGIN
END.