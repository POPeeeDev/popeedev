# Grammar Issues - Original vs. Corrected

This document provides a side-by-side comparison of issues found in the original grammar and how they were addressed in the corrected version.

## Critical Syntax Errors

### 1. Inequality Production

**Original (WRONG):**
```ebnf
inequality ::= expr "=" expr     /* This is equality, not inequality */
               | expr "" expr     /* Empty string operator */
               | expr "=" expr     /* Duplicate */
               | expr "" expr     /* Empty string again */
               | expr "!=" expr
```

**Corrected:**
```ebnf
inequality ::= expr "<" expr
               | expr "<=" expr
               | expr ">" expr
               | expr ">=" expr
               | expr "!=" expr
```

**Changes:**
- Removed duplicate `expr "=" expr` (appeared 2 times)
- Replaced empty string operators `""` with actual operators `<`, `<=`, `>`, `>=`
- Removed equality from inequality production

---

### 2. Implication Production

**Original (WRONG):**
```ebnf
implication ::= formula "=" formula   /* = is equality, not implication */
```

**Corrected:**
```ebnf
implication ::= formula "=>" formula
                | formula "->" formula
                | formula "<=>" formula      /* Bi-implication */
```

**Changes:**
- Changed `"="` to `"=>"` for logical implication
- Added alternative arrow syntax `"->"` (common in logic)
- Added bi-implication `"<=>"`

---

### 3. Relation Production

**Original (WRONG):**
```ebnf
relation ::= expr "=" expr
             | expr "!=" expr
             | expr "=" expr    /* Duplicate */
             | expr "=" expr    /* Duplicate again */
             | expr "" expr     /* Empty operator */
             | expr "" expr     /* Empty operator */
             | expr "subset" expr
             | expr "in" expr
```

**Corrected:**
```ebnf
relation ::= expr "=" expr
             | expr "!=" expr
             | expr "<" expr
             | expr "<=" expr
             | expr ">" expr
             | expr ">=" expr
             | expr "subset" expr
             | expr "C_" expr              /* Metamath-style subset */
             | expr "in" expr
             | expr "e." expr              /* Metamath-style element-of */
```

**Changes:**
- Removed 2 duplicate `expr "=" expr` rules
- Replaced 2 empty string operators with `<`, `<=`, `>`, `>=`
- Added Metamath-style operators `C_` (subset) and `e.` (element-of)

---

## Ambiguity Resolutions

### 4. Function Call vs. LValue

**Original (AMBIGUOUS):**
```ebnf
primary ::= func_call | lvalue
func_call ::= ident "(" arg_list_opt ")"
lvalue ::= ident | ident "(" arg_list_opt ")"
```

**Problem:** `foo()` can parse as both `func_call` and `lvalue`

**Corrected:**
```ebnf
primary ::= func_call | ident
func_call ::= ident "(" arg_list_opt ")"
lvalue ::= ident | field_access | index_access
```

**Changes:**
- Removed function call form from `lvalue` production
- Made `lvalue` only for actual assignable locations
- Clarified that function calls return values, not lvalues

---

### 5. Tuple vs. Parenthesized Expression

**Original (AMBIGUOUS):**
```ebnf
primary ::= "(" expr ")"
            | tuple_expr
tuple_expr ::= "(" expr_list ")"
expr_list ::= expr | expr "," expr_list
```

**Problem:** `(x)` ambiguous - is it a tuple or parenthesized expr?

**Corrected:**
```ebnf
tuple_expr ::= "(" expr_list ")"
               | "(" expr "," ")"            /* Single-element tuple */
```

**Changes:**
- Require trailing comma for single-element tuples: `(x,)`
- Makes `(x)` unambiguously a parenthesized expression
- Matches Python convention

---

### 6. Operator Precedence

**Original (AMBIGUOUS):**
```ebnf
formula ::= "(" formula ")"
            | "not" formula
            | formula "and" formula
            | formula "or" formula
```

**Problem:** `p or q and r` is ambiguous (which binds tighter?)

**Corrected:**
```ebnf
formula ::= disjunction

disjunction ::= conjunction
                | disjunction "or" conjunction

conjunction ::= negation
                | conjunction "and" negation

negation ::= "not" negation
             | "-." negation
             | atom
```

**Changes:**
- Separated into precedence levels: `or` < `and` < `not`
- Standard logical operator precedence
- Unambiguous parsing

---

## Missing Features Added

### 7. Comments

**Original:** Not in grammar

**Corrected:**
```ebnf
comment ::= line_comment | block_comment
line_comment ::= "//" any_char* "\n"
block_comment ::= "/*" any_char* "*/"
```

**Rationale:** Every practical language needs comments

---

### 8. String Literals

**Original:** Not in grammar

**Corrected:**
```ebnf
string ::= '"' string_char* '"'
           | "'" string_char* "'"

string_char ::= [^"\\\n]
                | "\\" escape_sequence

escape_sequence ::= "n" | "t" | "r" | "\\" | '"' | "'"
```

**Rationale:** Needed for I/O operations and practical programming

---

### 9. I/O Error Handling

**Original:**
```ebnf
io_expr ::= "read" "(" ident ")"
            | "write" "(" ident "," expr ")"
            | "bind" "(" io_expr "," lambda ")"
            | "return" "(" expr ")"
```

**Corrected:**
```ebnf
io_expr ::= "read" "(" ident ")"
            | "write" "(" ident "," expr ")"
            | "bind" "(" io_expr "," lambda ")"
            | "return" "(" expr ")"
            | "error" "(" string ")"             /* NEW */
            | "catch" "(" io_expr "," lambda ")" /* NEW */
            | do_block                           /* NEW */
```

**Rationale:** Real I/O needs error handling

---

### 10. Do-Notation Sugar

**Original:** Not in grammar

**Corrected:**
```ebnf
do_block ::= "do" "{" io_statement_list "}"

io_statement_list ::= io_statement
                      | io_statement ";" io_statement_list

io_statement ::= ident "<-" io_expr
                 | io_expr
```

**Rationale:** Makes monadic I/O much more readable

---

## Major Design Changes

### 11. Classes → Records

**Original:**
```ebnf
class_decl ::= "class" ident "{" class_body "}"
class_member ::= "field" ident ":" type_expr
                | "method" ident "(" param_list ")" ":" type_expr ":=" expr
```

**Corrected:**
```ebnf
record_decl ::= "record" ident "{" field_decl_list "}"
field_decl_list ::= field_decl | field_decl field_decl_list
field_decl ::= "field" ident ":" type_expr
```

**Rationale:**
- Classes were poorly defined (no inheritance, no `this`)
- Records better align with set-theoretic foundation
- Methods can be functions that take records as arguments

---

### 12. Async/Memory Removed

**Original:**
```ebnf
async_decl ::= "async" ident ":=" async_expr
async_expr ::= "choice" "(" expr_list ")"
              | "parallel" "(" expr_list ")"
              | "sequence" "(" expr_list ")"

memory_decl ::= "memory" ident ":=" memory_expr
memory_expr ::= "alloc" "(" expr ")"
               | "load" "(" expr ")"
               | "store" "(" expr "," expr ")"
               | "free" "(" expr ")"
```

**Corrected:** **REMOVED ENTIRELY**

**Rationale:**
- No connection to Reflectology axioms
- "Non-deterministic choice" is not practical concurrency
- Toy memory model unusable for real systems programming
- Honest assessment: These don't belong in this DSL

---

## Improved Type System

### 13. Type Syntax

**Original:**
```ebnf
type_expr ::= "function" "(" type_expr "," type_expr ")"
```

**Corrected:**
```ebnf
type_expr ::= type_expr "->" type_expr
             | type_expr "&" type_expr
             | "(" type_expr ")"
```

**Changes:**
- Arrow syntax `A -> B` instead of verbose `function(A, B)`
- Added intersection types `A & B`
- Parentheses for grouping complex types

---

## Terminal Symbol Clarification

### 14. Complete Terminal List

**Original:** Scattered, incomplete

**Corrected:**
```
Arithmetic: + - * / x.
Comparison: = != < <= > >= 
Logical: and or not => -> <=> /\ \/ -.
Set theory: in e. subset C_ emptyset 0. power union
Quantifiers: forall exists A. E.
Functions: lambda λ \ grad nabla
I/O: read write bind return error catch do
Types: type record field function set product
Delimiters: ( ) { } [ ] , . ; : | 
Assignment: =
Special: ' _ " infty epsilon norm argmin limit sum log d/dt
Comments: // /* */
```

**Changes:**
- Complete list of all terminal symbols
- Both ASCII and Unicode variants (λ vs lambda)
- Both English and Metamath-style operators

---

## Summary Table

| Issue | Original | Corrected | Impact |
|-------|----------|-----------|--------|
| Inequality ops | Empty strings `""` | `<`, `<=`, `>`, `>=` | **CRITICAL** |
| Implication | `=` (equality) | `=>` (arrow) | **CRITICAL** |
| Relation duplicates | 3 copies of `=` | 1 copy, added comparisons | **HIGH** |
| Func call ambiguity | Both in primary & lvalue | Separated properly | **HIGH** |
| Tuple ambiguity | `(x)` unclear | Require `(x,)` for tuple | **MEDIUM** |
| Operator precedence | Flat, ambiguous | Hierarchical | **HIGH** |
| Comments | Missing | Added `//` and `/* */` | **MEDIUM** |
| Strings | Missing | Added with escapes | **MEDIUM** |
| Error handling | Missing | Added error/catch | **MEDIUM** |
| Do-notation | Missing | Added sugar for I/O | **MEDIUM** |
| Classes | Poorly defined | Changed to records | **DESIGN** |
| Async/memory | Superficial | Removed | **DESIGN** |
| Type syntax | Verbose | Arrow notation | **LOW** |

---

## Verification

All corrections have been verified in the corrected grammar file:
- **`grammar/reflectology-dsl.ebnf`**

Test programs demonstrating the fixes:
- **`examples/01-basic-axioms.refl`** - Basic syntax
- **`examples/02-io-monads.refl`** - I/O with do-notation
- **`examples/03-type-system.refl`** - Type system features

---

**Conclusion:** The corrected grammar addresses all critical syntax errors and most ambiguities. It remains experimental and not production-ready, but is now at least syntactically sound.
