# Principia Reflectologia - Metamath Validation

This repository contains formal Metamath proofs for the Reflectology axiom system and its relationship to ZFC set theory.

## Repository Structure

- **axioms.mm** - The 40 axioms of Reflectology formally stated in Metamath
- **rzfc.mm** - Proofs showing that ZFC set theory can be derived from Reflectology axioms
- **omega.mm** - Extension of set.mm with Reflectology axioms (requires external set.mm)
- **AXIOMS_MM_VALIDATION_CHECKLIST.md** - Detailed validation checklist and status report

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

### ZFC Derivation

The file `rzfc.mm` demonstrates that all 10 axioms of Zermelo-Fraenkel set theory with Choice can be derived from the Reflectology axioms:

1. Extensionality ← ax-rf10 (Omega-Bijection)
2. Empty Set ← ax-rf1 (Initial Emptiness)
3. Pairing ← ax-rf3 (Recursive Encapsulation)
4. Union ← ax-rf5 (Hierarchical Structuring)
5. Power Set ← ax-rf6 (Redundancy Reduction)
6. Infinity ← ax-rf15 (Reflective Convergence)
7. Separation ← ax-rf8 (Symmetry Breaking)
8. Replacement ← ax-rf32 (Path Dependence)
9. Foundation ← ax-rf19 (Hyperreal Extension)
10. Choice ← ax-rf14 (Canonical Selection)

## License

See individual file headers for license information. Most files are either public domain or GNU GPL as indicated in their headers.
