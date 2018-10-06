PROGRAM Fractales;


{ Programa para graficar Sistemas Iterados de Funciones en Rý usando el
  Algoritmo de Iteraci¢n Aleatoria.
  Desarrollado por Fernando P‚rez, Depto. de F¡sica, U. de Antioquia.
  Abril-Septiembre de 1.991. Colombia. }


Uses
  Graph, Crt, Dos, FracUni1, BGIDriv, BGIFont;


Procedure Abort(Msg : string);
begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
end;


Procedure Enlace;
begin
  { Register all the drivers }
  if RegisterBGIdriver(@CGADriverProc) < 0 then
    Abort('CGA');
  if RegisterBGIdriver(@EGAVGADriverProc) < 0 then
    Abort('EGA/VGA');
  if RegisterBGIdriver(@HercDriverProc) < 0 then
    Abort('Herc');
  

  { Register all the fonts }
  if RegisterBGIfont(@GothicFontProc) < 0 then
    Abort('Gothic');
  if RegisterBGIfont(@SansSerifFontProc) < 0 then
    Abort('SansSerif');
  if RegisterBGIfont(@TriplexFontProc) < 0 then
    Abort('Triplex');
End; { Termmina el proc. Enlace}


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
        #94: Ch := CtrlF1;
      end;
    ReadChar := Ch;
  End;  { Termina la fn. ReadChar }


Procedure Lea(Var Numero : Real);

 Const
   Bksp  = #8;
   Enter = #13;
   Esc   = #27;

 Var
   Fil,Col,Cod         : Integer;
   NumLet              : String[15];
   Tec                 : Char;

 Begin
   Fil:=WhereY;
   Col:=WhereX;
   NumLet:='';
   Repeat
     Tec:=Readkey;
     Case Tec of
       '-' : If Length(NumLet)=0 Then
             Begin
               NumLet:='-';
               Write(Tec);
               Inc(Col);
             End;
       '.' : If (Pos('.',NumLet)=0) Then
             Begin
               NumLet:=NumLet+Tec;
               Write(Tec);
               Inc(Col);
             End;
       '0'..'9' : Begin
                    NumLet:=NumLet+Tec;
                    Write(Tec);
                    Inc(Col);
                  End;
       Bksp : Begin
                If Length(Numlet)>0 Then
                  Begin
                    Delete(NumLet,Length(NumLet),1);
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
   If (Tec=Enter) and (NumLet<>'') Then Val(NumLet,Numero,Cod) Else Numero:=Numero;
 End;   { Termina Lea }


Procedure LeaNombre(Var Texto : NameStr);

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
       '0'..'9',
       'A'..'z': Begin
                    If Length(TexProv)<8 Then
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


Procedure AsigneColores;

  Begin
    If ColorMaximo = 1 Then
      Begin

     { Monitor monocrom tico. }
     { Colores de las ventanas de texto : }
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
        ColorFondo  := Black;
        ColorCaja   := Black;
        ColorTexto  := LightGray;
        ColorPuntos := LightGray;
        ColorEjes   := LightGray;
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
        ColorFondo  := Blue;
        ColorCaja   := DarkGray;
        ColorTexto  := White;
        ColorPuntos := Yellow;
        ColorEjes   := LightRed;
      End;
  End;  { Termina AsigneColores }


Procedure ParamDefecto;

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
    Done:=False;
    Tottran:=0;
    NuevaVent:= True;
    Xcom:=-5;
    Xfin:=5;
    Ycom:=-5;
    Yfin:=5;
    Trejes:=False;
    Panpeq:=True;
    Titulo:='';
    ModoActivo:=Geo;
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
  End;      { Termina TextosEcuaciones }


Procedure TextosPantalla;
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
      Textos[Pant,7]:=' Zona de Graficaci¢n: Peque¤a.'
    Else
      Textos[Pant,7]:=' Zona de Graficaci¢n:  Grande.';
    Textos[Pant,8]:=' Nombre de la figura:            ' + Titulo;
  End;      { Termina TextosPantalla }


Procedure TextosGraficar;
  Begin
    Textos[Graf,1]:='GRAFICAR';
    Textos[Graf,2]:=' Ejecutar';
  End;      { Termina TextosGraficar }


Procedure TextosDisco;
  Begin
    Textos[Disk,1]:='ARCHIVO';
    Textos[Disk,2]:=' Directorio';
    Textos[Disk,3]:=' Ver Dir.';
    Textos[Disk,4]:=' Grabar';
    Textos[Disk,5]:=' Leer';
    Textos[Disk,6]:=' Salir';
  End;      { Termina TextosDisco }


Procedure DefinirTextos;
  Begin
    TextosDemo;
    TextosEcuaciones;
    TextosPantalla;
    TextosGraficar;
    TextosDisco;
  End;  { Termina DefinirTextos }


Procedure EcuaVigentes;

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];

  Begin
    Window(8,20-TotTran,73,23);
    FrameWin('ECUACIONES VIGENTES', SingleFrame,
               TitVenEcVig + BorVenEcVig * 16,
               MarVenEcVig + BorVenEcVig * 16);
    ClrScr;
    If ModoActivo=Cart Then
      Begin
        Wxy(2,1,'Presentaci¢n Cartesiana ('+Titulo+') :');
        Wxy(10,2,
            'A11       A12       A21       A22       B1        B2');
        For Fil:=1 to TotTran do
          Begin
            Str(Fil,Filalet);
            Wxy(2,Fil+2,'T'+Filalet+' : ');
            Col:=7; J:=1;
            While J<=6 do
              Begin
                GotoXY(Col,Fil+2);
                Write(MatTran[Fil,J]:7:4);
                Inc(J); Inc(Col,10);
              End;
          End;
      End
    Else
      Begin
        Wxy(2,1,'Presentaci¢n Geom‚trica ('+Titulo+') :');
        Wxy(11,2,
             'r         s         é         í        B1        B2');
        For Fil:=1 to TotTran do
          Begin
            Str(Fil,Filalet);
            Wxy(2,Fil+2,'T'+Filalet+' : ');
            Col:=7; J:=1;
            While J<=6 do
              Begin
                GotoXY(Col,Fil+2);
                Write(MatTranG[Fil,J]:7:4);
                Inc(J); Inc(Col,10);
              End;
          End;
      End;
  End;  { Termina EcuaVigentes }


Procedure AbrirVentana(Vent : Ventanas; Nueva : Boolean);

  Procedure Abra(EsqYTam : Vector5; Ventana : Ventanas);
     { Este es un subprocedimiento de AbrirVentana }
    Var
      CuentaFilas : Integer;
      TituloVentana : String;
    Begin
      TituloVentana:=Textos[Ventana,1];
      OpenWindow(EsqYTam[1],EsqYTam[2],EsqYTam[3],EsqYTam[4],TituloVentana,
                   TitVenAct + BorVenAct*16,
                   MarVenAct + BorVenAct*16);
      ClrScr;
      For CuentaFilas:=2 To EsqYTam[5] Do
          EscribaV(Textos[Ventana,CuentaFilas]);
      If Nueva Then Posicion.Renglon:=2;
      RenglonActivo:=Textos[Posicion.Ventana,Posicion.Renglon];
      GotoXY(1,Posicion.Renglon-1);
      Resaltar(RenglonActivo);
    End;   { Termina el subproc. Abra }

  Begin     { Comienza AbrirVentana }
    Case Vent of
      Dem :  Begin
              Esquinas[1]:=3;
              Esquinas[2]:=1;
              Esquinas[3]:=16;
              Esquinas[4]:=10;
              Esquinas[5]:=9;
            End;
      Ecua : Begin
              Esquinas[1]:=13;
              Esquinas[2]:=1;
              Esquinas[3]:=34;
              Esquinas[4]:=6;
              Esquinas[5]:=5;
            End;
      Pant : Begin
              Esquinas[1]:=23;
              Esquinas[2]:=1;
              Esquinas[3]:=56;
              Esquinas[4]:=10;
              Esquinas[5]:=8;
            End;
      Graf : Begin
              Esquinas[1]:=51;
              Esquinas[2]:=1;
              Esquinas[3]:=62;
              Esquinas[4]:=3;
              Esquinas[5]:=2;
            End;
      Disk : Begin
              Esquinas[1]:=66;
              Esquinas[2]:=1;
              Esquinas[3]:=79;
              Esquinas[4]:=7;
              Esquinas[5]:=6;
            End;
    End;   { Fin del Case }
    Abra(Esquinas,Vent);
  End;   { Termina AbrirVentana }


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
    Wxy(1,25,'  Ctrl-F1:Instrucciones G/rales   F1:Ayuda    Alt-X:Salir');
    ClrEol;
    Wxy(66,25,'FRACTALES 1.0');
    ClrEol;
    TopWindow := nil;
    WindowCount := 0;
    TextAttr:=TxVenNor + FonVenNor*16;
    TextosPantalla;
    EcuaVigentes;
    AbrirVentana(Posicion.Ventana,NuevaVent);
    Resaltar(RenglonActivo);
  End;   { Termina InitVentanas }


Procedure MoverIzq;
  Begin
    NuevaVent:=True;
    If Posicion.Ventana>Dem Then
             Begin
               CloseWindow;
               Dec(Posicion.Ventana);
               AbrirVentana(Posicion.Ventana,NuevaVent);
             End
           Else
             Begin
               CloseWindow;
               Posicion.Ventana:=Disk;
               AbrirVentana(Posicion.Ventana,NuevaVent);
             End;
  End;   { Termina MoverIzq }


Procedure MoverDer;
  Begin
    NuevaVent:=True;
    If Posicion.Ventana<Disk Then
             Begin
               CloseWindow;
               Inc(Posicion.Ventana);
               AbrirVentana(Posicion.Ventana,NuevaVent);
             End
           Else
             Begin
               CloseWindow;
               Posicion.Ventana:=Dem;
               AbrirVentana(Posicion.Ventana,NuevaVent);
             End;
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
    If LugarY <> 1 Then
      Begin
        Dec(LugarY);
        Dec(Posicion.Renglon);
      End
    Else
      Begin
        LugarY:=Esquinas[5]-1;
        Posicion.Renglon:=Esquinas[5];
      End;
    RenglonActivo:=Textos[Posicion.Ventana,Posicion.Renglon];
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
    If LugarY<>Esquinas[5]-1 Then
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
    GotoXY(1,LugarY);
    Resaltar(RenglonActivo);
  End;   { Termina  MoverAbajo }


Procedure DibPan(Peq : Boolean);Forward;


Procedure Graficar;Forward;


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
      OpenWindow(13,11,68,14,'ERROR',
                 TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
      TextAttr:=TxVenEsp +  FonVenEsp*16;
      ClrScr;
      W('Los coeficientes A11..A22 definen una transformaci¢n');
      Write(' no contractora. Digite otros diferentes.');
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
                 Wxy(2,8,'A11 =            ');
                 GotoXY(8,8);
                 Lea(a);
               Until Abs(a)<1;
               MatTran[TrEntrada,1]:=a;
               Repeat
                 Wxy(21,8,'A12 =           ');
                 GotoXY(28,8);
                 Lea(b);
               Until Abs(b)<1;
               MatTran[TrEntrada,2]:=b;
               Repeat
                 Wxy(41,8,'A21 =           ');
                 GotoXY(48,8);
                 Lea(c);
               Until Abs(c)<1;
               MatTran[TrEntrada,3]:=c;
               Repeat
                 Wxy(61,8,'A22 =            ');
                 GotoXY(68,8);
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
                 Wxy(2,8,'r =            ');
                 GotoXY(6,8);
                 Lea(r);
               Until Abs(r)<1;
               MatTranG[TrEntrada,1]:=r;
               Repeat
                 Wxy(21,8,'s =            ');
                 GotoXY(26,8);
                 Lea(s);
               Until Abs(s)<1;
               MatTranG[TrEntrada,2]:=s;
               Repeat
                 Wxy(43,8,'é =            ');
                 GotoXY(49,8);
                 Lea(Theta);
               Until Abs(Theta)<=90;
               MatTranG[TrEntrada,3]:=Theta;
               Repeat
                 Wxy(61,8,'í =            ');
                 GotoXY(66,8);
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
               CloseWindow;
             End
           Else Titulo:='';
         End
       Else Titulo:='';
      CloseWindow;
      DibPan(Panpeq);
      Graficar;
     End;
  End;        { Termina el proc. Crear }


Procedure DibPan;    { Presenta la pantalla de graficaci¢n }

  Var
    Fil,Col     : Integer;
    Numero      : String[7];
    Numtran     : Char;

  Begin
    If Not(Grabierta) then Inigraf;
    SetBkColor(ColorFondo);
    SetColor(ColorTexto);
    Marco;
    DefEjes(PanPeq);
    If Peq Then
     Begin
       MarcoEjes;
       Escriba(3,2,'FRACTALES 1.0');
       Line (3*Colum,2*fila+2,(3*Colum)+TextWidth('FRACTALES 1.0'),2*Fila+2);
       SetTextJustify(Centertext, CenterText);
       OutTextXY(Xa+Round((Xb-Xa)/2),Round(Yb/2),Titulo);
       If Xmax>700 Then
         Begin
           OutTextXY(Round(Xa/2),4*Fila,'Estamos graficando el siguiente con-');
           OutTextXY(Round(Xa/2),5*Fila,'junto de Transformaciones Afines :');
           OutTextXY(Round(Xa/2)+8,7*Fila,'A11    A12    A21   A22    B1     B2');
           For Fil:= 8 to Tottran+7 do
             For Col := 1 to 6 do
               Begin
                 If Col=1 then
                   Begin
                     Numtran:=Chr(Fil+41);
                     OutTextXY(2*Colum,Fil*Fila,'T');
                     OutTextXY(3*Colum,Fil*Fila,Numtran);
                   End;
                 Str(Mattran[fil-7,col]:4:3,Numero);
                 OutTextXY(Round(7.60*Col*Xmax/100),Fil*Fila,Numero);
               End;
           SetTextJustify(LeftText,CenterText);
         End;
       Escriba(2,18,'Pulse cualquier tecla para');
       Escriba(2,19,'detener la graficacion.');
     End
    Else
      Begin
        Escriba(1.8,2,'FRACTALES 1.0');
        Line (Round(1.8*Colum),2*fila+2,Round(1.8*Colum)+TextWidth('FRACTALES 1.0'),2*Fila+2);
        Line(Xa-7,3,Xa-7,Ya+5);
        Line(Xa-7,Ya+5,Xmax-3,Ya+5);
      End;
      SetFillStyle(Solidfill,ColorCaja);
      Bar(Xa,Ya,Xb,Yb);
      SetColor(ColorEjes);
    If Trejes Then TrazaEjes(PanPeq);
    SetColor(ColorTexto);
  End;     { Termina el proc. DibPan  }


Function EscTran(S: Real):Integer;  { Escoge qu‚ transformaci¢n se aplica, }
                                    { teniendo en cuenta la asignaci¢n de  }
  Var                               { probabilidades.                      }
    J       : Integer;
    Crit    : Boolean;
    Cont    : Real;

  Begin
    Crit:=True;
    J:=0; Cont:=0;
    While Crit Do
      Begin
        Inc(J);
        If (J=Tottran) and (Crit) Then Crit:=False;
        Cont:=Cont + Probtran[j];
        If (S<=Cont) Then Crit:=False;
      End;
    EscTran:=J;
  End;       { Termina la funci¢n EscTran }


Procedure Graficar;   { Procedimiento central de Graficaci¢n del programa }

  Var
    Iter                   : Longint;
    Xvie,Yvie,Xnue,Ynue,aleat:Real;
    Tesc, Xpan, Ypan       : Integer;
    Iteraciones            : String[6];
    Resultado              : String[40];
    Tecla                  : Char;
    Fuera                  : Boolean;

  Procedure MarqueIteraciones;
    Begin
      Str(Iter,Iteraciones);
      SetTextJustify(CenterText,CenterText);
      If PanPeq Then
        Begin
          If (Xmax>700) Then
          Resultado:='Hemos realizado '+Iteraciones+' Iteraciones'
          Else Resultado:='Iteraciones : '+Iteraciones;
          OutTextXY(Round(Xa/2)-10,21*Fila,Resultado);
          OutTextXY(Round(Xa/2)-10,23*Fila,'Pulse <Escape> para salir,');
          OutTextXY(Round(Xa/2)-10,24*Fila,'o C para continuar.');
        End
      Else
        Begin
          Escriba(2,20,'Iteraciones :');
          Escriba(5,21,Iteraciones);
          Escriba(2,23,'C : Continuar,');
          Escriba(2,24,'<Esc> : Salir.');
        End;
    End;   { Fin del Subproc. MarqueIteraciones }


  Begin      { Comienza el procedimiento Graficar }
    Iter:=0;
    Fuera:=False;
    Xvie:=0.5;Yvie:=0.5;
    Randomize;
    Repeat
      If Tottran<>0 Then
        Begin              { Este ciclo es la graficaci¢n efectiva : }
          DefEjes(Panpeq);
          DefPantalla;
          Repeat
            Aleat:=Random(1000)/1000;
            Tesc:=Esctran(Aleat);
            Xnue:=(Xvie*Mattran[tesc,1])+(Yvie*Mattran[tesc,2])+(Mattran[tesc,5]);
            Ynue:=(Xvie*Mattran[tesc,3])+(Yvie*Mattran[tesc,4])+(Mattran[tesc,6]);
            Inc(Iter);
            Pantalla(Xnue,Ynue,Xpan,Ypan);
            If (Iter>100) and
              (Xpan<Xb) and (Xpan>Xa) and (Ypan>Yb) and (Ypan<Ya) Then
                PutPixel(Xpan,Ypan,ColorPuntos);
            Xvie:=Xnue; Yvie:=Ynue;
          Until KeyPressed;
        End;
      SetColor(ColorEjes);
      If Trejes Then TrazaEjes(PanPeq);
      SetColor(ColorTexto);
      MarqueIteraciones;
      Repeat
        Tecla:=Readchar;
        Tecla:=Upcase(Tecla);
      Until Tecla in [Esc,'C'];
      If Tecla='C' Then
        Begin
          SetColor(ColorFondo);
          MarqueIteraciones;
        End
      Else Fuera:=True;
    Until Fuera;
  End;     {Termina el proc. Graficar}


Procedure VerEcCart(Filacom : Integer);

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];

  Begin
    Wxy(2,Filacom,'Presentaci¢n Cartesiana ('+Titulo+') :');
    Wxy(12,Filacom+1,
        'A11         A12         A21         A22          B1          B2');
    For Fil:=1 to TotTran do
      Begin
        Str(Fil,Filalet);
        Wxy(2,Fil+FilaCom+1,'T'+Filalet+' : ');
        Col:=8; J:=1;
        While J<=6 do
          Begin
            GotoXY(Col,Fil+Filacom+1);
            Write(MatTran[Fil,J]:9:5);
            Inc(J); Inc(Col,12);
          End;
      End;
  End;  { Termina VerEcCart }


Procedure VerEcGeo(FilaCom : Integer);

  Var
    J,Fil,Col   : Integer;
    Filalet     : String[2];

  Begin
    Wxy(2,Filacom,'Presentaci¢n Geom‚trica ('+Titulo+') :');
    Wxy(13,Filacom+1,
         'r           s           é           í           B1          B2');
    For Fil:=1 to TotTran do
      Begin
        Str(Fil,Filalet);
        Wxy(2,Fil+Filacom+1,'T'+Filalet+' : ');
        Col:=8; J:=1;
        While J<=6 do
          Begin
            GotoXY(Col,Fil+FilaCom+1);
            Write(MatTranG[Fil,J]:9:5);
            Inc(J); Inc(Col,12);
          End;
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
    CloseWindow;
  End;     { Termina VerEcuaciones }


Procedure CambiarModoActivo;
  Begin
   If ModoActivo=Cart Then ModoActivo:=Geo Else ModoActivo:=Cart;
  End;   { Termina CambiarModoActivo }


Procedure EditarEcuaciones;

 Procedure Error;  { Subproc. de EditarEcuaciones }
   Begin
     OpenWindow(18,11,63,14,'ERROR',
                 TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
     TextAttr:=TxVenEsp + FonVenEsp*16;
     ClrScr;
     W('Este valor produce una transformaci¢n no');
     Write(' contractora. Digite otro diferente.');
     EspereTecla;
     CloseWindow;
     TextAttr:=TxVenNor + FonVenNor*16;
   End;   { Fin del subproc. Error }

  Var
    Selec,Coef                : Char;
    TotTranLet                : Char;
    ModoEnLetras              : String[12];
    Fil,TranEsc,CoefEsc,I,Cod : Integer;
    A                         : Array[1..4] Of Real;
    r,s                       : Real;

  Begin
    OpenWindow(1,3,80,TotTran+16,'EDICION DE LAS ECUACIONES',
               TitVenEcua + BorVenEcua*16, MarVenEcua + BorVenEcua*16);
    Repeat
      Clrscr;
      Wxy(2,2,'Las ecuaciones son actualmente, en su');
      If ModoActivo=Cart then VerEcCart(4) Else VerEcGeo(4);
      Wxy(2,TotTran+7,'Escriba qu‚ transformaci¢n (1-');
      Write(TotTran);
      Write(') desea alterar, o pulse :');
      Wxy(18,TotTran+9,'M para cambiar el modo de presentaci¢n.');
      Wxy(18,TotTran+10,'<ESC> para volver al programa.');
      Repeat
        GotoXY(60,TotTran+7);
        Selec:=Readkey
      Until (Selec in [Esc,'m','M']) or
	    ((Ord(Selec)-48) in [1..TotTran]);
      If Selec in ['m','M'] Then CambiarModoActivo;
      If ((Ord(Selec)-48) >=1) and ((Ord(Selec)-48)<=TotTran) Then
        Begin
          TranEsc:=Ord(Selec)-48;
          Wxy(2,TotTran+12,'Editando la transformaci¢n : '+Selec);
          Writeln;
          Writeln;
          Write(' Seleccione qu‚ coeficiente va a alterar (1-6) : ');
          Repeat
            Coef:=Readkey;
          Until Coef in ['1'..'6'];
          Writeln (Coef);
          Val(Coef,Coefesc,Cod);
          Writeln;

          If ModoActivo=Cart Then
            Begin
              Case CoefEsc of
                1..4 : Repeat
                         Write(' Entre su nuevo valor : ');
                         Lea (MatTran[TranEsc,CoefEsc]);
                         Writeln;
                         For i:=1 to 4 do A[i]:=MatTran[TranEsc,i];
                         r:=Sqrt(A[1]*A[1] + A[3]*A[3]);
                         s:=Sqrt(A[2]*A[2] + A[4]*A[4]);
                         If (r>1) or (s>1) Then Error;
                       Until (Abs(A[CoefEsc])<=1) And (r<=1) And (s<=1);
                5,6 : Begin
                        Write(' Entre su nuevo valor : ');
                        Lea (MatTran[Tranesc,Coefesc]);
                        Writeln;
                      End;
              End;  { Fin del Case }
              AsigneMatTranG;
            End
          Else
            Begin
              Case CoefEsc of
                1,2 : Repeat
                        Write(' Entre su nuevo valor : ');
                        Lea (MatTranG[Tranesc,Coefesc]);
                        Writeln;
                      Until Abs(MatTranG[Tranesc,Coefesc])<=1;
                3,4 : Repeat
                        Write(' Entre su nuevo valor : ');
                        Lea (MatTranG[Tranesc,Coefesc]);
                        Writeln;
                      Until Abs(MatTranG[Tranesc,Coefesc])<=90;
                5,6 : Begin
                        Write(' Entre su nuevo valor : ');
                        Lea (MatTranG[Tranesc,Coefesc]);
                        Writeln;
                      End;
              End; { Fin del Case }
            AsigneMatTran;
            End;
        End;
    Until Selec=Esc;
    CrearProbTran;
  End;     { Termina EditarEcuaciones }


Procedure Salir; { Procedimiento de abandono del programa }

 Var
   Salida : Boolean;
   Tec : Char;

 Procedure ResalteSI;
   Begin
     TextAttr:=TxVenEsp +  FonVenEsp*16;
     Wxy(18,4,'NO');
     TextAttr:=TitVenErr + BorVenErr*16;
     Wxy(9,4,'SI');
     Salida:=True;
     TextAttr:=TxVenEsp +  FonVenEsp*16;
   End;   { Termina el subproc. ResalteSI }

 Procedure ResalteNO;
   Begin
     TextAttr:=TxVenEsp +  FonVenEsp*16;
     Wxy(9,4,'SI');
     TextAttr:=TitVenAy + BorVenAy*16;
     GotoXY(18,4);
     Write('NO');
     Salida:=False;
     TextAttr:=TxVenEsp +  FonVenEsp*16;
   End;   { Termina el subproc. ResalteNO }

 Begin    { Cuerpo del proc. Salir }
   OpenWindow(26,10,54,16,'SALIDA',
                 TitVenAy + BorVenAy*16,MarVenErr + BorVenAy*16);
   TextAttr:=TxVenEsp +  FonVenEsp*16;
   ClrScr;
   Writeln;
   W('  ¨ Est  usted seguro ?');
   Writeln;
   ResalteSI;
   Repeat
     Tec:=ReadChar;
     Case Tec of
       CRight,CLeft : If Salida Then ResalteNO Else ResalteSI;
       CEnter : If Salida Then Done:=True;
     End;
   Until Tec=CEnter;
   CloseWindow;
   TextAttr:=TxVenNor + FonVenNor*16;
 End;   { Termina Salir }


Procedure Apague;
  Begin
    Window(1,1,80,25);
    LowVideo;
    TextAttr:= LightGray + Black*16;
    ClrScr;
  End;  { Termina Apague }


Procedure ManejeDisco;

  Var
    Arch                      : Text;
    Nombre                    : NameStr;
    DirProv, NombreCompleto,
    DirMuestra                : String;
    Selec                     : Char;
    DirOK                     : Boolean;
    Cuenta,J,Fi,Co            : Integer;
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
      CloseWindow;
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
            Until Selec in ['S','N'];
            If Selec='S' Then
              Begin
                Wxy(3,9,'Nuevo directorio : ');
                Readln(DirProv);
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
                    CloseWindow;
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
            CloseWindow;
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
            CloseWindow;
          End;


      4 : Begin           {  Grabaci¢n  }
            DirProv:=Directorio + '\*.*';
            FindFirst(DirProv, Archive, DirInfo);
            If DosError=3 then
              Begin
                OpenWindow(14,9,66,15,'ERROR',
                               TitVenErr + BorVenErr*16,MarVenErr + BorVenErr*16);
                TextAttr:=TxVenEsp +  FonVenEsp*16;
                ClrScr;
                W('El directorio actualmente especificado no existe.');
                W('Corrija este problema usando la opci¢n "DIRECTORIO"');
                W('de este mismo men£ antes de grabar.');
                W('');
                Write(' Pulse cualquier tecla.');
                EspereTecla;
                CloseWindow;
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
                LeaNombre(Nombre);
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
                          For J:=1 To 6 do Writeln(Arch,MatTran[Cuenta,J]);
                        Close(Arch);
                        Wxy(10,7,'Grabaci¢n conclu¡da. Pulse cualquier tecla. ');
                        EspereTecla;
                      End;
                  End;
                CloseWindow;
              End;
          End;

      5 : Begin              { Lectura }
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
                W('del men£ DISCO.');
                Write('               Pulse cualquier tecla.');
                EspereTecla;
                CloseWindow;
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
                LeaNombre(Nombre);
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
                          For J:=1 To 6 do Readln(Arch,MatTran[Cuenta,J]);
                        Close(Arch);
                        Wxy(10,7,'Lectura conclu¡da. Pulse cualquier tecla.');
                        EspereTecla;
                        AsigneMatTranG;
                        CrearProbtran;
                      End;
                  End;
                CloseWindow;
              End;
          End;     { Fin de la opci¢n de Lectura }

      6 : Salir;

    End;   { Fin del Case Renglon of }
    CloseWindow;
  End;    { Termina el proc. ManejeDisco }

Procedure RutinasIniciales;
  Begin
    ParamDefecto;
    Enlace;         { Enlaza los *.CHR y *.BGI internamente al programa  }
    Inigraf;        { Inicializa la unidad Graph.TPU }
    DefModGraf;     { Se inicializan los par metros b sicos del modo gr fico }
    AsigneColores;
    PantallaInicial; { Pantalla de presentaci¢n del programa }
    Cierregraf;
    DefinirTextos;   { Crea la matriz Textos }
  End;  { Termina RutinasIniciales }

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


  Begin
    NuevaVent:=False;
    With Posicion do
      Case Ventana Of

         Dem  : Begin
                 Case Renglon of
                   2 : Sierpinski;
                   3 : VonKoch;
                   4 : Bronchi;
                   5 : Helecho;
                   6 : Hoja;
                   7 : Arbol;
                   8 : Caracoles;
                   9 : Molinos;
                 End;
                 CloseWindow;   { Cierra la ventana Demo }
                 AsigneMatTranG;
                 DibPan(PanPeq);
                 Graficar;
                End;  { Fin de la opcion Dem }

         Ecua:  Begin
                  CloseWindow;   { Cierra la ventana Ecuaciones }
                  Case Renglon of
                    2 : VerEcuaciones;
                    3 : Crear;
                    4 : EditarEcuaciones;
                    5 : CambiarModoActivo;
                  End;  { Fin del Case Renglon of }
                  TextosEcuaciones;

                End;   { Fin de la opcion Ecuaciones }

         Pant : Begin

                  Case Renglon of
                    2 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo comienzo del Eje X (<>',Xfin:5:2,') : ');
                          Repeat Lea(Xcom) Until (Xcom<>Xfin);
                          CloseWindow;   { Cierra la ventana de Edicion }
                        End;
                    3 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo final del Eje X (<>',Xcom:5:2,') = ');
                          Repeat Lea(Xfin) until (Xfin<>Xcom) ;
                          CloseWindow;   { Cierra la ventana de Edicion }
                        End;
                    4 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo comienzo del Eje Y (<>',Yfin:5:2,') : ');
                          Repeat Lea(Ycom) Until (Ycom<>Yfin);
                          CloseWindow;   { Cierra la ventana de Edicion }
                        End;
                    5 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo final del Eje Y (<>',Ycom:5:2,') : ');
                          Repeat Lea(Yfin) until (Yfin<>Ycom) ;
                          CloseWindow;   { Cierra la ventana de Edicion }
                        End;
                    6 : Trejes:=Not(Trejes);
                    7 : Panpeq:=Not(Panpeq);
                    8 : Begin
                          VentEdicion;
                          Write(' Entre el nuevo nombre para la figura : ');
                          Readln(Titulo);
                          CloseWindow;   { Cierra la ventana de Edicion }
                        End;
                  End; { Fin del Case Renglon of }
                  CloseWindow;   { Cierra la ventana Pantalla }
                  TextosPantalla;
                End;  { Fin de la opcion Pantalla }

         Graf : Begin
                  CloseWindow;   { Cierra la ventana Graficar }
                  DibPan(PanPeq);
                  Graficar;
                End;  { Fin de la opcion Graf }

         Disk : ManejeDisco;

      End;  { Fin del Case Ventana of }
  End;    { Termina Ejecutar }



BEGIN        { PROGRAMA PRINCIPAL }

  RutinasIniciales;
  InitVentanas;    { Abre la presentaci¢n de pantalla en ventanas }
  Repeat
    Ch := ReadChar;
    Case Ch of
      CLeft  : MoverIzq;
      CRight : MoverDer;
      CUp    : MoverArriba;
      CDown  : MoverAbajo;
      CEnter : Begin
                 Ejecutar;
                 If GrAbierta Then CierreGraf;
                 InitVentanas;
               End;
      F1     : Ayude(Posicion);
      CtrlF1 : Instrucciones;
      CExit  : Salir;
    Else
      Beep;
    End;
  Until Done;
  Apague;

END.    { TERMINA EL PROGRAMA PRINCIPAL. }