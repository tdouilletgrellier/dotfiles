#!/bin/bash
#=====================================================================
#  LaTeX Project Archiver
#
#  PURPOSE:
#    Creates a ZIP archive for a LaTeX project by identifying and
#    collecting all dependent files based on a .dep or .tex file.
#    Supports explicit inclusion of additional files using patterns.
#
#  AUTHOR:
#    Original script enhanced with better comments and colors
#
#  USAGE:
#    ./gather_tex.sh <file.dep or file.tex> [-a <file_pattern> ...]
#
#  OPTIONS:
#    -a <pattern>    Add files matching the pattern to the archive
#    -q              Quiet mode (errors only)
#    -v              Verbose mode (detailed information)
#    -h, --help      Display help information
#=====================================================================

#=====================================================================
# COLOR DEFINITIONS
# These colors are used for console output to make information easier
# to differentiate and read at a glance
#=====================================================================
GREEN="\e[32m"    # Success messages
YELLOW="\e[33m"   # Warnings and information
RED="\e[31m"      # Error messages
CYAN="\e[36m"     # Processing steps
BLUE="\e[34m"     # File operations
MAGENTA="\e[35m"  # Important information
WHITE="\e[97m"    # Highlighted text
BOLD="\e[1m"      # Bold text
ITALIC="\e[3m"    # Italic text
UNDERLINE="\e[4m" # Underlined text
RESET="\e[0m"     # Reset formatting

# Define exit codes for better error handling
EXIT_SUCCESS=0
EXIT_MISSING_ARG=1
EXIT_FILE_NOT_FOUND=2
EXIT_INVALID_OPTION=3
EXIT_PERMISSION_ERROR=4
EXIT_ZIP_ERROR=5

# Default verbosity level (0=quiet, 1=normal, 2=verbose)
VERBOSITY=1

#=====================================================================
# FUNCTION: log_message
#
# PURPOSE:
#   Displays log messages to the console based on verbosity level.
#   Different message types are displayed in different colors.
#
# PARAMETERS:
#   $1 - Minimum verbosity level required to show message
#   $2 - Color code for the message
#   $3 - The message text
#
# EXAMPLE:
#   log_message 1 "$GREEN" "File successfully processed"
#=====================================================================
log_message() {
	local level=$1
	local color=$2
	local message=$3

	if [[ $VERBOSITY -ge $level ]]; then
		echo -e "${color}${message}${RESET}"
	fi
}

#=====================================================================
# FUNCTION: log_error
#
# PURPOSE:
#   Displays error messages to stderr. These are always shown
#   regardless of verbosity level.
#
# PARAMETERS:
#   $1 - The error message text
#
# EXAMPLE:
#   log_error "Failed to create directory"
#=====================================================================
log_error() {
	local message=$1
	echo -e "${BOLD}${RED}[Error] ${message}${RESET}" >&2
}

#=====================================================================
# FUNCTION: show_help
#
# PURPOSE:
#   Displays comprehensive, color-coded help information about
#   the script's usage, options, and examples.
#
# PARAMETERS:
#   None
#
# OUTPUTS:
#   Help text to stdout
#=====================================================================
show_help() {
	echo -e "${BOLD}${CYAN}=====================================================================
 LaTeX Project Archiver
=====================================================================
${RESET}"
	echo -e "${BOLD}${YELLOW}USAGE:${RESET}"
	echo -e "  $(basename "$0") ${UNDERLINE}<file.dep or file.tex>${RESET} [${ITALIC}options${RESET}]"
	echo -e ""
	echo -e "${BOLD}${YELLOW}OPTIONS:${RESET}"
	echo -e "  ${WHITE}-a ${UNDERLINE}<file_pattern>${RESET}  Explicitly add file(s) to the archive. Glob patterns are supported."
	echo -e "  ${WHITE}-q${RESET}                 Quiet mode (show only errors)"
	echo -e "  ${WHITE}-v${RESET}                 Verbose mode (show detailed information)"
	echo -e "  ${WHITE}-h, --help${RESET}         Show this help message and exit"
	echo -e ""
	echo -e "${BOLD}${YELLOW}DESCRIPTION:${RESET}"
	echo -e "  This script reads a .dep file or parses a .tex file,"
	echo -e "  collects all listed/included files, and packages them"
	echo -e "  into a ZIP archive. Users can manually add extra files"
	echo -e "  using the -a option, which supports glob patterns for"
	echo -e "  matching multiple files at once. To generate a .dep "
	echo -e "  file, recompile your LaTeX project with "
	echo -e "  ${WHITE}\\RequirePackage{snapshot}${RESET} at the top of your main "
	echo -e "  file, before ${WHITE}\\documentclass${RESET}."
	echo -e ""
	echo -e "${BOLD}${YELLOW}EXAMPLES:${RESET}"
	echo -e "  ${GREEN}$(basename "$0") project.dep -a figures/extra.png -a notes.txt${RESET}"
	echo -e "  ${GREEN}$(basename "$0") project.tex -v${RESET}"
	echo -e "  ${GREEN}$(basename "$0") project.tex -a 'images/*.png'${RESET}"
	echo -e "  ${GREEN}$(basename "$0") project.tex -a 'figures/graph-*.pdf' -a 'data/*.csv'${RESET}"
	echo -e "  ${GREEN}$(basename "$0") project.tex -a 'path-to-folder/file*.png'${RESET}"
	echo ""
	exit $EXIT_SUCCESS
}

#=====================================================================
# FUNCTION: process_animated_graphics
#
# PURPOSE:
#   Extracts and processes \animategraphics commands from LaTeX files.
#   These commands are used for animations in LaTeX presentations.
#
# ALGORITHM:
#   1. Scans the specified tex file for \animategraphics commands
#   2. Extracts the prefix, first and last frame numbers
#   3. Generates a list of all frame filenames in the sequence
#
# PARAMETERS:
#   $1 - Path to the .tex file to analyze
#
# RETURNS:
#   Space-separated list of animation frame files
#
# EXAMPLE LaTeX CODE HANDLED:
#   \animategraphics[width=\textwidth]{12}{animation-}{1}{30}
#=====================================================================
process_animated_graphics() {
	local tex_file="$1"
	local tex_dir=$(dirname "$tex_file")
	local deps=()

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Scanning $tex_file for animated graphics..."

	# Use perl for more robust extraction of animated graphics commands
	local animations=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\animategraphics(?:\[[^\]]*\])?\{([^}]+)\}\{([^}]+)\}\{([^}]+)\}\{([^}]+)\}/g) {
			print "$1|$2|$3|$4\n";
		}')

	while IFS='|' read -r fps prefix first last; do
		[[ -z "$fps" ]] && continue

		log_message 2 "$MAGENTA" "[${BOLD}Animation${RESET}${MAGENTA}] Found sequence: ${WHITE}$prefix${RESET}${MAGENTA} from ${WHITE}$first${RESET}${MAGENTA} to ${WHITE}$last${RESET}"

		# Validate that first and last are numeric
		if ! [[ "$first" =~ ^[0-9]+$ ]] || ! [[ "$last" =~ ^[0-9]+$ ]]; then
			log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Non-numeric frame numbers: fps=$fps, prefix=$prefix, first=$first, last=$last"
			continue
		fi

		# Generate the frame filenames
		for ((i = first; i <= last; i++)); do
			# Determine if we need to add an extension
if [[ "$prefix" =~ \.[a-zA-Z]+$ ]]; then
    deps+=("$prefix$i")
else
    local resolved_path=$(try_extensions "$prefix$i" "$tex_dir")
    if [[ -n "$resolved_path" ]]; then
        # Extract just the filename with extension
        local filename=$(basename "$resolved_path")
        deps+=("$filename")
    else
        # Default to png if no file is found
        deps+=("$prefix$i.png")
    fi
fi
		done
	done <<<"$animations"

	echo "${deps[@]}"
}

#=====================================================================
# FUNCTION: resolve_path
#
# PURPOSE:
#   Resolves a file path considering absolute and relative paths
#
# PARAMETERS:
#   $1 - File path to resolve
#   $2 - Base directory to use for relative paths
#
# RETURNS:
#   Resolved file path if found, empty string otherwise
#=====================================================================
resolve_path() {
	local file="$1"
	local base_dir="$2"

	if [[ "$file" == /* ]]; then
		# Absolute path
		if [[ -f "$file" ]]; then
			echo "$file"
			return 0
		fi
	else
		# Try relative to base directory
		if [[ -f "$base_dir/$file" ]]; then
			echo "$base_dir/$file"
			return 0
		fi
		# Try relative to project root
		if [[ -f "$BASE_DIR/$file" ]]; then
			echo "$BASE_DIR/$file"
			return 0
		fi
	fi

	# File not found
	return 1
}

#=====================================================================
# FUNCTION: try_extensions
#
# PURPOSE:
#   Tries to find a file with different extensions
#
# PARAMETERS:
#   $1 - Base file name without extension
#   $2 - Base directory to search in
#
# RETURNS:
#   File path with extension if found, empty string otherwise
#=====================================================================
try_extensions() {
	local file="$1"
	local base_dir="$2"

	# If file already has extension
	if [[ "$file" =~ \.[a-zA-Z]+$ ]]; then
		resolve_path "$file" "$base_dir" && return 0
		return 1
	fi

	# Try different extensions
	for ext in tex pdf png jpg jpeg eps svg tikz; do
		local result=$(resolve_path "${file}.${ext}" "$base_dir")
		if [[ -n "$result" ]]; then
			echo "$result"
			return 0
		fi
	done

	return 1
}

#=====================================================================
# FUNCTION: extract_tex_dependencies
#
# PURPOSE:
#   Recursively extracts all dependencies from a .tex file including:
#   - Included/input files (\input, \include, etc.)
#   - Graphics files (\includegraphics)
#   - Animation frames (\animategraphics)
#
# ALGORITHM:
#   1. Prevents circular references with a processed files list
#   2. Extracts LaTeX commands for file inclusion
#   3. Processes each dependency, adding file extensions as needed
#   4. Recursively processes included .tex files
#   5. Returns a deduplicated list of all dependencies
#
# PARAMETERS:
#   $1 - Path to the .tex file to analyze
#
# RETURNS:
#   Space-separated list of all dependency files
#=====================================================================
extract_tex_dependencies() {
	local tex_file="$1"
	local tex_dir=$(dirname "$tex_file")
	local deps=()

	# Use an associative array for processed files to improve lookup efficiency
	local -A processed_files

	# To prevent infinite recursion for circular references
	local file_hash=$(realpath "$tex_file")
	if [[ -n "${processed_files[$file_hash]}" ]]; then
		log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Already processed: $tex_file"
		return
	fi
	processed_files[$file_hash]=1

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Scanning $tex_file for dependencies..."

	# Extract includes and inputs using perl for better accuracy
	local includes=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\(input|include|includeonly|bibliography|addbibresource)\{([^}]+)\}/g) { print "$2\n"; }')

	# Extract graphics with perl for more robust extraction
	local graphics=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\includegraphics(?:\[[^\]]*\])?\{([^}]+)\}/g) { print "$1\n"; }')

	# Extract other graphics commands
	local other_graphics=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\(pgfimage|overpic|includesvg|includestandalone)(?:\[[^\]]*\])?\{([^}]+)\}/g) { print "$2\n"; }')

	# Extract TikZ external graphics
	local tikz_graphics=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\(input|include)\{([^}]+\.tikz)\}/g) { print "$2\n"; }')

	# Extract import/subimport packages
	local imports=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\(import|subimport)\{([^}]+)\}\{([^}]+)\}/g) {
			$dir = $2; $file = $3;
			$file .= ".tex" unless $file =~ /\.[a-zA-Z]+$/;
			print "$dir/$file\n";
		}')

	# Extract LaTeX packages
	local packages=$(grep -v '^\s*%' "$tex_file" |
		perl -n -e 'while (/\\usepackage(?:\[[^\]]*\])?\{([^}]+)\}/g) {
			foreach $pkg (split(/,/, $1)) {
				$pkg =~ s/^\s+|\s+$//g; # Trim whitespace
				print "$pkg.sty\n" unless $pkg =~ /^(standard|core)$/i;
			}
		}')

	# Process animated graphics
	local animated_graphics=($(process_animated_graphics "$tex_file"))
	for anim in "${animated_graphics[@]}"; do
		deps+=("$anim")
	done

process_dependency() {
    local dep="$1"
    local tex_dir="$2"
    local type="$3"  # "tex", "image", "package", etc.

    local resolved_path=$(try_extensions "$dep" "$tex_dir")
    if [[ -n "$resolved_path" ]]; then
        # Make path relative to tex_dir for deps
        if [[ "$resolved_path" == /* ]]; then
            local rel_path=$(realpath --relative-to="$tex_dir" "$resolved_path")
            deps+=("$rel_path")
        else
            deps+=("$dep")
        fi

        # Recursively process included tex files (only for .tex files)
        if [[ "$type" == "tex" && "$resolved_path" == *.tex ]]; then
            local nested_deps=($(extract_tex_dependencies "$resolved_path"))
            for nested in "${nested_deps[@]}"; do
                deps+=("$nested")
            done
        fi
        return 0
    else
        log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Could not find $type: $dep"

        # For graphics, we still want to include the path even if file not found
        if [[ "$type" == "image" ]]; then
            deps+=("$dep")
        fi
        return 1
    fi
}

	# Process all includes and bibliography files
	for inc in $includes; do
		# Add appropriate extension if not present
		if [[ ! "$inc" =~ \.[a-zA-Z]+$ ]]; then
			# For bibliography entries
			if [[ "$inc" =~ ^.*bibliography.*$ ]]; then
				inc="${inc}.bib"
			else
				inc="${inc}.tex"
			fi
		fi

		process_dependency "$inc" "$tex_dir" "tex"
	done

	# Process import/subimport files
	for imp in $imports; do
		process_dependency "$imp" "$tex_dir" "import"
	done

	# Process standard graphics
	for img in $graphics $other_graphics $tikz_graphics; do
		process_dependency "$img" "$tex_dir" "image"
	done

	# Process packages (optional, depending on your needs)
	for pkg in $packages; do
		# Check if package exists in TEXMF paths
		local pkg_path=$(kpsewhich "$pkg" 2>/dev/null)
		if [[ -n "$pkg_path" ]]; then
			deps+=("$pkg")
		fi
	done

	# Return all dependencies (sort and remove duplicates)
	echo "${deps[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

#=====================================================================
# FUNCTION: process_glob_pattern
#
# PURPOSE:
#   Processes a glob pattern and adds all matching files to the archive.
#   Handles both absolute and relative paths in patterns.
#
# ALGORITHM:
#   1. Separates directory and filename components of the pattern
#   2. Handles path separators appropriately
#   3. Processes files matching the pattern
#   4. Reports success or failure
#
# PARAMETERS:
#   $1 - Glob pattern to process (e.g., "images/*.png")
#   $2 - Temporary directory for the archive
#   $3 - Base directory (project root)
#
# RETURNS:
#   Number of files successfully processed
#=====================================================================
process_glob_pattern() {
	local pattern="$1"
	local temp_dir="$2"
	local base_dir="$3"
	local count=0

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Glob pattern: ${WHITE}$pattern${RESET}"

	# Special handling for patterns with path separators
	if [[ "$pattern" == *"/"* ]]; then
		local pattern_dir=$(dirname "$pattern")
		local pattern_file=$(basename "$pattern")

		# Check if pattern_dir is absolute or relative path
		if [[ "$pattern_dir" == /* ]]; then
			# Absolute path
			for file in $pattern_dir/$pattern_file; do
				if [[ -f "$file" ]]; then
					copy_file "$file" "$temp_dir" "$base_dir"
					((count++))
				fi
			done
		else
			# Relative path
			for file in $pattern_dir/$pattern_file; do
				if [[ -f "$file" ]]; then
					copy_file "$file" "$temp_dir" "$base_dir"
					((count++))
				fi
			done
		fi
	else
		# Simple filename pattern (no directory)
		for file in $pattern; do
			if [[ -f "$file" ]]; then
				copy_file "$file" "$temp_dir" "$base_dir"
				((count++))
			fi
		done
	fi

	if [[ $count -eq 0 ]]; then
		log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] No files match pattern: $pattern"
	else
		log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $count files matching pattern: ${WHITE}$pattern${RESET}"
	fi

	return $count
}

#=====================================================================
# FUNCTION: copy_file
#
# PURPOSE:
#   Copies a file to the temporary directory while preserving the
#   relative directory structure.
#
# ALGORITHM:
#   1. Determines if file path is relative to BASE_DIR
#   2. Creates necessary subdirectories
#   3. Copies the file to the correct location
#   4. Reports success or failure
#
# PARAMETERS:
#   $1 - Source file path
#   $2 - Temporary directory (destination)
#   $3 - Base directory (project root)
#
# RETURNS:
#   0 on success, 1 on failure
#=====================================================================
declare -A processed_files
copy_file() {
	local file="$1"
	local temp_dir="$2"
	local base_dir="$3"
	local target_path

	# Check if file exists
	if [[ -f "$file" ]]; then
		# For files in BASE_DIR, make them relative to BASE_DIR
		if [[ "$(realpath "$file")" == "$(realpath "$base_dir")"* ]]; then
			target_path=$(realpath --relative-to="$base_dir" "$file")
		else
			# For files not in BASE_DIR, keep their relative path from current directory
			target_path=$(realpath --relative-base="$(pwd)" "$file")
		fi

		# Remove any leading slash to ensure it's always a relative path
		target_path="${target_path#/}"
		
		# Check if file has already been processed using the target_path as key
		if [[ -n "${processed_files[$target_path]}" ]]; then
			log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] $target_path (already processed)"
			return 0
		fi
		
		# Mark this file as processed to prevent duplicate messages
		processed_files[$target_path]=1

		# Create directories in TEMP_DIR
		local dir_path="$(dirname "$target_path")"
		if [[ "$dir_path" != "." ]]; then
			mkdir -p "$temp_dir/$dir_path"
			if [ $? -ne 0 ]; then
				log_error "Failed to create directory: $temp_dir/$dir_path"
				return 1
			fi
		fi

		# Skip if file already exists at destination
		if [[ -f "$temp_dir/$target_path" ]]; then
			log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] $target_path (already exists)"
			return 0
		fi

		# Copy the file to the temporary directory
		cp "$file" "$temp_dir/$target_path"
		if [ $? -ne 0 ]; then
			log_error "Failed to copy file: $file to $temp_dir/$target_path"
			return 1
		fi
		# Always display relative path in logs
		log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $target_path"
		return 0

    # Case-insensitive check if the exact case doesn't match
    elif [[ -d "$(dirname "$file")" ]]; then
        local dir_path="$(dirname "$file")"
        local file_name="$(basename "$file")"
        local found_file=$(find "$dir_path" -maxdepth 1 -type f -iname "$file_name" | head -n 1)

        if [[ -n "$found_file" ]]; then
            log_message 1 "$YELLOW" "[${BOLD}Case Mismatch${RESET}${YELLOW}] Using $found_file instead of $file"
            # Reuse resolve_path logic by calling copy_file recursively with the found file
            copy_file "$found_file" "$temp_dir" "$base_dir"
            return $?
        fi

        log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
        return 1
    else
        log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
        return 1
    fi
}

#=====================================================================
# FUNCTION: create_archive
#
# PURPOSE:
#   Main function that creates the ZIP archive based on the input
#   file (.dep or .tex) and command-line options.
#
# ALGORITHM:
#   1. Processes command-line arguments
#   2. Determines project name and output file name
#   3. Handles different input file types (.dep or .tex)
#   4. Creates a temporary directory for staging files
#   5. Processes all dependencies and extra patterns
#   6. Creates the ZIP archive
#   7. Moves the archive to its final destination
#
# PARAMETERS:
#   All command-line arguments passed to the script
#
# RETURNS:
#   Exit code (0 on success, non-zero on failure)
#=====================================================================
create_archive() {
	local INPUT_FILE="$1"
	shift
	local EXTRA_PATTERNS=()
	local MAIN_FILE="$INPUT_FILE"

	# Reset our processed files tracking for each archive creation
	declare -gA processed_files=()

	# Process options
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-a)
			if [[ -n "$2" ]]; then
				EXTRA_PATTERNS+=("$2")
				shift 2
			else
				log_error "Missing file pattern after -a option."
				exit $EXIT_MISSING_ARG
			fi
			;;
		-q)
			VERBOSITY=0
			shift
			;;
		-v)
			VERBOSITY=2
			shift
			;;
		-h | --help)
			show_help
			;;
		*)
			log_error "Unknown argument: $1"
			show_help
			exit $EXIT_INVALID_OPTION
			;;
		esac
	done

	# Check if input file exists
	if [[ ! -f "$INPUT_FILE" ]]; then
		log_error "Input file not found: $INPUT_FILE"
		exit $EXIT_FILE_NOT_FOUND
	fi

	# Export BASE_DIR as global for use in functions
	export BASE_DIR=$(dirname "$(realpath "$INPUT_FILE")")
	local INPUT_BASENAME=$(basename "$INPUT_FILE")
	local INPUT_EXT="${INPUT_BASENAME##*.}"
	local PROJECT_NAME="${INPUT_BASENAME%.*}"
	local ZIP_FILE="$BASE_DIR/${PROJECT_NAME}.zip"
	local files_to_process=()

	log_message 1 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Processing file: ${WHITE}$INPUT_FILE${RESET}"
	log_message 1 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Archive name: ${WHITE}$ZIP_FILE${RESET}"

	# Handle different input file types
	if [[ "$INPUT_EXT" == "dep" ]]; then
		log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Reading dependency file..."

		# Extract all files directly mentioned in the .dep file
		local all_files=($(sed -n 's/.*\*{file}\s*{\([^}]*\)}.*/\1/p' "$INPUT_FILE"))

		# Extract all class names used
		local all_classes=($(sed -n 's/.*\*{class}\s*{\([^}]*\)}.*/\1/p' "$INPUT_FILE"))

		# Extract all beamer themes if beamer class is used
		local beamer_themes=()
		if [[ " ${all_classes[*]} " =~ " beamer " ]]; then
			beamer_themes=($(sed -n 's/.*\*{package}{beamertheme\([^}]*\)}.*/\1/p' "$INPUT_FILE"))
			log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Beamer class detected, looking for themes..."
		fi

		files_to_process=()

		# Filter out unwanted extensions
		# =================  EXCLUDED EXTENSIONS (customize as needed) =================
		local excluded_extensions=("bbl" "out" "aux" "log" "toc")
		# ==============================================================================

		# Process regular files
		for file in "${all_files[@]}"; do
			local file_ext="${file##*.}"
			if [[ " ${excluded_extensions[*]} " =~ " ${file_ext} " ]]; then
				log_message 2 "$YELLOW" "[${BOLD}Excluded${RESET}${YELLOW}] Skipping file with excluded extension: $file"
			else
				files_to_process+=("$file")
				log_message 2 "$BLUE" "[${BOLD}Dependency${RESET}${BLUE}] Found in .dep: $file"
			fi
		done

		# Add class files (.cls)
		for class in "${all_classes[@]}"; do
			files_to_process+=("$class.cls")
			log_message 2 "$MAGENTA" "[${BOLD}Class${RESET}${MAGENTA}] Adding class file: $class.cls"
		done

		# Add beamer theme files (.sty)
		for theme in "${beamer_themes[@]}"; do
			files_to_process+=("beamertheme$theme.sty")
			log_message 2 "$MAGENTA" "[${BOLD}Beamer Theme${RESET}${MAGENTA}] Adding theme: beamertheme$theme.sty"
		done

		MAIN_FILE="$BASE_DIR/${PROJECT_NAME}.tex"

		# Add dependencies from main tex file
		if [[ -f "$MAIN_FILE" ]]; then
			local tex_deps=($(extract_tex_dependencies "$MAIN_FILE"))
			files_to_process+=("${tex_deps[@]}")
		else
			log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Main file not found: $MAIN_FILE"
		fi

	elif [[ "$INPUT_EXT" == "tex" ]]; then
		log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Extracting dependencies from LaTeX file..."
		# Extract dependencies from .tex file
		files_to_process=($(extract_tex_dependencies "$INPUT_FILE"))
	else
		log_error "Unsupported input file type: .$INPUT_EXT (expected .dep or .tex)"
		exit $EXIT_INVALID_OPTION
	fi

	log_message 1 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Expected main LaTeX file: ${WHITE}$MAIN_FILE${RESET}"

	# Create temporary directory
	local TEMP_DIR=$(mktemp -d)
	if [ $? -ne 0 ]; then
		log_error "Failed to create temporary directory."
		exit $EXIT_PERMISSION_ERROR
	fi
	log_message 2 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Created temporary directory: ${WHITE}$TEMP_DIR${RESET}"

	# Trap to clean up temp directory on exit
	trap "rm -rf '$TEMP_DIR'" EXIT

	# =================  INCLUDED EXTENSIONS (customize as needed) =================
	local image_extensions=("png" "jpeg" "jpg" "bmp" "pdf" "eps" "gif")
	local tex_extensions=("tex" "tikz" "bib" "sty" "cls")
	# ==============================================================================

	# Always include the main file
	copy_file "$MAIN_FILE" "$TEMP_DIR" "$BASE_DIR"
	if [ $? -ne 0 ]; then
		log_error "Failed to copy main file. Aborting."
		exit $EXIT_PERMISSION_ERROR
	fi

	# Extract the folder name from \tikzexternalize[prefix=...]
	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Checking for TikZ externalization folder..."
	TIKZFOLDER=$(grep -oP '\\tikzexternalize\[prefix=\K[^]]+' "$MAIN_FILE" | sed 's/\/$//' | tr -d '{}')

	# If TIKZFOLDER is not empty
	if [[ -n "$TIKZFOLDER" ]]; then
		# Handle relative paths - make sure TIKZFOLDER is relative to BASE_DIR
		if [[ "$TIKZFOLDER" != /* ]]; then
			TIKZFOLDER_FULL="$BASE_DIR/$TIKZFOLDER"
		else
			TIKZFOLDER_FULL="$TIKZFOLDER"
		fi

		log_message 2 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Found TikZ externalization folder: ${WHITE}$TIKZFOLDER${RESET}"

		# Check if the folder exists
		if [[ ! -d "$TIKZFOLDER_FULL" ]]; then
			# Folder doesn't exist, create it and add to TEMP_DIR
			mkdir -p "$TEMP_DIR/$TIKZFOLDER"
			if [ $? -ne 0 ]; then
				log_error "Failed to create TikZ folder: $TEMP_DIR/$TIKZFOLDER"
				# Continue execution rather than exiting
			else
				log_message 1 "$GREEN" "[${BOLD}Created${RESET}${GREEN}] TikZ folder: $TIKZFOLDER"
			fi
		elif [[ "$(ls -A "$TIKZFOLDER_FULL" 2>/dev/null)" ]]; then
			# Folder exists and is not empty, add the files to TEMP_DIR
			mkdir -p "$TEMP_DIR/$TIKZFOLDER"
			if [ $? -ne 0 ]; then
				log_error "Failed to create TikZ folder: $TEMP_DIR/$TIKZFOLDER"
			else
				# Copy files matching project name pattern
				cp -r "$TIKZFOLDER_FULL/${PROJECT_NAME}"* "$TEMP_DIR/$TIKZFOLDER/" 2>/dev/null
				if [ $? -ne 0 ]; then
					log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] No TikZ files matching ${PROJECT_NAME}* found in $TIKZFOLDER"
				else
					log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] TikZ files from: $TIKZFOLDER"
				fi
			fi
		else
			# Folder exists but is empty, add it to TEMP_DIR
			mkdir -p "$TEMP_DIR/$TIKZFOLDER"
			if [ $? -ne 0 ]; then
				log_error "Failed to create TikZ folder: $TEMP_DIR/$TIKZFOLDER"
			else
				log_message 1 "$YELLOW" "[${BOLD}Note${RESET}${YELLOW}] TikZ folder exists but is empty: $TIKZFOLDER"
			fi
		fi
	else
		log_message 2 "$YELLOW" "[${BOLD}Info${RESET}${YELLOW}] No TikZ externalization detected in $MAIN_FILE"
	fi

	# Remove duplicates from files_to_process
	readarray -t files_to_process_unique < <(printf '%s\n' "${files_to_process[@]}" | sort -u)

	# Process each file from the input file
	for file in "${files_to_process_unique[@]}"; do
		log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Checking file: ${WHITE}$file${RESET}"
		ext="${file##*.}"

		# Check for full path or relative path
		local resolved_path=$(resolve_path "$file" "$BASE_DIR")
		if [[ -n "$resolved_path" ]]; then
			copy_file "$resolved_path" "$TEMP_DIR" "$BASE_DIR"
			# The message is now handled inside copy_file with relative path
		else
			# Try with extensions if needed
			resolved_path=$(try_extensions "$file" "$BASE_DIR")
			if [[ -n "$resolved_path" ]]; then
				copy_file "$resolved_path" "$TEMP_DIR" "$BASE_DIR"
				# The message is now handled inside copy_file with relative path
			else
				# Try case-insensitive search as last resort
				local found_file=$(find "$BASE_DIR" -maxdepth 1 -type f -iname "$(basename "$file")" | head -n 1)
				if [[ -n "$found_file" ]]; then
					log_message 1 "$YELLOW" "[${BOLD}Case Mismatch${RESET}${YELLOW}] Using $found_file instead of $BASE_DIR/$file"
					copy_file "$found_file" "$TEMP_DIR" "$BASE_DIR"
					# The message is now handled inside copy_file with relative path
				else
					log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found : $file"
				fi
			fi
		fi

		# Handle patterns for image files with numeric suffixes
		if [[ "$file" =~ ^([^/]+/[^/]+)([-_])[0-9]+\.[a-zA-Z]+$ ]]; then
			folder="${file%/*}"
			base_name="${file##*/}"
			prefix="${base_name%[-_]*}"
			separator="${BASH_REMATCH[2]}" # Get the actual separator (dash or underscore)
			extension="${base_name##*.}"
			pattern="${prefix}${separator}*.$extension"
			pattern_key="${folder}/${pattern}"

			# Check if we've already processed this pattern
			if [[ -z "${processed_files[$pattern_key]}" ]]; then
				log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Pattern detected: ${WHITE}$pattern_key${RESET}"
				processed_files[$pattern_key]=1

				# Create directory if it doesn't exist
				mkdir -p "$TEMP_DIR/$folder"
				if [ $? -ne 0 ]; then
					log_error "Failed to create directory: $TEMP_DIR/$folder"
					exit $EXIT_PERMISSION_ERROR
				fi

				# Copy matching files to temporary directory
				for f in "$BASE_DIR/$folder"/$pattern; do
					if [[ -f "$f" ]]; then
						local target_file="$folder/$(basename "$f")"
						if [[ ! -f "$TEMP_DIR/$target_file" ]]; then
							cp "$f" "$TEMP_DIR/$target_file"
							if [ $? -ne 0 ]; then
								log_error "Failed to copy: $f"
								exit $EXIT_PERMISSION_ERROR
							fi
						fi
					fi
				done

				log_message 1 "$BLUE" "[${BOLD}Added${RESET}${BLUE}] $folder/$pattern (pattern)"
			else
				log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Pattern already processed: $pattern_key"
			fi
		fi
	done

	# Process any extra file patterns specified by the user
	for pattern in "${EXTRA_PATTERNS[@]}"; do
		process_glob_pattern "$pattern" "$TEMP_DIR" "$BASE_DIR"
	done

	# Create the ZIP archive
	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Creating ZIP archive..."
	(cd "$TEMP_DIR" && zip -r "$PROJECT_NAME.zip" . >/dev/null)
	if [ $? -ne 0 ]; then
		log_error "Failed to create ZIP archive."
		exit $EXIT_ZIP_ERROR
	fi

	# Make sure we're not trying to overwrite the output file while it's in use
	if [[ -f "$ZIP_FILE" ]]; then
		rm -f "$ZIP_FILE"
		if [ $? -ne 0 ]; then
			log_error "Failed to remove existing ZIP file. It may be in use."
			exit $EXIT_PERMISSION_ERROR
		fi
	fi

	mv "$TEMP_DIR/$PROJECT_NAME.zip" "$ZIP_FILE"
	if [ $? -ne 0 ]; then
		log_error "Failed to move ZIP archive to final destination."
		exit $EXIT_PERMISSION_ERROR
	fi

	log_message 1 "${BOLD}${GREEN}[${WHITE}Success${GREEN}] Archive created: ${WHITE}$ZIP_FILE${RESET}"
	log_message 1 "${BOLD}${GREEN}[${WHITE}Summary${GREEN}] ${#processed_files[@]} files added to archive${RESET}"

	return $EXIT_SUCCESS
}

#=====================================================================
# MAIN SCRIPT EXECUTION
#
# If no arguments are provided, show help.
# Otherwise, call create_archive with all arguments.
#=====================================================================
if [[ "$#" -eq 0 ]]; then
	show_help
else
	create_archive "$@"
	exit_code=$?
	exit $exit_code
fi
