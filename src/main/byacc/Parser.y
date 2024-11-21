%{
  import java.lang.Math;
  import java.io.Reader;
  import java.io.IOException;
  import main.jflex.Lexer;
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

basico : INT {System.out.println("Entero");}
| FLOAT {System.out.println("Flotante");}
| DOUBLE {System.out.println("Doble");}
| COMPLEX {System.out.println("Complejo");}
| RUNE {System.out.println("Runa");}
| VOID {System.out.println("Vacio");}
| STRING {System.out.println("Cadena");}
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

argumentos : listarg {System.out.println("Argumentos");}
|
;

listarg : tipo ID listargsp {System.out.println("Lista de argumentos");}
;

listargsp : COMA tipo ID listargsp {System.out.println("Lista de argumentos");}
|
;

bloque : LKEY declaraciones instrucciones RKEY {System.out.println("Bloque");}
;

instrucciones : sentencia instruccionesp {System.out.println("Instrucciones");}
;

instruccionesp : sentencia instruccionesp {System.out.println("Instrucciones");}
|
;

sentencia : parteizq ASIG exp PYC {System.out.println("Asignacion");}
| IF LPAR exp RPAR sentencia sentenciaa {System.out.println("If");}
| WHILE LPAR exp RPAR sentencia {System.out.println("While");}
| DO sentencia WHILE LPAR exp RPAR PYC {System.out.println("Do");}
| BREAK PYC {System.out.println("Break");}
| bloque {System.out.println("Bloque");}
| RETURN sentenciab {System.out.println("Return");}
| SWITCH LPAR exp RPAR LKEY casos RKEY {System.out.println("Switch");}
| PRINT exp PYC {System.out.println("Print");}
| SCAN parteizq {System.out.println("Scan");}
;

sentenciaa : ELSE sentencia {System.out.println("Else");}
|
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

exp : exp DISY exp {$$ = new ParserVal($1 || $3);}
| exp CONJ exp {$$ = $1 && $3;}
| exp EQ exp {$$ = $1 == $3;}
| exp NEQ exp {$$ = $1 != $3;}
| exp MAYOR exp {$$ = $1 > $3;}
| exp MENOR exp {$$ = $1 < $3;}
| exp MAYEQ exp {$$ = $1 >= $3;}
| exp MENEQ exp {$$ = $1 <= $3;}
| exp SUMA exp {$$ = new ParserVal($1.dval + $3.dval);}
| exp RESTA exp {$$ = new ParserVal($1.dval - $3.dval);}
| exp MULT exp {$$ = new ParserVal($1.dval * $3.dval);}
| exp DIV exp {$$ = new ParserVal($1.dval / $3.dval);}
| exp MOD exp {$$ = new ParselVal($1.dval % $3.dval);}
| exp DIVDIV exp {$$ = $1 / $3;}
| NOT exp {$$ = !$2;}
| NEG exp {$$ = -$2;}
| LPAR exp RPAR {$$ = $2;}
| ID expp {$$ = $2;}
| F {$$ = 1;}
| LITSTRING {$$ = $1;}
| T {$$ = 1;}
| LITRUNE {$$ = $1;}
| LITENT {$$ = $1;}
| LITFLOAT {$$ = $1;}
| LITDOUBLE {$$ = $1;}
| LITCOMPLEX {$$ = $1;}
;

expp : LPAR parametros RPAR {$$ = 2;}
| localizacion {$$ = $1}
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

localizacion : arreglo {System.out.println("Localizacion");}
| estructurado {System.out.println("Localizacion");}
;

arreglo : LCOR exp RCOR arreglop {System.out.println("Arreglo");}
;

arreglop : LCOR exp RCOR arreglop {System.out.println("Arreglo");}
|
;

estructurado : P ID estructuradop {System.out.println("Estructurado");}
;

estructuradop : P ID estructuradop {System.out.println("Estructurado");}
|
;

%%

Lexer scanner;


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
