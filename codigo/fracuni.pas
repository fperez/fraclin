Unit FracUni;    { Esta unidad contiene todas las rutinas y variables
                   usadas por el programa FRACTALES .
                   Fue creada 'pegando' las unidades  VARI, WIN, WIN1,
                   DEFDEMO, AYUDA y GRFRAC.                        } 

Interface

Uses

  Dos, Crt, Graph;

Type

  Modo         =  (Geo, Cart);
  Modulo       =  (Control,Programa);
  Palabra30    =  String[30];
  Palabra40    =  String[40];
  Palabra75    =  String[75];
  Palabra80    =  String[80];
  Ventanas     =  (Dem,Ecua,Pant,Graf,Disk);
  VentanasCont =  (Instruc,Oper,Info,Suger,Salir);

  Vector5      =  Array [1..5] of Integer;

  Localizacion = Record
    Ventana : Ventanas;
    Renglon : Integer;
  End;

  LocalizacionCont = Record
    Ventana : VentanasCont;
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

  F1      = #1 ;
  F2      = #2 ;
  CtrlF1  = #3;
  Esc     = #27;
  PgUp    = ^W;
  PgDn    = ^Z;
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

    Esquinas              : Array [Dem..Disk,1..5] of Integer;
    Textos                : Array [Dem..Disk,1..12] Of String;
    EsquinasC             : Array [Instruc..Salir,1..5] of Integer;
    TextosC               : Array [Instruc..Salir,1..12] Of String;
    PosicionC             : LocalizacionCont;
    Posicion              : Localizacion;
    RenglonActivo         : String;
    RenglonAnterior       : String;
    Renglon               : Integer;
    VentActiva            : Ventanas;
    ModuloActivo          : Modulo;
    NuevaVent,PantIni,
    SalirPrograma,
    SalirControl          : Boolean;
    Ch                    : Char;
    Opcion                : Char;
    CaminoControl         : String;
    Titulo                : Palabra30;
    XMax,YMax,Xcen,Ycen,
    X0,Xa,Xb,Y0,Ya,Yb,
    DXp,DYp,
    FacEscX,FacEscY       : Integer;
    ControlGrafico,
    ModoGrafico,Fila,Colum,
    CodError,TotTran      : Integer;
    ColorCaja,ColorPuntos : Word;
    ColorPant             : Word;
    ColorEjes,ColorTexto  : Word;
    ColorMaximo           : Word;
    GrAbierta,PanPeq,
    TrEjes                : Boolean;
    Escx,Escy,CenX,CenY,
    Xcom,Xfin,Ycom,Yfin,
    Rasp,DXm,DYm          : Real;
    ModoActivo            : Modo;
    MatTran               : Array [1..8,1..6] of Real;
    MatTranG              : Array [1..8,1..6] of Real;
    ProbTran              : Array [1..8] of Real;

    DirInfo               : SearchRec;
    Directorio            : DirStr;
    Camino                : String;

    Activas               : Array[1..8] of Boolean;
    Colores               : Array [1..8] of Word;

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
Procedure Vicsek;
Procedure Cristales;


{ Procedimientos de ayuda y control:  }
Procedure AsigneColores;
Procedure Beep;
Procedure Wxy(x,y : Integer; Texto : Palabra75);
Function ReadChar: Char;
Procedure Lea(Var Numero : Real);
Procedure LeaEnteroPos(Var Numero : Word);
Procedure LeaNombre(Tam : Integer; Var Texto : Palabra30);
Procedure EscribaV(Texto : String);
Procedure Resaltar(Texto : String);
Function NumTexto(Numero:Real;Ancho:Byte;Decimales:Byte):String;
Procedure W(Texto : String);
Procedure Wf(Texto : String);
Procedure EspereTecla;
Procedure EspereEsc;
Procedure AbrirVentana(Nueva : Boolean);
Procedure MoverIzq;
Procedure MoverDer;
Procedure MoverArriba;
Procedure MoverAbajo;
Procedure Cierre;
Procedure Instrucciones;
Procedure Ayude(Pos : Localizacion);


{ Rutinas del programa: }
Procedure AsigneMatTran;
Procedure AsigneMatTranG;
Procedure CrearProbTran;
Procedure Salida(Var CodigoAbandono: Boolean);
Procedure Apague;


{ Procedimientos Gr ficos: }
Procedure IniGraf;
Procedure DefModGraf;
Procedure Escriba(Xx,Yy: Real; Texto: Palabra80);
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
    Titulo:='Tri ngulo de Sierpinski';
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
    Xcom:=0;
    Xfin:=1;
    Ycom:=-0.25;
    Yfin:=0.6;
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
    Xcom:=-1.5;
    Xfin:=1.5;
    Ycom:=-0.1;
    Yfin:=1.7;
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
    Mattran[3,3]:=0.6      ; Mattran[3,4]:=0        ;
    Mattran[3,5]:=0        ; Mattran[3,6]:=0.8      ;
    Mattran[4,1]:=0        ; Mattran[4,2]:=0.8      ;
    Mattran[4,3]:=-0.65    ; Mattran[4,4]:=0        ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=0.8     ;
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
    Xfin:=1;
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
    Mattran[3,3]:=0.3182   ; Mattran[3,4]:=0.3182    ;
    Mattran[3,5]:=0.2      ; Mattran[3,6]:=0        ;
    Mattran[4,1]:=-0.3182   ; Mattran[4,2]:=0.3182  ;
    Mattran[4,3]:=0.3182   ; Mattran[4,4]:=0.3182   ;
    Mattran[4,5]:=0.8      ; Mattran[4,6]:=0        ;
  End;


Procedure Arbol;
  Begin
    Xcom:=-1;
    Xfin:=1;
    Ycom:=-0.03;
    Yfin:=2.1;
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
    Mattran[3,3]:=0.39     ; Mattran[3,4]:=0.38     ;
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
    Mattran[2,1]:=0.75     ; Mattran[2,2]:=0.5      ;
    Mattran[2,3]:=-0.6     ; Mattran[2,4]:=0.4      ;
    Mattran[2,5]:=-1       ; Mattran[2,6]:=2        ;
  End;


Procedure Molinos;
  Begin
    Xcom:=-2.15;
    Xfin:=1.5;
    Ycom:=-0.9;
    Yfin:=2.8;
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
    Mattran[3,1]:=0.5303307; Mattran[3,2]:=-0.5303307;
    Mattran[3,3]:=0.5303307; Mattran[3,4]:=0.5303307;
    Mattran[3,5]:=0        ; Mattran[3,6]:=1        ;
    Mattran[4,1]:=0        ; Mattran[4,2]:=0.5      ;
    Mattran[4,3]:=-0.5     ; Mattran[4,4]:=0        ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=1.2      ;
  End;


Procedure Vicsek;
  Begin
    Xcom:=-0.1;
    Xfin:=3.1;
    Ycom:=-0.1;
    Yfin:=3.1;
    Titulo:='Curva de Vicsek';
    Tottran:=5;
    Probtran[1]:=0.2   ;
    Probtran[2]:=0.2   ;
    Probtran[3]:=0.2   ;
    Probtran[4]:=0.2   ;
    Probtran[5]:=0.2   ;
    Mattran[1,1]:=0.333333 ; Mattran[1,2]:=0        ;
    Mattran[1,3]:=0        ; Mattran[1,4]:=0.333333 ;
    Mattran[1,5]:=0        ; Mattran[1,6]:=0        ;
    Mattran[2,1]:=0.333333 ; Mattran[2,2]:=0        ;
    Mattran[2,3]:=0        ; Mattran[2,4]:=0.333333 ;
    Mattran[2,5]:=2        ; Mattran[2,6]:=0        ;
    Mattran[3,1]:=0.333333 ; Mattran[3,2]:=0        ;
    Mattran[3,3]:=0        ; Mattran[3,4]:=0.333333 ;
    Mattran[3,5]:=1        ; Mattran[3,6]:=1        ;
    Mattran[4,1]:=0.333333 ; Mattran[4,2]:=0        ;
    Mattran[4,3]:=0        ; Mattran[4,4]:=0.333333 ;
    Mattran[4,5]:=0        ; Mattran[4,6]:=2        ;
    Mattran[5,1]:=0.333333 ; Mattran[5,2]:=0        ;
    Mattran[5,3]:=0        ; Mattran[5,4]:=0.333333 ;
    Mattran[5,5]:=2        ; Mattran[5,6]:=2        ;
  End;


Procedure Cristales;
  Begin
    Xcom:=-0.05;
    Xfin:=1.05;
    Ycom:=-0.5;
    Yfin:=0.8;
    Titulo:='Cristales';
    Tottran:=3;
    Probtran[1]:=0.333;
    Probtran[2]:=0.333;
    Probtran[3]:=0.334;
    Mattran[1,1]:=0.5 ;Mattran[1,2]:=0;
    Mattran[1,3]:=0   ;Mattran[1,4]:=-0.5;
    Mattran[1,5]:=0   ;Mattran[1,6]:=0;
    Mattran[2,1]:=0.5 ;Mattran[2,2]:=0;
    Mattran[2,3]:=0   ;Mattran[2,4]:=-0.5;
    Mattran[2,5]:=0.5 ;Mattran[2,6]:=0;
    Mattran[3,1]:=0.5 ;Mattran[3,2]:=0;
    Mattran[3,3]:=0   ;Mattran[3,4]:=-0.5;
    Mattran[3,5]:=0.25;Mattran[3,6]:=0.5;
  End;


Procedure AsigneColores;

  Begin
    If ColorMaximo in [1..5] Then
      Begin

     { Monitor monocrom tico. }
     { Colores de las ventanas de texto : }
        {SetPalette(LightGray,Blue);}
        TxLinPpales := Black;
        FonLinPpales:= LightGray;
        TxVenNor    := LightGray;
        FonVenNor   := Black;
        TxVenEsp    := Black;
        FonVenEsp   := LightGray;
        TxRes       := Black;
        FonRes      := LightGray;
        TitVenAct   := LightGray;
        MarVenAct   := LightGray;
        BorVenAct   := Black;
        TitVenAy    := LightGray;
        MarVenAy    := LightGray;
        BorVenAy    := Black;
        TitVenErr   := LightGray;
        MarVenErr   := LightGray;
        BorVenErr   := Black;
        TitVenEcVig := Black;
        MarVenEcVig := Black;
        BorVenEcVig := LightGray;
        TitVenEcua  := Black;
        MarVenEcua  := Black;
        BorVenEcua  := LightGray;
        TitVenPres  := LightGray;
        MarVenPres  := LightGray;
        BorVenPres  := Black;

     { Colores de la parte gr fica : }
        ColorPuntos := 1;
        ColorPant   := Black;
        ColorCaja   := Black;
        ColorTexto  := 1;
        ColorEjes   := 1;
        
      End

    Else
      Begin

     { Monitor en colores. }
     { Colores de las ventanas de texto : }
        TxLinPpales := Yellow;
        FonLinPpales:= Blue;
        TxVenNor    := LightGray;
        FonVenNor   := Black;
        TxVenEsp    := Black;
        FonVenEsp   := LightGray;
        TxRes       := Yellow;
        FonRes      := Red;
        TitVenAct   := Red;
        MarVenAct   := Red;
        BorVenAct   := LightGray;
        TitVenAy    := Yellow;
        MarVenAy    := LightGray;
        BorVenAy    := Blue;
        TitVenErr   := Yellow;
        MarVenErr   := Yellow;
        BorVenErr   := Red;
        TitVenEcVig := Blue;
        MarVenEcVig := Blue;
        BorVenEcVig := LightGray;
        TitVenEcua  := Red;
        MarVenEcua  := Black;
        BorVenEcua  := LightGray;
        TitVenPres  := Red;
        MarVenPres  := Red;
        BorVenPres  := LightGray;

      { Colores de la parte gr fica : }
        ColorPuntos := Yellow;
        ColorPant   := Blue;
        ColorCaja   := Black;
        ColorTexto  := White;
        ColorEjes   := LightRed;

      End;
  End;  { Termina AsigneColores }


Procedure Beep;
  Begin
    Sound(500); Delay(25); NoSound;
  End;


Procedure Wxy(x,y : Integer; Texto : Palabra75);
  Begin
    If Grabierta Then CierreGraf;
    Gotoxy(x,y);
    Write(Texto);
  End;


Function ReadChar: Char;
  Var
    Ch: Char;
  Begin
    Ch := ReadKey;
    If Ch = #0 then
      Case ReadKey of
        #45: Ch := CExit;     { Alt-X }
        #72: Ch := CUp;       { Up }
        #75: Ch := CLeft;     { Left }
        #77: Ch := CRight;    { Right }
        #80: Ch := CDown;     { Down }
        #59: Ch := F1;
        #60: Ch := F2;
        #94: Ch := CtrlF1;
        #73: Ch := PgUp;
        #81: Ch := PgDn;
      end;
    ReadChar := Ch;
  End;  { Termina la fn. ReadChar }


Procedure Lea(Var Numero : Real);

 Const
   Bksp  = #8;
   Enter = #13;
   Esc   = #27;

 Var
   Fil,Col,Cod,LongMax : Integer;
   NumLet              : String[20];
   Tec                 : Char;

 Begin
   LongMax:=15;
   Fil:=WhereY;
   NumLet:='';
   Repeat
     Tec:=Readkey;
     If  (Length(NumLet)<LongMax) Then
       Case Tec of
         '-' : If Length(NumLet)=0 Then
               Begin
                 NumLet:='-';
                 Write(Tec);
               End;
         '.' : If (Pos('.',NumLet)=0) Then
               Begin
                 NumLet:=NumLet+Tec;
                 Write(Tec);
               End;
         '0'..'9' : Begin
                      NumLet:=NumLet+Tec;
                      Write(Tec);
                    End;
       End;  { Fin del Case }
     Case Tec of
       Bksp : Begin
                If Length(Numlet)>0 Then
                  Begin
                    Delete(NumLet,Length(NumLet),1);
                    Col:=WhereX-1;
                    GotoXY(Col,Fil);Write(' ');
                    GotoXY(Col,Fil);
                  End;
              End;
       #0 : Begin
              Tec:=Readkey;
              If Tec = #59 Then Ayude(Posicion);   { Reconoce F1 }
              If Tec = #94 Then Instrucciones;     { Reconoce Ctrl-F1 }
            End;
     End;   { Fin del Case }

   Until (Tec in [Enter,Esc]);
   If (Tec=Enter) and (NumLet<>'') Then Val(NumLet,Numero,Cod) Else Numero:=Numero;
 End;   { Termina Lea }


Procedure LeaEnteroPos;

 Const
   Bksp  = #8;
   Enter = #13;
   Esc   = #27;

 Var
   Fil,Col,Cod,LongMax : Integer;
   NumLet              : String[13];
   Tec                 : Char;

 Begin
   LongMax:=11;
   Fil:=WhereY;
   NumLet:='';
   Repeat
     Tec:=Readkey;
     If  (Length(NumLet)<LongMax) Then
       Case Tec of
         '0'..'9' : Begin
                      NumLet:=NumLet+Tec;
                      Write(Tec);
                    End;
       End;   { Fin del Case }
     Case Tec of
       Bksp : Begin
                If Length(Numlet)>0 Then
                  Begin
                    Delete(NumLet,Length(NumLet),1);
                    Col:=WhereX-1;
                    GotoXY(Col,Fil);Write(' ');
                    GotoXY(Col,Fil);
                  End;
              End;
       #0 : Begin
              Tec:=Readkey;
              If Tec = #59 Then Ayude(Posicion);   { Reconoce F1 }
              If Tec = #94 Then Instrucciones;     { Reconoce Ctrl-F1 }
            End;
     End;   { Fin del Case }
   Until (Tec in [Enter,Esc]);
   If (Tec=Enter) and (NumLet<>'') Then Val(NumLet,Numero,Cod) Else Numero:=Numero;
 End;   { Termina LeaEntero }


Procedure LeaNombre;

Const
   Bksp  = #8;
   Enter = #13;
   Esc   = #27;

 Var
   Fil,Col,Cod         : Integer;
   TexProv             : String;
   Tec                 : Char;

 Begin
   Fil:=WhereY;
   Col:=WhereX;
   TexProv:='';
   Repeat
     Tec:=Readkey;
     Case Tec of
       #32..#255: Begin
                    If Length(TexProv)<Tam Then
                      Begin
                        TexProv:=TexProv+Tec;
                        Write(Tec);
                        Inc(Col);
                      End;
                  End;
       Bksp : Begin
                If Length(TexProv)>0 Then
                  Begin
                    Delete(TexProv,Length(TexProv),1);
                    Dec(Col);
                    GotoXY(Col,Fil);Write(' ');
                    GotoXY(Col,Fil);
                  End;
              End;
       #0 : Begin
              Tec:=Readkey;
              If Tec = #59 Then Ayude(Posicion);   { Reconoce F1 }
              If Tec = #94 Then Instrucciones;     { Reconoce Ctrl-F1 }
            End;
       End;   { Fin del Case }
   Until Tec in [Enter,Esc];
   If (Tec=Enter) and (TexProv<>'') Then Texto:=TexProv Else Texto:=Texto;
 End;   { Termina Lea }


Procedure  EscribaV(Texto : String);
  Var
    LugarY : Integer;
  Begin
    LugarY:=WhereY;
    Write(Texto);
    If WhereX<>1 Then  ClrEol;
    GotoXY(1,LugarY+1);
  End;  { Termina EscribaV }


Procedure  Resaltar(Texto : String);
  Var
    LugarY : Integer;
  Begin
    LugarY:=WhereY;
    TextAttr:=TxRes + FonRes*16;
    Write(Texto);
    If WhereX<>1 Then  ClrEol;
    GotoXY(1,LugarY);
    TextAttr:=TxVenNor + FonVenNor*16;
  End;  { Termina Resaltar }


Function NumTexto(Numero:Real;Ancho:Byte;Decimales:Byte):String;
  Var
    Texto : String;
  Begin
    Str(Numero:Ancho:Decimales,Texto);
    NumTexto:=Texto;
  End;  { Termina la Funci¢n NumTexto }


Procedure W;
  Begin
    Writeln(' '+Texto);
  End;


Procedure Wf;
  Begin
    Write(' '+Texto);
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
    Tecla : Char;
  Begin
    Repeat
      Tecla:= Readkey;
      If Tecla<>Esc Then Beep;
    Until Tecla=Esc;
  End;


Procedure AbrirVentana;

  Var
    CuentaFilas   : Integer;
    TituloVentana : String;
    Ventana       : Ventanas;
    VentanaC      : VentanasCont;
  Begin
    If ModuloActivo=Programa Then
      Begin
        Ventana:=Posicion.Ventana;
        TituloVentana:=Textos[Ventana,1];
        OpenWindow(Esquinas[Ventana,1],Esquinas[Ventana,2],Esquinas[Ventana,3],
                   Esquinas[Ventana,4],TituloVentana,TitVenAct + BorVenAct*16,
                   MarVenAct + BorVenAct*16);
        ClrScr;
        For CuentaFilas:=2 To Esquinas[Ventana,5] Do
            EscribaV(Textos[Ventana,CuentaFilas]);
        If Nueva Then Posicion.Renglon:=2;
        RenglonActivo:=Textos[Posicion.Ventana,Posicion.Renglon];
        GotoXY(1,Posicion.Renglon-1);
        Resaltar(RenglonActivo);
      End
    Else           { Si esta en el modulo de control: }
      Begin
        VentanaC:=PosicionC.Ventana;
        TituloVentana:=TextosC[VentanaC,1];
        OpenWindow(EsquinasC[VentanaC,1],EsquinasC[VentanaC,2],EsquinasC[VentanaC,3],
                   EsquinasC[VentanaC,4],TituloVentana,TitVenAct + BorVenAct*16,
                   MarVenAct + BorVenAct*16);
        ClrScr;
        For CuentaFilas:=2 To EsquinasC[VentanaC,5] Do
            EscribaV(TextosC[VentanaC,CuentaFilas]);
        If Nueva Then PosicionC.Renglon:=2;
        RenglonActivo:=TextosC[PosicionC.Ventana,PosicionC.Renglon];
        GotoXY(1,PosicionC.Renglon-1);
        Resaltar(RenglonActivo);
      End
  End;   { Termina AbrirVentana }



Procedure MoverIzq;
  Begin
    NuevaVent:=True;
    If ModuloActivo=Programa Then
      Begin
        If Posicion.Ventana>Dem Then
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Dec(Posicion.Ventana);
                   AbrirVentana(NuevaVent);
                 End
               Else
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Posicion.Ventana:=Disk;
                   AbrirVentana(NuevaVent);
                 End;
      End
    Else         { Si esta en el modulo de control: }
      Begin
        If PosicionC.Ventana>Instruc Then
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Dec(PosicionC.Ventana);
                   AbrirVentana(NuevaVent);
                 End
               Else
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   PosicionC.Ventana:=Salir;
                   AbrirVentana(NuevaVent);
                 End;
      End;
  End;   { Termina MoverIzq }


Procedure MoverDer;
  Begin
    NuevaVent:=True;
    If ModuloActivo=Programa Then
      Begin
        If Posicion.Ventana<Disk Then
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Inc(Posicion.Ventana);
                   AbrirVentana(NuevaVent);
                 End
               Else
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Posicion.Ventana:=Dem;
                   AbrirVentana(NuevaVent);
                 End;
      End
    Else
      Begin
        If PosicionC.Ventana<Salir Then
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   Inc(PosicionC.Ventana);
                   AbrirVentana(NuevaVent);
                 End
               Else
                 Begin
                   Repeat CloseWindow Until Windowcount=0;
                   PosicionC.Ventana:=Instruc;
                   AbrirVentana(NuevaVent);
                 End;
      End
  End;   { Termina MoverDer }


Procedure MoverArriba;
  Var
    LugarY : Integer;
  Begin
    LugarY:=WhereY;
    RenglonAnterior:=RenglonActivo;
    Write(RenglonAnterior);
    If WhereX<>1 Then ClrEol;
    GotoXY(1,LugarY);
    If ModuloActivo=Programa Then
      Begin
        If LugarY <> 1 Then
          Begin
            Dec(LugarY);
            Dec(Posicion.Renglon);
          End
        Else
          Begin
            LugarY:=Esquinas[Posicion.Ventana,5]-1;
            Posicion.Renglon:=Esquinas[Posicion.Ventana,5];
          End;
        RenglonActivo:=Textos[Posicion.Ventana,Posicion.Renglon];
      End
    Else             { Si esta en el modulo de control: }
      Begin
        If LugarY <> 1 Then
          Begin
            Dec(LugarY);
            Dec(PosicionC.Renglon);
          End
        Else
          Begin
            LugarY:=EsquinasC[PosicionC.Ventana,5]-1;
            PosicionC.Renglon:=EsquinasC[PosicionC.Ventana,5];
          End;
        RenglonActivo:=TextosC[PosicionC.Ventana,PosicionC.Renglon];
      End;
    GotoXY(1,LugarY);
    Resaltar(RenglonActivo);
  End;   { Termina  MoverArriba }


Procedure MoverAbajo;
  Var
    LugarY : Integer;
  Begin
    LugarY:=WhereY;
    RenglonAnterior:=RenglonActivo;
    Write(RenglonAnterior);
    If WhereX<>1 Then ClrEol;
    GotoXY(1,LugarY);
    If ModuloActivo=Programa Then
      Begin
        If LugarY<>Esquinas[Posicion.Ventana,5]-1 Then
          Begin
            Inc(LugarY);
            Inc(Posicion.Renglon);
          End
        Else
          Begin
            LugarY:=1;
            Posicion.Renglon:=2;
          End;
        RenglonActivo:=Textos[Posicion.Ventana,Posicion.Renglon];
      End
    Else               { Si esta en el modulo de control: }
      Begin
        If LugarY<>EsquinasC[PosicionC.Ventana,5]-1 Then
          Begin
            Inc(LugarY);
            Inc(PosicionC.Renglon);
          End
        Else
          Begin
            LugarY:=1;
            PosicionC.Renglon:=2;
          End;
        RenglonActivo:=TextosC[PosicionC.Ventana,PosicionC.Renglon];
      End;
    GotoXY(1,LugarY);
    Resaltar(RenglonActivo);
  End;   { Termina  MoverAbajo }


Procedure Cierre;
  Begin
    CloseWindow;
    TextAttr:=TxVenNor + FonVenNor*16;
  End;


Procedure Instrucciones;
  Begin
    OpenWindow(1,1,80,25,'PRESENTACION', TitVenPres + BorVenPres*16,
                MarVenPres + BorVenPres*16);
    TextAttr:=TxVenEsp + FonVenEsp*16;
    ClrScr;
    Writeln;
    W('Este es un programa interactivo para trabajar con objetos Fractales. En');
    W('particular, est  dise¤ado para manejar fractales lineales generados por');
    W('iteraci¢n de un conjunto de transformaciones afines del plano. Permite mani-');
    W('pular un m ximo de 8 transformaciones, alterar cualquiera de sus par metros,');
    W('y escoger el formato de graficaci¢n (es decir, la presentaci¢n en pantalla)');
    W('que se desee para observar la gr fica del fractal.');
    Writeln;
    W('Para manejarlo, use las flechas del teclado para desplazar la barra de color');
    W('por las diferentes opciones y ventanas del programa. Para ejecutar alguna');
    W('operaci¢n, pulse <ENTER> cuando tenga la barra de color sobre dicha opci¢n.');
    Writeln;
    W('Si desea informaci¢n adicional sobre alg£n punto, pulse la tecla F1.');
    W('Aparecer  en el centro de su pantalla una ventana que le dar  detalles sobre');
    W('la parte del programa donde se encuentre ubicado en ese momento. Para cerrar');
    W('estas ventanas de ayuda y volver al trabajo normal, simplemente pulse cual-');
    W('quier tecla, a menos que se le den otras instrucciones.');
    Writeln;
    W('Cuando escoja la opci¢n de salir, regresar  al m¢dulo de informaci¢n con el');
    Write(' cual comenz¢ el programa. Recuerde que all¡ est n las instrucciones completas');
    W('para usar a FraLin 1.2, y datos adicionales sobre el mundo de los fractales.');
    Writeln;
    Wf('               Pulse cualquier tecla para regresar al programa.');
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
                 Wf('talla empleando los men£s correspondientes.');
                 EspereTecla;
                 Cierre;
               End;      { Fin de la opcion Dem }

        Ecua : Case Renglon of
                 2 : Begin
                       VentAyuda(10,9,70,15);
                       Writeln;
                       W('Esta opci¢n le permite ver las ecuaciones actualmente');
                       W('vigentes, simult neamente en modo Cartesiano y en modo');
                       Wf('Geom‚trico.');
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
                       Wf('         Pulse cualquier tecla para continuar.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(8,3,72,21);
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
                       Wf('           Pulse cualquier tecla para continuar.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(10,6,70,18);
                       Writeln;
                       W('Si escoge el modo geom‚trico, exprese los  ngulos en ');
                       W('grados. Finalmente, para garantizar que todas las trans-');
                       W('formaciones sean contractoras (una exigencia de car cter');
                       W('matem tico para que se den figuras fractales a partir de');
                       W('Transformaciones Afines), el programa rechazar  aquellas');
                       W('para las que ³r³ò1 ¢ ³s³ò1, y le solicitar  que las');
                       W('las digite de nuevo.');
                       W(' ');
                       Wf('           Pulse cualquier tecla para continuar.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(10,5,71,21);
                       Writeln;
                       W('Cuando termine de entrar las ecuaciones, podr  (si lo de-');
                       W('sea) colocarles un nombre, y el programa comenzar  a gra-');
                       W('ficarlas.');
                       W('Es posible que las ecuaciones que usted haya introducido ');
                       W('definan un fractal que se observe mal (o que sencillamente');
                       W('no aparezca) en la regi¢n del plano XY en que el programa ');
                       W('est‚ configurado para graficar en ese momento.');
                       W('Para corregir este eventual problema, ajuste la zona del ');
                       W('plano XY usando las primeras cuatro opciones del men£ ');
                       W('"Pantalla". Si su figura no aparece, intente graficar una');
                       W('regi¢n mayor del plano hasta que la localice.');
                       Writeln;
                       Wf('      Pulse cualquier tecla para volver al programa.');
                       EspereTecla;
                       Cierre;

                     End;
                 4 : Begin
                       VentAyuda(9,4,71,23);
                       Writeln;
                       W('Desde aqu¡ es posible alterar cualquier par metro en ');
                       W('las ecuaciones vigentes. Seleccione la transformaci¢n que');
                       W('desea alterar por su n£mero y el par metro por el Nø de ');
                       W('la columna (entre 1 y 8) en que se encuentre.');
                       W('Las cols. 1 a 6 contienen los valores de los coeficientes');
                       W('de cada ecuaci¢n, indicados en modo cartesiano o geom‚trico');
                       W('(para conmutar entre los dos, pulse <M>).');
                       W('La s‚ptima col. indica qu‚ ecuaciones est n activas, es');
                       W('decir, cu les intervienen en el c lculo de la figura.');
                       W('Desactivar una ecuaci¢n equivale a "borrarla" temporalmente');
                       W('del fractal. Observe sin embargo que no solo desaparece la');
                       W('zona cuyo color corresponde al de la ecuaci¢n dada, sino ');
                       W('que todo el fractal se altera. ¨Qu‚ sucede aqu¡? La res-');
                       W('puesta a este fen¢meno se halla en la idea de la autosimi-');
                       W('litud de los fractales: cambios locales DEBEN tener efectos');
                       Wf('de car cter GLOBAL.');
                       EspereTecla;
                       Cierre;
                       VentAyuda(9,5,71,23);
                       Writeln;
                       W('La octava columna controla el color en que se grafica cada');
                       W('ecuaci¢n (t‚cnicamente, los puntos cuya direcci¢n de primer');
                       W('orden es dicha ecuaci¢n). As¡, si desea ver tan solo cier-');
                       W('tas ecuaciones, sin alterar la figura, les puede asignar ');
                       W('a las dem s el mismo color del fondo.');
                       Writeln;
                       W('Recuerde que los rangos para los coeficientes de las ecua-');
                       W('ciones son, para los modos cartesiano y geom‚trico:');
                       Writeln;
                       W('                       ³Aij³ < 1;');
                       Writeln;
                       W('              ³r³ y ³s³ < 1, ³é³ y ³í³ ó 90ø;');
                       Writeln;
                       W('Nota: Si desea que una ecuaci¢n represente una ROTACION,');
                       Wf('      coloque el MISMO valor para é y í.');
                       EspereTecla;
                       Cierre;
                     End;
                 5 : Begin
                       VentAyuda(10,9,70,17);
                       Writeln;
                       W('Para alterar el modo en que se le presentan las ecua-');
                       W('ciones vigentes en la parte inferior de su pantalla,');
                       W('y cuando grafica las figuras usando la zona peque¤a,');
                       W('simplemente pulse <ENTER>. Esto conmutar  el modo activo');
                       Wf('entre las opciones Cartesiano y Geom‚trico.');
                       EspereTecla;
                       Cierre;
                     End;
               End;  { Fin del Case Renglon of para Ecuaciones }

        Pant : Case Renglon of
                 2..5 : Begin
                          VentAyuda(9,4,73,20);
                          Writeln;
                          W('Las primeras cuatro opciones de este men£ le permiten esco-');
                          W('ger qu‚ zona del plano XY desea graficar. Los valores de ');
                          W('"Comienzo del eje X", ..., "Final del Eje Y" que seleccione');
                          W('definen las esquinas del  rea rectangular en el plano de ');
                          W('coordenadas donde el programa graficar . Si desea hacer una');
                          W('ampliaci¢n de alguna parte de una figura o si al crear sus ');
                          W('propios fractales no puede observarlos con claridad, utilice');
                          W('estas opciones para delimitar las coordenadas de graficaci¢n.');
                          W('Si desea ver al momento de graficar dichas coordenadas, uti-');
                          W('lice la opci¢n "Trazar Ejes en Pant.", la cual dibuja los');
                          W('ejes de coordenadas, junto con "Ventana de Grafic." puesta');
                          W('en "Grande", para obtener los valores num‚ricos de las coor-');
                          Wf('denadas XY en su pantalla.');
                          EspereTecla;
                          Cierre;
                        End;   
                    6 : Begin
                          VentAyuda(8,5,73,18);
                          Writeln;
                          W('Pulsando <ENTER>, conmuta entre "S¡" y "No" trazar los ejes');
                          W('de coordenadas XY en la pantalla cuando grafique. ');
                          W('Si la opci¢n "Ventana de Grafic." se encuentra en "Peque¤a",');
                          W('se dibujar n tan s¢lo las l¡neas de los ejes, pero si dicha');
                          W('opci¢n est  en "Grande", los ejes aparecer n con divisiones');
                          W('num‚ricas marcadas, que le permitir n ubicar con facilidad');
                          W('una determinada regi¢n del plano XY que quiera ver en detalle.');
                          W('Recuerde que para cambiar la regi¢n en que el programa gra-');
                          W('fica, debe emplear las primeras cuatro opciones de este');
                          Wf('mismo men£.');
                          EspereTecla;
                          Cierre;
                        End;
                    7 : Begin
                          VentAyuda(9,4,73,23);
                          Writeln;
                          W('Pulsando <ENTER>, conmuta entre "Grande" y "Peque¤a". Esto ');
                          W('determina qu‚ porci¢n DEL MONITOR se usa para graficar las');
                          W('figuras. No confunda esto con las primeras cuatro opciones ');
                          W('de este men£, qu‚ definen una regi¢n EN EL PLANO XY.');
                          W('- En "Peque¤a", se usa un recuadro relativamente peque¤o en');
                          W('la pantalla para graficar los fractales, pero el  rea res-');
                          W('tante es aprovechada para mostrarle las ecuaciones en el mo-');
                          W('do que tenga seleccionado en ese momento (Cartesiano o Geo-');
                          W('m‚trico). Adem s, los ejes de coordenadas aparecen como l¡-');
                          W('neas sin valores num‚ricos indicados.');
                          W('- En "Grande", se emplea pr cticamente todo el monitor del ');
                          W('computador para mostrar las figuras, logr ndose  una mejor');
                          W('imagen, y si tiene seleccionada la opci¢n de Trazar los Ejes');
                          W('XY, ‚stos aparecen con divisiones num‚ricas. Sin embargo, no');
                          W('hay espacio suficiente para mostrar las ecuaciones en la pan-');
                          Wf('talla al mismo tiempo que la figura.');
                          EspereTecla;
                          Cierre;
                        End;
                    8 : Begin
                          VentAyuda(8,5,73,17);
                          Writeln;
                          W('Desde aqu¡ puede usted seleccionar los colores de las distin-');
                          W('tas partes de la pantalla en la graficaci¢n de fractales.');
                          W('Por ejemplo, si desea capturar im genes de la pantalla para');
                          W('incluirlas en un documento, puede obtener mejores resultados');
                          W('si coloca los colores de todos los elementos en blanco (#15),');
                          W('y asigna a todas las ecuaciones el color negro (#0). Recuerde');
                          W('que los colores de las ecuaciones se seleccionan por medio del');
                          W('Editor de Ecuaciones, y aparecen indicados en la ventana Ecua-');
                          Wf('ciones Vigentes, en la parte inferior de su pantalla.');
                          EspereTecla;
                          Cierre;
                        End;
                    9 : Begin
                          VentAyuda(12,8,70,18);
                          Writeln;
                          W('Aqu¡ puede cambiar el nombre para la figura actual.');
                          W('Este nombre aparece en las ventanas de ecuaciones y');
                          W('cuando grafique con la Zona Peque¤a, pero no es el nom-');
                          W('bre del archivo DOS en que se grabar  el fractal si de-');
                          W('cide hacer tal cosa. Este nombre puede tener hasta 30');
                          W('letras, mientras que los archivos DOS pueden como m xi-');
                          Wf('mo tener nombres de 8 letras.');
                          EspereTecla;
                          Cierre;
                        End;

               End;      { Fin del Case Renglon para Pantalla }

        Graf : Begin
                 VentAyuda(10,6,71,20);
                 Writeln;
                 W('Pulsando <ENTER>, comenzar  la graficaci¢n de las ');
                 W('ecuaciones actualmente vigentes, de acuerdo con las con-');
                 W('diciones de presentaci¢n indicadas en el men£ "Pantalla".');
                 W('Para suspender la graficaci¢n, pulse cualquier tecla. ');
                 W('Esto le permitir  ver cu ntas iteraciones se han realizado');
                 W('hasta el momento. En ese punto, pulse la letra C para ');
                 W('continuar graficando, o la tecla <Esc> para regresar al ');
                 W('programa principal.');
                 Writeln;
                 W('Nota: La graficaci¢n tambi‚n puede comenzarse desde cual-');
                 Wf('      quier punto pulsando la tecla F2.');
                 EspereTecla;
                 Cierre;
               End;     { Fin de la opci¢n Graf }

        Disk : Case Renglon Of

                 2 : Begin
                       VentAyuda(10,7,71,16);
                       Writeln;
                       W('Esta opci¢n le muestra cu l es el directorio actualmente');
                       W('vigente, y le permite alterarlo si lo desea. Dicho direc-');
                       W('torio es el empleado por el programa para sus operaciones');
                       W('de grabaci¢n y lectura de archivos. Por lo tanto, si ');
                       W('desea manejar sus figuras en un directorio (o drive) dife-');
                       Wf('rente, deber  especific rselo al programa desde aqu¡.');
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
                       Wf('con extensi¢n .FRA .');
                       EspereTecla;
                       Cierre;
                     End;

                 4 : Begin
                       VentAyuda(10,7,71,18);
                       Writeln;
                       W('Para recuperar una figura previamente grabada, teclee el');
                       W('nombre del archivo donde se encuentra. La lectura se har ');
                       W('en el directorio actualmente vigente. ');
                       W('Para ver qu‚ figuras hay all¡, use la opci¢n "VER DIR".');
                       W('Para leer en otro lugar, emplee "DIRECTORIO", y defina un');
                       W('nuevo camino de lectura.');
                       W('Al conclu¡r la lectura, ejecute la opci¢n "GRAFICAR" para');
                       Wf('obtener la figura en pantalla.');
                       EspereTecla;
                       Cierre;
                     End;

                 5 : Begin
                       VentAyuda(10,6,70,17);
                       Writeln;
                       W('Para grabar en disco las ecuaciones y la regi¢n de grafi-');
                       W('caci¢n de una figura cualquiera, teclee el nombre (de ');
                       W('m ximo 8 letras) del archivo donde se almacenar  dicha ');
                       W('informaci¢n. La grabaci¢n quedar  en el directorio ');
                       W('actualmente vigente, y el archivo ser  autom ticamente');
                       W('creado con extensi¢n .FRA. Si desea grabar en otro ');
                       W('directorio diferente, use la opci¢n "DIRECTORIO" del');
                       Wf('men£ ARCHIVO.');
                       EspereTecla;
                       Cierre;
                     End;

                 6 : Begin
                       VentAyuda(20,11,61,16);
                       Writeln;
                       W('Aqu¡, puede usted abandonar FRACTALES');
                       Wf('y regresar al M¢dulo de Informaci¢n.');
                      { W('Antes de salir, el programa le pedir ');
                       W('que confirme su decisi¢n. Puede hacer');
                       W('esto con las flechas del cursor o pul-');
                       Wf('sando la inicial de cada opci¢n (S/N).');}
                       EspereTecla;
                       Cierre;
                     End;

               End;  { Fin del Case Renglon Of de la opcion Disk }

      End;  { Fin del Case Ventana Of }

End; { Fin del Proc. ayude }


Procedure AsigneMatTran;

  Var
    a,b,c,d,
    r,s,Theta,Fi     : Real;
    Cont             : Integer;

  Begin
    For Cont:=1 to TotTran do
      Begin
        r:=MatTranG[Cont,1];
        s:=MatTranG[Cont,2];
        Theta:=MatTranG[Cont,3];
        Fi:=MatTranG[Cont,4];
        a:= r * Cos((Theta*Pi)/180);
        b:= -s * Sin((Fi*Pi)/180);
        c:= r * Sin((Theta*Pi)/180);
        d:= s * Cos((Fi*Pi)/180);
        MatTran[Cont,1]:=a;
        MatTran[Cont,2]:=b;
        MatTran[Cont,3]:=c;
        MatTran[Cont,4]:=d;
        MatTran[Cont,5]:=MatTranG[Cont,5];
        MatTran[Cont,6]:=MatTranG[Cont,6];
      End;
  End;   { Termina AsigneMatTran }


Procedure AsigneMatTranG;

  Var
    a,b,c,d,
    r,s,Theta,Fi     : Real;
    Cont             : Integer;

  Begin
    For Cont:=1 to TotTran do
      Begin
        a:=MatTran[Cont,1];
        b:=MatTran[Cont,2];
        c:=MatTran[Cont,3];
        d:=MatTran[Cont,4];
        MatTranG[Cont,5]:=MatTran[Cont,5];
        MatTranG[Cont,6]:=MatTran[Cont,6];
        r:=Sqrt(a*a+c*c);
        If a<0 Then r:=-r;
        s:=Sqrt(b*b+d*d);
        If d<0 Then s:=-s;
        If a=0 Then
          If c=0 Then Theta:=0 Else
            If c>0 Then Theta:=90 Else Theta:=-90
        Else Theta:=(180/Pi)*(ArcTan(c/a));
        If d=0 Then
          If b=0 Then Fi:=0 Else
            If b>0 Then Fi:=-90 Else Fi:=90
        Else Fi:=(180/Pi)*(ArcTan(-b/d));
        MatTranG[Cont,1]:=r;
        MatTranG[Cont,2]:=s;
        MatTranG[Cont,3]:=Theta;
        MatTranG[Cont,4]:=Fi;
      End;
  End;     { Termina AsigneMatTranG }


Procedure CrearProbTran;

  Var
    I               : Integer;
    Sumalfa,r,s     : Real;
    Alfa            : Array[1..8] of Real;

  Begin
    Sumalfa:=0;
    For i:=1 to TotTran do
      Begin
        r:=MatTranG[I,1];
        s:=MatTranG[I,2];
        Alfa[I]:=0.5*(Abs(R)+Abs(S));
        Sumalfa:= Sumalfa + Alfa[I];
      End;
    For I:=1 to Tottran do
      If SumAlfa<>0 Then ProbTran[i]:=Alfa[i]/SumAlfa
      Else ProbTran[i]:=0;
  End;     { Termina CrearProbTran }


Procedure Salida; { Procedimiento de abandono del programa }

 Var
   PosSalida        : Boolean;
   Tec              : Char;
   PosiSalir        : Localizacion;

 Procedure ResalteSI;
   Begin
     TextAttr:=TxVenEsp +  FonVenEsp*16;
     Wxy(18,4,'NO');
     TextAttr:=TitVenErr + BorVenErr*16;
     Wxy(9,4,'SI');
     PosSalida:=True;
     TextAttr:=TxVenEsp +  FonVenEsp*16;
   End;   { Termina el subproc. ResalteSI }

 Procedure ResalteNO;
   Begin
     TextAttr:=TxVenEsp +  FonVenEsp*16;
     Wxy(9,4,'SI');
     TextAttr:=TitVenAy + BorVenAy*16;
     GotoXY(18,4);
     Write('NO');
     PosSalida:=False;
     TextAttr:=TxVenEsp +  FonVenEsp*16;
   End;   { Termina el subproc. ResalteNO }

 Begin    { Cuerpo del proc. Salida }
   CodigoAbandono:=False;
   OpenWindow(26,10,54,16,'SALIDA',
                 TitVenAy + BorVenAy*16,MarVenErr + BorVenAy*16);
   TextAttr:=TxVenEsp +  FonVenEsp*16;
   ClrScr;
   PosiSalir.Ventana:=Disk;
   PosiSalir.Renglon:=6;
   Writeln;
   W('  ¨ Est  usted seguro ?');
   Writeln;
   ResalteSI;
   Repeat
     Tec:=ReadChar;
     Case Tec of
       CRight,CLeft  : If PosSalida Then ResalteNO Else ResalteSI;
       CEnter        : If PosSalida Then CodigoAbandono:=True;
       F1            : If ModuloActivo=Programa Then Ayude(PosiSalir);
       CtrlF1        : If ModuloActivo=Programa Then Instrucciones;
     End;
   Until Tec In [CEnter,'n','N','s','S',Esc];
   If Tec In ['n','N',Esc] Then CodigoAbandono:=False;
   If Tec In ['s','S'] Then CodigoAbandono:=True;
   Repeat CloseWindow Until Windowcount=0;
   TextAttr:=TxVenNor + FonVenNor*16;
 End;   { Termina Salida }


Procedure Apague;
  Begin
    Window(1,1,80,25);
    LowVideo;
    TextAttr:= LightGray + Black*16;
    ClrScr;
  End;  { Termina Apague }



Procedure IniGraf;     { Inicializa el modo gr fico,                  }
                       { y reporta cualquier error que pueda occurir. }

  Begin
    Repeat
      ControlGrafico := Detect;                { Use autodetecci¢n }
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
        Xb:=Round((49*Xmax)/50);
        Xa:=Round(Xb-((0.68*Ymax)/Rasp));
        Ya:=Round(0.9*Ymax);
        Yb:=Round(0.1*Ymax);
        If ControlGrafico=HercMono Then   { Para corregir "a las malas" }
          Begin                           { el problema de las tarjetas }
            Xa:=370;                      { Hercules monocromaticas     }
            Xb:=700;
          End;                       
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
    FacEscX:=Round(DXp/DXm);
    FacEscY:=Round(DYp/DYm);
  End;      { Termina DefPantalla }


Procedure Pantalla(Xm,Ym : Real; Var Xp,Yp : Integer);
  { Transforma las coordenadas de 'mundo' (Xm,Ym) en coordenadas de
    pantalla (Xp,Yp), usando el sistema definido en Defejes  }

  Begin
    Xp:=Round (FacEscX*Xm + X0);
    Yp:=Round (FacEscY*Ym + Y0);
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
    Rectangle(Xa-5, Yb-5, Xb+5, Ya+5);
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
    Tam                       : Array[1..4,1..4] of Integer;
    NombreProg1,NombreProg2   : String[30];
    FuenteNombre              : Integer;    { Tipo de letra para el nombre }


  Procedure Tamanos;  { Este es un subproc. de PantallaInicial }
    Begin

      Case Xmax of
         0..350 : Begin             { CGA }
                   Tam[1,1]:=40;  Tam[1,2]:=10;
                   Tam[2,1]:=40;  Tam[2,2]:=10;
                   Tam[3,1]:=8 ;  Tam[3,2]:=10;
                   Tam[4,1]:=6 ;  Tam[4,2]:=10;
                  End;
       351..700 : Begin           { EGA y VGA }
                   Tam[1,1]:=32;  Tam[1,2]:=10;
                   Tam[2,1]:=32;  Tam[2,2]:=10;
                   Tam[3,1]:=90;  Tam[3,2]:=100;
                   Tam[4,1]:=60;  Tam[4,2]:=100;
                  End;
      701..1000 : Begin             { Herc }
                   Tam[1,1]:=42;  Tam[1,2]:=10;
                   Tam[2,1]:=42;  Tam[2,2]:=10;
                   Tam[3,1]:=75;  Tam[3,2]:=100;
                   Tam[4,1]:=60;  Tam[4,2]:=100;
                  End;
     1001..2000 : Begin             { 8514 }
                   Tam[1,1]:=24;  Tam[1,2]:=10;
                   Tam[2,1]:=24;  Tam[2,2]:=10;
                   Tam[3,1]:=56;  Tam[3,2]:=100;
                   Tam[4,1]:=38;  Tam[4,2]:=100;
                  End;

      End;        { Fin del Case Xmax Of }

      Case Ymax of
         0..210 : Begin             { CGA }
                   Tam[1,3]:=14;  Tam[1,4]:=10;
                   Tam[2,3]:=14;  Tam[2,4]:=10;
                   Tam[3,3]:=40;  Tam[3,4]:=100;
                   Tam[4,3]:=35;  Tam[4,4]:=100;
                  End;
       211..360 : Begin           { Herc y EGA }
                   Tam[1,3]:=26;  Tam[1,4]:=10;
                   Tam[2,3]:=26;  Tam[2,4]:=10;
                   Tam[3,3]:=65;  Tam[3,4]:=100;
                   Tam[4,3]:=50;  Tam[4,4]:=100;
                  End;
       361..500 : Begin             { VGA }
                   Tam[1,3]:=32; Tam[1,4]:=10;
                   Tam[2,3]:=32;  Tam[2,4]:=10;
                   Tam[3,3]:=9 ;  Tam[3,4]:=10;
                   Tam[4,3]:=6 ;  Tam[4,4]:=10;
                  End;
      501..1000 : Begin             { 8514 }
                   Tam[1,3]:=24;  Tam[1,4]:=10;
                   Tam[2,3]:=24;  Tam[2,4]:=10;
                   Tam[3,3]:=5 ;  Tam[3,4]:=10;
                   Tam[4,3]:=25;  Tam[4,4]:=100;
                  End;

      End;        { Fin del Case Ymax Of }

    End;      { Fin del subproc. Tamanos }


 Begin            { Comienza el proc. Pantalla Inicial }

   Tamanos;

   SetTextJustify(CenterText,CenterText);
   SetBkColor(ColorPant);
   SetColor(ColorPuntos);
   SetLineStyle(SolidLn,0,ThickWidth);
   Rectangle(0,0,Xmax,Ymax);

   NombreProg1:='Fractales';
   NombreProg2:='Lineales';
   FuenteNombre:=1;

   SetUserCharSize(Tam[1,1],Tam[1,2],Tam[1,3],Tam[1,4]);
   SetTextStyle(FuenteNombre{GothicFont}, HorizDir, UserCharSize);
   OutTextXY(Xcen+1,Round((1.7*YMax)/8),NombreProg1);
   OutTextXY(Xcen,Round((1.7*YMax)/8),NombreProg1);

   SetUserCharSize(Tam[2,1],Tam[2,2],Tam[2,3],Tam[2,4]);
   SetTextStyle(FuenteNombre{GothicFont}, HorizDir, UserCharSize);
   OutTextXY(Xcen+1,Round((3.2*YMax)/8),NombreProg2);
   OutTextXY(Xcen,Round((3.2*YMax)/8),NombreProg2);

   SetUserCharSize(Tam[3,1],Tam[3,2],Tam[3,3],Tam[3,4]);
   SetTextStyle(TriplexFont, HorizDir, UserCharSize);
   OutTextXY(Xcen,Round((5.0*YMax)/8),'Versi¢n 1.2');

   SetUserCharSize(Tam[3,1],Tam[3,2],Tam[3,3],Tam[3,4]);
   SetTextStyle(TriplexFont, HorizDir, UserCharSize);
   OutTextXY(Xcen,Round((8.6*YMax)/10),'Fernando P‚rez');

   SetUserCharSize(Tam[4,1],Tam[4,2],Tam[4,3],Tam[4,4]);
   SetTextStyle(SansSerifFont, HorizDir, UserCharSize);
   OutTextXY(Xcen,Round((9.2*YMax)/10),' Dpto. de F¡sica, U. de Antioquia.');
   OutTextXY(Xcen,Round((9.6*YMax)/10),'Medell¡n, COLOMBIA, 1991-92.');

   Delay(3000);

 End;    { Termina PantallaInicial }



Procedure CierreGraf;       { Cierra la unidad Graph y actualiza la     }
  Begin                     { variable de control (GrAbierta, boolean). }
    CloseGraph;
    GrAbierta:=False;
  End;



BEGIN
END.