%{
  import java.lang.Math;
  import java.io.Reader;
  import java.io.IOException;
  import java.util.*;
  import main.jflex.*;
  import main.byacc.*;
  import main.java.*;
%}

/* YACC Declarations */
%token PROTO INT FLOAT DOUBLE COMPLEX RUNE VOID STRING ID STRUCT PTR LITENT LITRUNE LITFLOAT LITDOUBLE LITCOMPLEX FUNC F LITSTRING T
%token PYC COMA IF ASIG BREAK PRINT SCAN RETURN P PP
%nonassoc IFX
%nonassoc ELSE
%nonassoc WHILE
%nonassoc DO
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left DISY
%left CONJ
%left EQ NEQ
%left MAYOR MENOR MAYEQ MENEQ
%left SUMA RESTA
%left MULT DIV MOD DIVDIV
%left NOT NEG
%nonassoc LPAR RPAR
%nonassoc LKEY RKEY
%nonassoc LCOR RCOR


/* Grammar follows */
%%

programa : declproto declvar declfunc {
  cfg = generadorBloques.generateCFG(cuadruplos);
  System.out.println(cfg);
}
;

declproto : PROTO tipo ID LPAR args RPAR PYC declproto {
  Symbol proto = new SymbolImpl(0, $2.tipoActual, "prototipo", null);
  tablaSimbolos.addSymbol($3.text, proto);
  genCode("proto", $3.text, "args (" + $5.args + ")", $2.tipoActual.getName());
  System.out.println("Prototipo" + $3.text);
}
|
;

declvar : tipo listvar PYC declvar {
  for (String var : $2.vars) {
    Symbol simbolo = new SymbolImpl(0, $1.tipoActual, "variable", null);
    tablaSimbolos.addSymbol(var, simbolo);
    genCode("declare", var, $1.tipoActual.getName(), "");
  }
  System.out.println("Declaracion de variables" + $2.vars);
}
|
;

tipo : basico compuesto {
  if ($2.dimensiones > 0) {
    $$ = new ParserVal();
    $$.tipoActual = tablaTipos.getType(tablaTipos.addType($1.sval, $2.dimensiones, -1)).orElse(null);
  } else {
    $$ = 1;
  }
}
| STRUCT LKEY declvar RKEY {
  $$ = new ParserVal();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("struct", 0, -1)).orElse(null);
}
| puntero {
  $$ = new ParserVal();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("ptr", 0, $1.tipoActual.getParenId())).orElse(null);
}
;

puntero : PTR basico {
  $$ = new ParserVal();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("ptr<"+$2.tipoActual.getName()+">", 0, $2.tipoActual.getParenId())).orElse(null);
}
;

basico : INT {System.out.println("Entero");
$$ = tablaTipos.addType("int", 0, -1);}
| FLOAT {System.out.println("Flotante");
$$ = tablaTipos.addType("float", 0, -1);}
| DOUBLE {System.out.println("Doble");
$$ = tablaTipos.addType("double", 0, -1);}
| COMPLEX {System.out.println("Complejo");
$$ = tablaTipos.addType("complex", 0, -1);}
| RUNE {System.out.println("Runa");
$$ = tablaTipos.addType("rune", 0, -1);}
| VOID {System.out.println("Vacio");
$$ = tablaTipos.addType("void", 0, -1);}
| STRING {System.out.println("Cadena");
$$ = tablaTipos.addType("string", 0, -1);}
;

compuesto : LCOR LITENT RCOR compuesto {
  $$ = new ParserVal();
  $$.dimensiones = $4 != null ? $4.dimensiones + 1 : 1;
}
|
;

listvar : ID listvarp {
  $$ = new ParserVal();
  $$.vars = new ArrayList<>();
  $$.vars.add($1.text);
  $$.vars.addAll($2.vars);
}
;

listvarp : COMA ID listvarp {
  $$ = new ParserVal();
  $$.vars = new ArrayList<>();
  $$.vars.add($2.text);
  $$.vars.addAll($3.vars);
}
|
;

declfunc : FUNC tipo ID LPAR args RPAR bloque declfunc {
  Symbol funcion = new SymbolImpl(0, $2.tipoActual, "funcion", $5.args);
  tablaSimbolos.addSymbol($3.text, funcion);
  genCode("func", $3.text, "args (" + $5.args + ")", $2.tipoActual.getName());
  genCode("end func", "", "", "");
}
|
;

args : listarg {
  $$ = new ParserVal();
  $$.args = $1.args;
}
|
;

listarg : tipo ID listargsp {
  $$ = new ParserVal();
  $$.args = new ArrayList<>();
  $$.args.add(new SymbolImpl(0, $1.tipoActual, "argumento", null));
  $$.args.addAll($3.args);
}
;

listargsp : COMA tipo ID listargsp {
  $$ = new ParserVal();
  $$.args = new ArrayList<>();
  $$.args.add(new SymbolImpl(0, $2.tipoActual, "argumento", null));
  $$.args.addAll($4.args);
}
|
;

bloque : LKEY declvar instrucciones RKEY {
  BasicBlock nuevoBloque = new BasicBlock();
  nuevoBloque.addInstructions(new Quadruple("label", "", "", ""));
  nuevoBloque.getInstructions().addAll(cuadruplos);
  nuevoBloque.addInstructions(new Quadruple("end", "", "", ""));
  cfg.addBasicBlock(nuevoBloque);
}
;

instrucciones : sentencia instruccionesp {
  BasicBlock nuevoBloque = new BasicBlock();
  nuevoBloque.addInstructions(new Quadruple("instrucciones", $1.dir, "", ""));
  nuevoBloque.addInstructions(new Quadruple("continuar", "", "", ""));
}
;

instruccionesp : sentencia instruccionesp {
  BasicBlock nuevoBloque = new BasicBlock();
  nuevoBloque.addInstructions(new Quadruple("instrucciones", $1.dir, "", ""));
  nuevoBloque.addInstructions(new Quadruple("continuar", "", "", ""));
}
|
;

sentencia : parteizq ASIG exp PYC {
  genCode("=", $1.dir, $3.dir, $1.dir);
}
| IF LPAR exp RPAR sentencia sentenciaa {
  String trueEtiqueta = nuevaEtiqueta();
  String falseEtiqueta = nuevaEtiqueta();
  pilaLabelTrue.push(trueEtiqueta);
  pilaLabelFalse.push(falseEtiqueta);
  genCode("if " , $3.dir, ""," goto " + pilaLabelTrue.peek());
  genCode("goto " ,"", "", pilaLabelFalse.peek());
  genCode("label ", pilaLabelTrue.peek(), "" , "");
  $$ = $5;
  genCode("label ", pilaLabelFalse.peek(), "" , "");
  pilaLabelTrue.pop();
  pilaLabelFalse.pop();
}
| WHILE LPAR exp RPAR sentencia {
  String nextEtiqueta = nuevaEtiqueta();
  String trueEtiqueta = nuevaEtiqueta();
  String falseEtiqueta = nuevaEtiqueta();
  pilaLabelNext.push(nextEtiqueta);
  pilaLabelTrue.push(trueEtiqueta);
  pilaLabelFalse.push(falseEtiqueta);
  genCode("label ", pilaLabelNext.peek(), "" , "");
  $$ = $3;
  genCode("if ", $3.dir, "", " goto " + pilaLabelTrue.peek());
  genCode("goto " ,"", "", pilaLabelFalse.peek());
  genCode("label ", pilaLabelTrue.peek(), "" , "");
  $$ = $5;
  genCode("goto " ,"","", pilaLabelNext.peek());
  genCode("label ", pilaLabelFalse.peek(), "" , "");
  pilaLabelNext.pop();
  pilaLabelTrue.pop();
  pilaLabelFalse.pop();
}
| DO sentencia WHILE LPAR exp RPAR PYC {
  String nextEtiqueta = nuevaEtiqueta();
  String trueEtiqueta = nuevaEtiqueta();
  String falseEtiqueta = nuevaEtiqueta();
  pilaLabelNext.push(nextEtiqueta);
  pilaLabelTrue.push(trueEtiqueta);
  pilaLabelFalse.push(falseEtiqueta);
  genCode("label ", pilaLabelNext.peek(), "" , "");
  $$ = $2;
  genCode("if ", $4.dir, "", " goto " + pilaLabelTrue.peek());
  genCode("goto " ,"", "", pilaLabelFalse.peek());
  genCode("label ", pilaLabelTrue.peek(), "" , "");
  genCode("goto " ,"","", pilaLabelNext.peek());
  genCode("label ", pilaLabelFalse.peek(), "" , "");
  pilaLabelNext.pop();
  pilaLabelTrue.pop();
  pilaLabelFalse.pop();
}
| BREAK PYC {System.out.println("Break");}
| bloque {
  System.out.println("Bloque");
  BasicBlock nuevoBloque = generadorBloques.generateCFG(cuadruplos);
  cfg.addBasicBlock(nuevoBloque);
}
| RETURN sentenciab {
  System.out.println("Return");
  genCode("return", $2.dir, "", "");
}
| SWITCH LPAR exp RPAR LKEY casos RKEY {
  String switchTemp = nuevaEtiqueta();
  genCode("switch", $3.dir, "", switchTemp);
  for (caso: casos){
    String caseLabel = nuevaEtiqueta();
    genCode("if", switchTemp, "==", caso.value, "goto " + caseEtiqueta);
    genCode("goto", "", "", "nextCaseLabel"); 
    genCode("label", caseLabel, "", "");
  }
}
| PRINT exp PYC {
  System.out.println("Print");
  genCode("print", $3.dir, "", "");
}
| SCAN parteizq {
  System.out.println("Scan");
  genCode("scan", "", "", $1.dir);
}
;

sentenciaa : %prec IFX
| ELSE sentencia {
  String trueEtiqueta = nuevaEtiqueta();
  String falseEtiqueta = nuevaEtiqueta();
  String nextEtiqueta = nuevaEtiqueta();
  pilaLabelTrue.push(trueEtiqueta);
  pilaLabelFalse.push(falseEtiqueta);
  pilaLabelNext.push(nextEtiqueta);
  genCode("if ", $3.dir, "", " goto " + pilaLabelTrue.peek());
  genCode("goto " ,"", "", pilaLabelFalse.peek());
  genCode("label ", pilaLabelTrue.peek(), "" , "");
  $$ = $5;
  genCode("goto " ,"","", pilaLabelNext.peek());
  genCode("label ", pilaLabelFalse.peek(), "" , "");
  $$ = $7;
  genCode("label ", pilaLabelNext.peek(), "" , "");
  pilaLabelTrue.pop();
  pilaLabelFalse.pop();
  pilaLabelNext.pop();
}
;

sentenciab : exp PYC {
  System.out.println("Return");
  genCode("return", $1.dir, "", "");
}
| PYC {
  System.out.println(";");
  genCode(";","", "", "");
}
;

casos : caso casos {System.out.println("Casos");}
| predeterminado {System.out.println("Predeterminado");}
|
;

caso : CASE opcion PP instrucciones {
  String caseLabel = nuevaEtiqueta();
  genCode("if", $3.dir, "==", $1.dir, "goto " + caseLabel);
  genCode("goto", "", "", "nextCaseLabel");
  genCode("label", caseLabel, "", "");
  $$ = 5;
}
;

opcion : LITENT {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITRUNE {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("rune", 0, -1)).orElse(null);
}
;

predeterminado : DEFAULT PP instrucciones {System.out.println("Predeterminado");}
;

parteizq : ID parteizqp {System.out.println("Parte izquierda");}
;

parteizqp : localizacion {System.out.println("Parte izquierda");}
|
;

exp : exp DISY exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipo);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipo);
    genCode(" || ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp CONJ exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" && ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp EQ exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" == ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp NEQ exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" != ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp MAYOR exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" > ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp MENOR exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" < ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp MAYEQ exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" >= ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp MENEQ exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" <= ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp SUMA exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" + ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación +.");
  }
}
| exp RESTA exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" - ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación -.");
  }
}
| exp MULT exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" * ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación *.");
  }
}
| exp DIV exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipoActual);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipoActual);
    genCode(" / ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| exp MOD exp {
  if ($1.tipoActual.getName().equals("int") && $3.tipoActual.getName().equals("int")) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
    genCode("%", $1.dir, $3.dir, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación %.");
  }
}
| exp DIVDIV exp {
  if (compatibles($1.tipoActual, $3.tipoActual)) {
    $$ = new ParserVal();
    $$.dir = nuevaTemporal();
    $$.tipoActual = max($1.tipoActual, $3.tipoActual);
    String a1 = ampliar($1.dir, $1.tipoActual, $$.tipo);
    String a2 = ampliar($3.dir, $3.tipoActual, $$.tipo);
    genCode(" // ", a1, a2, $$.dir);
  } else {
    System.err.println("Error: Tipos incompatibles en operación /.");
  }
}
| NOT exp {
  $$ = new ParserVal();
  $$.dir = nuevaTemporal();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
  genCode("!", $2.dir, "", $$.dir);
}
| RESTA exp %prec NEG {
  $$ = new ParserVal();
  $$.dir = nuevaTemporal();
  $$.tipoActual = $2.tipoActual;
  genCode("-", $2.dir, "", $$.dir);
}
| LPAR exp RPAR {
  $$ = $2;
}
| ID expp {
  Optional<Symbol> simbolo = pilaSimbolos.lookup($1.sval);
  if (simbolo.isPresent()) {
    $$ = new ParserVal();
    $$.dir = $1.sval;
    $$.tipoActual = tablaTipos.getType(simbolo.get().getType()).orElse(null);
  } else {
    System.err.println("Error: " + $1.sval + " no está definido.");
  }
}
| F {
  $$ = new ParserVal();
  $$.dir = "0"; // Representación fija para True
  $$.tipo = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITSTRING {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("string", 0, -1)).orElse(null);
}
| T {
  $$ = new ParserVal();
  $$.dir = "1"; // Representación fija para True
  $$.tipo = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITRUNE {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("rune", 0, -1)).orElse(null);
}
| LITENT {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITFLOAT {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("float", 0, -1)).orElse(null);
}
| LITDOUBLE {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("double", 0, -1)).orElse(null);
}
| LITCOMPLEX {
  $$ = new ParserVal();
  $$.dir = yylex();
  $$.tipoActual = tablaTipos.getType(tablaTipos.addType("complex", 0, -1)).orElse(null);
}
;

expp : LPAR parametros RPAR {$$ = 2;}
| localizacion {$$ = $1;}
|
;

parametros : listparam {
  System.out.println("Parametros");
  $$ = 1;
}
|
;

listparam : exp listparamp {
  genCode("param", $1.dir, "", "");
}
;

listparamp : COMA exp listparamp {
  genCode("param", $2.dir, "", "");
}
|
;

localizacion : arreglo {
  System.out.println("Acceso a arrelo");
  $$ = $1;
}
| estructurado {
  System.out.println("Acceso a estructura");
  $$ = $1;
}
;

arreglo : LCOR exp RCOR arreglop {
  if ($1.tipoActual.getItems() > 0) { // Validar que queden dimensiones
    $$ = new ParserVal();
    String index = ampliar($2.dir, $2.tipoActual, tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null));
    $$.dir = nuevaTemporal(); // Generar temporal para el resultado del acceso
    $$.tipoActual = tablaTipos.getType($1.tipoActual.getParenId()).orElse(null); // Reducir dimensión
    genCode("[]", $1.dir, index, $$.dir); // Generar cuádruplo para acceso a arreglo
  } else {
    System.err.println("Error: Acceso a más dimensiones de las que el arreglo tiene.");
  }
}
;

arreglop : LCOR exp RCOR arreglop {
  if ($1.tipoActual.getItems() > 0) { // Validar que queden dimensiones
    $$ = new ParserVal();
    String index = ampliar($2.dir, $2.tipoActual, tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null));
    $$.dir = nuevaTemporal(); // Generar temporal para el resultado
    $$.tipoActual = tablaTipos.getType($1.tipoActual.getParenId()).orElse(null); // Reducir dimensión
    genCode("[]", $1.dir, index, $$.dir);
  } else {
    System.err.println("Error: Acceso a más dimensiones de las que el arreglo tiene.");
  }
|
;

estructurado : P ID estructuradop {
  Optional<Type> tipoEstructura = Optional.ofNullable($1.tipoActual);
  if (tipoEstructura.isPresent() && tipoEstructura.get().getParentStruct() != null) {
    Optional<Symbol> miembro = tipoEstructura.get().getParentStruct().lookup($2.sval);
    if (miembro.isPresent()) {
      $$ = new ParserVal();
      $$.dir = nuevaTemporal(); // Generar un temporal para almacenar el resultado
      $$.tipoActual = tablaTipos.getType(miembro.get().getType()).orElse(null); // Tipo del miembro
      genCode(".", $1.dir, $2.sval, $$.dir);
    } else {
      System.err.println("Error: El miembro " + $2.sval + " no existe en la estructura.");
    }
  } else {
    System.err.println("Error: " + $1.dir + " no es una estructura válida.");
  }
}
;

estructuradop : P ID estructuradop {
  Optional<Type> tipoEstructura = Optional.ofNullable($1.tipoActual);
  if (tipoEstructura.isPresent() && tipoEstructura.get().getParentStruct() != null) {
    Optional<Symbol> miembro = tipoEstructura.get().getParentStruct().lookup($2.sval);
    if (miembro.isPresent()) {
      $$ = new ParserVal();
      $$.dir = nuevaTemporal(); // Generar un temporal para almacenar el resultado
      $$.tipoActual = tablaTipos.getType(miembro.get().getType()).orElse(null); // Tipo del miembro
      genCode(".", $1.dir, $2.sval, $$.dir);
    } else {
      System.err.println("Error: El miembro " + $2.sval + " no existe en la estructura.");
    }
  } else {
    System.err.println("Error: No se puede acceder a " + $2.sval + " desde " + $1.dir);
  }
}
|
;

%%

Lexer scanner;
ControlFlowGraph cfg = new ControlFlowGraph();
SymbolTableStack pilaSimbolos = new SymbolTableStack();
SymbolTable tablaSimbolos = new SymbolTable();
TypeTable tablaTipos = new TypeTableImpl();
List<Quadruple> cuadruplos = new ArrayList<>();
BasicBlock bloqueActual;
BasicBlockGenerator generadorBloques = new BasicBlockGenerator();
Type tipoActual;
Stack<BasicBlock> pilaLabelTrue = new Stack<>();
Stack<BasicBlock> pilaLabelFalse = new Stack<>();
Stack<BasicBlock> pilaLabelNext = new Stack<>();
String dir = "0";
int tempCounter = 0; //contador de temporales
int labelCounter = 0; //contador de etiquetas

public Parser(Reader r) {
  this.scanner = new Lexer(r, this);
  bloqueActual = new BasicBlock();
  pilaSimbolos.push(tablaSimbolos);
}

public void setYylval(ParserVal yylval) {
  this.yylval = yylval;
}

public void parse() {
  this.yyparse();
  cfg = generadorBloques.generateCFG(cuadruplos);
  System.out.println(cfg);
}

void yyerror(String s)
{
  System.out.println("Error sintactico:"+s);
}

boolean compatibles(Type tipo1, Type tipo2){
  return tipo1.equals(tipo2) ||
  (tipo1.getName().equals("float") && tipo2.getName().equals("int")) ||
  (tipo1.getName().equals("int") && tipo2.getName().equals("float"));
}

Type max(Type tipo1, Type tipo2) {
  if (tipo1.getName().equals("float") || tipo2.getName().equals("float")) {
    return tablaTipos.getType(tablaTipos.addType("float", 0, -1)).orElse(null);
  }
  return tipo1; // Por defecto, el tipo menor (int en este caso)
}

String nuevaTemporal() {
  return "t" + (tempCounter++);
}

String nuevaEtiqueta() {
  return "L" + (labelCounter++);
}

/*BasicBlock nuevoBloque() {
  return new BasicBlock();
}*/

void genCode(String op, String arg1, String arg2, String res) {
  Quadruple q = new Quadruple(op, arg1, arg2, res);
  cuadruplos.add(q);
  bloqueActual.addInstruction(q);
  System.out.println(q);
}

String ampliar(String dir, Type tipoOrigen, Type tipoDestino) {
  if (tipoOrigen.equals(tipoDestino)) return dir;
  String temp = nuevaTemporal();
  genCode("(cast)", dir, tipoDestino.getName(), temp);
  return temp;
}

int yylex()
{
  int yyl_return = -1;
  try {
    yyl_return = scanner.yylex();
  }
  catch (IOException e) {
    System.err.println("IO error :"+e);
  }
  return yyl_return;
}
