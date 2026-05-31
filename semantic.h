/* semantic.h - Person 3: Symbol Table + TAC Generation */
#ifndef SEMANTIC_H
#define SEMANTIC_H

#include "parser.h"

/* ---- Symbol Table ---- */
typedef struct {
    char name[64];
    int  declared;   /* 1 = declared via 'int' */
    int  value;      /* last assigned value (for constant folding, optional) */
} Symbol;

typedef struct {
    Symbol *entries;
    int     count;
    int     cap;
} SymbolTable;

/* ---- Three-Address Code (TAC) ---- */
typedef struct {
    char result[64];
    char arg1[64];
    char op[8];       /* "+", "-", "*", "/", "=", "print", "" */
    char arg2[64];
} TAC;

typedef struct {
    TAC *instructions;
    int  count;
    int  cap;
} TACList;

/* Run semantic phase: fill symbol table + emit TAC from AST.
   Prints both on stdout. */
void semantic_run(ASTNode *ast);

#endif /* SEMANTIC_H */
