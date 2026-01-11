# Grammar Test Cases

This document contains test cases for validating the Reflectology DSL grammar.

## Positive Test Cases (Should Parse)

### 1. Basic Arithmetic
```refl
x = 1 + 2 * 3
y = (4 - 5) / 6
```

### 2. Inequalities
```refl
a < b
c <= d
e > f
g >= h
i != j
```

### 3. Logical Formulas
```refl
p and q
r or s
not t
p => q
p <=> q
```

### 4. Quantifiers
```refl
forall x : x > 0
exists y in Natural : y = 5
A. x : x in Natural
E. y : y > x
```

### 5. Set Comprehensions
```refl
Evens = {n | n in Natural and exists k : n = 2 * k}
Positives = {x in Integer | x > 0}
```

### 6. Type Declarations
```refl
type Natural = set({n | n in 0. or exists m in Natural : n = succ(m)})
type IntToInt = Natural -> Natural
type Pair = Natural & Natural
```

### 7. Function Declarations
```refl
function add(x: Natural, y: Natural) : Natural = x + y
function factorial(n: Natural) : Natural = (n = 0) => 1 | (n * factorial(n - 1))
```

### 8. Lambda Expressions
```refl
double = lambda x . x * 2
identity = λ x . x
square = \x . x * x
```

### 9. Records
```refl
record Point {
  field x : Natural
  field y : Natural
}

origin = {x: 0, y: 0}
```

### 10. I/O Operations
```refl
io simple = read("file")
io chained = bind(read("in"), lambda c . write("out", c))
io withDo = do {
  x <- read("file");
  write("output", x);
  return(x)
}
```

### 11. Tuples
```refl
pair = (1, 2)
single = (3,)
triple = (4, 5, 6)
```

### 12. Comments
```refl
// This is a line comment
x = 1  // Comment after code

/* This is a 
   block comment */
y = 2
```

### 13. Chain Equality
```refl
a = b = c = 5
```

### 14. Postfix Operators
```refl
x'
y*
z_i
w_123
```

### 15. Complex Expressions
```refl
result = argmin(x in Natural, x * x - 5 * x + 6)
lim = limit(n -> infty, 1 / n)
total = sum(i in {1,2,3,4,5} : i * i)
```

---

## Negative Test Cases (Should NOT Parse)

### 1. Malformed Inequality (Original Grammar Bug)
```refl
x  y     /* Empty operator - fixed in corrected grammar */
```

### 2. Wrong Implication
```refl
p = q    /* Using = for implication - should use => */
```

### 3. Unclosed String
```refl
x = "hello
```

### 4. Missing Type in Function
```refl
function bad(x) = x + 1    /* Missing type annotations */
```

### 5. Invalid Token
```refl
x @ y    /* @ not defined */
```

### 6. Mismatched Parens
```refl
x = (1 + 2
```

### 7. Invalid Do-Block
```refl
io bad = do {
  read("file")    /* Missing <- binding */
  write("out", x)
```

---

## Ambiguity Test Cases

### 1. Tuple vs Parentheses
```refl
expr1 = (x)      /* Parenthesized expression */
expr2 = (x,)     /* Single-element tuple */
expr3 = (x, y)   /* Two-element tuple */
```

**Resolution:** Trailing comma required for single-element tuples.

### 2. Operator Precedence
```refl
formula1 = p or q and r    /* Parses as: p or (q and r) */
formula2 = (p or q) and r  /* Explicit grouping */
```

**Resolution:** `and` binds tighter than `or`.

### 3. Function Call vs Assignment
```refl
f(x)        /* Function call - expression */
f(x) = 5    /* Syntax error - can't assign to function call */
y = 5       /* Variable assignment - OK */
```

**Resolution:** Only lvalues (ident, field access, index) can be assigned.

---

## Edge Cases

### 1. Empty Constructs
```refl
empty_record = {}
empty_tuple = ()      /* Should this be allowed? Grammar doesn't specify */
```

### 2. Nested Lambdas
```refl
curry = lambda x . lambda y . x + y
```

### 3. Higher-Order Functions
```refl
function apply(f: Natural -> Natural, x: Natural) : Natural = f(x)
function compose(f: Natural -> Natural, g: Natural -> Natural) : Natural -> Natural =
  lambda x . f(g(x))
```

### 4. Complex Types
```refl
type ComplexFunc = (Natural -> Natural) -> (Natural -> Natural)
type Nested = set({f | f in (Natural -> Natural)})
```

### 5. Metamath-Style Syntax
```refl
x e. Natural        /* Element-of using Metamath syntax */
A C_ B              /* Subset using Metamath syntax */
p /\ q              /* Conjunction using Metamath syntax */
p \/ q              /* Disjunction using Metamath syntax */
-. p                /* Negation using Metamath syntax */
```

---

## Grammar Validation Checklist

- [ ] All positive test cases parse successfully
- [ ] All negative test cases fail to parse with appropriate errors
- [ ] Ambiguity test cases parse deterministically as documented
- [ ] Edge cases handled correctly
- [ ] Error messages are helpful
- [ ] No shift-reduce or reduce-reduce conflicts (if using LR parser)
- [ ] All examples in `examples/*.refl` parse correctly

---

## Parser Implementation Notes

When implementing a parser for this grammar:

1. **Use PEG (Parsing Expression Grammar)** - Recommended for this grammar
   - Handles ambiguities via ordered choice
   - No conflict resolution needed
   - Easy to implement

2. **Or use LALR(1) with disambiguation**
   - Specify precedence/associativity for operators
   - May need additional grammar refactoring

3. **Don't use LL(1)**
   - Grammar is not LL(1) due to left recursion
   - Would require significant restructuring

4. **Lexer Requirements**
   - Longest match for keywords vs identifiers
   - Handle Unicode (λ) and ASCII (\) versions
   - Comments should be ignored by lexer
   - String escape sequences processed in lexer

5. **Error Recovery**
   - Synchronize on statement boundaries (newline, semicolon)
   - Suggest corrections for common mistakes
   - Point out original grammar bugs if user writes them

---

## Integration with Metamath

To translate DSL code to Metamath proofs:

1. **Type checking** ensures all set operations are valid
2. **Code generation** produces `.mm` file with:
   - Variable declarations (`$v`)
   - Type assertions (`$f`)
   - Axiom applications (`$a`)
   - Proof steps (`$p ... $= ... $.`)

3. **Validation** using `metamath` tool

Example translation:

**DSL:**
```refl
type Nat = set({n | n in 0. or exists m in Nat : n = succ(m)})
```

**Metamath:**
```metamath
$( Define natural numbers via induction axiom $)
nat-def $a |- ( n e. Nat <-> ( n = 0. \/ E. m e. Nat n = suc m ) ) $.
```

---

## Future Enhancements

1. **Pattern matching** on types
2. **Type inference** (reduce annotations)
3. **Module system** for code organization
4. **Standard library** of common functions
5. **REPL** for interactive development
6. **LSP server** for IDE integration
7. **Formatter** for consistent style
8. **Documentation generator** from comments

---

**Status:** Test cases defined, parser implementation pending.
