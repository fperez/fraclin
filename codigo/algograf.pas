Var
    MatTran               : Array [1..8,1..6] of Real;
    ProbTran              : Array [1..8] of Real;


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
            Tesc:=Esctran(Random(1000)/1000);

           { Pero, si se desean ver los puntos fijos de las transf. afines,
             se debe emplear : }
            {If Tesc<TotTran Then Inc(Tesc) Else Tesc:=1;}

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