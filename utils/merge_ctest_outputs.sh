#!/bin/bash
#===================================================
#  CTest Output Merger
#  This script merges multiple ctest output files into one
#  consolidated file, handling both standard output and
#  output produced with --output-on-failure.
#
#  It can be used directly from the command line or sourced.
#===================================================

# Define ANSI color codes for colorful logging
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

#---------------------------------------------------
# Function: show_help
#  Displays a colorful help message and usage info.
#---------------------------------------------------
show_help() {
    echo -e "${CYAN}---------------------------------------------------"
    echo -e " CTest Output Merger"
    echo -e "---------------------------------------------------${RESET}"
    echo -e "${YELLOW}Usage:${RESET}"
    echo -e "  $0 [options]"
    echo -e ""
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  -o <file>    Specify output file (default: ctest_merged_output.txt)"
    echo -e "  -d <dir>     Specify directory containing ctest output files (default: current directory)"
    echo -e "  -f <glob>    Specify file glob pattern for input files (default: ctest_output_*.txt)"
    echo -e "  -h, --help   Show this help message and exit"
    echo -e ""
    echo -e "${YELLOW}Description:${RESET}"
    echo -e "  This script merges multiple ctest output files matching the given glob,"
    echo -e "  consolidating the results into a single file that resembles a standard ctest output."
    echo -e "  For any failed test, detailed failure output is saved in a separate file"
    echo -e "  inside a folder called 'failed_tests_logs'. The filename is derived from the test name."
    echo -e ""
    echo -e "${GREEN}Example:${RESET}"
    echo -e "  $0 -o merged.log -d /path/to/logs -f \"outpour_ctest_*.out\""
    echo ""
    exit 0
}

#---------------------------------------------------
# Function: merge_ctest_outputs
#  Merges the ctest output files using the specified options.
#
#  Options (via command-line arguments):
#    -o: output file name
#    -d: directory of ctest output files
#    -f: glob pattern for the file names
#---------------------------------------------------
merge_ctest_outputs() {
    # Set default values
    local OUTPUT_FILE="ctest_merged_output.txt"
    local OUTPUT_DIR="."
    local FILE_GLOB="ctest_output_*.txt"
    local FAIL_LOG_DIR="failed_tests_logs"

    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -o)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -d)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            -f)
                FILE_GLOB="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                ;;
            *)
                echo -e "${RED}[Error] Unknown option: $1${RESET}"
                show_help
                ;;
        esac
    done

    # Gather the output files using the provided directory and file glob pattern
    local OUTPUT_FILES=("$OUTPUT_DIR"/$FILE_GLOB)

    # Check if any output files were found
    if [[ ${#OUTPUT_FILES[@]} -eq 0 ]]; then
        echo -e "${RED}[Error] No files matching '$FILE_GLOB' were found in '$OUTPUT_DIR'!${RESET}"
        return 1
    fi

    echo -e "${YELLOW}[Info] Merging ${#OUTPUT_FILES[@]} file(s) matching '$FILE_GLOB' from directory '$OUTPUT_DIR'...${RESET}"

    # Create the directory for failed logs
    local FAIL_LOG_PATH="${OUTPUT_DIR}/${FAIL_LOG_DIR}"
    mkdir -p "$FAIL_LOG_PATH"

    # Initialize counters and arrays for summary and failure details
    local TOTAL_TESTS=0
    local PASSED_TESTS=0
    local FAILED_TESTS=0
    local FAILED_LIST=()
    local FAILED_FILES=()  # Holds the file names of detailed failure outputs

    # Use the first file's first line as a header in the merged output
    head -n 1 "${OUTPUT_FILES[0]}" > "$OUTPUT_FILE"

    # Process each output file
    for FILE in "${OUTPUT_FILES[@]}"; do
        echo -e "${YELLOW}[Info] Processing file: $FILE${RESET}"
        # Read the file into an array (each element is one line)
        mapfile -t lines < "$FILE"
        local num_lines=${#lines[@]}
        local i=0
        while [ $i -lt $num_lines ]; do
            local LINE="${lines[i]}"
            # Skip duplicate summary lines (e.g., "Errors while running CTest")
            if [[ $LINE =~ ^[[:space:]]*Errors\ while\ running\ CTest ]]; then
                ((i++))
                continue
            fi
            # If the line starts with "Start <num>:"
            if [[ $LINE =~ ^[[:space:]]*Start[[:space:]]+[0-9]+: ]]; then
                echo "$LINE" >> "$OUTPUT_FILE"
            # If the line is a test result line like "26/31 Test #232: ... Passed/Failed"
            elif [[ $LINE =~ ^[[:space:]]*[0-9]+/[0-9]+[[:space:]]+Test ]]; then
                echo "$LINE" >> "$OUTPUT_FILE"
                ((TOTAL_TESTS++))
                if [[ $LINE == *"Passed"* ]]; then
                    ((PASSED_TESTS++))
                elif [[ $LINE == *"Failed"* ]]; then
                    ((FAILED_TESTS++))
                    FAILED_LIST+=("$LINE")
                    
                    # Extract the test name from the failed test line.
                    local test_name
                    test_name=$(echo "$LINE" | sed -n 's/.*Test[[:space:]]*#[0-9]\+:[[:space:]]*\(.*\)[[:space:]]\.\.\..*Failed.*/\1/p')
                    if [[ -z "$test_name" ]]; then
                        test_name="unknown_test"
                    fi
                    # Sanitize test name for filename (replace spaces and slashes with underscores)
                    local sanitized_test_name
                    sanitized_test_name=$(echo "$test_name" | tr ' /' '__')
                    local failure_file="${FAIL_LOG_PATH}/${sanitized_test_name}.failed.log"

                    # Capture detailed failure output lines until a new test result or "Start" line is encountered.
                    local failure_output=""
                    local j=$((i + 1))
                    while [ $j -lt $num_lines ]; do
                        local next_line="${lines[j]}"
                        # Break if the next line is a new test result or starts with "Start"
                        if [[ $next_line =~ ^[[:space:]]*Start[[:space:]]+[0-9]+: ]] || [[ $next_line =~ ^[[:space:]]*[0-9]+/[0-9]+[[:space:]]+Test ]]; then
                            break
                        fi
                        # Skip duplicate error messages
                        if [[ ! $next_line =~ ^[[:space:]]*Errors\ while\ running\ CTest ]]; then
                            failure_output+="${next_line}"$'\n'
                        fi
                        ((j++))
                    done
                    # Remove any stray "Start ..." lines that might be at the end of the captured failure output
                    failure_output=$(echo "$failure_output" | sed '/^[[:space:]]*Start[[:space:]]\+[0-9]\+:/d')
                    
                    # Write the detailed failure output to its own file in the failed_tests_logs folder
                    echo -e "${YELLOW}[Info] Writing detailed failure output for '$test_name' to '$failure_file'${RESET}"
                    echo "$failure_output" > "$failure_file"
                    FAILED_FILES+=("$failure_file")
                    
                    # Move the outer index past the captured failure output
                    i=$((j - 1))
                fi
            fi
            ((i++))
        done
    done

    # Calculate pass percentage (guarding against division by zero)
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        local PASS_RATE=$(( (PASSED_TESTS * 100) / TOTAL_TESTS ))
    else
        local PASS_RATE=0
    fi

    # Write the final summary to the merged output file
    {
        echo ""
        echo "$PASS_RATE% tests passed, $FAILED_TESTS tests failed out of $TOTAL_TESTS"
        echo ""
        echo "Total Test time (real) = $(awk '/Total Test time/ {print $NF}' "${OUTPUT_FILES[@]}" | awk '{s+=$1} END {print s " sec"}')"
        echo ""
    } >> "$OUTPUT_FILE"

    # If any tests failed, list them and reference the files with detailed output.
    if [[ $FAILED_TESTS -gt 0 ]]; then
        {
            echo "The following tests FAILED:"
            printf "%s\n" "${FAILED_LIST[@]}"
            echo ""
            echo "Detailed failure outputs have been saved to the following files:"
            for file in "${FAILED_FILES[@]}"; do
                echo "$file"
            done
            echo "Errors while running CTest"
        } >> "$OUTPUT_FILE"
    fi

    echo -e "${GREEN}[Success] Merged output saved to $OUTPUT_FILE${RESET}"
}

# If the script is being run directly, call merge_ctest_outputs.
# If it is sourced, the function will be available for later use.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    if [[ $# -eq 0 ]]; then
        show_help
    else
        merge_ctest_outputs "$@"
    fi
fi
