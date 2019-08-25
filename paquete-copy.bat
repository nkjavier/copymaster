@echo off
color
rem preparao el archivo para hacer la tareas
set arranque=%time% - %date%
echo %date% %time% >to.txt
rem -----------------
set lista=
set lista2=
echo. >temp02.txt
echo. >temp03.txt
echo. >temp05.txt
echo. >temp06.txt
echo. >temp07.txt
echo. >tempa.txt
echo. >redout1.txt
echo. >redout2.txt
echo Se Inicia Registro de copia %date% %time% >registro.log
echo ------------------------------------------->>registro.log
rem obtengo el dato del total de pcs, para el reporte finales
rem donde F.txt es donde estan el listado de las pcs
type f.txt | find /v /c "" >fbeta.txt
FOR /F "tokens=*" %%A IN (fbeta.txt) DO set tmp69=%%A
rem -------------
rem Verificando el estado de las pcs en red...
FOR /F "eol=;" %%i in (f.txt) do call :llamo0 %%i
goto pc-sinred
:llamo0 %1
 set lista=%1
 cls
 echo.
 echo Verificando que la pc respondan en Red
 echo.
 type logopc.txt
   echo                          %lista%
 ping -n 1 %lista% | find /I "TTL" >temp01.txt
 rem pcs sin red aca
 If %errorlevel% neq 0 Echo %lista% >>temp02.txt
rem pcs con red aca
 If %errorlevel% neq 1 echo %lista% >>temp03.txt
 goto :eof
 goto pc-sinred
 rem Se desgloza las pcs sin red para un mejor resumen
 :pc-sinred
 FOR /F "eol=;" %%h in (temp02.txt) do call :llamo1 %%h
goto contaras
:llamo1 %1
 set lista3=%1
 cls
 echo.
 echo Verificando De las pc que no tenian Red
 echo.
 type logopc1.txt
    echo                          %lista3%
 rem ping -n 1 %lista3% | find /I "Tiemp" >tempa.txt
 ping -n 1 %lista3% >tempa.txt
 rem pcs sin red que ya sabemos que existen
 rem pcs sin red, pero que no responde a Tiempo de espera agotado para esta solicitud.
 type tempa.txt | find /i "Tiempo"
if %errorlevel% equ 0 echo %lista3% >>redout1.txt
rem si no existe la pc fisica o mal el nombre -------------
type tempa.txt | find /i "La solicitud de ping"
if %errorlevel% equ 0 echo %lista3% >>redout2.txt
 goto :eof
 goto contaras
  :contaras
   rem Aca empieza todo
rem ---------------------------------------------------------
rem Aca se cuenta las lineas
rem -------------------------------------------------------
rem FOR /F "tokens=*" %%A IN (f.txt) DO set tmp90=%%A
type temp03.txt | find /v /c "" >f1.txt
FOR /F "tokens=*" %%A IN (f1.txt) DO set tmp70=%%A
cls
Echo Detectado:
echo Cantidad de Pcs disponibles: %tmp70%
sleep 6
set numeroA=1
set numeroB=0
rem -------------------------------------------------------
goto enred
:enred
FOR /F "eol=;" %%g in (temp03.txt) do call :llamo2 %%g
goto fin
:llamo2 %1
 set lista2=%1
 rem Aca esta el contador de numero
 set /a numeroB=%numeroA%+1
 set numeroA=%numeroB%
 rem  ------------------------------
 rem animacion
 set/a pp1=(%Random% %%9)+1
 set/a pp2=(%Random% %%9)+1
 set/a pp3=(%Random% %%9)+1
 set/a pp4=(%Random% %%9)+1
 rem --------------------------
 cls
 echo =Estado================================== %pp1% %pp2%
 echo ========================================= %pp3% %pp4%
 echo.
 echo.
 echo.
 echo #Progreso#
 echo Trabajando en la PC [%lista2%]
 echo Pcs procesadas [%numerob% / de %tmp70%]
 echo ###########################################
 echo.
 echo                                           (V.1.1)
 rem genero la regla de 3 simple para determinar el Porcentaje
 rem %tmp70% es el 100%%
 echo.
 set /a numeroc=100*%numeroB%/%tmp70%
 echo #Proceso Global: %numeroc% %% / de 100%% ######
  rem Aca va el motor de lo quiero hacer /////
copy/y to.txt \\%lista2%\c$\usuario >NUL  2>NUL
echo Se copio el archivo to.txt de la pc origen %COMPUTERNAME% a destino \\%lista2%\c$\usuario -%time% >>registro.log
if exist \\%lista2%\c$\usuario\to.txt echo Archivo en Destino se copio correctamente >>registro.log
if not exist \\%lista2%\c$\usuario\to.txt echo Archivo en Destino no se copio o fallo >>registro.log
echo --------------- >>registro.log
rem //////////////////////////////////
goto :eof
goto fin
:fin
cls
type temp02.txt | find /v /c "" >f2.txt
FOR /F "tokens=*" %%A IN (f2.txt) DO set tmp71=%%A
echo.
echo.
echo =Resumen Final==============================
echo ============================================
echo.
echo.
echo Total de Pcs Cargadas %tmp69%
echo Total de Pcs Fuera de linea %tmp71%
echo Total de Pcs en linea %tmp70%
echo -----------------------------------------------
echo Iniciado a las %arranque%
echo finalizado a las %time% %date%
echo -----------------------------------------------
rem tareas finales
echo.
echo Generando Informe.
echo ########### >>temp05.txt
echo Pcs Sin red >>temp05.txt
echo ########### >>temp05.txt
type redout1.txt >>temp05.txt
echo ########################### >>temp06.txt
echo Pcs Host Error o no existe >>temp06.txt
echo ########################### >>temp06.txt
type redout2.txt >>temp06.txt
echo ############## >>temp07.txt
echo Pc Realizadas >>temp07.txt
echo ############## >>temp07.txt
type temp03.txt >>temp07.txt
start notepad.exe temp05.txt
start notepad.exe temp06.txt
start notepad.exe temp07.txt
start notepad.exe registro.log
echo Generando Informe. [Generado]
rem eliminado todas variables
set tmp70=
set tmp71=
set tmp69=
del/q f1.txt
del/q f2.txt
del/q fbeta.txt
del/q tempa.txt
set lista=
set lista2=
set lista3=
set numeroA=
set numeroB=
set numeroC=
set arranque=
set pp1=
set pp2=
set pp3=
set pp4=
