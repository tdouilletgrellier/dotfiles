#!/bin/bash
#=====================================================================
#  Reference Values Updater for EPX Files
#
#  PURPOSE:
#    Updates reference values in EPX files by extracting and comparing
#    reference and result values from log files. Designed to
#    streamline validation workflows by automatically updating
#    reference values to match new computational results.
#
#  AUTHOR:
#    Original script enhanced with better organization, comments, and
#    user interface elements
#
#  USAGE:
#    ./update_references_epx.sh <input_log> [replacement_file]
#
#  OPTIONS:
#    -b, --backup    Create backup before modifications
#    -q, --quiet     Suppress non-essential output
#    -d, --debug     Show detailed debugging information
#    -n, --dry-run   Show what would be done without making changes
#    -v, --verbose   Show more detailed processing information
#    -y, --yes       Auto-confirm all replacements
#    -h, --help      Display help information
#=====================================================================

#=====================================================================
# CONFIGURATION AND SETUP
#=====================================================================

# Terminal formatting codes
RESET="\033[0m"     # Reset all formatting
BOLD="\033[1m"      # Bold text
UNDERLINE="\033[4m" # Underline text
ITALIC="\033[3m"    # Italic text (not supported in all terminals)

# Foreground Colors
BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

# Bright Foreground Colors
BRIGHT_BLACK="\033[1;30m"
BRIGHT_RED="\033[1;31m"
BRIGHT_GREEN="\033[1;32m"
BRIGHT_YELLOW="\033[1;33m"
BRIGHT_BLUE="\033[1;34m"
BRIGHT_MAGENTA="\033[1;35m"
BRIGHT_CYAN="\033[1;36m"
BRIGHT_WHITE="\033[1;37m"

# Exit codes
EXIT_SUCCESS=0
EXIT_FAILURE=1
EXIT_INVALID_ARGS=2
EXIT_MISSING_FILES=3

# Global configuration variables - users can modify these
# String patterns for matching
REF_PATTERN="REF="
RES_PATTERN="RES="
# Default file extension for replacement files
DEFAULT_EXTENSION="epx"
# String pattern for identifying result lines
RESULT_IDENTIFIER="QUAL_RESU"
# Decimal precision for number formatting (if needed)
DECIMAL_PRECISION=6
# File permissions for backups (octal)
BACKUP_PERMISSIONS=644

# Verbosity levels
VERBOSITY_QUIET=0   # Only errors
VERBOSITY_NORMAL=1  # Normal output (default)
VERBOSITY_VERBOSE=2 # Verbose output
VERBOSITY_DEBUG=3   # Debug output

# Default verbosity level
VERBOSITY=$VERBOSITY_NORMAL

#=====================================================================
# LOGGING FUNCTIONS
#=====================================================================

# Log a message with a specified level, color, and message
log_message() {
	local level=$1
	local color=$2
	local message=$3
	if [[ $VERBOSITY -ge $level ]]; then
		echo -e "${color}${message}${RESET}"
	fi
}

# Log an error message (always displayed)
log_error() {
	local message=$1
	echo -e "${BOLD}${RED}[Error] ${message}${RESET}" >&2
}

# Log a warning message
log_warning() {
	local message=$1
	log_message $VERBOSITY_NORMAL "${BRIGHT_YELLOW}[Warning] ${message}"
}

# Log an info message
log_info() {
	local message=$1
	log_message $VERBOSITY_NORMAL "${BRIGHT_CYAN}${message}"
}

# Log a success message
log_success() {
	local message=$1
	log_message $VERBOSITY_NORMAL "${BRIGHT_GREEN}${message}"
}

# Log a debug message
log_debug() {
	local message=$1
	log_message $VERBOSITY_DEBUG "${BRIGHT_MAGENTA}[Debug] ${message}"
}

#=====================================================================
# COLORED DIFF FUNCTION
#=====================================================================

# Display a color-coded diff of the changes
show_colored_diff() {
	local old_value="$1"
	local new_value="$2"
	local line="$3"

	# Find and highlight the position of the value in the line
	local highlighted_line="${line//$old_value/${BRIGHT_RED}${old_value}${RESET}}"
	local preview_line="${line//$old_value/${BRIGHT_YELLOW}${new_value}${RESET}}"

	echo -e "${BOLD}${WHITE}Before:${RESET} $highlighted_line"
	echo -e "${BOLD}${WHITE}After: ${RESET} $preview_line"
}

#=====================================================================
# NUMBERS FUNCTIONS
#=====================================================================

# Validate if a string is a valid numeric value (integer, decimal, or scientific notation)
validate_number() {
	local value="$1"
	# Pattern matches integers, decimals, and scientific notation
	if [[ $value =~ ^[+-]?[0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?$ ]]; then
		return 0 # Valid number
	else
		return 1 # Invalid number
	fi
}

# Compare numbers considering both scientific and standard notation
compare_numbers() {
    local num1="$1"
    local num2="$2"
    local tolerance=1e-10
    
    # Use awk instead of bc for more reliable floating point math
    local result=$(awk -v n1="$num1" -v n2="$num2" -v t="$tolerance" 'BEGIN {if (sqrt((n1-n2)^2) < t) print 1; else print 0}')
    
    if [ "$result" = "1" ]; then
        return 0 # Numbers are equal within tolerance
    else
        return 1 # Numbers are different
    fi
}

#=====================================================================
# HELP AND DOCUMENTATION FUNCTIONS
#=====================================================================

# Display help information
show_help() {
	echo -e "${BOLD}${CYAN}=====================================================================
 Reference Values Updater for EPX Files
=====================================================================
${RESET}"
	echo -e "${BOLD}${YELLOW}USAGE:${RESET}"
	echo -e "  $(basename "$0") ${UNDERLINE}<input_log>${RESET} [${UNDERLINE}replacement_file${RESET}] [${ITALIC}options${RESET}]"
	echo -e "  If replacement_file is not specified, <filename>.${DEFAULT_EXTENSION} is used"
	echo -e "  (ignoring input_log extension)."
	echo -e ""
	echo -e "${BOLD}${YELLOW}OPTIONS:${RESET}"
	echo -e "  ${WHITE}-b, --backup${RESET}           Create backup (.bak) before modification"
	echo -e "  ${WHITE}-q, --quiet${RESET}            Suppress non-essential output"
	echo -e "  ${WHITE}-d, --debug${RESET}            Show detailed debugging information"
	echo -e "  ${WHITE}-n, --dry-run${RESET}          Show what would be done without making changes"
	echo -e "  ${WHITE}-v, --verbose${RESET}          Show more detailed processing information"
	echo -e "  ${WHITE}-y, --yes${RESET}              Auto-confirm all replacements"
	echo -e "  ${WHITE}-h, --help${RESET}             Show this help message"
	echo -e ""
	echo -e "${BOLD}${YELLOW}DESCRIPTION:${RESET}"
	echo -e "  This script extracts reference and result values from log files and"
	echo -e "  updates reference values in target EPX files. It compares values and"
	echo -e "  allows selective or automatic replacement. The script is designed to"
	echo -e "  streamline validation workflows by updating reference values that match"
	echo -e "  new computational results."
	echo -e ""
	echo -e "${BOLD}${YELLOW}CUSTOMIZATION:${RESET}"
	echo -e "  You can modify the global variables at the top of the script to customize:"
	echo -e "  - REF_PATTERN: Currently \"${REF_PATTERN}\" - Pattern for reference values"
	echo -e "  - RES_PATTERN: Currently \"${RES_PATTERN}\" - Pattern for result values"
	echo -e "  - DEFAULT_EXTENSION: Currently \"${DEFAULT_EXTENSION}\" - Default extension"
	echo -e "  - RESULT_IDENTIFIER: Currently \"${RESULT_IDENTIFIER}\" - Result line identifier"
	echo -e ""
	echo -e "${BOLD}${YELLOW}EXAMPLES:${RESET}"
	echo -e "  ${GREEN}$(basename "$0") results.log${RESET}"
	echo -e "    Process log file with default settings"
	echo -e ""
	echo -e "  ${GREEN}$(basename "$0") results.log data.epx${RESET}"
	echo -e "    Process log file with specific replacement file"
	echo -e ""
	echo -e "  ${GREEN}$(basename "$0") -b -y results.log${RESET}"
	echo -e "    Create backup and auto-confirm all replacements"
	echo -e ""
	echo -e "  ${GREEN}$(basename "$0") -n -v results.log data.epx${RESET}"
	echo -e "    Run in dry-run mode with verbose output"
	echo ""
	return $EXIT_SUCCESS
}

#=====================================================================
# MAIN PROCESSING FUNCTION
#=====================================================================

# Function to process listings files and replace values in epx test case
update_epx_ref_values() {
	local input_log=""
	local replace_file=""
	local backup=0
	local dry_run=0
	local auto_confirm=0

	# Check for required commands
	if ! command -v sed &>/dev/null; then
		log_error "sed is not installed or not in the PATH."
		return $EXIT_FAILURE
	fi

	# Show help if no arguments
	if [ $# -eq 0 ]; then
		show_help
		return $EXIT_INVALID_ARGS
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--backup | -b)
			backup=1
			log_debug "Backup enabled"
			;;
		--quiet | -q)
			VERBOSITY=$VERBOSITY_QUIET
			log_debug "Quiet mode enabled"
			;;
		--debug | -d)
			VERBOSITY=$VERBOSITY_DEBUG
			log_debug "Debug mode enabled"
			;;
		--dry-run | -n)
			dry_run=1
			log_debug "Dry run mode enabled"
			;;
		--verbose | -v)
			VERBOSITY=$VERBOSITY_VERBOSE
			log_debug "Verbose mode enabled"
			;;
		--yes | -y)
			auto_confirm=1
			log_debug "Auto confirm enabled"
			;;
		--help | -h)
			show_help
			return $EXIT_SUCCESS
			;;
		*)
			log_error "Unknown option: $1"
			return $EXIT_INVALID_ARGS
			;;
		esac
		shift
	done

	# Check if at least input log was provided
	if [ $# -lt 1 ]; then
		log_error "Missing required input log argument."
		show_help
		return $EXIT_INVALID_ARGS
	fi

	input_log="$1"

	# If replacement file is not provided, use basename with configured extension
	if [ $# -lt 2 ]; then
		# Get the basename without extension
		local basename=$(basename "$input_log")
		local filename="${basename%.*}"

		# Create the replacement filename with configured extension
		replace_file="${filename}.${DEFAULT_EXTENSION}"

		log_info "No replacement file specified. Using: ${BRIGHT_YELLOW}$replace_file${RESET}"
	else
		replace_file="$2"
	fi

	# Check if files exist
	if [ ! -f "$input_log" ]; then
		log_error "Input log file not found: ${BRIGHT_YELLOW}$input_log${RESET}"
		return $EXIT_MISSING_FILES
	fi

	if [ ! -f "$replace_file" ]; then
		log_error "Replacement file not found: ${BRIGHT_YELLOW}$replace_file${RESET}"
		return $EXIT_MISSING_FILES
	fi

	# Create backup of original file if requested
	if [ $backup -eq 1 ]; then
		cp "$replace_file" "${replace_file}.bak"
		chmod $BACKUP_PERMISSIONS "${replace_file}.bak"
		log_info "Created backup: ${BRIGHT_YELLOW}${replace_file}.bak${RESET}"
	fi

	# Count of replacements made
	local replacement_count=0
	local line_count=0
	local match_count=0
	local skipped_count=0

	log_info "Processing log file: ${BRIGHT_YELLOW}$input_log${RESET}"

	# Extract REF and RES values using configurable patterns
	while IFS= read -r line || [ -n "$line" ]; do
		((line_count++))

		log_debug "Reading line ${BRIGHT_YELLOW}$line_count${RESET}: ${line:0:50}..."

		if [[ $line =~ ${RESULT_IDENTIFIER} ]]; then
			((match_count++))
			ref_value=$(echo "$line" | sed -r "s/.*${REF_PATTERN}\s*([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s+.*/\1/")
			res_value=$(echo "$line" | sed -r "s/.*${RES_PATTERN}\s*([-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?)\s+.*/\1/")

			if [ -z "$ref_value" ] || [ -z "$res_value" ]; then
				log_debug "Failed to extract values from line $line_count"
				continue
			fi
			# Validate extracted values are proper numbers
			if ! validate_number "$ref_value"; then
				log_debug "Invalid reference value format: '$ref_value' at line $line_count"
				continue
			fi

			if ! validate_number "$res_value"; then
				log_debug "Invalid result value format: '$res_value' at line $line_count"
				continue
			fi

			# Check if the replacement is necessary (values are different)
			if compare_numbers "$ref_value" "$res_value"; then
				log_message $VERBOSITY_VERBOSE "${BRIGHT_YELLOW}" "Skipping identical values: $ref_value"
				continue
			fi

			# Find occurrences in replacement file
			if grep -q "$ref_value" "$replace_file"; then

				# Display original log line
				echo -e ""
				echo -e "${BRIGHT_WHITE}# ------------------------------------------------------------------${RESET}"
				echo -e "\n${BOLD}${WHITE}Found a match :${RESET}"
				local highlighted_line="${line//$ref_value/${BRIGHT_RED}${ref_value}${RESET}}"
				highlighted_line="${highlighted_line//$res_value/${BRIGHT_YELLOW}${res_value}${RESET}}"
				highlighted_line="${highlighted_line//$REF_PATTERN/${UNDERLINE}${REF_PATTERN}${RESET}}"
				highlighted_line="${highlighted_line//$RES_PATTERN/${UNDERLINE}${RES_PATTERN}${RESET}}"
				highlighted_line="${highlighted_line//$RESULT_IDENTIFIER/${BRIGHT_BLUE}${RESULT_IDENTIFIER}${RESET}}"
				echo -e "$highlighted_line"

				# Total occurences
				local total_occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)

				# Ask for confirmation unless auto-confirm is set
				if [ $dry_run -eq 1 ]; then

					# Display the lines that will be modified
					echo -e "\n${BRIGHT_YELLOW}$total_occurrences${RESET} ${BOLD}${WHITE}lines to be modified in ${BRIGHT_YELLOW}$replace_file${BOLD}${WHITE}:${RESET}"
					grep --color=always -n "$ref_value" "$replace_file"

					echo -e "\n${BRIGHT_CYAN}Would process each occurrence individually (Dry run)${RESET}"
					
				elif [ $auto_confirm -eq 1 ]; then

					# Count occurrences before replacement
					local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
					sed -i "s/$ref_value/$res_value/g" "$replace_file"
					((replacement_count += occurrences))
					echo -e "\n${BRIGHT_CYAN}Automatically replaced:${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"

				else

					# Process each occurrence individually
					local current_occurrence=0
					while read -r found_line_num found_line; do
						((current_occurrence++))             # Occurences counter
						found_line_num=${found_line_num%%:*} # Extract line number

						echo -e "\n${BOLD}${WHITE}Occurrence ${BRIGHT_YELLOW}$current_occurrence/$total_occurrences${RESET} at line ${BRIGHT_YELLOW}$found_line_num${RESET}:${RESET}"
						show_colored_diff "$ref_value" "$res_value" "$found_line"

						# Remainung occurences
						local remaining=$((total_occurrences - current_occurrence + 1))

						# Confirmation
						echo -e "\n${BOLD}${WHITE}Replace this occurrence ?${RESET} (y/n/a/s/q)"
						echo -e "  y = yes (replace ${BRIGHT_YELLOW}1${RESET} occurrence), n = no, a = yes to all (replaces all ${BRIGHT_YELLOW}$total_occurrences${RESET} occurrences),"
						echo -e "  s = yes to all for this value (replaces remaining ${BRIGHT_YELLOW}$remaining${RESET} occurrences), q = quit"
						read -r answer </dev/tty

						case "$answer" in
						[Yy]*)
							# Replace only this occurrence
							# We need line number and context to ensure we only replace at this position
							sed -i "${found_line_num}s/$ref_value/$res_value/" "$replace_file"
							((replacement_count++))
							log_info "Replaced occurrence at line ${BRIGHT_YELLOW}$found_line_num${RESET}"
							;;
						[Aa]*)
							auto_confirm=1
							# Replace all remaining occurrences globally
							local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
							sed -i "s/$ref_value/$res_value/g" "$replace_file"
							((replacement_count += occurrences))
							log_info "Replaced all: ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"
							log_warning "Auto-confirm enabled for remaining replacements."
							break
							;;
						[Ss]*)
							# Replace all occurrences of this specific value
							local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
							sed -i "s/$ref_value/$res_value/g" "$replace_file"
							((replacement_count += occurrences))
							log_info "Replaced all occurrences of: ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"
							break
							;;
						[Qq]*)
							log_warning "Operation cancelled by user."
							return $EXIT_SUCCESS
							;;
						*)
							((skipped_count++))
							log_warning "Skipped occurrence at line ${BRIGHT_YELLOW}$found_line_num${RESET}"
							;;
						esac
					done < <(grep -n "$ref_value" "$replace_file")
				fi
			else
				log_message $VERBOSITY_VERBOSE "${BRIGHT_YELLOW}" "No occurrences found for: $ref_value"
			fi
		fi
	done <"$input_log"

	# Summary
	if [ $VERBOSITY -ge $VERBOSITY_NORMAL ]; then
		echo -e "\n${BOLD}${WHITE}Summary:${RESET}"
		echo -e "  ${BRIGHT_CYAN}Lines processed:${RESET} ${BRIGHT_YELLOW}$line_count${RESET}"
		echo -e "  ${BRIGHT_CYAN}Matches found:${RESET} ${BRIGHT_YELLOW}$match_count${RESET}"

		if [ $dry_run -eq 1 ]; then
			echo -e "  ${BRIGHT_CYAN}Replacements (dry run):${RESET} ${BRIGHT_YELLOW}$replacement_count${RESET}"
		else
			echo -e "  ${BRIGHT_CYAN}Replacements made:${RESET} ${BRIGHT_YELLOW}$replacement_count${RESET}"
			echo -e "  ${BRIGHT_CYAN}Replacements skipped:${RESET} ${BRIGHT_YELLOW}$skipped_count${RESET}"
		fi
	fi

	log_success "Processing completed successfully!"
	return $EXIT_SUCCESS
}

#=====================================================================
# MAIN SCRIPT EXECUTION
#
# If no arguments are provided, show help.
# Otherwise, call update_epx_ref_values with all arguments.
#=====================================================================
if [[ "$#" -eq 0 ]]; then
	show_help
else
	update_epx_ref_values "$@"
	exit_code=$?
	exit $exit_code
fi
