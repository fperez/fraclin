Echo Off

Echo Rutina de instalaci¢n de FRACTALES LINEALES 1.2 en disco duro.

If Exist C:\FracLin Goto Copiar

MD C:\FracLin

:Copiar
Copy Fraclin.EXE C:\Fraclin
Copy *.TXT C:\Fraclin
Copy Fraclin.HDD C:\Fraclin\Fraclin.INI

If Exist C:\Fraclin\Figuras Goto CopiarFiguras

MD C:\Fraclin\Figuras

:CopiarFiguras
Cd Figuras
Copy *.FRA C:\Fraclin\Figuras
Cd ..

Echo Instalaci¢n terminada.
Echo El programa Fractales Lineales 1.2 qued¢ instalado
Echo en el directorio C:\FRACLIN.
Echo Para entrar al programa, entre la ¢rden:
Echo FRACLIN          { Inicia el programa }
Echo On