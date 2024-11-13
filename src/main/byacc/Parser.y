%{
  import java.lang.Math;
  import java.io.Reader;
  import java.io.IOException;
  import main.jflex.Lexer;
%}

/* YACC Declarations */
%token PROTO INT FLOAT DOUBLE COMPLEX RUNE VOID STRING ID STRUCT PTR LITENT LITRUNE FUNC F LITSTRING T
%token DISY CONJ EQ NEQ MAYOR MENOR MAYEQ MENEQ SUMA RESTA MULT DIV MOD DIVDIV NOT NEG 
%token LPAR RPAR LKEY RKEY LCOR RCOR PYC COMA IF ELSE WHILE DO ASIG BREAK PRINT SCAN RETURN SWITCH P PP CASE DEFAULT
%nonassoc IF
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

args : tipo ID argsp
;

argsp : COMA tipo ID argsp
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

sentenciaa : 
| ELSE sentencia
;

sentenciab : exp PYC
| PYC
;

casos : caso casos
|
| predeterminado
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

exp : expa expp
;

expp : DISY expa expp
|
;

expa : expb expap
;

expap : CONJ expb expap
|
;

expb : expc expbp
;

expbp : EQ expc expbp
| NEQ expc expbp
|
;

expc : expd expcp
;

expcp : MAYOR expd expcp
| MENOR expd expcp
| MAYEQ expd expcp
| MENEQ expd expcp
|
;

expd : expe expdp
;

expdp : SUMA expe expdp
| RESTA expe expdp
|
;

expe : expf expep
;

expep : MULT expf expep
| DIV expf expep
| MOD expf expep
| DIVDIV expf expep
|
;

expf : NOT expf
| NEG expf
| expg
;

expg : LPAR exp RPAR
| ID expgp
| F
| T
| LITSTRING
| LITENT
| LITRUNE
;

expgp : LPAR parametros RPAR
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
