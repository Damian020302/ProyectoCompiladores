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
  System.out.println("Entrada programa");
}
;

declproto : PROTO tipo ID LPAR args RPAR PYC declproto {
  System.out.println("Entrada declproto");
}
|  {System.out.println("Epsilon ");}
;

declvar : tipo listvar PYC declvar {
  System.out.println("Entrada declvar");
}
|
;

tipo : basico compuesto {
  System.out.println("Entrada tipo1");
}
| STRUCT LKEY declvar RKEY {
  System.out.println("Entrada tipo2");
}
| puntero {
  System.out.println("Entrada tipo3");
}
;

puntero : PTR basico {
  System.out.println("Entrada puntero1");
}
;

basico : INT {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| FLOAT {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("float");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| DOUBLE {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("double");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| COMPLEX {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("complex");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| RUNE {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| VOID {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("void");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| STRING {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("string");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

compuesto : LCOR LITENT RCOR compuesto {
  $$ = new ParserValExtended($2.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
|
;

listvar : listvar COMA ID
| ID {
  System.out.println("Entrada listvar");
}
;

declfunc : FUNC tipo ID LPAR args RPAR bloque declfunc {
  System.out.println("Entrada declfunc");
}
|
;

args : listarg {
  System.out.println("Entrada args");
}
|
;

listarg : listarg COMA tipo ID {
  System.out.println("Entrada listarg");
}
| tipo ID {
  System.out.println("Entrada listarg");
}
;

bloque : LKEY declvar instrucciones RKEY {
  System.out.println("Entrada bloque");
}
;

instrucciones : instrucciones sentencia {
  System.out.println("Entrada instrucciones");
}
| sentencia
;

sentencia : parteizq ASIG exp PYC {
  System.out.println("Entrada sentencia1");
}
| IF LPAR exp RPAR sentencia sentenciaa {
  System.out.println("Entrada sentencia2");
}
| WHILE LPAR exp RPAR sentencia {
  System.out.println("Entrada sentencia3");
}
| DO sentencia WHILE LPAR exp RPAR PYC {
  System.out.println("Entrada sentencia4");
}
| BREAK PYC {System.out.println("Entrada sentencia5");}
| bloque {
  System.out.println("Entrada sentencia6");
}
| RETURN sentenciab {
  System.out.println("Entrada sentencia7");
}
| SWITCH LPAR exp RPAR LKEY casos RKEY {
  System.out.println("Entrada sentencia8");
}
| PRINT exp PYC {
  System.out.println("Entrada sentencia9");
}
| SCAN parteizq {
  System.out.println("Entrada sentencia10");
}
;

sentenciaa : %prec IFX
| ELSE sentencia {
  System.out.println("Entrada sentenciaa");
}
;

sentenciab : exp PYC {
  System.out.println("Entrada sentneciab1");
}
| PYC {
  System.out.println("Entrada sentenciab2");
}
;

casos : caso casos {System.out.println("Entrada casos1");}
| predeterminado {System.out.println("Entrada casos2");}
|
;

caso : CASE opcion PP instrucciones {
  System.out.println("Entrada caso");
}
;

opcion : LITENT {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITRUNE {
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

predeterminado : DEFAULT PP instrucciones {System.out.println("Entrada predeterminado");}
;

parteizq : ID parteizqp {System.out.println(" Entrada ParteIzquierda");}
;

parteizqp : localizacion {System.out.println("Entrada ParteIzquierdaP");}
|
;

exp : exp DISY exp {
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
  System.out.println("Entrada exp11");
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
  System.out.println("Entrada exp11");
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
  System.out.println("Entrada exp11");
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
  System.out.println("Entrada exp11");
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
  $$ = new ParserValExtended();
  ((ParserValExtended)$$).dir = nuevaTemporal();
  String a = ampliar(((ParserValExtended)$2).dir, ((ParserValExtended)$2).tipo, ((ParserValExtended)$2).tipo);
  genCode("!", a, null, ((ParserValExtended)$$).dir);
}
| RESTA exp %prec NEG {
  $$ = new ParserValExtended();
  ((ParserValExtended)$$).dir = nuevaTemporal();
  String a = ampliar(((ParserValExtended)$2).dir, ((ParserValExtended)$2).tipo, ((ParserValExtended)$2).tipo);
  genCode("!", a, null, ((ParserValExtended)$$).dir);
}
| LPAR exp RPAR {
  System.out.println("Entrada exp17");
}
| ID expp {
  System.out.println("Entrada exp18");
  $$ = new ParserValExtended($1.sval);
}
| F {
  System.out.println("Entrada exp19");
  $$ = new ParserValExtended($1.ival);
  int idType = tablaTipos.getId("bool");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITSTRING {
  System.out.println("Entrada exp20");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("string");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| T {
  System.out.println("Entrada exp21");
  // pendiente
  $$ = new ParserValExtended($1.ival);
  int idType = tablaTipos.getId("bool");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITRUNE {
  System.out.println("Entrada exp22");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("rune");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITENT {
  System.out.println("Entrada exp23");
  System.out.println($1.sval);
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("int");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
  System.out.println("Este es el tipo " + ((ParserValExtended)$$).tipo.getName() + " de la tabla de tipos");
}
| LITFLOAT {
  System.out.println("Entrada exp24");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("float");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITDOUBLE {
  System.out.println("Entrada exp25");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("double");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
| LITCOMPLEX {
  System.out.println("Entrada exp26");
  $$ = new ParserValExtended($1.sval);
  int idType = tablaTipos.getId("complex");
  (((ParserValExtended)$$).tipo) = tablaTipos.getType(idType).get();
}
;

expp : LPAR parametros RPAR {System.out.println("Entrada expp1");}
| localizacion {System.out.println("Entrada expp2");}
|
;

parametros : listparam {
  System.out.println("Entrada parametros");
}
|
;

listparam : listparam COMA exp {
  System.out.println("Entrada listparam");
}
| exp {
  System.out.println("Entrada listparam");
}
;

localizacion : arreglo {
  System.out.println("Entrada localizacion1");
}
| estructurado {
  System.out.println("Entrada localizacion2");
}
;

arreglo : arreglo LCOR exp RCOR {
  System.out.println("Entrada arreglo1");
}
| LCOR exp RCOR {
  System.out.println("Entrada arreglo");
}
;

estructurado : estructurado P ID {
  System.out.println("Entrada estructurado");
}
| P ID {
  System.out.println("Entrada estructuradop");
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
