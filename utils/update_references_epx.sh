#!/bin/bash

# Function to process log files and replace values
process_logs() {
	local input_log=""
	local replace_file=""
	local backup=0
	local quiet=0
	local debug=0
	local dry_run=0
	local verbose=0
	local auto_confirm=0

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

	# Check for required commands
	if ! command -v sed &>/dev/null; then
		echo -e "${BRIGHT_RED}Error:${RESET} sed is not installed or not in the PATH."
		return 1
	fi

	# Help function
	show_help() {
		echo -e "${BRIGHT_WHITE}process_logs:${RESET} Replace ${REF_PATTERN} values with ${RES_PATTERN} values from log files"
		echo -e "${BRIGHT_WHITE}Usage:${RESET}"
		echo -e "  ${BRIGHT_CYAN}process_logs${RESET} ${BRIGHT_YELLOW}[options]${RESET} <input_log> [replacement_file]"
		echo -e "  If replacement_file is not specified, <filename>.${DEFAULT_EXTENSION} is used (ignoring input_log extension)."
		echo -e "${BRIGHT_WHITE}Options:${RESET}"
		echo -e "  ${BRIGHT_GREEN}-b, --backup${RESET}           Create backup (.bak) before modification"
		echo -e "  ${BRIGHT_GREEN}-q, --quiet${RESET}            Suppress non-essential output"
		echo -e "  ${BRIGHT_GREEN}-d, --debug${RESET}            Show detailed debugging information"
		echo -e "  ${BRIGHT_GREEN}-n, --dry-run${RESET}          Show what would be done without making changes"
		echo -e "  ${BRIGHT_GREEN}-v, --verbose${RESET}          Show more detailed processing information"
		echo -e "  ${BRIGHT_GREEN}-y, --yes${RESET}              Auto-confirm all replacements"
		echo -e "  ${BRIGHT_GREEN}-h, --help${RESET}             Show this help message"
		echo -e ""
		echo -e "${BRIGHT_WHITE}Customizable Settings:${RESET}"
		echo -e "  You can modify the global variables at the top of the script to customize:"
		echo -e "  - REF_PATTERN: Currently \"${REF_PATTERN}\" - Pattern to identify reference values"
		echo -e "  - RES_PATTERN: Currently \"${RES_PATTERN}\" - Pattern to identify result values"
		echo -e "  - DEFAULT_EXTENSION: Currently \"${DEFAULT_EXTENSION}\" - Default extension for replacement files"
		echo -e "  - RESULT_IDENTIFIER: Currently \"${RESULT_IDENTIFIER}\" - String to identify result lines"
		echo -e ""
		echo -e "${BRIGHT_WHITE}Examples:${RESET}"
		echo -e "  ${BRIGHT_CYAN}# Process log file with default settings${RESET}"
		echo -e "  ${BRIGHT_YELLOW}process_logs results.log${RESET}"
		echo -e ""
		echo -e "  ${BRIGHT_CYAN}# Process log file with specific replacement file${RESET}"
		echo -e "  ${BRIGHT_YELLOW}process_logs results.log data.epx${RESET}"
		echo -e ""
		echo -e "  ${BRIGHT_CYAN}# Create backup and auto-confirm all replacements${RESET}"
		echo -e "  ${BRIGHT_YELLOW}process_logs -b -y results.log${RESET}"
		echo -e ""
		echo -e "  ${BRIGHT_CYAN}# Run in dry-run mode with verbose output${RESET}"
		echo -e "  ${BRIGHT_YELLOW}process_logs -n -v results.log data.epx${RESET}"
		echo -e ""
		echo -e "  ${BRIGHT_CYAN}# Change default patterns (modify in script)${RESET}"
		echo -e "  ${BRIGHT_YELLOW}# To change REF_PATTERN=\"VALUE=\" and RES_PATTERN=\"RESULT=\",${RESET}"
		echo -e "  ${BRIGHT_YELLOW}# edit these variables at the top of the script.${RESET}"
		return 1
	}

	# Show help if no arguments
	if [ $# -eq 0 ]; then
		show_help
		return 1
	fi

	# Parse options
	while [[ "$1" == -* ]]; do
		case "$1" in
		--backup | -b) backup=1 ;;
		--quiet | -q) quiet=1 ;;
		--debug | -d) debug=1 ;;
		--dry-run | -n) dry_run=1 ;;
		--verbose | -v) verbose=1 ;;
		--yes | -y) auto_confirm=1 ;;
		--help | -h)
			show_help
			return 0
			;;
		*)
			echo -e "${BRIGHT_RED}Error:${RESET} Unknown option: $1"
			return 1
			;;
		esac
		shift
	done

	# Check if at least input log was provided
	if [ $# -lt 1 ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Missing required input log argument."
		show_help
		return 1
	fi

	input_log="$1"

	# If replacement file is not provided, use basename with configured extension
	if [ $# -lt 2 ]; then
		# Get the basename without extension
		local basename=$(basename "$input_log")
		local filename="${basename%.*}"

		# Create the replacement filename with configured extension
		replace_file="${filename}.${DEFAULT_EXTENSION}"

		[ $quiet -eq 0 ] && echo -e "${BRIGHT_CYAN}No replacement file specified. Using:${RESET} ${BRIGHT_YELLOW}$replace_file${RESET}"
	else
		replace_file="$2"
	fi

	# Check if files exist
	if [ ! -f "$input_log" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Input log file not found: ${BRIGHT_YELLOW}$input_log${RESET}"
		return 1
	fi

	if [ ! -f "$replace_file" ]; then
		echo -e "${BRIGHT_RED}Error:${RESET} Replacement file not found: ${BRIGHT_YELLOW}$replace_file${RESET}"
		return 1
	fi

	# Create backup of original file if requested
	if [ $backup -eq 1 ]; then
		cp "$replace_file" "${replace_file}.bak"
		chmod $BACKUP_PERMISSIONS "${replace_file}.bak"
		[ $quiet -eq 0 ] && echo -e "${BRIGHT_CYAN}Created backup:${RESET} ${BRIGHT_YELLOW}${replace_file}.bak${RESET}"
	fi

	# Count of replacements made
	local replacement_count=0
	local line_count=0
	local match_count=0
	local skipped_count=0

	[ $quiet -eq 0 ] && echo -e "${BRIGHT_CYAN}Processing log file:${RESET} ${BRIGHT_YELLOW}$input_log${RESET}"

	# Extract REF and RES values using configurable patterns
	while IFS= read -r line; do
		((line_count++))

		[ $debug -eq 1 ] && echo -e "Reading line ${BRIGHT_YELLOW}$line_count${RESET}: ${line:0:50}..."

		if [[ $line =~ $RESULT_IDENTIFIER ]]; then
			((match_count++))
			ref_value=$(echo "$line" | sed -r "s/.*${REF_PATTERN}\s*([0-9.E+-]+)/\1/")
			res_value=$(echo "$line" | sed -r "s/.*${RES_PATTERN}\s*([0-9.E+-]+)/\1/")

			if [ -z "$ref_value" ] || [ -z "$res_value" ]; then
				[ $quiet -eq 0 ] && echo -e "${BRIGHT_YELLOW}Warning:${RESET} Failed to extract values from line $line_count"
				continue
			fi

			if [ $verbose -eq 1 ] || [ $debug -eq 1 ]; then
				echo -e "Found match: ${REF_PATTERN}${BRIGHT_YELLOW}$ref_value${RESET} ${RES_PATTERN}${BRIGHT_GREEN}$res_value${RESET}"
			fi

			# Check if the replacement is necessary (values are different)
			if [ "$ref_value" == "$res_value" ]; then
				[ $verbose -eq 1 ] && echo -e "${BRIGHT_YELLOW}Skipping${RESET} identical values: $ref_value"
				continue
			fi

			# Find occurrences in replacement file
			if grep -q "$ref_value" "$replace_file"; then
				# Display original log line
				echo -e "\n${BRIGHT_WHITE}Original log line:${RESET}"
				echo -e "${BRIGHT_CYAN}$line${RESET}"

				# Display the lines that will be modified
				echo -e "\n${BRIGHT_WHITE}Lines to be modified in ${BRIGHT_YELLOW}$replace_file${BRIGHT_WHITE}:${RESET}"
				grep --color=always -n "$ref_value" "$replace_file"

				# Ask for confirmation unless auto-confirm is set
				if [ $dry_run -eq 1 ]; then
					echo -e "\n${BRIGHT_CYAN}Would replace:${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} (Dry run)"
				elif [ $auto_confirm -eq 1 ]; then
					# Count occurrences before replacement
					local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
					sed -i "s/$ref_value/$res_value/g" "$replace_file"
					((replacement_count += occurrences))
					echo -e "\n${BRIGHT_CYAN}Automatically replaced:${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"
				else
					echo -e "\n${BRIGHT_WHITE}Replace${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET}? (y/n/a/q)"
					echo -e "  y = yes, n = no, a = yes to all, q = quit"
					read -r answer
					case "$answer" in
					[Yy]*)
						# Count occurrences before replacement
						local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
						sed -i "s/$ref_value/$res_value/g" "$replace_file"
						((replacement_count += occurrences))
						echo -e "${BRIGHT_CYAN}Replaced:${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"
						;;
					[Aa]*)
						auto_confirm=1
						local occurrences=$(grep -o "$ref_value" "$replace_file" | wc -l)
						sed -i "s/$ref_value/$res_value/g" "$replace_file"
						((replacement_count += occurrences))
						echo -e "${BRIGHT_CYAN}Replaced:${RESET} ${BRIGHT_YELLOW}$ref_value${RESET} with ${BRIGHT_GREEN}$res_value${RESET} ($occurrences occurrences)"
						echo -e "${BRIGHT_YELLOW}Auto-confirm enabled for remaining replacements.${RESET}"
						;;
					[Qq]*)
						echo -e "${BRIGHT_YELLOW}Operation cancelled by user.${RESET}"
						break
						;;
					*)
						((skipped_count++))
						echo -e "${BRIGHT_YELLOW}Skipped:${RESET} $ref_value"
						;;
					esac
				fi
			else
				[ $verbose -eq 1 ] && echo -e "${BRIGHT_YELLOW}No occurrences found for:${RESET} $ref_value"
			fi
		fi
	done <"$input_log"

	# Summary
	if [ $quiet -eq 0 ]; then
		echo -e "\n${BRIGHT_WHITE}Summary:${RESET}"
		echo -e "  ${BRIGHT_CYAN}Lines processed:${RESET} ${BRIGHT_YELLOW}$line_count${RESET}"
		echo -e "  ${BRIGHT_CYAN}Matches found:${RESET} ${BRIGHT_YELLOW}$match_count${RESET}"

		if [ $dry_run -eq 1 ]; then
			echo -e "  ${BRIGHT_CYAN}Replacements (dry run):${RESET} ${BRIGHT_YELLOW}$replacement_count${RESET}"
		else
			echo -e "  ${BRIGHT_CYAN}Replacements made:${RESET} ${BRIGHT_YELLOW}$replacement_count${RESET}"
			echo -e "  ${BRIGHT_CYAN}Replacements skipped:${RESET} ${BRIGHT_YELLOW}$skipped_count${RESET}"
		fi
	fi

	[ $quiet -eq 0 ] && echo -e "\n${BRIGHT_GREEN}Processing completed successfully!${RESET}"
	return 0
}

# If the script is being run directly, call process_logs.
# If it is sourced, the function will be available for later use.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	if [[ $# -eq 0 ]]; then
		process_logs
	else
		process_logs "$@"
	fi
fi
