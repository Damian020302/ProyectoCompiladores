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
%token PYC IF BREAK PRINT SCAN RETURN PP
%nonassoc IFX
%nonassoc ELSE
%nonassoc WHILE
%nonassoc DO
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
$left P
$left COMA
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
%nonassoc ASIG


/* Grammar follows */
%%

programa : declproto declvar declfunc {
  System.out.println("programa -> declproto declvar declfunc");
}
;

declproto : PROTO tipo ID LPAR args RPAR PYC declproto {
  System.out.println("declproto -> proto tipo id (args); declproto");
}
|  
;

declvar : tipo listvar PYC declvar {
  System.out.println("declvar -> tipo listvar ; declvar");
}
|
;

tipo : basico compuesto {
  System.out.println("tipo -> basico compuesto");
}
| STRUCT LKEY declvar RKEY {
  System.out.println("tipo -> struct{declvar}");
}
| puntero {
  System.out.println("tipo -> puntero");
}
;

puntero : PTR basico {
  System.out.println("puntero -> ptr basico");
}
;

basico : INT {
  System.out.println("basico -> int");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| FLOAT {
  System.out.println("basico -> float");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("float");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| DOUBLE {
  System.out.println("basico -> double");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("double");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| COMPLEX {
  System.out.println("basico -> complex");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("complex");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| RUNE {
  System.out.println("basico -> rune");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| VOID {
  System.out.println("basico -> void");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("void");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| STRING {
  System.out.println("basico -> string");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("string");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

compuesto : LCOR LITENT RCOR compuesto {
  System.out.println("compuesto -> [literal_entera] compuesto");
  $$ = new ParserValExtended($2.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
|
;

listvar : listvar COMA ID
| ID {
  System.out.println("listvar, id");
}
;

declfunc : FUNC tipo ID LPAR args RPAR bloque declfunc {
  System.out.println("declfunc -> func tipo id(args)bloque declfunc");
}
|
;

args : listarg {
  System.out.println("args -> listarg");
}
|
;

listarg : listarg COMA tipo ID {
  System.out.println("listarg -> listarg, tipo id");
}
| tipo ID {
  System.out.println("listarg -> tipo id");
}
;

bloque : LKEY declvar instrucciones RKEY {
  System.out.println("bloque -> { declvar instrucciones }");
}
;

instrucciones : instrucciones sentencia {
  System.out.println("instrucciones -> instrucciones sentencia");
}
| sentencia { 
  System.out.println("instrucciones -> sentencia");
}
;

sentencia : parteizq ASIG exp PYC {
  System.out.println("sentencia -> parteizq = exp;");
}
| IF LPAR exp RPAR sentencia sentenciaa {
  System.out.println("sentencia -> if(exp) sentencia sentenciaa");
}
| WHILE LPAR exp RPAR sentencia {
  System.out.println("sentencia -> while(exp) sentencia");
}
| DO sentencia WHILE LPAR exp RPAR PYC {
  System.out.println("sentencia -> do sentencia while(exp);");
}
| BREAK PYC {System.out.println("sentencia -> break;");}
| bloque {
  System.out.println("sentencia -> bloque");
}
| RETURN sentenciab {
  System.out.println("sentencia -> return sentenciab");
}
| SWITCH LPAR exp RPAR LKEY casos RKEY {
  System.out.println("sentencia -> switch(exp){ casos }");
}
| PRINT exp PYC {
  System.out.println("sentencia -> print exp ;");
}
| SCAN parteizq {
  System.out.println("sentencia -> scan parteizq");
}
;

sentenciaa : %prec IFX
| ELSE sentencia {
  System.out.println("sentenciaa -> else sentencia");
}
;

sentenciab : exp PYC {
  System.out.println("sentneciab -> exp;");
}
| PYC {
  System.out.println("sentenciab -> ;");
}
;

casos : caso casos {System.out.println("casos -> caso casos");}
| predeterminado {System.out.println("casos -> predeterminado");}
|
;

caso : CASE opcion PP instrucciones {
  System.out.println("caso -> case opcion : instrucciones");
}
;

opcion : LITENT {
  System.out.println("opcion -> literal_entera");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITRUNE {
  System.out.println("opcion -> literal_runa");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

predeterminado : DEFAULT PP instrucciones {
  System.out.println("predeterminado -> default : instrucciones");
}
;


parteizq : ID localizacion {
  System.out.println("parteizq -> ID localizacion");
}
| ID {
  System.out.println("parteizq -> ID");
}
;

exp : exp DISY exp {
  System.out.println("exp -> exp || exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("||", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en disyuncion.");
  }
}
| exp CONJ exp {
  System.out.println("exp -> exp && exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("&&", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en conjuncion.");
  }
}
| exp EQ exp {
  System.out.println("exp -> exp == exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("==", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en igualdad.");
  }
}
| exp NEQ exp {
  System.out.println("exp -> exp != exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("!=", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en no igualdad.");
  }
}
| exp MAYOR exp {
  System.out.println("exp -> exp > exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode(">", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles.");
  }
}
| exp MENOR exp {
  System.out.println("exp -> exp < exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("<", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en iguales.");
  }
}
| exp MAYEQ exp {
  System.out.println("exp -> exp >= exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode(">=", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en iguales.");
  }
}
| exp MENEQ exp {
  System.out.println("exp -> exp <= exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("<=", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en iguales.");
  }
}
| exp SUMA exp {
  System.out.println("exp -> exp + exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("+", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en suma.");
  }
}
| exp RESTA exp {
  System.out.println("exp -> exp - exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("-", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en multiplicacion.");
  }
}
| exp MULT exp {
  System.out.println("exp -> exp * exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("*", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en multiplicacion.");
  }
}
| exp DIV exp {
  System.out.println("exp -> exp / exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("/", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en division.");
  }
}
| exp MOD exp {
  System.out.println("exp -> exp % exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("%", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles en modulo.");
  }
}
| exp DIVDIV exp {
  System.out.println("exp -> exp // exp");
  $$ = new ParserValExtended();
  Type tipo1 = ((ParserValExtended)$1).tipo;
  Type tipo2 = ((ParserValExtended)$3).tipo;
  ((ParserValExtended)$1).dir = ((ParserValExtended)$1).sval;
  ((ParserValExtended)$3).dir = ((ParserValExtended)$3).sval;
  if (compatibles(tipo1, tipo2)) {
    //Calcular el tipo resultante
    Type tipoResultante = max(tipo1, tipo2);
    ((ParserValExtended)$$).tipo = tipoResultante;
    ((ParserValExtended)$$).dir = nuevaTemporal();
    String a1 = ampliar(((ParserValExtended)$1).dir, tipo1, tipoResultante);
    String a2 = ampliar(((ParserValExtended)$3).dir, tipo2, tipoResultante);
    genCode("//", a1, a2, ((ParserValExtended)$$).dir);
  } else {
    System.err.println("Error: Tipos incompatibles.");
  }
}
| NOT exp {
  System.out.println("exp -> ! exp");
  $$ = new ParserValExtended();
  ((ParserValExtended)$$).dir = nuevaTemporal();
  String a = ampliar(((ParserValExtended)$2).dir, ((ParserValExtended)$2).tipo, ((ParserValExtended)$2).tipo);
  genCode("!", a, null, ((ParserValExtended)$$).dir);
}
| RESTA exp %prec NEG {
  System.out.println("exp -> - exp");
  $$ = new ParserValExtended();
  ((ParserValExtended)$$).dir = nuevaTemporal();
  String a = ampliar(((ParserValExtended)$2).dir, ((ParserValExtended)$2).tipo, ((ParserValExtended)$2).tipo);
  genCode("!", a, null, ((ParserValExtended)$$).dir);
}
| LPAR exp RPAR {
  System.out.println("exp -> (exp)");
}
| ID expp {
  System.out.println("exp -> id expp");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("id");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| F {
  System.out.println("exp -> false");
  $$ = new ParserValExtended($1.ival);
  int idType = tablaTipos.getId("bool");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITSTRING {
  System.out.println("exp -> literal_cadena");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("string");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| T {
  System.out.println("exp -> true");
  // pendiente
  $$ = new ParserValExtended($1.ival);
  int idType = tablaTipos.getId("bool");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITRUNE {
  System.out.println("exp -> literal_runa");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITENT {
  System.out.println("exp -> literal_entera");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITFLOAT {
  System.out.println("exp -> literal_float");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("float");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITDOUBLE {
  System.out.println("exp -> literal_double");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("double");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITCOMPLEX {
  System.out.println("exp -> literal_compleja");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("complex");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

expp : LPAR parametros RPAR {
  System.out.println("expp -> (parametros)");
}
| localizacion {
  System.out.println("expp -> localizacion");
}
|
;

parametros : listparam {
  System.out.println("parametros -> listparam");
}
|
;

listparam : listparam COMA exp {
  System.out.println("listparam -> listparam, exp");
}
| exp {
  System.out.println("listparam -> exp");
}
;

localizacion : arreglo {
  System.out.println("localizacion -> arreglo");
}
| estructurado {
  System.out.println("localizacion -> estructurado");
}
;

arreglo : arreglo LCOR exp RCOR {
  System.out.println("arreglo -> arreglo [exp]");
}
| LCOR exp RCOR {
  System.out.println("arreglo -> [exp]");
}
;

estructurado : estructurado P ID {
  System.out.println("estructurado -> estructurado.ID");
}
| P ID {
  System.out.println("estructurado -> .ID");
}
;

%%

Lexer scanner;
ControlFlowGraph cfg = new ControlFlowGraph();
SymbolTableStack pilaSimbolos = new SymbolTableStackImpl();
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
  iniciarTipos();
}

public void iniciarTipos() {
  tablaTipos.addType("int", 1, -1);
  tablaTipos.addType("float", 4, -1);
  tablaTipos.addType("double", 8, -1);
  tablaTipos.addType("complex", 16, -1);
  tablaTipos.addType("rune", 2, -1);
  tablaTipos.addType("void", 0, -1);
  tablaTipos.addType("string", 0, -1);
  tablaTipos.addType("bool", 1, -1);
  // esto se agrego para evitar tablaSimbolos por que aun no la usamos
  tablaTipos.addType("id", 0, -1);
  tablaTipos.addType("array", 0, -1);
  tablaTipos.addType("struct", 0, -1);  
}

public void setYylval(ParserVal yylval) {
  this.yylval = yylval;
}

public void parse() {
  this.yyparse();
  //cfg = generadorBloques.generateCFG(cuadruplos);
  System.out.println(this.yyparse());
}

void yyerror(String s)
{
  int linea = scanner.getLine() + 1;
  System.out.println("Error sintactico: "+ s + " en la linea: " + linea);
}

boolean compatibles(Type tipo1, Type tipo2){
  return tipo1.equals(tipo2) ||
  (tipo1.getName().equals("float") && tipo2.getName().equals("int")) ||
  (tipo1.getName().equals("int") && tipo2.getName().equals("float"))||
  (tipo1.getName().equals("id") && tipo2.getName().equals("int")) ||
  (tipo1.getName().equals("id") && tipo2.getName().equals("float"))||
  (tipo1.getName().equals("int") && tipo2.getName().equals("id")) ||
  (tipo1.getName().equals("array") && tipo2.getName().equals("struct"))||
  (tipo1.getName().equals("float") && tipo2.getName().equals("id")) ||
  (tipo1.getName().equals("struct") && tipo2.getName().equals("array"));
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

String reducir(String dir, Type tipoOrigen, Type tipoDestino) {
  if (tipoOrigen.equals(tipoDestino)) return dir;
  String temp = nuevaTemporal();
  genCode("(cast)", dir, tipoOrigen.getName(), temp);
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
