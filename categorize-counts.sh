#!/bin/bash

# Paths to files
GENPROG_FOUND="genprog-repairs-found"
GENPROG_NOT_FOUND="genprog-repairs-not-found"
PREP_FOUND="prep-found"
PREP_NOT_FOUND="prep-not-found"
PREP_FAILED="prep-failed.txt"

# Output file
OUTPUT_FILE="combined-categories.txt"

# Step 0: Filter PREP lists to remove failed files
sed 's/^/temp-/' "$PREP_FAILED" > prep-failed-temp.txt
grep -vxFf prep-failed-temp.txt "$PREP_FOUND" > prep-found-filtered.txt
grep -vxFf prep-failed-temp.txt "$PREP_NOT_FOUND" > prep-not-found-filtered.txt

# Update PREP paths to filtered files
PREP_FOUND="prep-found-filtered.txt"
PREP_NOT_FOUND="prep-not-found-filtered.txt"

# Clear output file
> $OUTPUT_FILE

# Print header
echo -e "File\tGenProg Repair Status without PREP\tGenProg Repair Status with PREP\tCategory" >> $OUTPUT_FILE

# Initialize counters
count1=0
count2=0
count3=0
count4=0

# Function to check PREP status
get_prep_status() {
    local file=$1
    if grep -qxF "$file" "$PREP_FOUND"; then
        echo "Repair Found"
    elif grep -qxF "$file" "$PREP_NOT_FOUND"; then
        echo "Repair Not Found"
    else
        echo "Unknown"
    fi
}

# Process GenProg found files
while read -r file; do
    prep_status=$(get_prep_status "$file")
    if [ "$prep_status" = "Repair Found" ]; then
        category=1
        ((count1++))
    elif [ "$prep_status" = "Repair Not Found" ]; then
        category=3
        ((count3++))
    else
        category="Unknown"
    fi
    echo -e "$file\tRepair Found\t$prep_status\t$category" >> $OUTPUT_FILE
done < "$GENPROG_FOUND"

# Process GenProg not found files
while read -r file; do
    prep_status=$(get_prep_status "$file")
    if [ "$prep_status" = "Repair Not Found" ]; then
        category=2
        ((count2++))
    elif [ "$prep_status" = "Repair Found" ]; then
        category=4
        ((count4++))
    else
        category="Unknown"
    fi
    echo -e "$file\tRepair Not Found\t$prep_status\t$category" >> $OUTPUT_FILE
done < "$GENPROG_NOT_FOUND"

# Print counts
echo -e "\nCategory counts:" >> $OUTPUT_FILE
echo "1 (Repair Found / Repair Found): $count1" >> $OUTPUT_FILE
echo "2 (Repair Not Found / Repair Not Found): $count2" >> $OUTPUT_FILE
echo "3 (Repair Found / Repair Not Found): $count3" >> $OUTPUT_FILE
echo "4 (Repair Not Found / Repair Found): $count4" >> $OUTPUT_FILE

echo "Categorization complete. Results saved in $OUTPUT_FILE"
echo "Counts: 1=$count1, 2=$count2, 3=$count3, 4=$count4"
