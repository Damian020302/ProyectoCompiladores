# ProyectoCompiladores
Proyecto de la materia de Compiladores del semestre 2025-1

### Profesores.
Profesora: Ariel Adara Mercado Martínez.
Ayudante: Yessica Janeth Pablo Martínez.
Ayudante Laboratorio: Carlos Gerardo Acosta Hernández.

### Integrantes.
- 317243705: Andrea Rojas Fuentes
- 318309877: Damián Vázquez Torrijos
- 421024388: José David Aguilar Uribe
- 311245488: Jesús Haans Lopez Hernández

# Ejecucion.
## Prerequisitos.
- Tener instalado java jdk 23.0.0
para verificar la version de java ejecutar el siguiente comando.
```
java -v
```
- Tener instalado byaccj
para verificar la instalacion de byaccj ejecutar el siguiente comando.
```
byaccj
```
devolvera lo siguiente.
```
usage:
 byaccj [-dlrtvj] [-b file_prefix] [-Joption] filename
  where -Joption is one or more of:
   -J
   -Jclass=className
   -Jvalue=valueClassName (avoids automatic value class creation)
   -Jpackage=packageName
   -Jextends=extendName
   -Jimplements=implementsName
   -Jsemantic=semanticType
   -Jnorun
   -Jnoconstruct
   -Jstack=SIZE   (default 500)
   -Jnodebug (omits debugging code for better performance)
   -Jfinal (makes generated class final)
   -Jthrows (declares thrown exceptions for yyparse() method)
```

- Tener instalado flex
para verificar la version de flex ejecutar el siguiente comando.
```
flex --version
```
- tener instalado ant
para verificar la version de ant ejecutar el siguiente comando.
```
ant -version
```

## Compilacion.

Para compilar el proyecto ejecutar el siguiente comando en la raiz del proyecto.
```
ant
````

esto  generara una carpeta llamada build en la raiz del proyecto, con todos los archivos .class del proyecto y despues  ejecutara el main del proyecto con cada uno de los archivos de prueba.