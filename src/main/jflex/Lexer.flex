package main.jflex;

import main.byacc.Parser;
import main.byacc.ParserVal;
import java.io.Reader;


%%

%byaccj

%{

private Parser yyparser;

public Lexer(Reader r, Parser yyparser) {
       this(r);
       this.yyparser = yyparser;
}

public int getLine() { return yyline; }

%}

%public
%class Lexer
%standalone
%unicode
%line

ESP=[ \t\n]
NUM = ([1-9]([0-9])*|0)+(\.[0-9]+)?([eE][+-]?[0-9]+)?
ID = [a-zA-Z_][a-zA-Z0-9_]*


%%
{ESP}+ { /* No hacer nada */ }
"int" { return Parser.INT; }
"float" { return Parser.FLOAT; }
"if" { return Parser.IF; }
"else" { return Parser.ELSE; }
"while" { return Parser.WHILE; }
{NUM} { yyparser.setYylval(new ParserVal(Double.parseDouble(yytext()))); return Parser.NUM; }
{ID} { yyparser.setYylval(new ParserVal(Double.parseDouble(yytext()))); return Parser.ID; }
";" { return Parser.PYC; }
"=" { return Parser.ASIG; }
"+" { return Parser.SUMA; }
"-" { return Parser.RESTA; }
"*" { return Parser.MULT; }
"/" { return Parser.DIV; }
"(" { return Parser.LPAR; }
")" { return Parser.RPAR; }
"," { return Parser.COMA; }
{NUM} { yyparser.setYylval(new ParserVal(Double.parseDouble(yytext()))); return Parser.NUM; }
\b {System.err.println("Illegal character: "+yytext()); return -1; }
[^] {System.err.println("Illegal character: "+yytext()); return -1; }