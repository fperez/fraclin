PROGRAM Fractales_Lineales;

{ Nota: Archivo NO PROTEGIDO CONTRA COPIAS 
        Se diferencia de FRACLIN.PAS en que en aqui se utiliza un solo
        archivo para almacenar las instrucciones, y se busca la pantalla
        pedida por el usuario de manera secuencial en dicho archivo.
        En FRACLIN, se utiliza un archivo individual para cada tema,
        siendo mas rapida la busqueda.


  Programa para graficar Sistemas Iterados de Funciones en Rý usando el
  Algoritmo de Iteraci¢n Aleatoria.
  Desarrollado por Fernando P‚rez, Depto. de F¡sica, U. de Antioquia.
  Abril-Septiembre de 1.991.
  Adiciones: Abril-Mayo de 1.992. Colombia.

  Directiva de compilacion para activar la inclusion de los
  .BGI y .CHR dentro del codigo .EXE :                       }

(*     {$Define EnlazarGraficos}*)

Uses

{$IfDef EnlazarGraficos}
  BGIDriv, BGIFont,
{$EndIf}

  Crt, FracUni, FracExe, Printer;

Const
  NombreArchivoTextos = 'C:\TP\FRACTAL\FRACTEXT.TXT';


{$IfDef EnlazarGraficos}
{ Registra todos los drivers BGI y las fuentes: }

Procedure Enlace;

  Procedure Abort(Msg : string);
    Begin
      Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
      Halt(1);
    End;

  Begin

    if RegisterBGIdriver(@CGADriverProc) < 0 then
      Abort('CGA');
    if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
      Abort('EGA/VGA');
    if RegisterBGIdriver(@HercDriverProc) < 0 then
      Abort('Herc');

    if RegisterBGIfont(@GothicFontProc) < 0 then
      Abort('Gothic');
    if RegisterBGIfont(@SansSerifFontProc) < 0 then
      Abort('SansSerif');
    if RegisterBGIfont(@TriplexFontProc) < 0 then
      Abort('Triplex');
  End;            { Termina el proc. Enlace}
{$EndIf}


Procedure ParamDefectoInfo;

  Var
    K   : Integer;

  Begin      { Comienza el proc. ParamDefecto }
    SalirControl:=No;
    NuevaVent:= Si;
    ModuloActivo:=Control;
    PosicionC.Ventana:=Instruc;
    PosicionC.Renglon:=2;
    RenglonActivo:=TextosC[Instruc,2];
  End;   { Termina ParamDefecto }


Procedure TextosInstruc;
  Begin
     TextosC[Instruc,1]:='INSTRUCCIONES';
     TextosC[Instruc,2]:=' Presentaci¢n';
     TextosC[Instruc,3]:=' Manejo B sico';
     TextosC[Instruc,4]:=' Las Ayudas';
     TextosC[Instruc,5]:=' Las Ventanas';
     TextosC[Instruc,6]:=' Demo';
     TextosC[Instruc,7]:=' Ecuaciones';
     TextosC[Instruc,8]:=' Pantalla';
     TextosC[Instruc,9]:=' Graficar';
     TextosC[Instruc,10]:=' Archivo';

     EsquinasC[Instruc,1]:=4;
     EsquinasC[Instruc,2]:=1;
     EsquinasC[Instruc,3]:=20;
     EsquinasC[Instruc,4]:=11;
     EsquinasC[Instruc,5]:=10;
  End;      { Termina TextosInstruc }


Procedure TextosOperar;
  Begin
    TextosC[Oper,1]:='OPERAR';
    TextosC[Oper,2]:=' Fractales Lineales 1.2';

    EsquinasC[Oper,1]:=14;
    EsquinasC[Oper,2]:=1;
    EsquinasC[Oper,3]:=39;
    EsquinasC[Oper,4]:=3;
    EsquinasC[Oper,5]:=2;
  End;      { Termina TextosOper }


Procedure TextosInfo;
  Var Colorlet : String[3];
  Begin
    TextosC[Info,1]:='INFORMACION';
    TextosC[Info,2]:=' Los Fractales';
    TextosC[Info,3]:=' Matem ticas';
    TextosC[Info,4]:=' Graficaci¢n';
    TextosC[Info,5]:=' Nota del Autor';
    TextosC[Info,6]:=' Bibliograf¡a';

    EsquinasC[Info,1]:=33;
    EsquinasC[Info,2]:=1;
    EsquinasC[Info,3]:=50;
    EsquinasC[Info,4]:=7;
    EsquinasC[Info,5]:=6;
  End;      { Termina TextosInfo }


Procedure TextosSugerir;
  Begin
    TextosC[Suger,1]:='SUGERENCIAS';
    TextosC[Suger,2]:=' Propuestas';
    TextosC[Suger,3]:=' Soluciones';

    EsquinasC[Suger,1]:=52;
    EsquinasC[Suger,2]:=1;
    EsquinasC[Suger,3]:=66;
    EsquinasC[Suger,4]:=4;
    EsquinasC[Suger,5]:=3;
  End;      { Termina TextosSugerir }


Procedure TextosSalir;
  Begin
    TextosC[Salir,1]:='SALIR';
    TextosC[Salir,2]:=' Ir al DOS';

    EsquinasC[Salir,1]:=66;
    EsquinasC[Salir,2]:=1;
    EsquinasC[Salir,3]:=79;
    EsquinasC[Salir,4]:=3;
    EsquinasC[Salir,5]:=2;
  End;      { Termina TextosSalir }


Procedure DefinirTextos;
  Begin
    TextosInstruc;
    TextosOperar;
    TextosInfo;
    TextosSugerir;
    TextosSalir
  End;  { Termina DefinirTextos }


Procedure QueHacer;
  Begin
    Window(5,15,76,22);
    FrameWin('¨Qu‚ hacer?', SingleFrame,
               TitVenEcVig + BorVenEcVig * 16,
               MarVenEcVig + BorVenEcVig * 16);
    ClrScr;
    Writeln;
    W('Utilice las flechas del teclado para desplazarse entre las ventanas');
    W('del programa, y presione <ENTER> para ejecutar la opci¢n que desee.');
    W('Para volver al DOS, vaya a la ventana "SALIR" y pulse <ENTER>, o');
    Wf('presione Alt-X. Luego, pulse <ENTER> o la tecla S para confirmar.');
  End;     { Termina QueHacer }


Procedure InitVentanasInfo;
  Begin
    ModuloActivo:=Control;
    TextAttr:=LightGray+LightGray*16;
    ClrScr;
    LowVideo;
    CheckBreak := No;
    if (LastMode <> CO80) and (LastMode <> BW80) and
      (LastMode <> Mono) then TextMode(CO80);
    TextAttr:=TxLinPpales + FonLinPpales*16;
    Window(1, 2, 80, 24);
    If ColorMaximo>5 Then
      FillWin(#178, LightGray + Blue* 16)
    Else
      FillWin(#178, LightGray + Black* 16);
    Window(1, 1, 80, 25);
    GotoXY(1, 1);
    Write('     INSTRUCCIONES     OPERAR      INFORMACION'+
            '       SUGERENCIAS     SALIR');
    ClrEol;
    Wxy(1,25,'  Alt-X : Abandonar y salir al DOS');
    ClrEol;
    Wxy(45,25,'M¢dulo de Informaci¢n, FracLin 1.2');
    ClrEol;
    TopWindow := nil;
    WindowCount := 0;
    TextAttr:=TxVenNor + FonVenNor*16;
    QueHacer;
    AbrirVentana(NuevaVent);
    Resaltar(RenglonActivo);
  End;   { Termina InitVentanasInfo }


Procedure RutinasInicialesInfo;
  Begin
    SalirControl:=No;
    ParamDefectoInfo;
    CaminoControl:='C:\TP\BGI';

    {$IfDef EnlazarGraficos}
    Enlace;   { Incluye los *.CHR y *.BGI en el .EXE }
    {$EndIf}

    Inigraf;        { Inicializa la unidad Graph.TPU }
    DefModGraf;     { Se inicializan los par metros b sicos del modo gr fico }
    AsigneColores;
    If PantIni Then PantallaInicial; { Pantalla de presentaci¢n del programa }
    Cierregraf;
    DefinirTextos;   { Crea la matriz Textos }
  End;  { Termina RutinasIniciales }


PROCEDURE TEXTOS;

Const
  MaxPag              = 12;          { # maximo de paginas por seccion      }
  FinPagina           = 'þ';         { Caracter de fin de pagina  : Alt-254 }
  FinSeccion          = 'ï';         { Caracter de fin de seccion : Alt-239 }

Type
  Paginas  = Array[1..20] of String[80];
  Seccion  = Array[1..MaxPag] of Paginas;
  SecPtr   = ^Seccion;

Var
  TextoActivo               : SecPtr;
  PaginaActiva,UltimaPagina : Integer;
  TeclaPulsada              : Char;
  SalirTextos               : Boolean;


Procedure AbraVentanaTextos(PosiCont : LocalizacionCont);
  Var
    TitVent : String[30];
  Begin
    TitVent:=TextosC[PosiCont.Ventana,PosiCont.Renglon];
    Delete(TitVent,1,1);      { El primer caracter siempre es un }
                              { espacio en blanco                }
    OpenWindow(1,1,80,25,TitVent,
        TitVenAy+ BorVenAy*16, MarVenAy+ BorVenAy*16);
    TextAttr:=TxVenEsp + FonVenEsp*16;
    ClrScr;
    Wxy(3,2,'Un momento por favor...');
  End;


Procedure CargueSeccion(PosiCont : LocalizacionCont; Var TotPag:Integer);

 Var
   ArchTextos         : Text;
   CuenFil,CuenPag    : Integer;
   SeccionTerminada   : Boolean;

  Procedure FaltaTexto;              { Subproc de CargueSeccion }
   Begin
     Window(1,1,80,25);
     TextColor(LightGray);
     TextBackground(Black);
     ClrScr;
     Sound(400);
     Wxy(33,10,'**** ERROR ****');
     Wxy(20,12,'Fractales Lineales 1.2 no encuentra un');
     Wxy(20,13,'archivo necesario para su ejecuci¢n.');
     Wxy(20,15,'Operaci¢n interrumpida.');
     Gotoxy(1,18);
     Delay(800);Nosound;
     Halt(1);
   End;                             { Termina el subproc FaltaTexto}

 Procedure BusqueSeccion;
   Var
     TituloABuscar,
     TextoPrueba      : String;
   Begin
     TituloABuscar:=TextosC[PosiCont.Ventana,PosiCont.Renglon];
     Delete(TituloABuscar,1,1);      { El primer caracter siempre es un }
                                     { espacio en blanco                }
     Assign(ArchTextos,NombreArchivoTextos);
     {$I-}
     Reset(ArchTextos);
     If IOResult<>0 Then FaltaTexto;
     {$I+}
     Repeat
       Readln(ArchTextos,TextoPrueba);
     Until TextoPrueba=TituloABuscar;   { ArchTextos se deja abierto }
   End;                              { Termina BusqueSeccion }

 Function TerminaSeccion:Boolean;
   Var
     Lin         : String[80];
     Tam         : Integer;
   Begin
     Lin:=TextoActivo^[CuenPag,CuenFil-1];
     Tam:=Length(Lin);
     If Lin[Tam]=FinSeccion Then              
       Begin
         TerminaSeccion:=Si;
         Delete(TextoActivo^[CuenPag,CuenFil-1],Tam,1);
         SeccionTerminada:=Si;
       End
     Else TerminaSeccion:=No;
   End;                             { Termina la fn TerminaSeccion }

 Function TerminaPagina:Boolean;
   Var
     Lin         : String[80];
     Tam         : Integer;
   Begin
     Lin:=TextoActivo^[CuenPag,CuenFil-1];
     Tam:=Length(Lin);
     If Lin[Tam]=FinPagina Then
       Begin
         TerminaPagina:=Si;
         Delete(TextoActivo^[CuenPag,CuenFil-1],Tam,1);
       End
     Else TerminaPagina:=No;
   End;                              { Termina la fn TerminaPagina }

 Begin                               { Comienza CargueSeccion      }
   SeccionTerminada:=No;
   TotPag:=1;
   For CuenPag:=1 to MaxPag do    { Borra la seccion }
     For Cuenfil:=1 to 20 do      
       TextoActivo^[CuenPag,CuenFil]:='';
   BusqueSeccion;
   CuenPag:=1;
   Repeat                         { Cargar la seccion pagina por pagina }
     Cuenfil:=1;
     Repeat
       Readln(ArchTextos,TextoActivo^[CuenPag,CuenFil]);
       Inc(CuenFil);
     Until (TerminaPagina) or (TerminaSeccion) or (Cuenfil>20);
     Inc(CuenPag);
   Until SeccionTerminada;
   TotPag:=CuenPag-1;
   Close(ArchTextos);
 End;                         { Termina CargueSeccion }


Procedure MuestrePagina(PagAct,UltPag:Integer);
 Var
   CuenFil             : Integer;
   UltimaLin,IndicPag,
   PagActLet,UltPagLet : String;
 Begin
   If PagAct = 1 Then
     UltimaLin:='I:Imprimir    Pg Dn:Siguiente    Esc:Salir                   '
   Else
     UltimaLin:='I:Imprimir    Pg Up:Ant.    Pg Dn:Siguiente    Esc:Salir     ';
   If PagAct=UltPag Then
     UltimaLin:='I:Imprimir    Pg Up:Ant.    Esc:Salir                        ';
   If UltPag=1 Then
     UltimaLin:='       I : Imprimir Secci¢n             Esc : Salir          ';
   Str(PagAct,PagActLet);
   Str(UltPag,UltPagLet);
   IndicPag:='P gina:'+PagActLet+'/'+UltPagLet+'.';
   ClrScr;
   GotoXY(1,2);
   For CuenFil:=1 to 20 do Writeln('  ',TextoActivo^[PaginaActiva,CuenFil]);
   Writeln;
   Write('   ',UltimaLin,IndicPag);
 End;                         { Termina MuestrePagina }


Procedure ImprimaSeccion(PosiCont:LocalizacionCont; UltPag:Integer);
  Var
    CuenFil,CuenPagImp,
    CuenPagSec,TotPagImp     : Integer;
    ErrorImp                 : Word;
    PrimLin,SegLin,EspBlanco,
    TitSec                   : String[80];

  Function TodoBien:Boolean;
    Var
      ImpCorrecta   : Boolean;
      Codigo        : Integer;
    Begin
      Codigo:=IOResult;
      If Codigo=0 Then TodoBien:=Si Else TodoBien:=No;
    End;      { Termina la subfn. TodoBien }

  Procedure IndiqueErrorImpresion;
    Begin
      OpenWindow(18,9,62,17,'ERROR DE IMPRESION',
                   TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
      TextAttr:=TxVenEsp +  FonVenEsp*16;
      ClrScr;
      W('');
      W('  Hay alg£n problema con la impresora.');
      W('  Intente corregirlo y repita el pro-');
      W('  cedimiento de impresi¢n.');
      W('');
      Wf('        Pulse <ESC> para salir.');
      EspereEsc;
      CloseWindow;
    End;   { Termina el subproc. IndiqueErrorImpresion }
      
  Procedure VentanaImpresion;
    Begin
      OpenWindow(22,10,58,15,'IMPRESION',
          TitVenAy+ BorVenAy*16, MarVenAy+ BorVenAy*16);
      TextAttr:=TxVenNor + FonVenNor*16;
      ClrScr;
    End;       { Termina el subproc. VentanaImpresion }

  Procedure MensajeImpresion(NumPag,TotPag:Integer);
    Var
      NumPagLet,TotPagLet  : String[5];
    Begin
      ClrScr;
      Str(NumPag,NumPagLet);
      Str(TotPag,TotPagLet);
      W('');
      W('Imprimiendo :'+TitSec);
      Wf('P gina      : '+NumPagLet+' de '+TotPagLet+'.');
    End;       { Termina el subproc. MensajeImpresion }

  Begin        { Comienza el proc. ImprimaSeccion }
     EspBlanco:='                                     ';
     TitSec:=TextosC[PosiCont.Ventana,PosiCont.Renglon];
     PrimLin:='Fractales Lineales Versi¢n 1.2';
     SegLin:='Secci¢n:'+TitSec+EspBlanco+'P gina ';
     TotPagImp:=(UltPag+2) Div 3;
     CuenPagSec:=1;
     {$I-}
     Write(Lst,' ');               { Probando la impresora }
     If TodoBien Then
       Begin
         VentanaImpresion;
         For CuenPagImp:=1 to TotPagImp do
           Begin
             MensajeImpresion(CuenPagImp,TotPagImp);
             Writeln(Lst);
             Writeln(Lst);
             Writeln(Lst,PrimLin);   { Encabezamiento }
             Writeln(Lst,SegLin,CuenPagImp);
             Writeln(Lst);
             Repeat
               For CuenFil:=1 to 20 do         { Imprimir Texto }
                 Writeln(Lst,'    ',TextoActivo^[CuenPagSec,CuenFil]);
               Inc(CuenPagSec);
             Until (CuenPagSec-1) Mod 3 = 0;  { Se imprimen 3 'paginas' de }
                                              { seccion por hoja de papel  }
             Write(Lst,Chr(12));              { Caracter de nueva pagina   }
           End;
         CloseWindow;  { Ventana de impresion }
       End
     Else IndiqueErrorImpresion;
     {$I+}
  End;                                      { Termina ImprimaSeccion }


BEGIN                         { Cuerpo Central de TEXTOS }
  SalirTextos:=No;
  AbraVentanaTextos(PosicionC);
  PaginaActiva:=1;
  New(TextoActivo);
  CargueSeccion(PosicionC,UltimaPagina);
  MuestrePagina(PaginaActiva,UltimaPagina);
  Repeat
    TeclaPulsada:=ReadChar;
    Case TeclaPulsada of
      PgUp,CUp : If PaginaActiva>1 Then
                   Begin
                     Dec(PaginaActiva);
                     MuestrePagina(PaginaActiva,UltimaPagina);
                   End
                 Else Beep;
      PgDn,CDown : If PaginaActiva<UltimaPagina Then
                     Begin
                       Inc(PaginaActiva);
                       MuestrePagina(PaginaActiva,UltimaPagina);
                     End
                   Else Beep;
      'I','i': ImprimaSeccion(PosicionC,UltimaPagina);
      Esc    : SalirTextos:=Si;
    Else Beep;
    End;          { Fin del Case }
  Until SalirTextos;
  CloseWindow;                     { Cierra la ventana con los textos }
  TextAttr:=TxVenNor + FonVenNor*16;
  Dispose(TextoActivo);
  TextoActivo:=Nil;
END;                          { Termina TEXTOS }


Procedure QuiereSalirC;
  Begin
    Salida(SalirControl);
    AbrirVentana(NuevaVent);
  End;              { Termina QuiereSalirC }


Procedure EjecutarInfo;

  Begin
    NuevaVent:=No;
    With PosicionC do
      Case Ventana Of
        Instruc,
        Info,
        Suger    : Textos;
        Oper     : Fractales;
        Salir    : QuiereSalirC;
      Else Beep;
      End;  { Fin del Case Ventana of }
    If PosicionC.Ventana=Oper Then InitVentanasInfo;
  End;    { Termina Ejecutar }


BEGIN        { PROGRAMA PRINCIPAL: MODULO DE CONTROL }
  PantIni:=Si;{No;}
  RutinasInicialesInfo;
  InitVentanasInfo;    { Abre la presentaci¢n de pantalla en ventanas }
  Repeat
    Ch := ReadChar;
    Case Ch of
      CLeft  : MoverIzq;
      CRight : MoverDer;
      CUp    : MoverArriba;
      CDown  : MoverAbajo;
      CEnter : EjecutarInfo;
      CExit  : QuiereSalirC;
    Else
      Beep;
    End;
  Until SalirControl;    
  Apague;
END.    { TERMINA EL PROGRAMA PRINCIPAL. }