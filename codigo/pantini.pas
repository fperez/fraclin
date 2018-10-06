Program PantInicial;

Uses Graph, Crt,FracUni;


Procedure PantallaInicial1;  { Genera la pantalla de presentaci¢n del programa }

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

  (* Delay(3000);*)

 End;    { Termina PantallaInicial }

Begin
    CaminoControl:='C:\TP6\BGI';
    Inigraf;        { Inicializa la unidad Graph.TPU }
    DefModGraf;     { Se inicializan los par metros b sicos del modo gr fico }
    AsigneColores;
    PantallaInicial1; { Pantalla de presentaci¢n del programa }
    Repeat Until KeyPressed;
    Cierregraf;
End.