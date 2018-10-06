unit check;

Interface

Var
 datos : array[1..512] of byte;

Implementation

Uses Dos,crt;

Var
 direc : string;
 i     : integer;
 u     : integer;

Function Verifica(unidad,cara,pista,sector :byte) : boolean;
Var
 r : registers;
Begin
 r.ah:=4;
 r.al:=1;
 r.dl:=unidad; { 0-1  }
 r.dh:=cara;   { 0-1  }
 r.ch:=pista;  { 0-39 }
 r.cl:=sector; { 1-9  }
 intr($13,r);
 if r.ah<>0 then verifica:=false
 else verifica:=true;
End;


Procedure LeeSector(u,c,p,s : integer);
Var
 i : integer;
 r : registers;
Begin
 for i:=1 to 512 do datos[i]:=0;
 r.ah:=2;
 r.al:=1;
 r.dl:=u;
 r.dh:=c;
 r.ch:=p;
 r.cl:=s;
 r.es:=seg(datos); r.bx:=ofs(datos);
 intr($13,r);
End;

Function CheckHole : Boolean;
Var
 c,p,s : Integer;
 f,g   : Boolean;
Begin
 f:=true;
 s:=8;
 for p:=27 to 33 do
  for c:=0 to 1 do
   for s:=1 to 9 do
    Begin
     g:=verifica(u,c,p,s);
     if g and (s=8) then f:=false;
     if not(g) and (s<>8) then f:=false;
    End;
 LeeSector(u,0,27,5);
 for i:=2 to 512 do
  if datos[i]<>(i div 2 -1) then f:=false;
 CheckHole:=f;
End;

Var
 dirinfo : searchrec;

Begin
 u:=0;
 FindFirst('A:\instalar.exe',Archive,dirinfo);
 If DosError<>0 then u:=1;
 if not(CheckHole) then
    Begin
     Writeln('Lo siento. Copia de programa no valida');
     Halt(1);
    End
End.