package main.jflex;

import main.byacc.*;
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
INT = [1-9][0-9]*|0+
FLOAT = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[fF]
DOUBLE = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[lL]?
COMPLEX = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[+-]([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)i
ID = [a-zA-Z_áéíóúüñÁÉÍÓÚÜÑ][a-zA-Z0-9_áéíóúüñÁÉÍÓÚÜÑ]*
RUNE = \'[^\']\'
STRING = \"[^\"]*\"


%%
{ESP}+ { /* No hacer nada */ }


// Palabras reservadas
"proto" { return Parser.PROTO; }
"struct" { return Parser.STRUCT; }
"ptr" { return Parser.PTR; }
"int" { return Parser.INT; }
"float" { return Parser.FLOAT; }
"double" { return Parser.DOUBLE; }
"complex" { return Parser.COMPLEX; }
"rune" { return Parser.RUNE; }
"void" { return Parser.VOID; }
"string" { return Parser.STRING; }
"func" { return Parser.FUNC; }
"if" { return Parser.IF; }
"while" { return Parser.WHILE; }
"do" { return Parser.DO; }
"break" { return Parser.BREAK; }
"return" { return Parser.RETURN; }
"switch" { return Parser.SWITCH; }
"print" { return Parser.PRINT; }
"scan" { return Parser.SCAN; }
"else" { return Parser.ELSE; }
"case" { return Parser.CASE; }
"default" { return Parser.DEFAULT; }
"false" { return Parser.F; }
"true" { return Parser.T; }

// Simbolos especiales
"(" { return Parser.LPAR; }
")" { return Parser.RPAR; }
";" { System.out.println("encontro ;");return Parser.PYC; }
"{" { return Parser.LKEY; }
"}" { return Parser.RKEY; }
"[" { return Parser.LCOR; }
"]" { return Parser.RCOR; }
"," { return Parser.COMA; }
"=" { System.out.println("encontro ="); return Parser.ASIG;}
":" { return Parser.PP; }
"||" { return Parser.DISY; }
"&&" { return Parser.CONJ; }
"==" { return Parser.EQ; }
"!=" { return Parser.NEQ; }
"<" { return Parser.MENOR; }
"<=" { return Parser.MENEQ; }
">" { return Parser.MAYOR; }
">=" { return Parser.MAYEQ; }
"-" { return Parser.RESTA; }
"*" { return Parser.MULT; }
"/" { return Parser.DIV; }
"%" { return Parser.MOD; }
"//" { return Parser.DIVDIV; }
"!" { return Parser.NOT; }
"." { return Parser.P; }
"+" { System.out.println("se encontro una suma ");return Parser.SUMA; }

// Identificadores
{ID}   { String cadena = yytext();
         System.out.println("se encontro la cadena " + cadena);
         yyparser.setYylval(new ParserVal(cadena));
         return Parser.ID;
       }

// Constantes numericas
{INT} { String numero = yytext();
        System.out.println("se encontro el numero" + numero);
        yyparser.setYylval(new ParserVal(numero));
        return Parser.LITENT; 
       }
{FLOAT} { String flotante = yytext();
        yyparser.setYylval(new ParserVal(flotante));
        System.out.println("se encontro el flotante " + flotante);
        return Parser.LITFLOAT; 
       }
{DOUBLE} { String doble =  yytext();
        yyparser.setYylval(new ParserVal(doble));
        System.out.println("se encontro el doble " + doble);
        return Parser.LITDOUBLE; 
       }
{COMPLEX} {   String complejo = yytext();
              System.out.println("se encontro el complejo " + complejo);
              yyparser.setYylval(new ParserVal(complejo));
              return Parser.LITCOMPLEX;
       }

// Constantes literales
{STRING} {    String cadena = yytext();
              cadena = cadena.substring(1,cadena.length());
              System.out.println("se encontro la cadena " + cadena);
              yyparser.setYylval(new ParserVal(cadena));
              return Parser.LITSTRING;
       }
{RUNE} {      String runa = yytext();
              runa = runa.substring(1,runa.length());
              System.out.println("se encontro la runa " + runa);
              yyparser.setYylval(new ParserVal(runa));
              return Parser.RUNE;
       }



// Manejo de errores lexicos.
. {System.err.println("Illegal character: "+yytext()); return -1; }
