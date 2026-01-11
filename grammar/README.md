# Reflectology DSL Grammar

This directory contains the formal grammar specification for the Reflectology Domain-Specific Language (DSL).

## Files

- **`reflectology-dsl.ebnf`** - Corrected EBNF grammar specification
- **Grammar status:** Syntax errors fixed, semantic refinement still needed

## Quick Reference

### What is This DSL?

The Reflectology DSL is an experimental language that attempts to unify:
1. The 40 axioms of Reflectology (formal logic system)
2. Set-theoretic foundations from set.mm (Metamath)
3. Modern programming concepts (types, functions, I/O)

### Key Features

- **Set-theoretic types**: Types defined as sets with comprehensions
- **Functional programming**: Lambda expressions, higher-order functions
- **Monadic I/O**: Haskell-inspired state monads with do-notation
- **Formal logic**: Quantifiers, implications, predicates
- **Mathematical notation**: Integration with Metamath symbols

## Grammar Overview

### Expression Hierarchy

```
formula (logical)
  → disjunction (or)
    → conjunction (and)
      → negation (not)
        → atom (relation/predicate)

expr (arithmetic)
  → term
    → factor
      → postfix
        → primary
```

### Major Non-terminals

- **`document`** - Top-level program
- **`statement`** - Assignments, equations, declarations
- **`type_decl`** - Type definitions as sets
- **`func_decl`** - Function declarations
- **`io_decl`** - I/O operations (monadic)
- **`formula`** - Logical expressions
- **`expr`** - Arithmetic expressions
- **`primary`** - Base expressions

## Examples

See the `../examples/` directory for sample programs:

1. **`01-basic-axioms.refl`** - Basic axiom usage, set operations
2. **`02-io-monads.refl`** - Monadic I/O examples
3. **`03-type-system.refl`** - Type system features

## Critical Issues (See Review Document)

⚠️ **This grammar is NOT production-ready**

The comprehensive review (`REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md`) identifies:

1. **Fixed Issues** (in corrected version):
   - Inequality operators (was `""` empty strings, now `<`, `<=`, etc.)
   - Implication operator (was `=`, now `=>`)
   - Duplicate productions removed
   - Missing terminals added
   - Operator precedence clarified

2. **Remaining Issues**:
   - Ambiguities (tuple vs. parenthesized expr)
   - Integration with Metamath unclear
   - Missing features (imports, better error handling)
   - Verbose syntax

## Usage

### Parsing Tools

This grammar can be parsed with:

- **PEG parsers** (recommended): Parsing Expression Grammar tools
- **ANTLR**: Requires disambiguation rules
- **Yacc/Bison**: Needs shift-reduce conflict resolution

### Example: Simple Program

```refl
// Define natural numbers type
type Nat = set({n | n in 0. or exists m in Nat : n = succ(m)})

// Define factorial function
function factorial(n: Nat) : Nat =
  (n = 0) => 1 | (n * factorial(n - 1))

// Use the function
result = factorial(5)
```

## Relation to Metamath

The grammar claims to use "set.mm translations" but the mapping is incomplete:

| DSL Construct | set.mm Theorem | Status |
|---------------|----------------|--------|
| `set({x \| P(x)})` | `df-rab` | ✓ Defined |
| `type -> type` | `df-map` | ✓ Defined |
| `power(A)` | `df-pw` | ✓ Defined |
| `union(A, B)` | `df-iun` | ✓ Defined |
| `async/memory` | N/A | ✗ No mapping |
| `io` operations | N/A | ✗ No mapping |

## Future Work

1. **Parser implementation** - Build reference parser in Python/Rust
2. **Type checker** - Implement set-theoretic type checking
3. **Metamath translator** - Generate .mm proofs from DSL code
4. **Standard library** - Common functions and types
5. **Tooling** - LSP server, syntax highlighting, formatter

## Getting Help

- Read the **comprehensive review**: `../REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md`
- Check **example programs**: `../examples/*.refl`
- Review **Metamath files**: `../Principia Reflectologia/*.mm`

## Rating

**Overall Grammar Score: 4.5/10** (see review document for details)

- Interesting concepts
- Multiple syntax errors (fixed in corrected version)
- Incomplete integration with Metamath
- Not production-ready without significant work

## Contributing

If improving this grammar:

1. Fix remaining ambiguities
2. Implement parser prototype
3. Document Metamath translation formally
4. Add comprehensive test suite
5. Simplify verbose syntax

---

*Grammar Status: EXPERIMENTAL - Not recommended for production use*
