# Quick Start Guide - Metamath Validation

## For Contributors

### Before You Commit

Always validate your changes before pushing:

```bash
./validate-metamath.sh
```

### Common Issues and Fixes

#### 1. Missing Newline at End of File

**Error:**
```
?Warning: the last line in file "..." is incomplete.
```

**Fix:**
```bash
echo "" >> "your-file.mm"
```

#### 2. Undeclared Symbol

**Error:**
```
?Error: Symbol "xyz" is not declared.
```

**Fix:** Add declaration at the top of your file:
```metamath
$c xyz $.  $( For constants $)
$v xyz $.  $( For variables $)
```

#### 3. Variable Not Typed

**Error:**
```
?Error: Variable "x" has no type assignment.
```

**Fix:** Add type assignment:
```metamath
$v x $.
vx $f setvar x $.
```

#### 4. Proof Verification Failed

**Error:**
```
?Error: Proof of theorem "..." has an error.
```

**Fix:** 
- Check that all referenced labels exist
- Verify substitutions are correct
- Ensure all hypotheses are satisfied
- Check distinct variable conditions

### File Structure Template

```metamath
$( ========================================
   File: your-file.mm
   Description: What this file does
   ======================================== $)

$( === Constants === $)
$c wff class setvar $.
$c |- ( ) $.
$c -> <-> $.

$( === Variables === $)
$v ph ps $.
$v x y $.

$( === Type Assignments === $)
wph $f wff ph $.
wps $f wff ps $.
vx $f setvar x $.
vy $f setvar y $.

$( === Axioms === $)
ax-1 $a |- ( ph -> ( ps -> ph ) ) $.

$( === Theorems === $)
${
  thm-1.1 $e |- ph $.
  thm-1 $p |- ph $= wph thm-1.1 $.
$}
```

## For Reviewers

### Validation Checklist

- [ ] All `.mm` files pass `./validate-metamath.sh`
- [ ] GitHub Actions workflow passes
- [ ] New axioms are documented with comments
- [ ] New theorems have proofs (or are marked as axioms)
- [ ] Naming conventions followed (ax-, thm-, c, v, w prefixes)
- [ ] Changes don't break existing proofs

### Manual Review Steps

```bash
# 1. Checkout the PR branch
git checkout pr-branch-name

# 2. Run validation
./validate-metamath.sh

# 3. Check specific file
./metamath
MM> read "path/to/file.mm"
MM> show labels
MM> verify proof *
MM> exit

# 4. Review changes
git diff main -- "*.mm"
```

## Testing Locally

### Quick Test

```bash
# Validate all files
./validate-metamath.sh
```

### Detailed Test

```bash
# Start metamath interactive shell
/path/to/metamath

# Load a file
MM> read "Principia Reflectologia/rzfc.mm"

# Show all labels
MM> show labels

# Show specific axiom
MM> show statement ax-rf1

# Verify all proofs
MM> verify proof *

# Show statistics
MM> show statistics

# Exit
MM> exit
```

## CI/CD Integration

The repository automatically validates all `.mm` files on:

- **Push to main/master**: Validates changed files
- **Pull Requests**: Validates all `.mm` files
- **Manual Trigger**: Can be run from Actions tab

### Workflow Status

Check the status badge in README.md:

[![Metamath Validation](https://github.com/POPeeeDev/popeedev/actions/workflows/metamath-validation.yml/badge.svg)](https://github.com/POPeeeDev/popeedev/actions/workflows/metamath-validation.yml)

### View Workflow Results

1. Go to repository → Actions tab
2. Click on "Metamath Validation" workflow
3. Click on the specific run
4. View logs and artifacts

## Troubleshooting

### Metamath Not Building

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y gcc make autoconf automake git

# Clean and rebuild
rm -rf .metamath
./validate-metamath.sh
```

### Validation Script Not Executable

```bash
chmod +x validate-metamath.sh
```

### File Encoding Issues

Ensure files are UTF-8 encoded:

```bash
file -i "Principia Reflectologia/your-file.mm"
# Should show: charset=utf-8 or charset=us-ascii
```

If not:

```bash
iconv -f ISO-8859-1 -t UTF-8 input.mm > output.mm
```

## Resources

- **Metamath Home**: https://us.metamath.org/
- **Metamath Book**: https://github.com/metamath/metamath-book
- **set.mm Repository**: https://github.com/metamath/set.mm
- **Proof Explorer**: https://us.metamath.org/mpeuni/mmset.html

## Getting Help

1. Check [METAMATH_COMPLIANCE.md](METAMATH_COMPLIANCE.md) for detailed standards
2. Review [README.md](README.md) for overview
3. Check existing files for examples
4. Consult [Metamath Book](https://github.com/metamath/metamath-book)
5. Open an issue on GitHub
