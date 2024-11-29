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

programa : declproto declvar declfunc {System.out.println("Compilacion exitosa");}
;

declproto : PROTO tipo ID LPAR args RPAR PYC declproto {System.out.println("Prototipo de funcion");}
|
;

declvar : tipo listvar PYC declvar {System.out.println("Declaracion de variables");}
|
;

tipo : basico compuesto {System.out.println("Tipo de dato");}
| STRUCT LKEY declvar RKEY {System.out.println("Estructura");}
| puntero {System.out.println("Puntero");}
;

puntero : PTR basico {System.out.println("Puntero");}
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

compuesto : LCOR LITENT RCOR compuesto {System.out.println("Arreglo");}
|
;

listvar : ID listvarp {System.out.println("Lista de variables");}
;

listvarp : COMA ID listvarp {System.out.println("Lista de variables");}
|
;

declfunc : FUNC tipo ID LPAR args RPAR bloque declfunc {System.out.println("Funcion");}
|
;

args : listarg {System.out.println("Argumentos");}
|
;

listarg : tipo ID listargsp {System.out.println("Lista de argumentos");}
;

listargsp : COMA tipo ID listargsp {System.out.println("Lista de argumentos");}
|
;

bloque : LKEY declvar instrucciones RKEY {System.out.println("Bloque");}
;

instrucciones : sentencia instruccionesp {System.out.println("Instrucciones");}
;

instruccionesp : sentencia instruccionesp {System.out.println("Instrucciones");}
|
;

sentencia : parteizq ASIG exp PYC {System.out.println("Asignacion");}
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
| bloque {System.out.println("Bloque");}
| RETURN sentenciab {System.out.println("Return");}
| SWITCH LPAR exp RPAR LKEY casos RKEY {System.out.println("Switch");}
| PRINT exp PYC {System.out.println("Print");}
| SCAN parteizq {System.out.println("Scan");}
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

sentenciab : exp PYC {System.out.println("Return");}
| PYC {System.out.println("Return");}
;

casos : caso casos {System.out.println("Casos");}
| predeterminado {System.out.println("Predeterminado");}
|
;

caso : CASE opcion PP instrucciones {System.out.println("Caso");}
;

opcion : LITENT {System.out.println("Opcion");}
| LITRUNE {System.out.println("Opcion");}
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
| NOT exp {$$ = !$2;}
| RESTA exp %prec NEG {$$ = -$2;}
| LPAR exp RPAR {$$ = $2;}
| ID expp {$$ = $2;}
| F {
  $$ = new ParserVal();
  $$.dir = "0"; // Representación fija para True
  $$.tipo = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITSTRING {$$ = $1;}
| T {
  $$ = new ParserVal();
  $$.dir = "0"; // Representación fija para True
  $$.tipo = tablaTipos.getType(tablaTipos.addType("int", 0, -1)).orElse(null);
}
| LITRUNE {$$ = $1;}
| LITENT {$$ = $1;}
| LITFLOAT {$$ = $1;}
| LITDOUBLE {$$ = $1;}
| LITCOMPLEX {$$ = $1;}
;

expp : LPAR parametros RPAR {$$ = 2;}
| localizacion {$$ = $1;}
|
;

parametros : listparam {$$ = 1;}
|
;

listparam : exp listparamp {System.out.println("Lista de parametros");}
;

listparamp : COMA exp listparamp {System.out.println("Lista de parametros");}
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
Type tipoActual;
Stack<BasicBlock> pilaLabelTrue = new Stack<>();
Stack<BasicBlock> pilaLabelFalse = new Stack<>();
Stack<BasicBlock> pilaLabelNext = new Stack<>();
String dir = "0";
int tempCounter = 0; //contador de temporales
int labelCounter = 0; //contador de etiquetas

public Parser(Reader r) {
  this.scanner = new Lexer(r, this);
}

public void setYylval(ParserVal yylval) {
  this.yylval = yylval;
}

public void parse() {
  this.yyparse();
}

void yyerror(String s)
{
  System.out.println("Error sintactico:"+s);
}

boolean compatibles(Type tipo1, Type tipo2){
  return tipo1.equals(tipo2) || (tipo1.getName().equals("float") && tipo2.getName().equals("int"));
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
