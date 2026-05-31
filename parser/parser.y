%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yylineno;
extern FILE *yyin;
extern FILE *tokenFile;
void yyerror(const char *s);
%}

/* =========================================================================
   1. TOKEN DECLARATIONS 
   ========================================================================= */
%token BEGIN_KEYWORD END_KEYWORD STRING_KEYWORD INT_KEYWORD FLOAT_KEYWORD CHAR_KEYWORD
%token INPUT_KEYWORD IF_KEYWORD ELSE_KEYWORD PRINT_KEYWORD
%token IDENTIFIER INTEGER FLOAT_LITERAL CHAR_LITERAL
%token SEMICOLON COMMA LPAREN RPAREN ASSIGN ARITH_OP RELOP

/* Precedence rules to resolve the classic dangling-else shift/reduce warning. */
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
    ;

term:
    IDENTIFIER
    | INTEGER
    | FLOAT_LITERAL
    | CHAR_LITERAL
    | LPAREN expression RPAREN
    ;

/* If-Else Ladder Logic */
if_else_statement:
    IF_KEYWORD LPAREN condition RPAREN statement else_part
    ;

else_part:
    ELSE_KEYWORD statement          /* Handles both final 'else' and chained 'else if' */
    | /* empty */ %prec LOWER_THAN_ELSE
    ;

condition:
    expression RELOP expression
    ;

%%
/* =========================================================================
   3. C ROUTINES (Error Handling)
   ========================================================================= */

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s at line %d\n", s, yylineno);
}

int main() {
    int result;
    FILE *inputFile = fopen("sample_input/quiz_program.txt", "r");

    if (inputFile == NULL) {
        printf("Cannot open input file.\n");
        return 1;
    }

    yyin = inputFile;
    tokenFile = fopen("outputs/tokens.txt", "w");

    if (tokenFile == NULL) {
        printf("Cannot create tokens file.\n");
        fclose(inputFile);
        return 1;
    }

    result = yyparse();

    fclose(inputFile);
    fclose(tokenFile);

    if (result == 0) {
        printf("Tokens saved in outputs/tokens.txt\n");
    }

    return result;
}
