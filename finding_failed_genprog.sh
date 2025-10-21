## in genprog-prep
## into each directory
## file initial build
## if it contains:
# Parsing errorFatal error: exception Frontc.ParseError("Parse error")
# Makefile:6: recipe for target 'all' failed
# make: *** [all] Error 2
## then output in genprog-failed-txt file the name of the directory.
## if not output the genprog-passed-txt file the name of the directory.
#!/usr/bin/env bash

# Base directory
BASE_DIR="genprog-run"

# Output files
FAILED_FILE="genprog-failed.txt"
PASSED_FILE="genprog-passed.txt"

# Loop through each subdirectory
for dir in "$BASE_DIR"/*; do
    if [ -d "$dir" ]; then
        # Check for parsing error or make failure
        if grep -qE "Parse error|Fatal error: exception Frontc\.ParseError|Makefile:.*recipe for target 'all' failed|make: \*\*\* \[all\] Error 2" "$dir/build.log"; then
            echo "$(basename "$dir")" >> "$FAILED_FILE"
        else
            echo "$(basename "$dir")" >> "$PASSED_FILE"
        fi
    fi
done

echo
echo "Failed builds saved to: $FAILED_FILE"
echo "Passed builds saved to: $PASSED_FILE"

## will be same for prep