%{
#include <stdio.h>
#include <stdlib.h>

FILE *tokenFile;
%}

%option noyywrap

LETTER      [a-zA-Z_]
DIGIT       [0-9]

ID          {LETTER}({LETTER}|{DIGIT})*
INTNUM      {DIGIT}+
FLOATNUM    {DIGIT}+"."{DIGIT}+

%%

"begin"        { fprintf(tokenFile, "KEYWORD\tbegin\n"); }
"end"          { fprintf(tokenFile, "KEYWORD\tend\n"); }

"int"          { fprintf(tokenFile, "KEYWORD\tint\n"); }
"float"        { fprintf(tokenFile, "KEYWORD\tfloat\n"); }
"char"         { fprintf(tokenFile, "KEYWORD\tchar\n"); }
"string"       { fprintf(tokenFile, "KEYWORD\tstring\n"); }

"if"           { fprintf(tokenFile, "KEYWORD\tif\n"); }
"else"         { fprintf(tokenFile, "KEYWORD\telse\n"); }

"input"        { fprintf(tokenFile, "KEYWORD\tinput\n"); }
"print"        { fprintf(tokenFile, "KEYWORD\tprint\n"); }

">="           { fprintf(tokenFile, "RELOP\t>=\n"); }
"<="           { fprintf(tokenFile, "RELOP\t<=\n"); }
"=="           { fprintf(tokenFile, "RELOP\t==\n"); }
">"            { fprintf(tokenFile, "RELOP\t>\n"); }
"<"            { fprintf(tokenFile, "RELOP\t<\n"); }

"="            { fprintf(tokenFile, "ASSIGN\t=\n"); }

"+"            { fprintf(tokenFile, "ARITH_OP\t+\n"); }
"-"            { fprintf(tokenFile, "ARITH_OP\t-\n"); }
"*"            { fprintf(tokenFile, "ARITH_OP\t*\n"); }
"/"            { fprintf(tokenFile, "ARITH_OP\t/\n"); }

";"            { fprintf(tokenFile, "SEMICOLON\t;\n"); }
","            { fprintf(tokenFile, "COMMA\t,\n"); }

"("            { fprintf(tokenFile, "LPAREN\t(\n"); }
")"            { fprintf(tokenFile, "RPAREN\t)\n"); }

{FLOATNUM}     { fprintf(tokenFile, "FLOAT\t%s\n", yytext); }

{INTNUM}       { fprintf(tokenFile, "INTEGER\t%s\n", yytext); }

{ID}           { fprintf(tokenFile, "IDENTIFIER\t%s\n", yytext); }

\'[A-Za-z]\'   { fprintf(tokenFile, "CHAR_LITERAL\t%s\n", yytext); }

[ \t\n]+       ;

.              { fprintf(tokenFile, "UNKNOWN\t%s\n", yytext); }

%%

int main()
{
    FILE *inputFile;

    inputFile = fopen("sample_input/quiz_program.txt", "r");

    if(inputFile == NULL)
    {
        printf("Cannot open input file.\n");
        return 1;
    }

    yyin = inputFile;

    tokenFile = fopen("outputs/tokens.txt", "w");

    if(tokenFile == NULL)
    {
        printf("Cannot create tokens file.\n");
        return 1;
    }

    yylex();

    printf("Lexical Analysis Completed.\n");
    printf("Tokens saved in outputs/tokens.txt\n");

    fclose(inputFile);
    fclose(tokenFile);

    return 0;
}
