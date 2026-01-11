# Principia Reflectologia - Metamath Validation

This repository contains formal Metamath proofs for the Reflectology axiom system and its relationship to ZFC set theory.

## Repository Structure

### Core Metamath Files
- **axioms.mm** - The 40 axioms of Reflectology formally stated in Metamath
- **rzfc.mm** - Proofs showing that ZFC set theory can be derived from Reflectology axioms
- **omega.mm** - Extension of set.mm with Reflectology axioms (requires external set.mm)

### Documentation
- **[CLASSICAL_LOGIC_MAPPING.md](CLASSICAL_LOGIC_MAPPING.md)** - 📖 Comprehensive analysis showing how each .mm file maps to classical logic, validation roadmap, and honest assessment of proof status
- **[REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md](REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md)** - 📖 **NEW**: Critical technical review of the proposed Reflectology DSL grammar (Rating: 4.5/10)
- **AXIOMS_MM_VALIDATION_CHECKLIST.md** - Detailed validation checklist and status report
- **METAMATH_COMPLIANCE.md** - Standards compliance documentation
- **IMPLEMENTATION_SUMMARY.md** - Implementation details and achievements
- **QUICKSTART.md** - Quick start guide for contributors

### Grammar & DSL (Experimental)
- **[grammar/reflectology-dsl.ebnf](grammar/reflectology-dsl.ebnf)** - Corrected EBNF grammar specification for Reflectology DSL
- **[grammar/README.md](grammar/README.md)** - Grammar documentation and usage guide
- **[examples/](examples/)** - Example programs in Reflectology DSL syntax

## Validation Status

[![Metamath Validation](https://github.com/POPeeeDev/popeedev/actions/workflows/metamath-validation.yml/badge.svg)](https://github.com/POPeeeDev/popeedev/actions/workflows/metamath-validation.yml)

All standalone Metamath files in this repository are validated against the official [Metamath specification](https://us.metamath.org/).

### Current Validation Results

| File | Statements | Axioms | Proofs | Status |
|------|-----------|--------|--------|--------|
| axioms.mm | 101 | 62 | 0 | ✅ Verified |
| rzfc.mm | 172 | 87 | 12 | ✅ Verified |
| omega.mm | - | - | - | ⚠️ Requires set.mm |

## Validation Tools

This repository uses the official [Metamath proof verifier](https://github.com/metamath/metamath-exe) to validate all proofs.

### Local Validation

To validate the Metamath files locally:

```bash
# Make the script executable (if not already)
chmod +x validate-metamath.sh

# Run validation
./validate-metamath.sh
```

The script will:
1. Automatically download and build the Metamath verifier if not present
2. Validate all `.mm` files in the repository
3. Report any errors or warnings
4. Provide a summary of validation results

### Manual Validation

You can also validate files manually using the Metamath executable:

```bash
# Install metamath (if not already installed)
git clone https://github.com/metamath/metamath-exe.git
cd metamath-exe
./build.sh

# Validate a file
./metamath
MM> read "path/to/file.mm"
MM> verify proof *
MM> exit
```

## Continuous Integration

This repository uses GitHub Actions to automatically validate all Metamath files on every push and pull request. The workflow:

1. Builds the Metamath verifier from source
2. Runs validation on all `.mm` files
3. Reports any errors or warnings
4. Fails the build if validation errors are found

See [.github/workflows/metamath-validation.yml](.github/workflows/metamath-validation.yml) for details.

## Metamath Standards Compliance

All files in this repository conform to the [Metamath specification](http://us.metamath.org/downloads/metamath.pdf) and follow best practices from the [set.mm project](https://github.com/metamath/set.mm):

### Syntax Requirements

- ✅ All constants declared with `$c`
- ✅ All variables declared with `$v`
- ✅ Type assignments for all variables with `$f`
- ✅ Proper axiom syntax: `label $a |- statement $.`
- ✅ Proper theorem syntax: `label $p |- statement $= proof $.`
- ✅ Proper inference rule syntax with hypotheses
- ✅ All statements end with `$.`
- ✅ Comments enclosed in `$( ... $)`

### Proof Requirements

- ✅ All proofs are complete and explicit
- ✅ Every step justified by axioms or proven theorems
- ✅ Distinct variable conditions properly maintained
- ✅ No circular dependencies
- ✅ All referenced labels exist

## References

This project is validated against standards from:

- **[metamath/set.mm](https://github.com/metamath/set.mm)** - The comprehensive Metamath database for set theory and mathematics
- **[metamath-book](https://github.com/metamath/metamath-book)** - Documentation and tutorials on Metamath
- **[Metamath Home Page](https://us.metamath.org/)** - Official Metamath website with tools and documentation

## Contributing

When contributing changes to `.mm` files:

1. Run `./validate-metamath.sh` locally before committing
2. Ensure all validations pass
3. Fix any errors or warnings reported
4. The CI will automatically validate your changes on push

## Axiom System Overview

### The 40 Axioms of Reflectology

The axioms are organized into five categories following the Reflectology framework:

1. **Configuration Space (Axioms 1-5)**: Define the fundamental structure Omega
2. **Redundancy Reduction (Axioms 6-10)**: Quotient operations and symmetry
3. **Canonical Forms (Axioms 11-14)**: Loss functions and optimal configurations
4. **Evaluate Options (Axioms 15-24)**: Convergence and goodness criteria
5. **Optimize Decision-Making (Axioms 25-40)**: Dynamical systems and optimization

### ZFC Relationship with Reflectology

The file `rzfc.mm` explores the relationship between the 40 Reflectology axioms and the 10 axioms of Zermelo-Fraenkel set theory with Choice. The file provides:

- ✅ Formal statements of all 10 ZFC axioms in Metamath syntax
- ✅ Detailed informal derivation strategies for each axiom
- ✅ Formal proofs for 2 axioms (Empty Set and a simplified Foundation)
- 📋 Roadmap for completing formal derivations of remaining 8 axioms

**Derivation Status**:
1. Extensionality ← ax-rf10 (Omega-Bijection) - 📋 Proof planned
2. Empty Set ← ax-rf1 (Initial Emptiness) - ✅ **PROVEN**
3. Pairing ← ax-rf2, ax-rf3 (Structure, Encapsulation) - 📋 Proof planned
4. Union ← ax-rf5 (Hierarchical Structuring) - 📋 Proof planned
5. Power Set ← ax-rf6 (Redundancy Reduction) - 📋 Proof planned
6. Infinity ← ax-rf15 (Reflective Convergence) - 📋 Proof planned
7. Separation ← ax-rf8 (Symmetry Breaking) - 📋 Proof planned
8. Replacement ← ax-rf39 (Internal Emergence) - 📋 Proof planned
9. Foundation ← ax-rf25 (Gradient Dynamics) - ⚠️ Simplified proof
10. Choice ← ax-rf14 (Canonical Selection) - 📋 Proof planned

For detailed analysis, see **[CLASSICAL_LOGIC_MAPPING.md](CLASSICAL_LOGIC_MAPPING.md)** which provides:
- Complete mapping of each .mm file to classical propositional and first-order logic
- Comparison with the `tauto` tactic from [GinoGiotto/mm1_tactics](https://github.com/GinoGiotto/mm1_tactics/tree/main/tauto)
- Comprehensive validation and benchmarking roadmap
- Honest assessment of current proof status vs. aspirational claims

## Reflectology DSL (Experimental)

This repository includes an experimental Domain-Specific Language (DSL) that attempts to bridge Reflectology axioms with modern programming concepts through set-theoretic foundations.

### DSL Grammar Review

**Status: ⚠️ EXPERIMENTAL - Not Production Ready**  
**Rating: 4.5/10** (See [REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md](REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md))

The DSL grammar has been reviewed with technical honesty:

**What Works:**
- Set-theoretic type system (aligned with set.mm)
- Functional programming features (lambdas, higher-order functions)
- Monadic I/O (Haskell-inspired)
- Mathematical notation integration

**Critical Issues:**
- Multiple syntax errors (corrected in `grammar/reflectology-dsl.ebnf`)
- Ambiguous productions
- Superficial Metamath integration
- Missing essential features (imports, comprehensive error handling)
- Verbose syntax

**Key Files:**
- **[REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md](REFLECTOLOGY_DSL_GRAMMAR_REVIEW.md)** - Comprehensive honest review
- **[grammar/reflectology-dsl.ebnf](grammar/reflectology-dsl.ebnf)** - Corrected grammar specification
- **[examples/](examples/)** - Sample programs demonstrating syntax

### Example DSL Code

```refl
// Define natural numbers as a set
type Nat = set({n | n in 0. or exists m in Nat : n = succ(m)})

// Define factorial function
function factorial(n: Nat) : Nat =
  (n = 0) => 1 | (n * factorial(n - 1))

// Monadic I/O with do-notation
io pipeline = do {
  content <- read("input.txt");
  processed <- return(content + " [processed]");
  write("output.txt", processed);
  return(processed)
}
```

**Recommendation:** This DSL is exploratory. For production use, consider established tools like Coq, Lean, or Agda.

## License

See individual file headers for license information. Most files are either public domain or GNU GPL as indicated in their headers.
