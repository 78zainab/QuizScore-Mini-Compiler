/* semantic.c - Person 3: Symbol Table + TAC Generation
   Walks the AST:
     1. Builds a symbol table (declaration/use checking)
     2. Emits Three-Address Code (TAC)
*/

#include "semantic.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* -------- Symbol Table helpers -------- */

static void sym_init(SymbolTable *st) {
    st->cap     = 16;
    st->count   = 0;
    st->entries = malloc(st->cap * sizeof(Symbol));
}

static Symbol *sym_lookup(SymbolTable *st, const char *name) {
    for (int i = 0; i < st->count; i++)
        if (strcmp(st->entries[i].name, name) == 0)
            return &st->entries[i];
    return NULL;
}

static Symbol *sym_declare(SymbolTable *st, const char *name) {
    if (sym_lookup(st, name)) {
        fprintf(stderr, "[Semantic] Warning: re-declaration of '%s'\n", name);
        return sym_lookup(st, name);
    }
    if (st->count == st->cap) {
        st->cap *= 2;
        st->entries = realloc(st->entries, st->cap * sizeof(Symbol));
    }
    Symbol *s = &st->entries[st->count++];
    strncpy(s->name, name, 63);
    s->declared = 1;
    s->value    = 0;
    return s;
}

static void sym_print(SymbolTable *st) {
    printf("\n===== SYMBOL TABLE =====\n");
    printf("%-16s  %s\n", "Name", "Status");
    printf("%-16s  %s\n", "----", "------");
    for (int i = 0; i < st->count; i++)
        printf("%-16s  declared\n", st->entries[i].name);
    printf("========================\n");
}

/* -------- TAC helpers -------- */

static void tac_init(TACList *tl) {
    tl->cap          = 32;
    tl->count        = 0;
    tl->instructions = malloc(tl->cap * sizeof(TAC));
}

static int temp_counter = 0;

static void new_temp(char *buf) {
    sprintf(buf, "t%d", temp_counter++);
}

static void tac_emit(TACList *tl,
                     const char *result, const char *arg1,
                     const char *op,     const char *arg2) {
    if (tl->count == tl->cap) {
        tl->cap *= 2;
        tl->instructions = realloc(tl->instructions,
                                   tl->cap * sizeof(TAC));
    }
    TAC *i = &tl->instructions[tl->count++];
    strncpy(i->result, result ? result : "", 63);
    strncpy(i->arg1,   arg1   ? arg1   : "", 63);
    strncpy(i->op,     op     ? op     : "", 7);
    strncpy(i->arg2,   arg2   ? arg2   : "", 63);
}

static void tac_print(TACList *tl) {
    printf("\n===== THREE-ADDRESS CODE =====\n");
    for (int i = 0; i < tl->count; i++) {
        TAC *t = &tl->instructions[i];
        if (strcmp(t->op, "print") == 0) {
            printf("  print %s\n", t->arg1);
        } else if (strcmp(t->op, "=") == 0 && strlen(t->arg2) == 0) {
            printf("  %s = %s\n", t->result, t->arg1);
        } else {
            printf("  %s = %s %s %s\n",
                   t->result, t->arg1, t->op, t->arg2);
        }
    }
    printf("==============================\n");
}

/* -------- AST traversal -------- */

/* Generate TAC for an expression node; store result name in *out */
static void gen_expr(ASTNode *node, TACList *tl, SymbolTable *st, char *out) {
    if (node->type == NODE_NUM) {
        strcpy(out, node->value);
        return;
    }
    if (node->type == NODE_ID) {
        if (!sym_lookup(st, node->value)) {
            fprintf(stderr, "[Semantic] Error: undeclared variable '%s'\n",
                    node->value);
            exit(1);
        }
        strcpy(out, node->value);
        return;
    }
    if (node->type == NODE_BINOP) {
        char left[64], right[64];
        gen_expr(node->left,  tl, st, left);
        gen_expr(node->right, tl, st, right);
        new_temp(out);
        tac_emit(tl, out, left, node->value, right);
        return;
    }
    fprintf(stderr, "[Semantic] Unexpected node in expression\n");
    exit(1);
}

static void gen_stmt(ASTNode *node, TACList *tl, SymbolTable *st) {
    switch (node->type) {

        case NODE_DECL:
            sym_declare(st, node->value);
            break;

        case NODE_ASSIGN: {
            if (!sym_lookup(st, node->value)) {
                fprintf(stderr, "[Semantic] Error: assigning to undeclared '%s'\n",
                        node->value);
                exit(1);
            }
            char rhs[64];
            gen_expr(node->right, tl, st, rhs);
            tac_emit(tl, node->value, rhs, "=", "");
            break;
        }

        case NODE_PRINT:
            if (!sym_lookup(st, node->value)) {
                fprintf(stderr, "[Semantic] Error: printing undeclared '%s'\n",
                        node->value);
                exit(1);
            }
            tac_emit(tl, "", node->value, "print", "");
            break;

        default:
            fprintf(stderr, "[Semantic] Unknown statement type\n");
            exit(1);
    }
}

/* -------- public API -------- */

void semantic_run(ASTNode *ast) {
    SymbolTable st;
    TACList     tl;
    sym_init(&st);
    tac_init(&tl);

    /* Walk top-level statements */
    for (int i = 0; i < ast->child_count; i++)
        gen_stmt(ast->children[i], &tl, &st);

    sym_print(&st);
    tac_print(&tl);

    printf("\n[Semantic] Phase complete: %d symbols, %d TAC instructions\n",
           st.count, tl.count);

    free(st.entries);
    free(tl.instructions);
}
