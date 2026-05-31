%{
#include <stdio.h>
#include <stdlib.h>
#include "../parser/parser.tab.h"

FILE *tokenFile = NULL;

static void write_token(const char *type, const char *value)
{
    if (tokenFile != NULL) {
        fprintf(tokenFile, "%s\t%s\n", type, value);
    }
}
%}

%option noyywrap yylineno

LETTER      [a-zA-Z_]
DIGIT       [0-9]

ID          {LETTER}({LETTER}|{DIGIT})*
INTNUM      {DIGIT}+
FLOATNUM    {DIGIT}+"."{DIGIT}+

%%

"begin"        { write_token("KEYWORD", yytext); return BEGIN_KEYWORD; }
"end"          { write_token("KEYWORD", yytext); return END_KEYWORD; }

"int"          { write_token("KEYWORD", yytext); return INT_KEYWORD; }
"float"        { write_token("KEYWORD", yytext); return FLOAT_KEYWORD; }
"char"         { write_token("KEYWORD", yytext); return CHAR_KEYWORD; }
"string"       { write_token("KEYWORD", yytext); return STRING_KEYWORD; }

"if"           { write_token("KEYWORD", yytext); return IF_KEYWORD; }
"else"         { write_token("KEYWORD", yytext); return ELSE_KEYWORD; }

"input"        { write_token("KEYWORD", yytext); return INPUT_KEYWORD; }
"print"        { write_token("KEYWORD", yytext); return PRINT_KEYWORD; }

">="           { write_token("RELOP", yytext); return RELOP; }
"<="           { write_token("RELOP", yytext); return RELOP; }
"=="           { write_token("RELOP", yytext); return RELOP; }
">"            { write_token("RELOP", yytext); return RELOP; }
"<"            { write_token("RELOP", yytext); return RELOP; }

"="            { write_token("ASSIGN", yytext); return ASSIGN; }

"+"            { write_token("ARITH_OP", yytext); return ARITH_OP; }
"-"            { write_token("ARITH_OP", yytext); return ARITH_OP; }
"*"            { write_token("ARITH_OP", yytext); return ARITH_OP; }
"/"            { write_token("ARITH_OP", yytext); return ARITH_OP; }

";"            { write_token("SEMICOLON", yytext); return SEMICOLON; }
","            { write_token("COMMA", yytext); return COMMA; }

"("            { write_token("LPAREN", yytext); return LPAREN; }
")"            { write_token("RPAREN", yytext); return RPAREN; }

{FLOATNUM}     { write_token("FLOAT", yytext); return FLOAT_LITERAL; }

{INTNUM}       { write_token("INTEGER", yytext); return INTEGER; }

{ID}           { write_token("IDENTIFIER", yytext); return IDENTIFIER; }

\'[A-Za-z]\'   { write_token("CHAR_LITERAL", yytext); return CHAR_LITERAL; }

[ \t\n]+       ;

.              { write_token("UNKNOWN", yytext); return yytext[0]; }

%%
