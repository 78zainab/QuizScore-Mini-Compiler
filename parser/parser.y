%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
void yyerror(const char *s);
%}

/* =========================================================================
   1. TOKEN DECLARATIONS (Matches Person 1's Lexer)
   ========================================================================= */
%token BEGIN_KEYWORD END_KEYWORD STRING_KEYWORD INT_KEYWORD FLOAT_KEYWORD CHAR_KEYWORD
%token INPUT_KEYWORD IF_KEYWORD ELSE_KEYWORD PRINT_KEYWORD
%token IDENTIFIER INTEGER CHAR_LITERAL
%token SEMICOLON COMMA LPAREN RPAREN ASSIGN ARITH_OP RELOP

/* Precedence rules to completely resolve the classic Dangling-Else Shift/Reduce Warning */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE_KEYWORD

%%
/* =========================================================================
   2. CONTEXT-FREE GRAMMAR (CFG) RULES
   ========================================================================= */

program:
    BEGIN_KEYWORD block END_KEYWORD { printf("Parsing completed successfully! Clean syntax.\n"); }
    ;

block:
    declaration_list statement_list
    ;

/* Variable Declarations */
declaration_list:
    declaration declaration_list
    | /* empty */
    ;

declaration:
    type id_list SEMICOLON
    ;

type:
    STRING_KEYWORD
    | INT_KEYWORD
    | FLOAT_KEYWORD
    | CHAR_KEYWORD
    ;

id_list:
    IDENTIFIER
    | IDENTIFIER COMMA id_list
    ;

/* Program Execution Statements */
statement_list:
    statement statement_list
    | /* empty */
    ;

statement:
    input_statement
    | print_statement
    | assignment_statement
    | if_else_statement
    ;

input_statement:
    INPUT_KEYWORD LPAREN IDENTIFIER RPAREN SEMICOLON
    ;

print_statement:
    PRINT_KEYWORD LPAREN IDENTIFIER RPAREN SEMICOLON
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression SEMICOLON
    ;

expression:
    term
    | expression ARITH_OP term
    | LPAREN expression RPAREN
    ;

term:
    IDENTIFIER
    | INTEGER
    | CHAR_LITERAL
    ;

/* If-Else Ladder Logic (Fixed & Unambiguous with Precedence) */
if_else_statement:
    IF_KEYWORD LPAREN condition RPAREN statement else_part %prec LOWER_THAN_ELSE
    ;

else_part:
    ELSE_KEYWORD statement          /* Handles both final 'else' and chained 'else if' */
    | /* empty */                   /* Handles standalone 'if' */
    ;

condition:
    IDENTIFIER RELOP INTEGER
    ;

%%
/* =========================================================================
   3. C ROUTINES (Error Handling)
   ========================================================================= */

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s at line %d\n", s, yylineno);
}

int main() {
    return yyparse();
}