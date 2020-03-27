%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define RED "\x1B[31m"
#define GREEN "\x1B[32m"
#define RESET "\x1B[0m"

int yylex ();
void yyerror (char *);

extern int yytext, yyleng;
extern int yylineno;
extern FILE *yyin;

union Set {
    char* key;
    int* value;
};

int size = 10;
int counter = 0;

%}
%token FUNCTION CONSTANT VARIABLE IDENTIFIER ASSIGN SHOW IF ELSE FOR UNTIL STEP WHILE DO
%token INTEGER_VALUE DECIMAL_VALUE STRING_VALUE BOOLEAN_VALUE CHAR_VALUE LARGE_INT_VALUE LARGE_DEC_VALUE
%left INTEGER DECIMAL STRING BOOLEAN CHAR LARGE_NUM LARGE_DEC
%left AND OR
%left PLUS MINUS
%left MULTIPLICATION DIVISION MODULE
%left EQUAL UNEQUAL HIGHER LOWER HIGHER_EQUAL LOWER_EQUAL ':' ','
%left '(' ')'
%left '{' '}'
%left '[' ']'
%%
input: line
| input line
;

line: funcDeclaration
| varAssignment
| varReassignment
| inputCall
| forExpression
| whileExpression
| ifExpression
| sysMethod
;

funcDeclaration: FUNCTION IDENTIFIER '(' argsOptions ')' '{' statement '}' { printf(GREEN "\nValid function declaration!\n" RESET); }
;

argsOptions:
| argsList
;

argsList: argsList ',' argument
| argument
;

argument: INTEGER IDENTIFIER
| LARGE_NUM IDENTIFIER
| DECIMAL IDENTIFIER
| LARGE_DEC IDENTIFIER
| STRING IDENTIFIER
| BOOLEAN IDENTIFIER
| CHAR IDENTIFIER
;

varAssignment: VARIABLE IDENTIFIER ':' dataTypes								{ printf(GREEN "\nValid variable assignment!\n" RESET); }
| CONSTANT IDENTIFIER ':' dataTypes												{ printf(GREEN "\nValid constant assignment!\n" RESET); }
| VARIABLE IDENTIFIER '[' ']' ':' INTEGER ASSIGN '[' arrayIntegerOptions ']'	{ printf(GREEN "\nValid variable array assignment!\n" RESET); }
| CONSTANT IDENTIFIER '[' ']' ':' INTEGER ASSIGN '[' arrayIntegerOptions ']'	{ printf(GREEN "\nValid constant array assignment!\n" RESET); }
;

varReassignment: IDENTIFIER ASSIGN dataValues									{ printf(GREEN "\nValid variable reassignment!\n" RESET); }
| IDENTIFIER ASSIGN '[' arrayIntegerOptions ']' 								{ printf(GREEN "\nValid variable array reassignment!\n" RESET); }
;

dataTypes: INTEGER ASSIGN INTEGER_VALUE
| LARGE_NUM ASSIGN LARGE_INT_VALUE
| DECIMAL ASSIGN DECIMAL_VALUE
| LARGE_DEC ASSIGN LARGE_DEC_VALUE
| STRING ASSIGN STRING_VALUE
| BOOLEAN ASSIGN BOOLEAN_VALUE
| CHAR ASSIGN CHAR_VALUE
;

dataValues: INTEGER_VALUE
| LARGE_INT_VALUE
| DECIMAL_VALUE
| LARGE_DEC_VALUE
| STRING_VALUE
| BOOLEAN_VALUE
| CHAR_VALUE
;

arrayIntegerOptions:
| arrayIntegerList
;

arrayIntegerList: arrayIntegerList ',' INTEGER_VALUE {
		counter++;
		if (counter + 1 > size) {
			printf(RED "Error - Max Array size is 10.\n" RESET);
		}
	}
| INTEGER_VALUE
;

inputCall: IDENTIFIER
| IDENTIFIER '(' argsOptions ')'
;

ifExpression: IF '(' condition ')' '{' statement '}' {
		printf(GREEN "\nValid if sentence!\n" RESET);

		if ($3) {
			printf("%d\n", $6);
		} else printf("False condition\n");
	}
| IF '(' condition ')' '{' statement '}' ELSE '{' statement '}' {
		printf(GREEN "\nValid if else sentence!\n" RESET);
		if ($3) {
			printf("%d\n", $6);
		} else {
			printf("%d\n", $10);
		}
	}
| IF '(' condition ')' '{' statement '}' ELSE ifExpression
;

forExpression: FOR IDENTIFIER ASSIGN INTEGER_VALUE UNTIL INTEGER_VALUE STEP INTEGER_VALUE '{' statement '}' {
		printf(GREEN "\nValid for sentence!\n" RESET);

		if ($4 < $6) {
			for (int i = $4; i <= $6; i += $8) {
				printf("%d\n", $10);
			}
		} else {
			for (int i = $4; i >= $6; i -= $8) {
				printf("%d\n", $10);
			}
		}
	}
;

whileExpression: WHILE '(' condition ')' '{' statement '}' {
		printf(GREEN "\nValid while sentence!\n" RESET);

		int sleep = 0; // Kill infinite loop for test
		while ($3) { printf("%d\n", $6); if (sleep == 10) break; sleep++; }
	}
| DO '{' statement '}' WHILE '(' condition ')' {
		printf(GREEN "\nValid do while sentence!\n" RESET);

		int sleep = 0; // Kill infinite loop for test
		do { printf("%d\n", $3); if (sleep == 10) break; sleep++; } while ($7);
	}
;

sysMethod: SHOW '(' statement ')'	{ printf(GREEN "\nValid print sentence!\n" RESET); printf("%d\n", $3); }
;

condition: INTEGER_VALUE
| expression HIGHER expression 			{ $$ = $1 > $3 ? 1 : 0; }
| expression LOWER expression 			{ $$ = $1 < $3 ? 1 : 0; }
| expression HIGHER_EQUAL expression 	{ $$ = $1 >= $3 ? 1 : 0; }
| expression LOWER_EQUAL expression 	{ $$ = $1 <= $3 ? 1 : 0; }
| expression EQUAL expression 			{ $$ = $1 == $3 ? 1 : 0; }
| expression UNEQUAL expression 		{ $$ = $1 != $3 ? 1 : 0; }
| expression AND expression 			{ $$ = $1 && $3 ? 1 : 0; }
| expression OR expression 				{ $$ = $1 || $3 ? 1 : 0; }
;

statement: body
| statement body
| sysMethod
| forExpression
| whileExpression
| ifExpression
;

body: expression
| inputCall
;

expression: INTEGER_VALUE
| DECIMAL_VALUE
| expression PLUS expression 			{ $$ = $1 + $3; }
| expression MINUS expression 			{ $$ = $1 - $3; }
| expression MULTIPLICATION expression 	{ $$ = $1 * $3; }
| expression DIVISION expression 		{ $$ = $1 / $3; }
| expression MODULE expression 			{ $$ = $1 % $3; }
| '(' expression ')' 					{ $$ = $2; }
;
%%

void yyerror (char *err) {
	printf(RED "Error found near line %d: %s\n" RESET, yylineno, err);
}

int main (int argc, char *argv[]) {
	char * point = strrchr(argv[1], '.');
	yyin = fopen(argv[1], "r");

	if (yyin == NULL) {
		printf(RED "\nError reading file...\n\n" RESET);
	} else if (strcmp(point, ".phab") == 0) {
		yyparse();
	} else {
		printf(RED "\nOnly .phab extension allowed...\n\n" RESET);
	}
	fclose(yyin);
	return 0;
}
