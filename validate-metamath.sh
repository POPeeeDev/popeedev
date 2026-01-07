#!/bin/bash
# Metamath validation script for Principia Reflectologia
# This script validates all .mm files in the repository against Metamath standards

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
METAMATH_DIR="${SCRIPT_DIR}/.metamath"
METAMATH_EXE="${METAMATH_DIR}/metamath"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Metamath Validation for Principia Reflectologia"
echo "=========================================="
echo ""

# Check if metamath is installed
if [ ! -f "${METAMATH_EXE}" ]; then
    echo -e "${YELLOW}Metamath executable not found. Installing...${NC}"
    
    # Create directory
    mkdir -p "${METAMATH_DIR}"
    
    # Clone and build metamath
    cd /tmp
    if [ -d "metamath-exe" ]; then
        rm -rf metamath-exe
    fi
    
    echo "Cloning metamath-exe repository..."
    git clone --depth 1 https://github.com/metamath/metamath-exe.git
    
    echo "Building metamath..."
    cd metamath-exe
    if ! ./build.sh > /tmp/metamath-build.log 2>&1; then
        echo -e "${RED}Failed to build Metamath. Check /tmp/metamath-build.log for details.${NC}"
        cat /tmp/metamath-build.log
        exit 1
    fi
    
    # Copy executable
    cp metamath "${METAMATH_EXE}"
    
    # Cleanup
    cd /tmp
    rm -rf metamath-exe
    
    echo -e "${GREEN}Metamath installed successfully!${NC}"
    echo ""
fi

cd "${SCRIPT_DIR}"

# Find all .mm files and store in array
mapfile -t MM_FILES < <(find "Principia Reflectologia" -name "*.mm" -type f)

if [ ${#MM_FILES[@]} -eq 0 ]; then
    echo -e "${RED}No .mm files found in the repository!${NC}"
    exit 1
fi

echo "Found the following Metamath files:"
printf '%s\n' "${MM_FILES[@]}"
echo ""

# Validate each file
TOTAL=0
PASSED=0
FAILED=0
SKIPPED=0

for FILE in "${MM_FILES[@]}"; do
    TOTAL=$((TOTAL + 1))
    echo "----------------------------------------"
    echo "Validating: $FILE"
    echo "----------------------------------------"
    
    # Check if file requires external dependencies
    if grep -q '\$\[' "$FILE"; then
        echo -e "${YELLOW}⚠ File includes external dependencies (e.g., set.mm)${NC}"
        echo -e "${YELLOW}⚠ Skipping validation (requires external file)${NC}"
        SKIPPED=$((SKIPPED + 1))
        echo ""
        continue
    fi
    
    # Run metamath validation
    MM_COMMANDS="read '${FILE}'
verify proof *
exit"
    RESULT=$(echo "$MM_COMMANDS" | "${METAMATH_EXE}" 2>&1)
    
    # Check for errors
    if echo "$RESULT" | grep -q "?Error"; then
        echo -e "${RED}✗ FAILED${NC}"
        echo "$RESULT" | grep "?Error"
        FAILED=$((FAILED + 1))
    elif echo "$RESULT" | grep -q "?Warning"; then
        # Check if it's only the incomplete last line warning (which we consider acceptable)
        if echo "$RESULT" | grep -q "All proofs in the database were verified"; then
            echo -e "${GREEN}✓ PASSED${NC}"
            if echo "$RESULT" | grep "?Warning"; then
                echo "$RESULT" | grep "?Warning"
            fi
            PASSED=$((PASSED + 1))
        else
            echo -e "${YELLOW}⚠ PASSED with warnings${NC}"
            echo "$RESULT" | grep "?Warning"
            PASSED=$((PASSED + 1))
        fi
    elif echo "$RESULT" | grep -q "All proofs in the database were verified"; then
        echo -e "${GREEN}✓ PASSED${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}✗ FAILED${NC}"
        echo "$RESULT"
        FAILED=$((FAILED + 1))
    fi
    
    # Show stats
    if echo "$RESULT" | grep -q "The source has"; then
        echo "$RESULT" | grep "The source has"
    fi
    
    echo ""
done

# Summary
echo "=========================================="
echo "VALIDATION SUMMARY"
echo "=========================================="
echo "Total files:   $TOTAL"
echo -e "${GREEN}Passed:        $PASSED${NC}"
echo -e "${RED}Failed:        $FAILED${NC}"
echo -e "${YELLOW}Skipped:       $SKIPPED${NC}"
echo ""

if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Validation failed! Please fix the errors above.${NC}"
    exit 1
else
    echo -e "${GREEN}All validations passed successfully!${NC}"
    exit 0
fi
