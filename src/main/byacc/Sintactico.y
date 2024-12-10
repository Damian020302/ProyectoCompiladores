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
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("int");
}
| FLOAT {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("float");
}
| DOUBLE {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("double");
}
| COMPLEX {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("complex");
}
| RUNE {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("rune");
}
| VOID {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("void");
}
| STRING {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("string");
}
;

compuesto : LCOR LITENT RCOR compuesto {
  $$ = new ParserValExtended($2.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("int");
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
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("int");
}
| LITRUNE {
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("rune");
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
  System.out.println("Entrada exp1");
}
| exp CONJ exp {
  System.out.println("Entrada exp2");
}
| exp EQ exp {
  System.out.println("Entrada exp3");
}
| exp NEQ exp {
  System.out.println("Entrada exp4");
}
| exp MAYOR exp {
  System.out.println("Entrada exp5");
}
| exp MENOR exp {
  System.out.println("Entrada exp6");
}
| exp MAYEQ exp {
  System.out.println("Entrada exp7");
}
| exp MENEQ exp {
  System.out.println("Entrada exp8");
}
| exp SUMA exp {
  System.out.println("Entrada exp9");
  System.out.println($$);
  System.out.println($1.sval);
  System.out.println(((ParserValExtended)$3).dir);
  int e1 = Integer.valueOf($3.sval);
  System.out.println("en la suma el primero es" + e1);
  
}
| exp RESTA exp {
  System.out.println("Entrada exp10");
}
| exp MULT exp {
  System.out.println("Entrada exp11");
}
| exp DIV exp {
  System.out.println("Entrada exp12");
}
| exp MOD exp {
  System.out.println("Entrada exp13");
}
| exp DIVDIV exp {
  System.out.println("Entrada exp14");
}
| NOT exp {
  System.out.println("Entrada exp15");
}
| RESTA exp %prec NEG {
  System.out.println("Entrada exp16");
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
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("bool");
}
| LITSTRING {
  System.out.println("Entrada exp20");
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("string");
}
| T {
  System.out.println("Entrada exp21");
  // pendiente
  $$ = new ParserValExtended($1.ival);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("bool");
}
| LITRUNE {
  System.out.println("Entrada exp22");
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("rune");
}
| LITENT {
  System.out.println("Entrada exp23");
  System.out.println($1.sval);
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("int");
  System.out.println("Este es el tipo " + ((ParserValExtended)$$).tipo + " de la tabla de tipos");
}
| LITFLOAT {
  System.out.println("Entrada exp24");
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("float");
}
| LITDOUBLE {
  System.out.println("Entrada exp25");
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("double");
}
| LITCOMPLEX {
  System.out.println("Entrada exp26");
  $$ = new ParserValExtended($1.sval);
  (((ParserValExtended)$$).tipo) = tablaTipos.getId("complex");
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
