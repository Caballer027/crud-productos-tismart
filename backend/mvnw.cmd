@ECHO OFF

SET "MAVEN_PROJECTBASEDIR=%~dp0"
IF "%MAVEN_PROJECTBASEDIR:~-1%" == "\" SET "MAVEN_PROJECTBASEDIR=%MAVEN_PROJECTBASEDIR:~0,-1%"

SET "WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
SET "WRAPPER_PROPS=%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties"

IF NOT EXIST "%WRAPPER_JAR%" (
    SET "WRAPPER_URL=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"
    IF EXIST "%WRAPPER_PROPS%" (
        FOR /F "usebackq tokens=1,2 delims==" %%A IN ("%WRAPPER_PROPS%") DO (
            IF "%%A" == "wrapperUrl" SET "WRAPPER_URL=%%B"
        )
    )
    ECHO Downloading maven-wrapper.jar...
    powershell -Command "Invoke-WebRequest -Uri '%WRAPPER_URL%' -OutFile '%WRAPPER_JAR%'" 2>NUL
    IF NOT EXIST "%WRAPPER_JAR%" (
        ECHO ERROR: Could not download maven-wrapper.jar. Check your internet connection.
        EXIT /B 1
    )
)

IF NOT "%JAVA_HOME%" == "" (
    SET "MAVEN_JAVA_EXE=%JAVA_HOME%\bin\java.exe"
) ELSE (
    SET "MAVEN_JAVA_EXE=java"
)

"%MAVEN_JAVA_EXE%" ^
  %MAVEN_OPTS% ^
  -classpath "%WRAPPER_JAR%" ^
  "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" ^
  org.apache.maven.wrapper.MavenWrapperMain ^
  %*

SET ERROR_CODE=%ERRORLEVEL%

IF "%MAVEN_BATCH_PAUSE%" == "on" PAUSE

EXIT /B %ERROR_CODE%
