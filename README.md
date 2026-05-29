# QuizScore Mini Compiler

## Compiler Construction Lab Project

This project is a Mini Compiler developed for the Compiler Construction Lab.
The compiler is designed for a small custom language based on a Quiz Score Calculation system.

The project demonstrates the major phases of a compiler including:

* Lexical Analysis
* Syntax Analysis
* Semantic Analysis
* Symbol Table Construction
* Three Address Code (TAC) Generation

---

# Project Objective

The objective of this project is to build a simple compiler that can process a small input program written in a custom C-like language and generate intermediate outputs through different compiler phases.

The selected input program calculates:

* Quiz Total
* Average
* Percentage
* Student Grade

using conditional statements and arithmetic expressions.

---

# Technologies Used

* C Language
* Flex (Lexical Analysis)
* Bison (Syntax Analysis)
* GCC Compiler
* Ubuntu / WSL

---

# Project Modules

## Lexical Analysis

Implemented using Flex for tokenization of:

* Keywords
* Identifiers
* Operators
* Constants
* Delimiters

## Syntax Analysis

Implemented using Bison for parsing grammar rules and validating syntax.

## Semantic Analysis

Checks declarations and manages symbol table entries.

## TAC Generation

Generates Three Address Code for arithmetic expressions and conditional statements.

---

# Project Structure

```bash
cc_project/
│
├── lexer/
│   └── lexer.l
│
├── parser/
│
├── symbol_table/
│
├── tac/
│
├── sample_input/
│   └── quiz_program.txt
│
├── reference_program/
│   └── quiz.c
│
├── outputs/
│   ├── tokens.txt
│   ├── symbol_table.txt
│   └── tac.txt
│
└── screenshots/
```

---

# Sample Input Program

The compiler processes a Quiz Score Calculation program written in a simplified custom language.

Features used:

* Variable declarations
* Arithmetic expressions
* If-else conditions
* Input/Output statements

---

# Team Responsibilities

## Member 1

* Lexical Analysis
* GitHub Integration and Merging
* Project Testing

## Member 2

* Syntax Analysis
* CFG and Parsing Tables
* Syntax Documentation

## Member 3

* Symbol Table
* Semantic Analysis
* TAC Generation
* Intermediate Code Documentation

---

# How to Run

## Generate Lexer

```bash
flex lexer.l
```

## Compile

```bash
gcc lex.yy.c -o lexer
```

## Run

```bash
./lexer
```
## Checking Outputs
cat outputs/tokens.txt 

# Expected Outputs

The compiler generates:

* tokens.txt
* symbol_table.txt
* tac.txt

inside the outputs folder.

---

# Status

Project currently under development.

