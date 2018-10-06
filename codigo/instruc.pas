Program INSTRUCCIONES;   { Instrucciones iniciales sobre FRACTALES 1.1 }

Uses Crt;

Procedure W(Texto: String);
  Begin
    Writeln(' '+Texto);
  End;

Begin
  ClrScr;
  GotoXY(12,1);
  W('*** Bienvenido al programa FRACTALES 1.0 ***');
  W('');
  W('FRACTALES 1.0 puede ser utilizado tal y como est  en este momento');
  W('en el diskette, para lo cual basta digitar FRACTAL.');
  W('');
  W('Si desea instalarlo en un disco duro, digite DDURO. Esto llamar  un');
  W('programa que har  la instalaci¢n autom ticamente, as¡:');
  W('');
  W('    1. Crear  en su disco duro los siguientes directorios:');
  W('             C:\FRACTAL, y C:\FRACTAL\FIGURAS.');
  W('    2. Copiar  el archivo FRACTAL.EXE al dir. C:\FRACTAL.');
  W('    3. Copiar  el archivo FRACTAL.DDU como FRACTAL.INI en');
  W('       el dir. C:\FRACTAL.');
  W('');
  W('Si desea efectuar la instalaci¢n Ud. mismo, efect£e estos tres');
  W('pasos manualmente.');
  W('');
  W('Para llamar el programa escriba FRACTAL, en el directorio C:\FRACTAL.');
  W('');
  w('NOTA: El directorio FIGURAS se crea para almacenar las ecuaciones');
  W('      de los fractales que Ud. escoja. Si quiere reconfigurar esto,');
  W('      edite manualmente el archivo FRACTAL.INI.');
  W('');
  GotoXY(17,24);
  Write('<PULSE CUALQUIER TECLA PARA SALIR>');
  Repeat Until KeyPressed;
  ClrScr;
End.