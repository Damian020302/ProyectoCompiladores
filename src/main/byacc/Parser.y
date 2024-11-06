%{
  import java.lang.Math;
  import java.io.Reader;
  import java.io.IOException;
  import main.jflex.Lexer;
%}

/* YACC Declarations */
%token ESP ID NUM
%token SUMA RESTA MULT DIV LPAR RPAR INT FLOAT IF ELSE WHILE PYC ASIG COMA
%nonassoc IF
%nonassoc ELSE
%nonassoc WHILE
%left SUMA RESTA
%left MULT DIV
%nonassoc LPAR RPAR


/* Grammar follows */
%%

pr : ds ss
;

ds : d dsp
;

dsp : d dsp
|
;

d : t lv PYC
;

t : INT
| FLOAT
;

lv : ID lvp
;

lvp : COMA ID lvp
|
;

ss : s ssp
;

ssp : s ssp
|
;

s : ID ASIG e PYC
| IF LPAR e RPAR ss ELSE ss
| WHILE LPAR e RPAR ss
;

e : f ep
;

ep : SUMA f ep { $$ = new ParserVal($2.dval + $3.dval); }
| RESTA f ep { $$ = new ParserVal($2.dval - $3.dval); }
|
;

f : g fp
;

fp : MULT g fp { $$ = new ParserVal($2.dval * $3.dval); }
| DIV g fp { $$ = new ParserVal($2.dval / $3.dval); }
|
;

g : LPAR e RPAR
| ID
| NUM { $$ = 1; }
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