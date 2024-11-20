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

programa : declproto declvar declfunc
;

declproto : PROTO tipo ID LPAR args RPAR PYC declproto
|
;

declvar : tipo listvar PYC declvar
|
;

tipo : basico compuesto
| STRUCT LKEY declvar RKEY
| puntero
;

puntero : PTR basico
;

basico : INT
| FLOAT
| DOUBLE
| COMPLEX
| RUNE
| VOID
| STRING
;

compuesto : LCOR LITENT RCOR compuesto
|
;

listvar : ID listvarp
;

listvarp : COMA ID listvarp
|
;

declfunc : FUNC tipo ID LPAR args RPAR bloque declfunc
|
;

argumentos : listarg
|
;

listarg : tipo ID listargsp
;

listargsp : COMA tipo ID listargsp
|
;

bloque : LKEY declaraciones instrucciones RKEY
;

instrucciones : sentencia instruccionesp
;

instruccionesp : sentencia instruccionesp
|
;

sentencia : parteizq ASIG exp PYC
| IF LPAR exp RPAR sentencia sentenciaa
| WHILE LPAR exp RPAR sentencia
| DO sentencia WHILE LPAR exp RPAR
| BREAK PYC
| bloque
| RETURN sentenciab
| SWITCH LPAR exp RPAR LKEY casos RKEY
| PRINT exp PYC
| SCAN parteizq
;

sentenciaa : ELSE sentencia
|
;

sentenciab : exp PYC
| PYC
;

casos : caso casos
| predeterminado
|
;

caso : CASE opcion PP instrucciones
;

opcion : LITENT
| LITRUNE
;

predeterminado : DEFAULT PP instrucciones
;

parteizq : ID parteizqp
;

parteizqp : localizacion
|
;

exp : exp DISY exp
| exp CONJ exp
| exp EQ exp
| exp NEQ exp
| exp MAYOR exp
| exp MENOR exp
| exp MAYEQ exp
| exp MENEQ exp
| exp SUMA exp
| exp RESTA exp
| exp MULT exp
| exp DIV exp
| exp MOD exp
| exp DIVDIV exp
| NOT exp
| NEG exp
| LPAR exp RPAR
| ID expp
| F
| LITSTRING
| T
| LITRUNE
| LITENT
| LITFLOAT
| LITDOUBLE
| LITCOMPLEX
;

expp : LPAR parametros RPAR
| localizacion
|
;

parametros : listparam
|
;

listparam : exp listparamp
;

listparamp : COMA exp listparamp
|
;

localizacion : arreglo
| estructurado
;

arreglo : LCOR exp RCOR arreglop
;

arreglop : LCOR exp RCOR arreglop
|
;

estructurado : P ID estructuradop
;

estructuradop : P ID estructuradop
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
