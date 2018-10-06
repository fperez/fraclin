PROGRAM Fractales;

{ Programa para graficar Sistemas Iterados de Funciones en Rý usando el
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

  Util, Graph, Crt, Printer, Dos, FracUni;

Var PantIni : Boolean;

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


Procedure ResetColors;
  Var
    K  : Byte;

  Begin
    For K:=1 to 8 do Activas[k]:=True;
    If ColorMaximo in [1..5] Then
         Begin
           Colores[1]  :=1;
           Colores[2]  :=1;
           Colores[3]  :=1;
           Colores[4]  :=1;
           Colores[5]  :=1;
           Colores[6]  :=1;
           Colores[7]  :=1;
           Colores[8]  :=1;
         End
       Else
         Begin
           Colores[1]  :=9;
           Colores[2]  :=10;
           Colores[3]  :=11;
           Colores[4]  :=12;
           Colores[5]  :=13;
           Colores[6]  :=14;
           Colores[7]  :=15;
           Colores[8]  :=6;
         End;
  End;  { Termina ResetColors }


Procedure ParamDefecto;

  Var
    K   : Integer;

  Procedure ConfigDir;
    Var
       ArchivoConfig   :  Text;
       ErrorEnDisco    :  Word;
    Begin
      Assign(ArchivoConfig,'Fractal.INI');
      {$I-}
      Reset(ArchivoConfig);
      {$I+}
      ErrorEnDisco:=IOResult;
      If ErrorEnDisco<>0 then
        Begin
          Directorio:='';
        End
      Else
        Begin
          Readln(ArchivoConfig,Directorio);
          Close(ArchivoConfig);
        End;
    End;   { Termina el subproc. ConfigDir }

  Begin      { Comienza el proc. ParamDefecto }
    ConfigDir;
    SalirPrograma:=False;
    Tottran:=0;
    NuevaVent:= True;
    Xcom:=-5;
    Xfin:=5;
    Ycom:=-5;
    Yfin:=5;
    Trejes:=False;
    Panpeq:={False}True;
    Titulo:='';
    ModoActivo:=Geo;
    ModuloActivo:=Programa;
    Posicion.Ventana:=Dem;
    Posicion.Renglon:=2;
    RenglonActivo:=Textos[Dem,2];
    Camino:=Directorio+'\*.FRA';
  End;   { Termina ParamDefecto }


Procedure TextosDemo;
  Begin
     Textos[Dem,1]:='DEMO';
     Textos[Dem,2]:=' Sierpinski';
     Textos[Dem,3]:=' Von Koch';
     Textos[Dem,4]:=' Bronchi';
     Textos[Dem,5]:=' Helecho';
     Textos[Dem,6]:=' Hoja';
     Textos[Dem,7]:=' Arbol';
     Textos[Dem,8]:=' Caracoles';
     Textos[Dem,9]:=' Molinos';
     Textos[Dem,10]:=' Vicsek';
     Textos[Dem,11]:=' Cristales';

     Esquinas[Dem,1]:=3;
     Esquinas[Dem,2]:=1;
     Esquinas[Dem,3]:=16;
     Esquinas[Dem,4]:=12;
     Esquinas[Dem,5]:=11;
  End;      { Termina TextosDemo }


Procedure TextosEcuaciones;
  Begin
    Textos[Ecua,1]:='ECUACIONES';
    Textos[Ecua,2]:=' Ver';
    Textos[Ecua,3]:=' Crear';
    Textos[Ecua,4]:=' Editar';
    If ModoActivo=Cart Then
    Textos[Ecua,5]:=' Modo Activo: Cart.'
    Else Textos[Ecua,5]:=' Modo Activo:  Geo.';

    Esquinas[Ecua,1]:=13;
    Esquinas[Ecua,2]:=1;
    Esquinas[Ecua,3]:=34;
    Esquinas[Ecua,4]:=6;
    Esquinas[Ecua,5]:=5;
  End;      { Termina TextosEcuaciones }


Procedure TextosPantalla;
  Var Colorlet : String[3];
  Begin
    Textos[Pant,1]:='PANTALLA';
    Textos[Pant,2]:=' Comienzo del Eje X :  ' + NumTexto(Xcom,4,3);
    Textos[Pant,3]:=' Final del Eje X    :  ' + NumTexto(Xfin,4,3);
    Textos[Pant,4]:=' Comienzo del Eje Y :  ' + NumTexto(Ycom,4,3);
    Textos[Pant,5]:=' Final del Eje Y    :  ' + NumTexto(Yfin,4,3);
    If Trejes Then
      Textos[Pant,6]:=' Trazar Ejes en Pant:     SI.'
    Else
      Textos[Pant,6]:=' Trazar Ejes en Pant:     NO.';
    If Panpeq Then
      Textos[Pant,7]:=' Ventana de Grafic. : Peque¤a.'
    Else
      Textos[Pant,7]:=' Ventana de Grafic. :  Grande.';
    Str(ColorCaja,ColorLet);
    Textos[Pant,8]:=' Men£ de Colores';{ del fondo    :  ' + ColorLet;}
    Textos[Pant,9]:=' Nombre de la figura:            ' + Titulo;

    Esquinas[Pant,1]:=23;
    Esquinas[Pant,2]:=1;
    Esquinas[Pant,3]:=56;
    Esquinas[Pant,4]:=11;
    Esquinas[Pant,5]:=9;
  End;      { Termina TextosPantalla }


Procedure TextosGraficar;
  Begin
    Textos[Graf,1]:='GRAFICAR';
    Textos[Graf,2]:=' Ejecutar';

    Esquinas[Graf,1]:=51;
    Esquinas[Graf,2]:=1;
    Esquinas[Graf,3]:=62;
    Esquinas[Graf,4]:=3;
    Esquinas[Graf,5]:=2;
  End;      { Termina TextosGraficar }


Procedure TextosDisco;
  Begin
    Textos[Disk,1]:='ARCHIVO';
    Textos[Disk,2]:=' Directorio';
    Textos[Disk,3]:=' Ver Dir.';
    Textos[Disk,4]:=' Leer';
    Textos[Disk,5]:=' Grabar';
    Textos[Disk,6]:=' Salir';

    Esquinas[Disk,1]:=66;
    Esquinas[Disk,2]:=1;
    Esquinas[Disk,3]:=79;
    Esquinas[Disk,4]:=7;
    Esquinas[Disk,5]:=6;
  End;      { Termina TextosDisco }


Procedure DefinirTextos;
  Begin
    TextosDemo;
    TextosEcuaciones;
    TextosPantalla;
    TextosGraficar;
    TextosDisco;
  End;  { Termina DefinirTextos }


Procedure TablaDeColoresPeq(FilaCom : Integer);
  Var
    CuentaColor, Columna  : Integer;

  Begin
    Wxy(7,FilaCom,'Color  : ');
    Wxy(7,FilaCom+1,'Muestra: ');
    Columna:=17;
    For CuentaColor:= 0 To ColorMaximo do
      Begin
        GotoXY(Columna,FilaCom);
        Write(CuentaColor);
        TextColor(CuentaColor);
        Wxy(Columna,FilaCom+1,'ÛÛ');
        TextColor(LightGray);
        Inc(Columna,3);
      End;
  End;  { Termina TablaDeColoresPeq } 


Procedure EcuaVigentes;

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];


  Begin
    Window(5,17-TotTran,76,23);
    FrameWin('ECUACIONES VIGENTES', SingleFrame,
               TitVenEcVig + BorVenEcVig * 16,
               MarVenEcVig + BorVenEcVig * 16);
    ClrScr;

    TablaDeColoresPeq(TotTran+4);
    If ModoActivo=Cart Then
      Begin
        Wxy(2,1,'Presentaci¢n Cartesiana ('+Titulo+') :');
        Wxy(10,2,
            'A11      A12      A21      A22      B1       B2    Act Color');
        For Fil:=1 to TotTran do
          Begin
            Str(Fil,Filalet);
            Wxy(2,Fil+2,'T'+Filalet+' : ');
            Col:=7; J:=1;
            While J<=6 do
              Begin
                GotoXY(Col,Fil+2);
                Write(MatTran[Fil,J]:7:4);
                Inc(J); Inc(Col,9);
              End;
            GotoXY(Col,Fil+2);
            If Activas[Fil] Then Write (' S¡') Else Write (' No');
            Inc(Col,6);
            GotoXY(Col,Fil+2);
            Write(Colores[Fil]);
          End;
      End
    Else
      Begin
        Wxy(2,1,'Presentaci¢n Geom‚trica ('+Titulo+') :');
        Wxy(11,2,
             'r        s        é        í       B1       B2    Act Color');
        For Fil:=1 to TotTran do
          Begin
            Str(Fil,Filalet);
            Wxy(2,Fil+2,'T'+Filalet+' : ');
            Col:=7; J:=1;
            While J<=6 do
              Begin
                GotoXY(Col,Fil+2);
                Write(MatTranG[Fil,J]:7:4);
                Inc(J); Inc(Col,9);
              End;
            GotoXY(Col,Fil+2);
            If Activas[Fil] Then Write (' S¡') Else Write (' No');
            Inc(Col,6);
            GotoXY(Col,Fil+2);
            Write(Colores[Fil]);
          End;
      End;
  End;  { Termina EcuaVigentes }


Procedure InitVentanas;
  Var
    i : Integer;
  Begin
    ClrScr;
    LowVideo;
    CheckBreak := False;
    if (LastMode <> CO80) and (LastMode <> BW80) and
      (LastMode <> Mono) then TextMode(CO80);
    TextAttr:=TxLinPpales + FonLinPpales*16;
    Window(1, 2, 80, 24);
    FillWin(#177, LightGray + Blue* 16);
    Window(1, 1, 80, 25);
    GotoXY(1, 1);
    Write('       DEMO       ECUACIONES       PANTALLA'+
            '         GRAFICAR        ARCHIVO');
    ClrEol;
    Wxy(1,25,'  Ctrl-F1:Present.   F1:Ayuda   F2:Graficar   Alt-X:Salir');
    ClrEol;
    Wxy(66,25,'Fractales 1.2');
    ClrEol;
    TopWindow := nil;
    WindowCount := 0;
    TextAttr:=TxVenNor + FonVenNor*16;
    TextosPantalla;
    EcuaVigentes;
    AbrirVentana(NuevaVent);
    Resaltar(RenglonActivo);
  End;   { Termina InitVentanas }


Procedure DibPan(Peq : Boolean);Forward;


Procedure Graficar;Forward;


Procedure Grafique; Forward;


Procedure Crear;  { Permite al usuario entrar los datos de la matriz    }
                  { de transformaciones en modo cartesiano o geom‚trico }

  Procedure MatricesEnCero;

    Var
     i,j  : Integer;

    Begin
      For i:= 1 to 8 do
        For j:= 1 to 6 do MatTran[i,j]:=0;
      AsigneMatTranG;
      CrearProbtran;
    End;  { Termina MatricesEnCero }


  Procedure Incorrecta;
    Begin
      OpenWindow(13,10,68,15,'ERROR',
                 TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
      TextAttr:=TxVenEsp +  FonVenEsp*16;
      ClrScr;
      W('Los coeficientes A11..A22 definen una transformaci¢n');
      W('no contractora. Digite otros diferentes.');
      W('Se debe cumplir que:');
      Write('     û(A11ý+A21ý) < 1,  Y  û(A12ý+A22ý) < 1.');
      EspereTecla;
      CloseWindow;
      TextAttr:=TxVenNor + FonVenNor*16;
    End;   { Fin del subproc. Incorrecta }


  Procedure InformeRangos;
    Begin
      Case ModoActivo Of
        Cart : Begin
                 Wxy(7,15,'Nota : Los valores de los coeficientes A11,..,A22 deben estar ');
                 Wxy(7,16,'       en el intervalo (-1,1). No existe restricci¢n para los ');
                 Wxy(7,17,'       valores de B1 y B2.');
               End;
        Geo  : Begin
                 Wxy(7,15,'Nota : Los valores de los coficientes r y s deben estar en el');
                 Wxy(7,16,'       intervalo (-1,1). é y í deben estar comprendidos entre');
                 Wxy(7,17,'       -90ø y 90ø. No existen restricciones para B1 y B2.');
               End;
      End;   { Fin del Case }
      Wxy(3,19,'De todos modos, si usted entra un valor que no respeta los rangos apro-');
      Wxy(3,20,'piados, el programa lo rechazar  y le solicitar  que lo digite de nuevo.');
      Wxy(15,22,'Si desea informaci¢n adicional, pulse F1 (Ayuda).');
    End;   { Fin del subproc. InformeRangos }

  Label
    Entrada;

  Var
    Decis,Num,Nom   : Char;
    Present         : String;
    TrEntrada,I     : Integer;

    a,b,c,d,e,f,
    r,s,Theta, Fi   : Real;
    Correcta        : Boolean;


  Begin     { Comienza el cuerpo del proc. CREAR }

    a:=0; b:=0; c:=0; d:=0; e:=0; f:=0;
    r:=0; s:=0; Theta:=0; Fi:=0;
    ResetColors;
    OpenWindow(1,1,80,25,'CREACION DE UNA FIGURA',
               TitVenEcua + BorVenEcua*16, MarVenEcua + BorVenEcua*16);
    Clrscr;
    Wxy(2,2,'Escoja el modo de presentaci¢n de las ecuaciones : Cartesiano o Geom‚trico.');
    Wxy(2,3,'Pulse C o G para elegir : ');
    Wxy(2,6,'Nota : si desea abandonar en este punto y volver al programa principal,');
    Wxy(2,7,'       pulse <Esc>. Si decide continuar, deber  efectuar todo el proceso');
    Wxy(2,8,'       de crear las ecuaciones.');
    Wxy(18,10,'Para obtener m s informaci¢n, pulse F1 (Ayuda).');
    Repeat
      GotoXY(29,3);
      Decis:=ReadChar;
      Decis:=Upcase(Decis);
    If Decis=F1 Then Ayude(Posicion);
    Until Decis in [Esc,'C','G'];
    If Decis<>Esc Then
      Begin
        MatricesEnCero;
        If Decis='C' Then ModoActivo:=Cart else ModoActivo:=Geo;
        Clrscr;
        Wxy(2,2,'*** ENTRADA DE DATOS ***');
        Repeat
          Wxy(2,4,'Entre el n£mero total de Transformaciones que va a usar (<=8) : ');
          Num:=readkey;
          Tottran:=Ord(Num)-48;
        Until (Tottran >=0) and (Tottran<=8);
        For Trentrada:= 1 to Tottran do
          Begin
           ENTRADA:
            Correcta:=True;
            Clrscr;
            Wxy(2,2,'*** ENTRADA DE DATOS ***');
            InformeRangos;
            If ModoActivo=Cart then Present:='Cartesiano.' else Present:='Geom‚trico.';
            Wxy(2,4,'Modo de presentaci¢n : '+ Present);
            GotoXY(2,6);Write('Transformaci¢n : ',Trentrada);
            If ModoActivo=Cart Then
              Begin
                Repeat
                  Wxy(2,8,'A11 =                ');
                  GotoXY(8,8);
                  Lea(a);
                Until Abs(a)<1;
                MatTran[TrEntrada,1]:=a;
                Repeat
                  Wxy(21,8,'A12 =                ');
                  GotoXY(27,8);
                  Lea(b);
                Until Abs(b)<1;
                MatTran[TrEntrada,2]:=b;
                Repeat
                  Wxy(41,8,'A21 =                ');
                  GotoXY(47,8);
                  Lea(c);
                Until Abs(c)<1;
                MatTran[TrEntrada,3]:=c;
                Repeat
                  Wxy(61,8,'A22 =                ');
                  GotoXY(67,8);
                  Lea(d);
                Until Abs(d)<1;
                MatTran[TrEntrada,4]:=d;
                r:=Sqrt(a*a+c*c);
                s:=Sqrt(b*b+d*d);
                If (r>=1) or (s>=1) Then Correcta:=False;
              End
            Else
              Begin
                Repeat
                  Wxy(2,8,'r =                ');
                  GotoXY(6,8);
                  Lea(r);
                Until Abs(r)<1;
                MatTranG[TrEntrada,1]:=r;
                Repeat
                  Wxy(21,8,'s =                ');
                  GotoXY(25,8);
                  Lea(s);
                Until Abs(s)<1;
                MatTranG[TrEntrada,2]:=s;
                Repeat
                  Wxy(43,8,'é =                  ');
                  GotoXY(47,8);
                  Lea(Theta);
                Until Abs(Theta)<=90;
                MatTranG[TrEntrada,3]:=Theta;
                Repeat
                  Wxy(61,8,'í =                  ');
                  GotoXY(65,8);
                  Lea(Fi);
                Until Abs(Fi)<=90;
                MatTranG[TrEntrada,4]:=Fi;
              End;
            If Not(Correcta) Then
              Begin
                Incorrecta;
                Goto ENTRADA;
              End;
            Wxy(10,10,'B1 = ');
            Lea(e);
            Wxy(50,10,'B2 = ');
            Lea(f);
            MatTran[TrEntrada,5]:=e;
            MatTran[TrEntrada,6]:=f;
            MatTranG[TrEntrada,5]:=e;
            MatTranG[TrEntrada,6]:=f;
          End;
        Clrscr;
        If ModoActivo=Cart Then AsigneMatTranG Else AsigneMatTran;
        CrearProbTran;
        If Tottran<>0 then
          Begin
            Wxy(17,11,'¨ Desea colocarle un nombre a la figura (S/N) ? ');
            Repeat
              Nom:=Readkey;
              Nom:=UpCase(Nom);
            Until Nom in ['S','N'];
            If Nom='S' Then
              Begin
                ClrScr;
                OpenWindow(10,8,70,14,'NOMBRE',
                    TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
                Wxy(5,2,'Entre el nombre (se almacenar n hasta 30 letras) :');
                Wxy(15,4,'> ');
                Read(Titulo);
                Repeat CloseWindow Until Windowcount=0;
              End
            Else Titulo:='';
          End
        Else Titulo:='';
        Repeat CloseWindow Until Windowcount=0;   {Cierra la vent. de creacion de ecuaciones }
        Xcom:=-5;
        Xfin:=5;
        Ycom:=-5;
        Yfin:=5;
        Grafique;
      End;
    Repeat CloseWindow Until Windowcount=0;
  End;        { Termina el proc. Crear }


Procedure DibPan;    { Presenta la pantalla de graficaci¢n }

  Var
    Fil,Col     : Integer;
    Col0        : Real;
    Numero      : String[7];
    NomProg     : String[30];
    Numtran     : Char;

  Procedure MuestreEcuaciones;
    Var
      Fil,Col,Tran   : Integer;

    Begin
      If ControlGrafico in [Ega,EgaMono,Ega64,HercMono] Then Col0:=1.5 Else Col0:=0;
      SetTextJustify(CenterText,CenterText);
      OutTextXY(Round(Xa/2),4*Fila,'Estamos graficando las siguientes');
      OutTextXY(Round(Xa/2),5*Fila,'Transformaciones Afines :');
      If ModoActivo=Cart Then
        Begin
          If ControlGrafico = HercMono Then
            OutTextXY(Round(Xa/2)+8,7*Fila,'A11    A12   A21    A22    B1    B2 ')
          Else OutTextXY(Round(Xa/2)+8,7*Fila,'A11   A12  A21   A22    B1   B2');
          Fil:=8;
          For Tran:= 1 to Tottran do
            Begin
              If Activas[Tran] Then For Col := 1 to 6 do
                Begin
                  If Col=1 then
                    Begin
                      Numtran:=Chr(Tran+48);
                      OutTextXY(Round((2+Col0)*Colum),Fil*Fila,'T'+NumTran);
                    End;
                  Str(Mattran[Tran,Col]:4:2,Numero);
                  OutTextXY(Round((7.1*Col*Xmax/100)+(Col0*Colum)),Fil*Fila,Numero);
                End;
              If Activas[Tran] Then Inc(Fil);
            End;
        End
      Else                      { Mostrar las ecs. en modo geometrico }
        Begin
          Case ControlGrafico of
            HercMono :  OutTextXY(Round(Xa/2)+8,7*Fila,' r      s   Theta   Fi     B1    B2 ');
            Ega,EgaMono,Ega64,Vga: OutTextXY(Round(Xa/2)+8,7*Fila,' r     s    é     í     B1   B2')
          Else OutTextXY(Round(Xa/2)+8,7*Fila,' r     s  Theta  Fi     B1   B2');
          End;  { Fin del Case }
          Fil:=8;
          For Tran:= 1 to Tottran do
            Begin
              If Activas[tran] Then For Col := 1 to 6 do
                Begin
                  If Col=1 then
                    Begin
                      Numtran:=Chr(Tran+48);
                      OutTextXY(Round((2+Col0)*Colum),Fil*Fila,'T'+NumTran);
                    End;
                  If Col in [3,4] Then Str(MattranG[Tran,col]:3:1,Numero)
                  Else Str(MattranG[Tran,col]:4:2,Numero);
                  OutTextXY(Round((7.1*Col*Xmax/100)+(Col0*colum)),Fil*Fila,Numero);
                End;
              If Activas[Tran] Then Inc(Fil);
            End;
        End;
    End;              { Termina el subproc MuestreEcuaciones }


  Begin
    If Not(Grabierta) then Inigraf;
    DefEjes(PanPeq);
    SetFillStyle(Solidfill,ColorPant);
    Bar(0,0,Xmax,Ymax);        { Genera el fondo }
    SetFillStyle(Solidfill,ColorCaja);
    Bar(Xa,Yb,Xb,Ya);        { Genera la zona de graficacion }
    SetColor(ColorTexto);
    Marco;                   { Marco a la pantalla }
    If Peq Then
     Begin
       MarcoEjes;
       NomProg:='Fractales Lineales 1.2';
       Escriba(3,2,NomProg);
       Line (3*Colum,2*fila+2,(3*Colum)+TextWidth(NomProg),2*Fila+2);
       SetTextJustify(Centertext, CenterText);
       OutTextXY(Xa+Round((Xb-Xa)/2),Round(Yb/2),Titulo);
       OutTextXY(Round(Xa/2),17*Fila,'Pulse cualquier tecla para');
       OutTextXY(Round(Xa/2),18*Fila,'detener la graficacion.');
       MuestreEcuaciones;
     End
    Else
      Begin
        NomProg:='FracLin 1.2';
        Escriba(2,2,NomProg);
        Line (Round(2*Colum),2*fila+2,Round(2*Colum)+TextWidth(NomProg),2*Fila+2);
        Line(Xa-7,3,Xa-7,Ya+5);
        Line(Xa-7,Ya+5,Xmax-3,Ya+5);
      End;
    SetColor(ColorEjes);
    If Trejes Then TrazaEjes(PanPeq);
    SetColor(ColorTexto);
  End;     { Termina el proc. DibPan  }


Procedure EscribaXY(Px,Py:Integer; Texto:String; Color:Word);
  Var
    ColorAnt  : Word;
  Begin
    ColorAnt:=GetColor;
    SetColor(Color);
    OutTextXY(Px,Py,Texto);
    SetColor(ColorAnt);
  End;       { Termina el proc. EscribaXY }


Procedure ImprimaFractal;

  Var
    ModGraf,CodImp,
    Xmen,Ymen        : Integer;
    ImprimioBien     : Boolean;
    Men              : Palabra40;

  Procedure MuestreMensaje(Situa:Integer);
    Procedure TextosPanGran;
      Begin
      If Situa=1 Then
        Begin
          Escriba(2,14,'Hay alg£n');
          Escriba(2,15,'problema con');
          Escriba(2,16,'la impresora.');
        End
      Else
        Begin
          Escriba(2,12,'No reconozco');
          Escriba(2,13,'el modo gr -');
          Escriba(2,14,'fico para ');
          Escriba(2,15,'efectos de ');
          Escriba(2,16,'impresi¢n.');
        End
      End;     { Termina TextosPanGran }

    Begin      { Comienza MuestreMensaje }
      If PanPeq Then
        Begin
          SetTextJustify(CenterText,CenterText);
          Xmen:=Round((Xb+Xa)/2);
          Ymen:=Round((Ymax+Ya)/2);
          If Situa=1 Then Men:='Hay problemas con la impresora...'
            Else Men:='Modo gr fico no identificado...';
          EscribaXY(Xmen,Ymen,Men,ColorTexto);
          Sound(400); Delay(500); NoSound;
          Delay(2000);
          EscribaXY(Xmen,Ymen,Men,ColorPant);
          If Situa=2 Then   { No se identifico el modo grafico }
            Begin
              Men:='Imposible imprimir';
              Beep;
              EscribaXY(Xmen,Ymen,Men,ColorTexto);
              Delay(2000);
              EscribaXY(Xmen,Ymen,Men,ColorPant);
            End;
          Beep;
        End
      Else       { Pantalla grande }
        Begin
          SetColor(ColorTexto);
          TextosPanGran;
          Sound(400); Delay(500); NoSound;
          Delay(2000);
          SetColor(ColorPant);
          TextosPanGran;
          Beep;
        End;
    End;   { Termina MuestreMensaje }

  Begin    { Comienza ImprimaFractal }
    ModGraf:=0;
    Case Xmax of
      319 : ModGraf:=1;
      639 : Case Ymax of
              199 : ModGraf:=2;
              349 : ModGraf:=3;
              479 : ModGraf:=5;
            End;   { Fin del Case Ymax of }
      719 : ModGraf:=4;
    End;   { Fin del Case Xmax of }
    If ModGraf in [1..5] Then
      Begin
        {$I-}
        Writeln(Lst,' ');
        If IOResult=0 Then    { La impresora parece estar bien... }
          Begin
            Writeln(Lst,'   T¡tulo de la figura: ',Titulo);
            Writeln(Lst);
            If PanPeq Then
              ImprimioBien:=Imprimir_Pantalla_Grafica(Xa,Yb,Xb,Ya,ModGraf)
            Else
              ImprimioBien:=Imprimir_Pantalla_Grafica(Xa,Yb,Xb,Ya-5,ModGraf);
            Writeln(Lst);
            Writeln(Lst,'   Figura generada por el programa Fractales Lineales 1.2.');
            Writeln(Lst);
          End                 
        Else                  { Hay problemas con la impresora... }
          Begin
            MuestreMensaje(1);
          End;
        {$I+}
      End
    Else                  { No se identifico el modo grafico }
      Begin
        MuestreMensaje(2);
      End;
  End;    { Termina ImprimaFractal }


Function EscTran(S: Real):Integer;  { Escoge qu‚ transformaci¢n se aplica, }
                                    { teniendo en cuenta la asignaci¢n de  }
  Var                               { probabilidades.                      }
    J       : Integer;
    Suma    : Real;

  Begin
    J:=0; Suma:=0;
    Repeat
      Inc(J);
      Suma:=Suma + Probtran[J];
    Until (Suma>=S) or (J=TotTran);
    EscTran:=J;
  End;       { Termina la funci¢n EscTran }


Procedure Graficar;   { Procedimiento central de Graficaci¢n del programa }

  Var
    Iter                   : Longint;
    Xvie,Yvie,Xnue,Ynue    : Real;
    Tesc, Xpan, Ypan       : Integer;
    Iteraciones            : String[6];
    Resultado              : String[40];
    Tecla                  : Char;
    Fuera                  : Boolean;

  Procedure MarqueIteraciones(Color : Integer);
    Begin
      SetColor(Color);
      Str(Iter,Iteraciones);
      SetTextJustify(CenterText,CenterText);
      If PanPeq Then
        Begin
          If (Xmax>600) Then
            Resultado:='Hemos realizado '+Iteraciones+' Iteraciones'
          Else Resultado:='Iteraciones : '+Iteraciones;
          OutTextXY(Round(Xa/2),20*Fila,Resultado);
          OutTextXY(Round(Xa/2),22*Fila,'Pulse C para continuar,');
          OutTextXY(Round(Xa/2),23*Fila,'I para imprimir el fractal,');
          OutTextXY(Round(Xa/2),24*Fila,'o <Esc> para salir.');
        End
      Else
        Begin
          Escriba(2,19,'Iteraciones :');
          Escriba(5,20,Iteraciones);
          Escriba(2,22,'C : Continuar,');
          Escriba(2,23,'I : Imprimir,');
          Escriba(2,24,'<Esc> : Salir.');
        End;
    End;   { Fin del Subproc. MarqueIteraciones }


  Begin      { Comienza el procedimiento Graficar }
    Iter:=0;
    Fuera:=False;
    Xvie:=0.5;Yvie:=0.5;
    Randomize;
    Tesc:=1;
    Repeat
      If Tottran<>0 Then
        Begin              
          DefEjes(Panpeq);
          DefPantalla;
          Repeat           { Este ciclo es la graficaci¢n efectiva : }

           { Para graficacion normal, usar la sigte linea: }
           { Tesc:=Esctran(Random(1000)/1000);}

           { Pero, si se desean ver los puntos fijos de las transf. afines,
             se debe emplear : }
            If Tesc<TotTran Then Inc(Tesc) Else Tesc:=1;

            If Activas[Tesc] Then
              Begin
                Xnue:=(Xvie*Mattran[tesc,1])+(Yvie*Mattran[tesc,2])+(Mattran[tesc,5]);
                Ynue:=(Xvie*Mattran[tesc,3])+(Yvie*Mattran[tesc,4])+(Mattran[tesc,6]);
                Inc(Iter);
                Pantalla(Xnue,Ynue,Xpan,Ypan);
                If (Iter>100) and
                  (Xpan<Xb) and (Xpan>Xa) and (Ypan>Yb) and (Ypan<Ya) Then
                    PutPixel(Xpan,Ypan,Colores[Tesc]);
                Xvie:=Xnue; Yvie:=Ynue;
              End;
          Until KeyPressed;  { Aqui termina el ciclo de graficacion }
        End;
      SetColor(ColorEjes);
      If Trejes Then TrazaEjes(PanPeq);
      MarqueIteraciones(ColorTexto);
      Repeat
        Tecla:=Readchar;
        Tecla:=Upcase(Tecla);
        If Not(Tecla in [Esc,'C','I']) Then Beep;
      Until Tecla in [Esc,'C','I'];
      Case Tecla of
        'C' :  MarqueIteraciones(ColorPant);
        'I' :  Begin
                 ImprimaFractal;
                 MarqueIteraciones(ColorPant);
               End;
        Esc :  Fuera:=True
      Else Beep;
      End;  { Fin del Case }
    Until Fuera;
    CierreGraf;
    InitVentanas;
  End;     {Termina el proc. Graficar}


Procedure Grafique;
  Begin
    Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana activa en ese momento }
    DibPan(PanPeq);
    Graficar;
  End;     { Termina Grafique }


Procedure TablaDeColores(FilaCom: Integer);
  Var
    CuentaColor, Columna  : Integer;

  Begin
    Wxy(2,FilaCom,'TABLA DE COLORES:');
    Wxy(2,FilaCom+1,'N£mero:  ');
    Wxy(2,FilaCom+2,'Muestra: ');
    Columna:=12;
    For CuentaColor:= 0 To ColorMaximo do
      Begin
        GotoXY(Columna+1,FilaCom+1);
        Write(CuentaColor);
        TextColor(CuentaColor);
        Wxy(Columna,FilaCom+2,'ÛÛÛ');
        TExtColor(LightGray);
        Inc(Columna,4);
      End;
  End;  { Termina TablaDeColores }


Procedure VerEcCart(Filacom : Integer);

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];

  Begin
    Wxy(2,Filacom,'Presentaci¢n Cartesiana ('+Titulo+') :');
    Wxy(10,Filacom+1,
        'A11       A12       A21       A22       B1        B2     Acti  Color');
    For Fil:=1 to TotTran do
      Begin
        Str(Fil,Filalet);
        Wxy(2,Fil+FilaCom+1,'T'+Filalet+' : ');
        Col:=6; J:=1;
        While J<=6 do
          Begin
            GotoXY(Col,Fil+Filacom+1);
            Write(MatTran[Fil,J]:8:4);
            Inc(J); Inc(Col,10);
          End;
        Inc(Col,2);
        GotoXY(Col,Fil+Filacom+1);
        If Activas[Fil] Then Write ('S¡') Else Write ('No');
        Inc(Col,7);
        GotoXY(Col,Fil+Filacom+1);
        Write(Colores[Fil]);
      End;
  End;  { Termina VerEcCart }


Procedure VerEcGeo(FilaCom : Integer);

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];

  Begin
    Wxy(2,Filacom,'Presentaci¢n Geom‚trica ('+Titulo+') :');
    Wxy(11,Filacom+1,
         'r         s         é         í        B1        B2     Acti  Color');
    For Fil:=1 to TotTran do
      Begin
        Str(Fil,Filalet);
        Wxy(2,Fil+FilaCom+1,'T'+Filalet+' : ');
        Col:=6; J:=1;
        While J<=6 do
          Begin
            GotoXY(Col,Fil+Filacom+1);
            Write(MatTranG[Fil,J]:8:4);
            Inc(J); Inc(Col,10);
          End;
        Inc(Col,2);
        GotoXY(Col,Fil+Filacom+1);
        If Activas[Fil] Then Write ('S¡') Else Write ('No');
        Inc(Col,7);
        GotoXY(Col,Fil+Filacom+1);
        Write(Colores[Fil]);
      End;
  End;   { Termina VerEcGeo  }


Procedure VerEcuaciones;
  Var
    Tecla : Char;
  Begin
    OpenWindow(1,1,80,25,'ECUACIONES VIGENTES',
               TitVenEcVig + BorVenEcVig*16, MarVenEcVig + BorVenEcVig*16);
    ClrScr;
    VerEcCart(2);
    VerEcGeo(TotTran+5);
    EspereTecla;
    Repeat CloseWindow Until Windowcount=0;
  End;     { Termina VerEcuaciones }


Procedure CambiarModoActivo;
  Begin
   If ModoActivo=Cart Then ModoActivo:=Geo Else ModoActivo:=Cart;
  End;   { Termina CambiarModoActivo }


Procedure EditarEcuaciones;

  Var
    Selec,Coef                : Char;
    TotTranLet                : Char;
    ModoEnLetras              : String[12];
    Fil,TranEsc,CoefEsc,I,Cod : Integer;
    A                         : Array[1..4] Of Real;
    r,s                       : Real;

 Procedure Error;  { Subproc. de EditarEcuaciones }
   Begin
     OpenWindow(18,10,63,14,'ERROR',
                 TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
     TextAttr:=TxVenEsp + FonVenEsp*16;
     ClrScr;
     W('Este valor produce una transformaci¢n no');
     W('contractora. Digite otro diferente.');
     Wf('  Pulse cualquier tecla para seguir.');
     EspereTecla;
     CloseWindow;
     TextAttr:=TxVenNor + FonVenNor*16;
   End;   { Fin del subproc. Error }

 Procedure NuevoValor;      { SubProc de EditarEcuaciones }
   Var
     NuevoCoef : Real;

   Procedure ErrorDeRangos;    { Subproc de NuevoValor }
     Begin
       OpenWindow(19,9,61,15,'ERROR',
                   TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
       TextAttr:=TxVenEsp + FonVenEsp*16;
       ClrScr;
       W('El valor entrado se sale de los rangos');
       W('apropiados para este coeficiente.');
       W('Si necesita m s informaci¢n, solicite');
       W('ayuda mediante la tecla F1.');
       Wf('  Pulse cualquier tecla para seguir.');
       EspereTecla;
       CloseWindow;
       TextAttr:=TxVenNor + FonVenNor*16;
     End;   { Fin del subproc. ErrorDeRangos }

   Function RangoCorrecto(Coef:Real):Boolean;  { Subfn de NuevoValor }
     Var
       RanCorr : Boolean;
     Begin
       If ModoActivo=Cart Then
         If CoefEsc in [1..4] Then
           If Abs(Coef)<1 Then RanCorr:=True Else RanCorr:=False;
       If ModoActivo=Geo Then
         Case CoefEsc of
           1,2 : If Abs(Coef)<1 Then RanCorr:=True Else RanCorr:=False;
           3,4 : If Abs(Coef)<=90 Then RanCorr:=True Else RanCorr:=False;
         End;   { Fin del Case }
       If CoefEsc in [5,6] Then RanCorr:=True;
       If Not(RanCorr) Then ErrorDeRangos;
       RangoCorrecto:=RanCorr;
     End;        { Termina la subfn RangoCorrecto }

   Begin         { Comienza el subproc NuevoValor }
     Repeat
       GotoXY(2,TotTran+10);
       ClrEol;
       Write('Entre su nuevo valor : ');
       Lea(NuevoCoef);
     Until RangoCorrecto(NuevoCoef);
     If Modoactivo=Cart Then MatTran[Tranesc,Coefesc]:=NuevoCoef
     Else MatTranG[Tranesc,Coefesc]:=NuevoCoef;
   End;              { Termina el subproc NuevoValor }


  Begin          { Comienza EditarEcuaciones }
    OpenWindow(1,1,80,TotTran+17,'EDICION DE LAS ECUACIONES',
               TitVenEcua + BorVenEcua*16, MarVenEcua + BorVenEcua*16);
    Repeat
      Clrscr;
      Wxy(2,1,'Las ecuaciones son actualmente, en su');
      If ModoActivo=Cart then VerEcCart(3) Else VerEcGeo(3);
      TablaDeColores(TotTran+13);
      Wxy(9,TotTran+6,'M : Cambia el modo de presentaci¢n; <ESC>: Vuelve al programa.');
      Wxy(2,TotTran+8,'Escriba qu‚ transformaci¢n (1-');
      Write(TotTran);
      Write(') desea alterar: ');
      Repeat
        Selec:=ReadChar
      Until (Selec in [Esc,'m','M',F1]) or ((Ord(Selec)-48) in [1..TotTran]);
      If Selec in ['m','M'] Then CambiarModoActivo;
      If Selec=F1 Then Ayude(Posicion);
      If ((Ord(Selec)-48) >=1) and ((Ord(Selec)-48)<=TotTran) Then
        Begin
          TranEsc:=Ord(Selec)-48;
          Writeln(Selec);
          Write(' Escoja el coeficiente u opci¢n (columna, 1-8) a alterar : ');
          Repeat
            Coef:=Readkey;
          Until Coef in ['1'..'8'];
          Writeln (Coef);
          Val(Coef,Coefesc,Cod);
          If ModoActivo=Cart Then
            Begin
              Case CoefEsc of
                1..4 : Repeat
                         NuevoValor;
                         For i:=1 to 4 do A[i]:=MatTran[TranEsc,i];
                         r:=Sqrt(A[1]*A[1] + A[3]*A[3]);
                         s:=Sqrt(A[2]*A[2] + A[4]*A[4]);
                         If (r>=1) or (s>=1) Then Error;
                       Until (Abs(r)<1) And (Abs(s)<1);
                5,6 : NuevoValor
              End;  { Fin del Case }
              AsigneMatTranG;
            End
          Else If CoefEsc in [1..6] Then              { Modo: Geometrico }
            Begin
              NuevoValor;
              AsigneMatTran;
            End;
          If CoefEsc=7 Then Activas[Tranesc]:=Not(Activas[Tranesc]);
          If Coefesc=8 Then
            Begin
              Repeat
              Write(' Escoja un nuevo color (0-',ColorMaximo,') para esta ecuaci¢n: ');
              LeaEnteroPos(Colores[Tranesc]);
              Writeln;
              Until Colores[Tranesc] in [0..ColorMaximo];
            End;

        End;
    Until Selec=Esc;
    CrearProbTran;
    Repeat CloseWindow Until Windowcount=0;
  End;     { Termina EditarEcuaciones }


Procedure ManejeDisco;

  Var
    Arch                      : Text;
    Nombre,DirProv            : Palabra30;

    NombreCompleto,DirMuestra : String;
    Selec                     : Char;
    DirOK                     : Boolean;
    Cuenta,J,Fi,Co,ActivasNum : Integer;
    ErrorDisco                : Byte;

  Procedure IndiqueError;
    Begin
      OpenWindow(20,11,60,15,'ERROR',
                   TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
      TextAttr:=TxVenEsp +  FonVenEsp*16;
      ClrScr;
      Case ErrorDisco Of
        2 : Begin
              W('No se encontr¢ el archivo pedido.');
              W('Rectifique el nombre o el directorio.');
            End;
        3 : Begin
              W('Camino DOS err¢neo. ');
              W('Verifique el directorio vigente.');
            End;
        100 : Begin
                W('Ocurri¢ un error de lectura de');
                W('disco.');
              End;
        101 : Begin
                W('Ocurri¢ un error de escritura de');
                W('disco.');
              End;
      Else Begin
             W('Ocurri¢ un error DOS. Verifique el');
             W('disco, el directorio, etc.');
           End;
      End;
      Write('        Pulse cualquier tecla.');
      EspereTecla;
      Repeat CloseWindow Until Windowcount=0;
      TextAttr:=TxVenNor + FonVenNor*16;
    End;   { Termina el subproc. IndiqueError }

  Procedure CorrijaDirProv;
    Var
     Largo  : Integer;
    Begin
      Largo:=Length(DirProv);
      DirMuestra:=DirProv;
      If DirProv[Largo]='\' Then
          Delete(DirProv,Largo,1);
    End;   { Termina el subproc. CorrijaDirProv }


  Begin    { Comienza el cuerpo del proc. ManejeDisco }
    Nombre:='SinNom';
    With Posicion do
    Case Renglon of

      2 : Repeat          { Cambio de directorio }
            DirOk:=True;
            OpenWindow(13,5,67,20,'DIRECTORIO',
               TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
            ClrScr;
            Wxy(3,2,'El directorio actualmente vigente para el manejo');
            Wxy(3,3,'de las figuras (grabaci¢n y lectura) es :');
            Wxy(12,5,Directorio);
            Wxy(3,7,'¨ Desea cambiar de directorio (S/N) ? ');
            Repeat
              Selec:=Readchar;
              Selec:=Upcase(Selec);
            Until Selec in ['S','N',Esc];
            If Selec='S' Then
              Begin
                Wxy(3,9,'Nuevo directorio : ');
                LeaNombre(30,DirProv);
                CorrijaDirProv;
                Camino:=DirProv+ '\*.FRA';
                FindFirst(Camino, Archive, DirInfo);
                If DosError=3 then
                  Begin
                    DirOk:=False;
                    OpenWindow(25,11,56,14,'ERROR',
                               TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
                    TextAttr:=TxVenEsp +  FonVenEsp*16;
                    ClrScr;
                    W('Tal directorio no existe.');
                    Write(' Pulse cualquier tecla.');
                    EspereTecla;
                    Repeat CloseWindow Until Windowcount=0;
                    TextAttr:=TxVenNor + FonVenNor*16;
                  End
                Else
                  Begin
                    Directorio:=DirProv;
                    Wxy(3,11,'El directorio activo es ahora : '+DirMuestra);
                    Wxy(15,13,'Pulse <ESC> para salir.');
                    EspereEsc;
                  End;
              End;
            Camino:=Directorio + '\*.FRA';
            Repeat CloseWindow Until Windowcount=0;
          Until DirOk;

      3 : Begin              { Ver directorio }
            Camino:=Directorio + '\*.FRA';
            OpenWindow(4,6,77,19,Camino,
               TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
            ClrScr;
            Co:=3; Fi:=2;
            FindFirst(Camino, Archive, DirInfo);
            If DosError=18 Then
                Wxy(15,6,'En este directorio no hay figuras grabadas.');
            While DosError = 0 do
              Begin
                Wxy(co,fi,DirInfo.Name);
                If co<=46 Then Inc(co,14)
                  Else
                   Begin
                     co:=3;
                     If fi<9 Then Inc(fi)
                      Else
                       Begin
                         Wxy(20,11,'PAUSA... Pulse cualquier tecla.');
                         Selec:=ReadChar;
                         ClrScr;
                         Co:=3; Fi:=2;
                       End;
                   End;
                FindNext(DirInfo);
              End;
            Wxy(25,11,'Pulse <Esc> para salir.');
            EspereEsc;
            Repeat CloseWindow Until Windowcount=0;
          End;

      4 : Begin              { Lectura }
            Camino:=Directorio+'\*.FRA';
            FindFirst(Camino, Archive, DirInfo);
            If DosError=18 Then
              Begin
                OpenWindow(13,9,68,16,'ERROR',
                              TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
                TextAttr:=TxVenEsp +  FonVenEsp*16;
                ClrScr;
                W('En el directorio actualmente especificado no hay');
                W('ninguna figura grabada. Por lo tanto, no es posible');
                W('efectuar el procedimiento de lectura.');
                W('Corrija este problema usando la opci¢n "DIRECTORIO"');
                W('del este mismo men£.');
                Write('               Pulse cualquier tecla.');
                EspereTecla;
                Repeat CloseWindow Until Windowcount=0;
                TextAttr:=TxVenNor + FonVenNor*16;
              End
            Else
              Begin
                OpenWindow(10,8,70,17,'LECTURA',
                   TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
                ClrScr;
                Wxy(3,2,'Entre el nombre del archivo a leer : ');
                Wxy(3,3,'(No use extensi¢n, s¢lo el nombre)');
                Wxy(18,7,'<ESC> para cancelar.');
                Wxy(23,5,'> ');
                LeaNombre(8,Nombre);
                If Nombre<>'SinNom' Then
                  Begin
                    NombreCompleto:=Directorio + '\' + Nombre + '.FRA';
                    Assign(Arch,NombreCompleto);
                    {$I-}
                    Reset(Arch);
                    {$I+}
                    ErrorDisco:=IOResult;
                    If ErrorDisco<>0 then IndiqueError
                    Else
                      Begin
                        Readln(Arch,Xcom);
                        Readln(Arch,Xfin);
                        Readln(Arch,Ycom);
                        Readln(Arch,Yfin);
                        Readln(Arch,Titulo);
                        Readln(Arch,Tottran);
                        For Cuenta :=1 To TotTran do
                          Begin
                            For J:=1 To 6 do Readln(Arch,MatTran[Cuenta,J]);
                            Readln(Arch,ActivasNum);
                            If ActivasNum=1 Then Activas[Cuenta]:=True Else Activas[Cuenta]:=False;
                            Readln(Arch,Colores[Cuenta]);
                          End;
                        Close(Arch);
                        Wxy(10,7,'Lectura conclu¡da. Pulse cualquier tecla.');
                        EspereTecla;
                        AsigneMatTranG;
                        CrearProbtran;
                      End;
                  End;
                Repeat CloseWindow Until Windowcount=0;
                Window(5,9,76,23);
                FillWin(#177, LightGray + Blue* 16);
                Window(1, 1, 80, 25);
                EcuaVigentes;
                TextosPantalla;
              End;
          End;     { Fin de la opci¢n de Lectura }


      5 : Begin           {  Grabaci¢n  }
            DirProv:=Directorio + '\*.*';
            FindFirst(DirProv, Archive, DirInfo);
            If DosError=3 then
              Begin
                OpenWindow(14,9,66,15,'ERROR',
                               TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
                TextAttr:=TxVenEsp +  FonVenEsp*16;
                ClrScr;
                W('El directorio actualmente especificado no existe.');
                W('Corrija este problema usando la opci¢n DIRECTORIO');
                W('de este mismo men£ antes de grabar.');
                W('');
                Write(' Pulse cualquier tecla.');
                EspereTecla;
                Repeat CloseWindow Until Windowcount=0;
                TextAttr:=TxVenNor + FonVenNor*16;
              End
            Else
              Begin
                OpenWindow(10,8,70,17,'GRABACION',
                          TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
                ClrScr;
                Wxy(3,2,'Entre el nombre del archivo (sin extensi¢n, y de m ximo');
                Wxy(3,3,'ocho letras) donde desea grabar:');
                Wxy(18,7,'<ESC> para cancelar.');
                Wxy(23,5,'> ');
                LeaNombre(8,Nombre);
                If  Nombre<>'SinNom' Then
                  Begin
                    NombreCompleto:=Directorio + '\' + Nombre + '.FRA';
                    Assign(Arch,NombreCompleto);
                    {$I-}
                    Rewrite(Arch);
                    ErrorDisco:=IOResult;
                    {$I+}
                    If ErrorDisco <> 0 Then IndiqueError
                    Else
                      Begin
                        Writeln(Arch,Xcom);
                        Writeln(Arch,Xfin);
                        Writeln(Arch,Ycom);
                        Writeln(Arch,Yfin);
                        Writeln(Arch,Titulo);
                        Writeln(Arch,Tottran);
                        For Cuenta :=1 To TotTran do
                          Begin
                            For J:=1 To 6 do Writeln(Arch,MatTran[Cuenta,J]);
                            If Activas[Cuenta] Then Writeln(Arch,1)
                              Else Writeln(Arch,0);
                            Writeln(Arch,Colores[Cuenta]);
                          End;
                        Close(Arch);
                        Wxy(10,7,'Grabaci¢n conclu¡da. Pulse cualquier tecla. ');
                        EspereTecla;
                      End;
                  End;
                Repeat CloseWindow Until Windowcount=0;
              End;
          End;               { Termina la opci¢n de grabar }


      6 : SalirPrograma:=True;

    End;   { Fin del Case Renglon of }
    AbrirVentana(NuevaVent);
    MoverAbajo;
  End;    { Termina el proc. ManejeDisco }


Procedure RutinasIniciales;
  Begin
    ParamDefecto;
    CaminoControl:='C:\TP\BGI';

    {$IfDef EnlazarGraficos}
    Enlace;   { Incluye los *.CHR y *.BGI en el .EXE }
    {$EndIf}

    Inigraf;        { Inicializa la unidad Graph.TPU }
    DefModGraf;     { Se inicializan los par metros b sicos del modo gr fico }
    AsigneColores;
    ResetColors;
    If PantIni Then PantallaInicial; { Pantalla de presentaci¢n del programa }
    Cierregraf;
    DefinirTextos;   { Crea la matriz Textos }
  End;  { Termina RutinasIniciales }


Procedure MenuDeColores;

  Var
    Tecla  : Char;

  Procedure MuestreColores;
    Begin
      Clrscr;
      Writeln;
      Writeln('   Los colores de la pantalla de graficaci¢n son actualmente:');
      Writeln;
      GotoXY(20,4);
      Write('(1) Fondo de la pantalla: ',ColorPant:2);
      TextColor(ColorPant);
      Writeln(' ÛÛÛ');
      TextColor(LightGray);
      GotoXY(20,5);
      Write('(2) Ventana de Grafic.  : ',ColorCaja:2);
      TextColor(ColorCaja);
      Writeln(' ÛÛÛ');
      TextColor(LightGray);
      GotoXY(20,6);
      Write('(3) Texto y Bordes      : ',ColorTexto:2);
      TextColor(ColorTexto);
      Writeln(' ÛÛÛ');
      TextColor(LightGray);
      GotoXY(20,7);
      Write('(4) Ejes Coordenados X-Y: ',ColorEjes:2);
      TextColor(ColorEjes);
      Writeln(' ÛÛÛ');
      TextColor(LightGray);
      Writeln;
    End;   { Termina el SubProc. MuestreColores }

  Procedure LeaColor(Var NuevoColor : Word);
    Var
      ColTemp : Word;
    Begin
      LeaEnteroPos(ColTemp);
      If ColTemp in [0..ColorMaximo] Then NuevoColor:=ColTemp;
    End;   { Termina el SubProc. LeaColor }

  Begin              { Comienza el proc. MenuDeColores }
    OpenWindow(5,7,76,23,'Men£ de Colores',
                TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
    Repeat
      MuestreColores;
      TablaDeColoresPeq(12);
      Wxy(28,15,'<ESC> Para Salir.');
      GotoXY(1,9);
      Write('   Escoja a qu‚ parte le quiere cambiar el color (1-4): ');
      Repeat Tecla:=Readchar
      Until Tecla in ['1'..'4',Esc,F1,CtrlF1];
      Writeln(Tecla);
      Case Tecla Of
        '1' :  Begin
                 Write('   Nuevo color para el fondo de la pantalla (0-',ColorMaximo,'): ');
                 LeaColor(ColorPant);
               End;
        '2' :  Begin
                 Write('   Nuevo color para la Ventana de Graficaci¢n (0-',ColorMaximo,'): ');
                 LeaColor(ColorCaja);
               End;
        '3' :  Begin
                 Write('   Nuevo color para el texto y los bordes (0-',ColorMaximo,'): ');
                 LeaColor(ColorTexto);
               End;
        '4' :  Begin
                 Write('   Nuevo color para los ejes coordenados X-Y (0-',ColorMaximo,'): ');
                 LeaColor(ColorEjes);
               End;
        F1  :  Ayude(Posicion);
        CtrlF1: Instrucciones;
      End;  { Fin del Case Tecla Of }
    Until Tecla=Esc;
    Repeat CloseWindow Until Windowcount=0;
  End;   { Termina MenuDeColores } 


Procedure Ejecutar;

  Var
    Selec  : Char;

  Procedure VentEdicion;
    Begin
      OpenWindow(5,12,76,16,'Edici¢n',
                  TitVenAy + BorVenAy*16,MarVenAy + BorVenAy*16);
      Clrscr;
      Writeln;
    End;    { Termina el subproc. VentEdicion }

  Begin     { Comienza Ejecutar }
    NuevaVent:=False;
    With Posicion do
      Case Ventana Of

         Dem  : Begin
                 Case Renglon of       { Asigna las matrices de los }
                   2 : Sierpinski;     { fractales de demostracion  }
                   3 : VonKoch;
                   4 : Bronchi;
                   5 : Helecho;
                   6 : Hoja;
                   7 : Arbol;
                   8 : Caracoles;
                   9 : Molinos;
                  10 : Vicsek;
                  11 : Cristales;
                 End;
                 Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana Demo }
                 AsigneMatTranG;
                 ResetColors;
                 Grafique;
                End;  { Fin de la opcion Dem }

         Ecua:  Begin
                  Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana Ecuaciones }
                  Case Renglon of
                    2 : VerEcuaciones;
                    3 : Crear;
                    4 : EditarEcuaciones;
                    5 : CambiarModoActivo;
                  End;  { Fin del Case Renglon of }
                  TextosEcuaciones;
                  EcuaVigentes;
                  Repeat CloseWindow Until Windowcount=0;
                  AbrirVentana(NuevaVent);
                End;   { Fin de la opcion Ecuaciones }

         Pant : Begin

                  Case Renglon of
                    2 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo comienzo del Eje X (<>',Xfin:5:2,') : ');
                          Repeat Lea(Xcom) Until (Xcom<>Xfin);
                          Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana de Edicion }
                        End;
                    3 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo final del Eje X (<>',Xcom:5:2,') = ');
                          Repeat Lea(Xfin) until (Xfin<>Xcom) ;
                          Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana de Edicion }
                        End;
                    4 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo comienzo del Eje Y (<>',Yfin:5:2,') : ');
                          Repeat Lea(Ycom) Until (Ycom<>Yfin);
                          Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana de Edicion }
                        End;
                    5 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo final del Eje Y (<>',Ycom:5:2,') : ');
                          Repeat Lea(Yfin) until (Yfin<>Ycom) ;
                          Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana de Edicion }
                        End;
                    6 : Trejes:=Not(Trejes);
                    7 : Panpeq:=Not(Panpeq);
                    8 : MenuDeColores;
                    9 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo nombre para la figura : ');
                          LeaNombre(30,Titulo);
                          Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana de Edicion }
                        End;
                  End; { Fin del Case Renglon of }
                  TextosPantalla;
                  Repeat CloseWindow Until Windowcount=0;   { Cierra la ventana Pantalla }
                  AbrirVentana(NuevaVent);
                  MoverAbajo;
                End;  { Fin de la opcion Pantalla }

         Graf : Grafique;

         Disk : ManejeDisco;

      End;  { Fin del Case Ventana of }
    If GrAbierta Then CierreGraf;
  End;    { Termina Ejecutar }


Procedure QuiereSalir;
  Begin
    Salida(SalirPrograma);
    AbrirVentana(NuevaVent);
  End;         { Termina QuiereSalir }


BEGIN        { PROGRAMA PRINCIPAL }
  PantIni:=False;
  RutinasIniciales;
  InitVentanas;    { Abre la presentaci¢n de pantalla en ventanas }
  Repeat
    Ch := ReadChar;
    Case Ch of
      CLeft  : MoverIzq;
      CRight : MoverDer;
      CUp    : MoverArriba;
      CDown  : MoverAbajo;
      CEnter : Ejecutar;
      F1     : Ayude(Posicion);
      CtrlF1 : Instrucciones;
      F2     : Grafique;
      CExit  : SalirPrograma:=True;
    Else
      Beep;
    End;
  Until SalirPrograma;
  Apague;

END.    { TERMINA EL PROGRAMA PRINCIPAL. }