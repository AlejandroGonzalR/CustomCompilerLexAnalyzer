%option yylineno
%option noyywrap noinput nounput nodefault

%{
#include <stdio.h>
#include "y.tab.h"
%}

Identifier  ([a-zA-Z_$][a-zA-Z_$0-9]*)
Integer     ([-+]?[0-9]*)
Decimal     ([-+]?[0-9]*[.][0-9]+)
String      (\"(\\.|[^"\\])*\")
Boolean     (true|false|1|0)
Char        (\'(\\.|[^'\\])*\')
Blank       [ \t\n]+

%%
"fun"           { return FUNCTION; }
"var"           { return VARIABLE; }
"let"           { return CONSTANT; }
"cond"	        { return IF; }
"so"	        { return ELSE; }
"since"         { return FOR; }
"until"         { return UNTIL; }
"step"          { return STEP; }
"loop"          { return WHILE; }
"act"           { return DO; }
"show"          { return SHOW; }

":="	        { return EQUAL; }
"/="            { return UNEQUAL; }
"mod"           { return MODULE; }
"and"           { return AND; }
"or"            { return OR; }
"->"            { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLICATION; }
"/"             { return DIVISION; }
">"             { return HIGHER; }
"<"             { return LOWER; }
">="            { return HIGHER_EQUAL; }
"<="            { return LOWER_EQUAL; }

"numeric"       { return INTEGER; }
"largeNum"      { return LARGE_NUM; }
"decimal"       { return DECIMAL; }
"largeDec"      { return LARGE_DEC; }
"text"          { return STRING; }
"binary"        { return BOOLEAN; }
"char"          { return CHAR; }

{Integer}{1,10} { yylval = atoi(yytext); return INTEGER_VALUE; }
{Integer}{1,18} { yylval = atoi(yytext); return LARGE_INT_VALUE; }
{Decimal}{1,10} { yylval = atof(yytext); return DECIMAL_VALUE; }
{Decimal}{1,18} { yylval = atof(yytext); return LARGE_DEC_VALUE; }
{String}        { return STRING_VALUE; }
{Boolean}       { return BOOLEAN_VALUE; }
{Char}          { return CHAR_VALUE; }

{Identifier}    { return IDENTIFIER; }
{Blank} 	    ;
.               { return yytext[0]; }
%%
