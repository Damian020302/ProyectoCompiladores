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
// los complejos son de la forma n.n+m.mi
COMPLEX = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[+-]([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)i
FLOAT = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[fF]
DOUBLE = ([+-]?([1-9][0-9]*|0+)\.[0-9]+[eE][+-]?[0-9]+?|[+-]?([1-9][0-9]*|0+)\.[0-9]+?)[lL]?
INT = [1-9][0-9]*|0+
ID = [a-zA-Z_áéíóúüñÁÉÍÓÚÜÑ][a-zA-Z0-9_áéíóúüñÁÉÍÓÚÜÑ]*
RUNE = \'[^\']\'
STRING = \"[^\"]*\"


%%
{ESP}+ { /* No hacer nada */ }


// Palabras reservadas
"proto" { System.out.println("<PROTO, proto>"); return Parser.PROTO; }
"struct" { System.out.println("<STRUCT, struct>"); return Parser.STRUCT; }
"ptr" { System.out.println("<PTR, ptr>"); return Parser.PTR; }
"int" { System.out.println("<INT, int>"); return Parser.INT; }
"float" { System.out.println("<FLOAT, float>"); return Parser.FLOAT; }
"double" { System.out.println("<DOUBLE, double>"); return Parser.DOUBLE; }
"complex" { System.out.println("<COMPLEX, complex>"); return Parser.COMPLEX; }
"rune" { System.out.println("<RUNE, rune>"); return Parser.RUNE; }
"void" { System.out.println("<VOID, void>"); return Parser.VOID; }
"string" { System.out.println("<STRING, string>"); return Parser.STRING; }
"func" { System.out.println("<FUNC, func>"); return Parser.FUNC; }
"if" { System.out.println("<IF, if>"); return Parser.IF; }
"while" { System.out.println("<WHILE, while>"); return Parser.WHILE; }
"do" { System.out.println("<DO, do>"); return Parser.DO; }
"break" { System.out.println("<BREAK, break>"); return Parser.BREAK; }
"return" { System.out.println("<RETURN, return>"); return Parser.RETURN; }
"switch" { System.out.println("<SWITCH, switch>"); return Parser.SWITCH; }
"print" { System.out.println("<PRINT, print>"); return Parser.PRINT; }
"scan" { System.out.println("<SCAN, scan>"); return Parser.SCAN; }
"else" { System.out.println("<ELSE, else>"); return Parser.ELSE; }
"case" { System.out.println("<CASE, case>"); return Parser.CASE; }
"default" { System.out.println("<DEFAULT, default>"); return Parser.DEFAULT; }
"false" { System.out.println("<FALSE, false>");     yyparser.setYylval(new ParserValExtended(0));
              return Parser.F; }
"true" { System.out.println("<TRUE, true>");     yyparser.setYylval(new ParserValExtended(1));
              return Parser.T; }

// Simbolos especiales
"(" { System.out.println("<LPAR, (>"); return Parser.LPAR; }
")" { System.out.println("<RPAR, )>"); return Parser.RPAR; }
";" { System.out.println("<PYC, ;>"); return Parser.PYC; }
"{" { System.out.println("<LKEY, {>"); return Parser.LKEY; }
"}" { System.out.println("<RKEY, }>"); return Parser.RKEY; }
"[" { System.out.println("<LCOR, [>"); return Parser.LCOR; }
"]" { System.out.println("<RCOR, ]>"); return Parser.RCOR; }
"," { System.out.println("<COMA, ,>"); return Parser.COMA; }
"=" { System.out.println("<ASIG, =>"); return Parser.ASIG;}
":" { System.out.println("<PP, :>"); return Parser.PP; }
"||" { System.out.println("<DISY, ||>"); return Parser.DISY; }
"&&" { System.out.println("<CONJ, &&>"); return Parser.CONJ; }
"==" { System.out.println("<EQ, ==>"); return Parser.EQ; }
"!=" { System.out.println("<NEQ, !=>"); return Parser.NEQ; }
"<" { System.out.println("<MENOR, <>"); return Parser.MENOR; }
"<=" { System.out.println("<MENEQ, <=>"); return Parser.MENEQ; }
">" { System.out.println("<MAYOR, >>"); return Parser.MAYOR; }
">=" { System.out.println("<MAYEQ, >=>"); return Parser.MAYEQ; }
"-" { System.out.println("<RESTA, ->"); return Parser.RESTA; }
"*" { System.out.println("<MULT, *>"); return Parser.MULT; }
"/" { System.out.println("<DIV, />"); return Parser.DIV; }
"%" { System.out.println("<MOD, %>"); return Parser.MOD; }
"//" { System.out.println("<DIVDIV, //>"); return Parser.DIVDIV; }
"!" { System.out.println("<NOT, !>"); return Parser.NOT; }
"." { System.out.println("<P, .>"); return Parser.P; }
"+" { System.out.println("<SUMA, +>"); return Parser.SUMA; }

// Identificadores
{ID}   { String cadena = yytext();
         System.out.println("<ID, " + cadena + ">");
         yyparser.setYylval(new ParserValExtended(cadena));
         return Parser.ID;
       }

// Constantes numericas
{COMPLEX} {   String complejo = yytext();
              System.out.println("<LITCOMPLEX, " + complejo + ">");
              yyparser.setYylval(new ParserValExtended(complejo));
              return Parser.LITCOMPLEX;
       }
{FLOAT} { String flotante = yytext();
        yyparser.setYylval(new ParserValExtended(flotante));
        System.out.println("<LITFLOAT, " + flotante + ">");
        return Parser.LITFLOAT; 
       }
{DOUBLE} { String doble =  yytext();
        yyparser.setYylval(new ParserValExtended(doble));
        System.out.println("<LITDOUBLE, " + doble + ">");
        return Parser.LITDOUBLE; 
       }
{INT} { String numero = yytext();
        System.out.println("<LITINT, " + numero + ">");
        yyparser.setYylval(new ParserValExtended(numero));
        return Parser.LITENT; 
       }

// Constantes literales
{STRING} {    String cadena = yytext();
              cadena = cadena.substring(1,cadena.length()-1);
              System.out.println("<LITSTRING, " + cadena + ">");
              yyparser.setYylval(new ParserValExtended(cadena));
              return Parser.LITSTRING;
       }
{RUNE} {      String runa = yytext();
              runa = runa.substring(1,runa.length()-1);
              System.out.println("<LITRUNE, " + runa + ">");
              yyparser.setYylval(new ParserValExtended(runa));
              return Parser.LITRUNE;
       }



// Manejo de errores lexicos.
. {System.err.println("Illegal character: "+yytext()); return -1; }
