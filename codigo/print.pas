Uses
 Printer,Graph;

Procedure Print(a1,b1,a2,b2 : word);
Var
 a : array[0..1000] of byte;
 l,i,j,k : integer;
Begin
 Write(lst,chr(27),'A',chr(8)); { Hace el espaciado de 8/72 de pulgada }
 i:=b1;
 While i<=b2 do
  Begin
   for l:=0 to a2-a1 do
    Begin
     a[l]:=0; k:=128;
     for j:=0 to 7 do
      Begin
       if getpixel(l+a1,i+j)<>0 then a[l]:=a[l]+k;
       k:=k div 2;
      End;
    End;

   i:=i+8;
   Write(lst,chr(27),'L',chr(lo(a2-a1+1)),chr(hi(a2-a1+1)));  { Setea el modo grafico DD, a2-a1+1 columnas }
   For j:=0 to a2-a1 do write(lst,chr(a[j])); { Imprimir la linea grafica }
   Writeln(lst);

  End;
  Write(lst,chr(27),'@');       { Resetear la impresora }
End;

Var
 i,a,b : integer;

Begin
 DetectGraph(a,b);
 InitGraph(a,b,'\tp6\bgi');
 ClearDevice;
 SetColor(White);
 bar(10,200,10,200);
 SetColor(White);
 rectangle(10,10,100,50);
 line(10,10,100,50);
 For I:=1 to 30 do
   PutPixel(i+10,30,White);
 readln;
{ Print(10,10,100,50);}
 closegraph;
end.
