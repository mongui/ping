@ECHO OFF

SET hosts=C:\Windows\System32\drivers\etc\hosts
SET filtro=dominio1.com dominio2.com
SET listar=NO
SET orden=NO
SET timeout=5
SET timeoutdisponible=0

SETLOCAL EnableDelayedExpansion

REM Sacamos la version de Windows porque el comando TIMEOUT solo esta disponible a partir de WIN7.
ECHO Extrayendo version de Windows...
FOR /F "skip=2 tokens=2,*" %%A IN ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentVersion') DO (set VERSION=%%B)
IF "%version%" EQU "10.0" (
	ECHO Windows 10/Windows Server 2016.
	SET timeoutdisponible=1
)
IF "%version%" EQU "6.3" (
	ECHO Windows 8.1/Windows Server 2012 R2.
	SET timeoutdisponible=1
)
IF "%version%" EQU "6.2" (
	ECHO Windows 8/Windows Server 2012.
	SET timeoutdisponible=1
)
IF "%version%" EQU "6.1" (
	ECHO Windows 7/Windows Server 2008 R2.
	SET timeoutdisponible=1
)
IF "%version%" EQU "6.0" (
	ECHO Windows Vista/Windows Server 2008.
	SET timeoutdisponible=1
)
IF "%version%" EQU "5.2" (
	ECHO Windows XP 64-Bit/Windows Server 2003.
	SET timeoutdisponible=0
)
IF "%version%" EQU "5.1" (
	ECHO Windows XP.
	SET timeoutdisponible=0
)
IF "%version%" EQU "5.0" (
	ECHO Windows 2000.
	SET timeoutdisponible=0
)
ECHO.

REM Lista todos los servidores del archivo de HOSTS que contengan las cadenas a filtrar.
ECHO Leyendo el fichero HOSTS...
SET total=0
FOR /F "usebackq tokens=*" %%A in (%hosts%) DO (
	SET name=%%~A
	
	IF /I "!name:~0,1!" NEQ "#" (
		FOR /F "tokens=2" %%G IN ("!name!") DO (
			ECHO.%%G | findstr "%filtro%" > nul && (
				SET "servidores[!total!]=%%G"
				SET /A total += 1
			)
		)
	)
)

ECHO Lectura completada.
ECHO.

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
SET /A num = -1
:ping

REM Dependiendo de la opcion seleccionada recupera un servidor aleatorio o en orden.
IF /I "%orden%" EQU "SI" (
	SET /A num += 1

	IF !num! GEQ !total! (
		SET /A num = 0
	)
) ELSE (
	SET /A num = %random% %% !total!
)

ECHO | set /p="Haciendo PING a !servidores[%num%]!... "
@%SystemRoot%\system32\ping.exe !servidores[%num%]! -n 1 > nul

IF %ERRORLEVEL% GTR 0 (
	ECHO ERROR.
) ELSE (
	ECHO Correcto.
)

IF %timeoutdisponible% equ 1 (
	TIMEOUT %timeout% > nul
) ELSE (
	@%SystemRoot%\system32\ping.exe -n %timeout% 127.0.0.1 > nul
)
GOTO :ping

:salir
