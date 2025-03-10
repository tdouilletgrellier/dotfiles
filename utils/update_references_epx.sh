#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 <input_log> <replacement_file>"
    echo "       $0 -h | --help"
}

# Check arguments
case "$1" in
    "-h"|"--help")
        show_usage
        exit 0
        ;;
esac

# Check if both filenames were provided
if [ $# -ne 2 ]; then
    show_usage
    exit 1
fi

INPUT_LOG="$1"
REPLACE_FILE="$2"

# Check if files exist
if [ ! -f "$INPUT_LOG" ] || [ ! -f "$REPLACE_FILE" ]; then
    echo "Error: One or both files not found"
    exit 1
fi

# Create backup of original file
cp "$REPLACE_FILE" "${REPLACE_FILE}.bak"
echo "Created backup: ${REPLACE_FILE}.bak"

# Extract REF and RES values
while IFS= read -r line; do
    if [[ $line =~ QUAL_RESU ]]; then
        ref_value=$(echo "$line" | sed -r 's/.*REF=\s*([0-9.E+-]+)/\1/')
        res_value=$(echo "$line" | sed -r 's/.*RES=\s*([0-9.E+-]+)/\1/')
        
        # Replace ref_value with res_value in replacement file
        sed -i "s/$ref_value/$res_value/g" "$REPLACE_FILE"
        echo "Replaced $ref_value with $res_value"
    fi
done < "$INPUT_LOG"

echo "Replacement completed successfully!"