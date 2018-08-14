@ECHO OFF

SET hosts=C:\Windows\System32\drivers\etc\hosts
SET filtro=ejiedes.net ejiedes.eus
SET listar=NO
SET timeout=5

SETLOCAL EnableDelayedExpansion

ECHO Leyendo el fichero HOSTS...

REM Lista todos los servidores del archivo de HOSTS que contengan las cadenas a filtrar.
SET total=0
FOR /F "tokens=2" %%G IN (%hosts%) DO (
	Echo.%%G | findstr "%filtro%" > nul && (
		SET "servidores[!total!]=%%G"
		SET /A total += 1
	)
)

ECHO Lectura completada.

REM Si no hay servidores, salimos del programa.
IF /I "%total%" EQU "0" (
	ECHO.
	ECHO No se ha encontrado ningun servidor que cumpla los parametros exigidos.
	GOTO :salir
)

ECHO Numero de entradas seleccionadas: !total!.

REM Imprime los servidores encontrados si asi se ha indicado en la variable inicial.
IF /I "%listar%" EQU "SI" (
	ECHO.
	ECHO Servidores encontrados con los filtros indicados en el archivo HOSTS:
	FOR /F "tokens=2 delims==" %%S IN ('set servidores[') DO ECHO %%S
	ECHO.
)

REM Realiza el ping sin mostrar los resultados del programa.
:ping
SET /A num=%random% %% !total!

ECHO | set /p="Haciendo PING a !servidores[%num%]!... "
@%SystemRoot%\system32\ping.exe !servidores[%num%]! -n 1 > nul

IF %ERRORLEVEL% GTR 0 (
	ECHO ERROR.
) ELSE (
	ECHO Correcto.
)

TIMEOUT %timeout% > nul
GOTO :ping

:salir
