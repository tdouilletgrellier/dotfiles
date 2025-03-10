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
# GLOBAL PARAMETERS
# Parameters that are used throughout the script
#=====================================================================

# Define exit codes for better error handling
EXIT_SUCCESS=0
EXIT_MISSING_ARG=1
EXIT_FILE_NOT_FOUND=2
EXIT_INVALID_OPTION=3
EXIT_PERMISSION_ERROR=4
EXIT_ZIP_ERROR=5

# Default verbosity level (0=quiet, 1=normal, 2=verbose)
VERBOSITY=1

# Default extension for image sequences (animategraphics)
DEFAULT_IMAGE_EXT_FOR_ANIMATEGRAPHICS="png"

# Valid extensions to look for
VALID_EXTENSIONS=(tex pdf png jpg jpeg eps svg tikz bib sty cls bst)

# Excluded extensions to look for
EXCLUDED_EXTENSIONS=(bbl out aux log toc)

# LaTeX keywords by category
LATEX_INCLUDES=("input" "include" "includeonly" "bibliography" "addbibresource" "includepdf" "includetikz" "bibliographystyle")
LATEX_GRAPHICS=("includegraphics")
LATEX_OTHER_GRAPHICS=("pgfimage" "overpic" "includesvg" "includestandalone")
LATEX_IMPORTS=("import" "subimport")
LATEX_TIKZ=("input" "include")
LATEX_PACKAGE=("usepackage")

# Graphics search folders
GRAPHICS_FOLDERS=("pictures" "figures" "images")
TIKZ_FOLDERS=("tikz" "tikz_in")

# Default file extensions
DEFAULT_BIB_EXT=".bib"
DEFAULT_BIBSTYLE_EXT=".bst"
DEFAULT_TEX_EXT=".tex"

# Recognized separators to catch multiple PNGs image_xxx.png or image-xxx.png
MULTIPLE_FILES_SEPARATORS="_-" # Default "_" and "-"

# Probable bibliography files patterns
BIB_PATTERNS=("biblio" "reference")
BIBSTYLE_PATTERNS=("bibstyle")

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

#=====================================================================
# GLOBAL VARIABLES
# Arrays that are used throughout the script
#=====================================================================
# Global variables to track processed items
declare -A processed_files
declare -A processed_patterns

# Valid extensions to look for
declare -A VALID_EXTENSIONS_DICT
for ext in "${VALID_EXTENSIONS[@]}"; do
	VALID_EXTENSIONS_DICT["$ext"]=1
done

# Excluded extensions to look for
declare -A EXCLUDED_EXTENSIONS_DICT
for ext in "${EXCLUDED_EXTENSIONS[@]}"; do
	EXCLUDED_EXTENSIONS_DICT["$ext"]=1
done

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

	# Fast path for absolute paths
	if [[ "$file" == /* ]]; then
		[[ -f "$file" ]] && echo "$file" && return 0
		return 1
	fi

	# Strip leading ./ to normalize paths
	# local clean_file="${file#./}"
	local clean_file="${file//.\//}"

	# Try relative to base directory first (most common case)
	if [[ -f "$base_dir/$clean_file" ]]; then
		echo "$base_dir/$clean_file"
		return 0
	fi

	# Try relative to project root if different
	if [[ "$base_dir" != "$BASE_DIR" && -f "$BASE_DIR/$clean_file" ]]; then
		echo "$BASE_DIR/$clean_file"
		return 0
	fi

	# Try current directory as last resort
	if [[ -f "$clean_file" ]]; then
		echo "$(pwd)/$clean_file"
		return 0
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

	# Remove leading ./ for consistency
	file="${file#./}"

	# If file already has extension, just check if it exists
	if [[ "$file" =~ \.[a-zA-Z]+$ ]]; then
		resolve_path "$file" "$base_dir" && return 0
		return 1
	fi

	# Try common extensions in order of likelihood
	# for ext in tex pdf png jpg jpeg eps svg tikz bib sty cls; do
	for ext in "${VALID_EXTENSIONS_DICT[@]}"; do

		local result=$(resolve_path "${file}.${ext}" "$base_dir")
		if [[ -n "$result" ]]; then
			echo "$result"
			return 0
		fi
	done

	return 1
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
#=====================================================================
process_animated_graphics() {
	local tex_file="$1"
	local tex_dir=$(dirname "$tex_file")
	local deps=()

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Scanning $tex_file for animated graphics..."

	# Use grep first to check if any animations exist before using perl
	if ! grep -a -q "\\\\animategraphics" "$tex_file"; then
		return
	fi

	# Optimize by only processing non-commented lines with animations
	local animations=$(grep -v '^\s*%' "$tex_file" |
		grep "\\\\animategraphics" |
		perl -n -e 'while (/\\animategraphics(?:\[[^\]]*\])?\{([^}]+)\}\{([^}]+)\}\{([^}]+)\}\{([^}]+)\}/g) {
            print "$1|$2|$3|$4\n";
        }')

	while IFS='|' read -r fps prefix first last; do
		[[ -z "$fps" ]] && continue

		log_message 2 "$MAGENTA" "[${BOLD}Animation${RESET}${MAGENTA}] Found sequence: ${WHITE}$prefix${RESET}${MAGENTA} from ${WHITE}$first${RESET}${MAGENTA} to ${WHITE}$last${RESET}"

		# Fast validation check for numbers
		if [[ ! "$first" =~ ^[0-9]+$ ]] || [[ ! "$last" =~ ^[0-9]+$ ]]; then
			log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Non-numeric frame numbers: fps=$fps, prefix=$prefix, first=$first, last=$last"
			continue
		fi

		# Generate frames - optimize by checking extension only once
		if [[ "$prefix" =~ \.[a-zA-Z]+$ ]]; then
			# Already has extension
			for ((i = first; i <= last; i++)); do
				deps+=("$prefix$i")
			done
		else
			# Check one time only for first frame to determine extension
			local resolved_path=$(try_extensions "$prefix$first" "$tex_dir")
			local ext="$DEFAULT_IMAGE_EXT_FOR_ANIMATEGRAPHICS" # Default extension

			if [[ -n "$resolved_path" ]]; then
				ext="${resolved_path##*.}"
			fi

			# Generate all frames with determined extension
			for ((i = first; i <= last; i++)); do
				deps+=("$prefix$i.$ext")
			done
		fi
	done <<<"$animations"

	echo "${deps[@]}"
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
	# local -A processed_tex_files

	# To prevent infinite recursion for circular references
	local file_hash=$(realpath "$tex_file")
	if [[ -n "${processed_files[$file_hash]}" ]]; then
		log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Already processed: $tex_file" >&2
		return
	fi
	processed_files[$file_hash]=1

	log_message 1 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Scanning $tex_file for dependencies..." >&2

	# Use grep to quickly check if each type of content exists before using perl
	local content=$(grep -a -v '^\s*%' "$tex_file")

	# Extract includes and inputs
	LATEX_INCLUDES_STR="${LATEX_INCLUDES[*]}"
	TIKZ_FOLDERS_STR="${TIKZ_FOLDERS[*]}"
	local includes=""
	if echo "$content" | grep -a -q -E "\\\\($(
		IFS='|'
		echo "${LATEX_INCLUDES[*]}"
	))"; then
		includes=$(echo "$content" | perl -n -e '
    BEGIN {
        @commands = split(/\s+/, "'"$LATEX_INCLUDES_STR"'");
        @folders = split(/\s+/, "'"$TIKZ_FOLDERS_STR"'");
        $pattern = join("|", map { $_ } @commands);  # Construct regex pattern without extra backslashes
    }
    while (/\\($pattern)\{([^}]+)\}/g) {
        $file = $2;
        foreach $folder (@folders) {
            print "$folder/$file\n";
        }
        print "$file\n";
    }')
	fi

	# Extract graphics
	LATEX_GRAPHICS_STR="${LATEX_GRAPHICS[*]}"
	GRAPHICS_FOLDERS_STR="${GRAPHICS_FOLDERS[*]}"
	local graphics=""
	if echo "$content" | grep -a -q -E "\\\\($(
		IFS='|'
		echo "${LATEX_GRAPHICS[*]}"
	))"; then
		graphics=$(echo "$content" | perl -n -e '
        BEGIN {
            @commands = split(/\s+/, "'"$LATEX_GRAPHICS_STR"'");
            @folders = split(/\s+/, "'"$GRAPHICS_FOLDERS_STR"'");
            $pattern = join("|", map { "\\\\" . $_ } @commands);  # Construct regex pattern
        }
        while (/$pattern(?:\[[^\]]*\])?\{([^}]+)\}/g) {
            $file = $1;
            foreach $folder (@folders) {
                print "$folder/$file\n";
            }
            print "$file\n";
        }')
	fi

	# Extract other graphics commands
	LATEX_OTHER_GRAPHICS_STR="${LATEX_OTHER_GRAPHICS[*]}"
	local other_graphics=""
	if echo "$content" | grep -a -q -E "\\\\($(
		IFS='|'
		echo "${LATEX_OTHER_GRAPHICS[*]}"
	))"; then
		other_graphics=$(echo "$content" |
			perl -n -e '
            BEGIN {
                @commands = split(/\s+/, "'"$LATEX_OTHER_GRAPHICS_STR"'");
                $pattern = join("|", map { "\\\\" . $_ } @commands);
            }
            while (/$pattern(?:\[[^\]]*\])?\{([^}]+)\}/g) {
                print "$1\n";
            }')
	fi

	# Extract TikZ external graphics
	LATEX_TIKZ_STR="${LATEX_TIKZ[*]}"
	TIKZ_FOLDERS_STR="${TIKZ_FOLDERS[*]}"
	local tikz_graphics=""
	if echo "$content" | grep -q '\.tikz'; then
		tikz_graphics=$(echo "$content" |
			perl -n -e '
            BEGIN {
                @folders = split(/\s+/, "'"$TIKZ_FOLDERS_STR"'");
                @commands = split(/\s+/, "'"$LATEX_TIKZ_STR"'");
                $pattern = join("|", map { "\\\\" . $_ } @commands);
            }
            while (/$pattern\{([^}]+\.tikz)\}/g) {
                $file = $1;
                foreach $folder (@folders) {
                    print "$folder/$file\n";
                }
                print "$file\n";
            }')
	fi
	# Extract import/subimport packages - only if found
	LATEX_IMPORTS_STR="${LATEX_IMPORTS[*]}"
	local imports=""
	if echo "$content" | grep -a -q -E "\\\\($(
		IFS='|'
		echo "${LATEX_IMPORTS[*]}"
	))"; then
		imports=$(echo "$content" |
			perl -n -e '
            BEGIN {
                @commands = split(/\s+/, "'"$LATEX_IMPORTS_STR"'");
                $pattern = join("|", map { "\\\\" . $_ } @commands);
            }
            while (/$pattern\{([^}]+)\}\{([^}]+)\}/g) {
                $dir = $1;
                $file = $2;
                $file .= ".tex" unless $file =~ /\.[a-zA-Z]+$/;
                print "$dir/$file\n";
            }')
	fi

	# Extract LaTeX packages - only if \usepackage is present
	LATEX_PACKAGE_STR="${LATEX_PACKAGE[*]}"
	local packages=""
	if echo "$content" | grep -a -q -E "\\\\($(
		IFS='|'
		echo "${LATEX_PACKAGE[*]}"
	))"; then
		packages=$(echo "$content" |
			perl -n -e '
            BEGIN {
                @commands = split(/\s+/, "'"$LATEX_PACKAGE_STR"'");
                $pattern = join("|", map { "\\\\" . $_ } @commands);
            }
            while (/$pattern(?:\[[^\]]*\])?\{([^}]+)\}/g) {
                foreach $pkg (split(/,/, $1)) {
                    $pkg =~ s/^\s+|\s+$//g; # Trim whitespace
                    print "$pkg.sty\n" unless $pkg =~ /^(standard|core)$/i;
                }
            }')
	fi

	# Process animated graphics
	local animated_graphics=($(process_animated_graphics "$tex_file"))
	for anim in "${animated_graphics[@]}"; do
		deps+=("$anim")
	done

	# Function to process dependencies - optimized
	process_dependency() {
		local dep="$1"
		local tex_dir="$2"
		local type="$3" # "tex", "image", "package", etc.

		# Skip if already processed
		local dep_key="${dep}:${type}"
		if [[ -n "${processed_files[$dep_key]}" ]]; then
			return 0
		fi
		processed_files[$dep_key]=1

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
				deps+=("${nested_deps[@]}")
			fi
			return 0
		else
			log_message 2 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Could not find $type: $dep" >&2

			# For graphics, we still want to include the path even if file not found
			if [[ "$type" == "image" ]]; then
				deps+=("$dep")
			fi
			return 1
		fi
	}

	# Process all includes and bibliography files (optimize extension handling)
	for inc in $includes; do
		# Add appropriate extension only if needed
		if [[ ! "$inc" =~ \.[a-zA-Z]+$ ]]; then
			# For bibliography entries
			IFS="|"
			BIB_PATTERN_STRING="${BIB_PATTERNS[*]}"
			BIBSTYLE_PATTERN_STRING="${BIBSTYLE_PATTERNS[*]}"
			if [[ "$inc" =~ ^.*(${BIB_PATTERN_STRING}).*$ ]]; then
				inc="${inc}${DEFAULT_BIB_EXT}"
			elif [[ "$inc" =~ ^.*(${BIBSTYLE_PATTERN_STRING}).*$ ]]; then				
				inc="${inc}${DEFAULT_BIBSTYLE_EXT}"
			else
				inc="${inc}${DEFAULT_TEX_EXT}"
			fi
			IFS=" "
		fi

		process_dependency "$inc" "$tex_dir" "tex"
	done

	# Process import/subimport files
	for imp in $imports; do
		process_dependency "$imp" "$tex_dir" "import"
	done

	# Process standard graphics - combine to reduce loops
	for img in $graphics $other_graphics $tikz_graphics; do
		[[ -z "$img" ]] && continue
		process_dependency "$img" "$tex_dir" "image"
	done

	# Process packages (optional, depending on your needs)
	# Use a faster check with hash lookup for package validation
	for pkg in $packages; do
		[[ -z "$pkg" ]] && continue
		# Instead of running kpsewhich for each package, just add to deps
		# and let the file copying step handle existence check
		deps+=("$pkg")
	done

	# Return all dependencies (use printf for faster output)
	printf "%s " "${deps[@]}"
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

		# Check if file has already been processed - fast hash lookup
		if [[ -n "${processed_files[$target_path]}" ]]; then
			log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] $target_path (already processed)"
			return 0
		fi

		# Mark this file as processed to prevent duplicate messages
		processed_files[$target_path]=1

		# Skip if file already exists at destination (faster than copying again)
		if [[ -f "$temp_dir/$target_path" ]]; then
			log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] $target_path (already exists)"
			return 0
		fi

		# Create directories in TEMP_DIR (only if needed)
		local dir_path="$(dirname "$target_path")"
		if [[ "$dir_path" != "." && ! -d "$temp_dir/$dir_path" ]]; then
			mkdir -p "$temp_dir/$dir_path"
			if [ $? -ne 0 ]; then
				log_error "Failed to create directory: $temp_dir/$dir_path"
				return 1
			fi
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

	# Case-insensitive check if the exact case doesn't match - optimize by checking dir first
	elif [[ -d "$(dirname "$file")" ]]; then
		local dir_path="$(dirname "$file")"
		local file_name="$(basename "$file")"
		# Use find with -iname for faster case-insensitive lookup
		local found_file=$(find "$dir_path" -maxdepth 1 -type f -iname "$file_name" | head -n 1)

		if [[ -n "$found_file" ]]; then
			log_message 1 "$YELLOW" "[${BOLD}Case Mismatch${RESET}${YELLOW}] Using $found_file instead of $file"
			# Reuse copy_file logic with the found file
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

	# Check if pattern has already been processed
	if [[ -n "${processed_patterns[$pattern]}" ]]; then
		log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Pattern already processed: $pattern"
		return ${processed_patterns[$pattern]}
	fi

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Glob pattern: ${WHITE}$pattern${RESET}"

	# Handle different pattern types more efficiently
	if [[ "$pattern" == *"/"* ]]; then
		# Pattern contains path separators
		local files=($(find $(dirname "$pattern") -maxdepth 1 -path "$pattern" -type f 2>/dev/null))
		for file in "${files[@]}"; do
			copy_file "$file" "$temp_dir" "$base_dir"
			((count++))
		done
	else
		# Simple filename pattern (no directory)
		local files=($(find . -maxdepth 1 -path "./$pattern" -type f 2>/dev/null))
		for file in "${files[@]}"; do
			copy_file "$file" "$temp_dir" "$base_dir"
			((count++))
		done
	fi

	if [[ $count -eq 0 ]]; then
		log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] No files match pattern: $pattern"
	else
		log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $count files matching pattern: ${WHITE}$pattern${RESET}"
	fi

	# Store the result to avoid reprocessing
	processed_patterns[$pattern]=$count
	return $count
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

	# Reset our tracking variables for each archive creation
	processed_files=()
	processed_patterns=()

	# Process options more efficiently
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

	# Create temporary directory
	local TEMP_DIR=$(mktemp -d)
	if [ $? -ne 0 ]; then
		log_error "Failed to create temporary directory."
		exit $EXIT_PERMISSION_ERROR
	fi
	log_message 2 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Created temporary directory: ${WHITE}$TEMP_DIR${RESET}"

	# Trap to clean up temp directory on exit
	trap "rm -rf '$TEMP_DIR'" EXIT

	# Handle different input file types - optimized processing
	if [[ "$INPUT_EXT" == "dep" ]]; then
		log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Reading dependency file..."

		# Extract files, classes, and themes more efficiently
		local content=$(cat "$INPUT_FILE")

		# Extract all files directly mentioned in the .dep file
		local all_files=($(echo "$content" | sed -n 's/.*\*{file}\s*{\([^}]*\)}.*/\1/p'))

		# Clean file paths (remove leading ./ for consistency)
		for ((i = 0; i < ${#all_files[@]}; i++)); do
			all_files[$i]="${all_files[$i]#./}"
		done

		# Extract all class names used
		local all_classes=($(echo "$content" | sed -n 's/.*\*{class}\s*{\([^}]*\)}.*/\1/p'))

		# Extract all beamer themes if beamer class is used
		local beamer_themes=()
		if [[ " ${all_classes[*]} " =~ " beamer " ]]; then
			beamer_themes=($(echo "$content" | sed -n 's/.*\*{package}{beamertheme\([^}]*\)}.*/\1/p'))
			log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Beamer class detected, looking for themes..."
		fi

		# Process regular files
		for file in "${all_files[@]}"; do
			local file_ext="${file##*.}"
			if [[ -n "${EXCLUDED_EXTENSIONS_DICT[$file_ext]}" ]]; then
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
		log_message 1 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Expected main LaTeX file: ${WHITE}$MAIN_FILE${RESET}"
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

	# Always include the main file
	copy_file "$MAIN_FILE" "$TEMP_DIR" "$BASE_DIR"
	if [ $? -ne 0 ]; then
		log_message 2 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Failed to copy main file. Continuing anyway."
	fi

	# Extract the folder name from \tikzexternalize[prefix=...] - use grep first to check existence
	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Checking for TikZ externalization folder..."

	local TIKZFOLDER=""
	if grep -q '\\tikzexternalize' "$MAIN_FILE" 2>/dev/null; then
		TIKZFOLDER=$(grep -oP '\\tikzexternalize\[prefix=\K[^]]+' "$MAIN_FILE" | sed 's/\/$//' | tr -d '{}')
	fi

	# If TIKZFOLDER is not empty - optimize TikZ folder handling
	if [[ -n "$TIKZFOLDER" ]]; then
		# Handle relative paths - make sure TIKZFOLDER is relative to BASE_DIR
		local TIKZFOLDER_FULL
		if [[ "$TIKZFOLDER" != /* ]]; then
			TIKZFOLDER_FULL="$BASE_DIR/$TIKZFOLDER"
		else
			TIKZFOLDER_FULL="$TIKZFOLDER"
		fi

		log_message 2 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Found TikZ externalization folder: ${WHITE}$TIKZFOLDER${RESET}"

		# Create target directory in temp folder (done only once)
		mkdir -p "$TEMP_DIR/$TIKZFOLDER"
		if [ $? -ne 0 ]; then
			log_error "Failed to create TikZ folder: $TEMP_DIR/$TIKZFOLDER"
		else
			# Handle based on if source folder exists and has content
			if [[ -d "$TIKZFOLDER_FULL" ]]; then
				# Optimize by copying only files matching project name pattern
				# Use find for better performance with large directories
				local tikz_files=($(find "$TIKZFOLDER_FULL" -maxdepth 1 -name "${PROJECT_NAME}*" -type f 2>/dev/null))

				if [[ ${#tikz_files[@]} -gt 0 ]]; then
					cp "${tikz_files[@]}" "$TEMP_DIR/$TIKZFOLDER/" 2>/dev/null
					log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] ${#tikz_files[@]} TikZ files from: $TIKZFOLDER"
				else
					log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] No TikZ files matching ${PROJECT_NAME}* found in $TIKZFOLDER"
				fi
			else
				log_message 1 "$YELLOW" "[${BOLD}Note${RESET}${YELLOW}] TikZ folder doesn't exist: $TIKZFOLDER"
			fi
		fi
	else
		log_message 2 "$YELLOW" "[${BOLD}Info${RESET}${YELLOW}] No TikZ externalization detected in $MAIN_FILE"
	fi

	# Remove duplicates from files_to_process more efficiently
	if [[ ${#files_to_process[@]} -gt 0 ]]; then
		# Use a hash to deduplicate faster than sort
		declare -A unique_files
		for file in "${files_to_process[@]}"; do
			unique_files["$file"]=1
		done
		files_to_process=("${!unique_files[@]}")
	fi

	log_message 2 "$MAGENTA" "[${BOLD}Info${RESET}${MAGENTA}] Processing ${#files_to_process[@]} unique dependency files"

	# Process each file from the input file
	for file in "${files_to_process[@]}"; do
		log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Checking file: ${WHITE}$file${RESET}"
		local ext="${file##*.}"

		# Check for full path or relative path
		local resolved_path=$(resolve_path "$file" "$BASE_DIR")
		if [[ -n "$resolved_path" ]]; then
			copy_file "$resolved_path" "$TEMP_DIR" "$BASE_DIR"
		else
			# Try with extensions if needed
			resolved_path=$(try_extensions "$file" "$BASE_DIR")
			if [[ -n "$resolved_path" ]]; then
				copy_file "$resolved_path" "$TEMP_DIR" "$BASE_DIR"
			else
				# Case-insensitive search as last resort but only if parent directory exists
				local parent_dir=$(dirname "$file")
				if [[ -d "$BASE_DIR/$parent_dir" || "$parent_dir" == "." ]]; then
					local filename=$(basename "$file")
					local found_file=$(find "$BASE_DIR/$parent_dir" -maxdepth 1 -type f -iname "$filename" | head -n 1)
					if [[ -n "$found_file" ]]; then
						log_message 1 "$YELLOW" "[${BOLD}Case Mismatch${RESET}${YELLOW}] Using $found_file instead of $file"
						copy_file "$found_file" "$TEMP_DIR" "$BASE_DIR"
					else
						log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
					fi
				else
					log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
				fi
			fi
		fi

		# Handle patterns for image files with numeric suffixes - optimize with regex pattern matching
		if [[ "$file" =~ ^(.*/)?([^/]+)([${MULTIPLE_FILES_SEPARATORS}])[0-9]+\.([a-zA-Z]+)$ ]]; then
			local folder="${BASH_REMATCH[1]:-}"
			local prefix="${BASH_REMATCH[2]}"
			local separator="${BASH_REMATCH[3]}" # dash or underscore
			local extension="${BASH_REMATCH[4]}"
			local pattern="${folder}${prefix}${separator}*.${extension}"

			# Skip if already processed - fast hash lookup
			if [[ -z "${processed_files["pattern:$pattern"]}" ]]; then
				processed_files["pattern:$pattern"]=1
				log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Pattern detected: ${WHITE}$pattern${RESET}"

				# Optimize by using find to get matching files
				if [[ -n "$folder" ]]; then
					local matching_files=($(find "$BASE_DIR/$folder" -maxdepth 1 -name "${prefix}${separator}*.${extension}" -type f 2>/dev/null))
					local target_dir="$TEMP_DIR/$folder"
				else
					local matching_files=($(find "$BASE_DIR" -maxdepth 1 -name "${prefix}${separator}*.${extension}" -type f 2>/dev/null))
					local target_dir="$TEMP_DIR"
				fi

				# Create target directory if needed
				if [[ ${#matching_files[@]} -gt 0 ]]; then
					mkdir -p "$target_dir"

					# Process batch copy for better performance
					for f in "${matching_files[@]}"; do
						local target_file="$target_dir/$(basename "$f")"
						if [[ ! -f "$target_file" ]]; then
							cp "$f" "$target_file"
							log_message 2 "$BLUE" "[${BOLD}Added${RESET}${BLUE}] $(basename "$f") (from pattern)"
						fi
					done

					log_message 1 "$BLUE" "[${BOLD}Added${RESET}${BLUE}] $pattern (${#matching_files[@]} files)"
				fi
			else
				log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Pattern already processed: $pattern"
			fi
		fi
	done

	# Process any extra file patterns specified by the user
	for pattern in "${EXTRA_PATTERNS[@]}"; do
		process_glob_pattern "$pattern" "$TEMP_DIR" "$BASE_DIR"
	done

	# Create the ZIP archive - optimize by skipping if no files
	local files_count=$(find "$TEMP_DIR" -type f | wc -l)
	if [[ $files_count -eq 0 ]]; then
		log_error "No files to archive. Aborting."
		exit $EXIT_FILE_NOT_FOUND
	fi

	log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Creating ZIP archive with $files_count files..."

	# Use quiet mode for zip with error handling
	(cd "$TEMP_DIR" && zip -q -r "$PROJECT_NAME.zip" .)
	if [ $? -ne 0 ]; then
		log_error "Failed to create ZIP archive."
		exit $EXIT_ZIP_ERROR
	fi

	# Atomic replacement of existing zip file
	if [[ -f "$ZIP_FILE" ]]; then
		mv "$TEMP_DIR/$PROJECT_NAME.zip" "$ZIP_FILE.new" &&
			mv "$ZIP_FILE.new" "$ZIP_FILE"
	else
		mv "$TEMP_DIR/$PROJECT_NAME.zip" "$ZIP_FILE"
	fi

	if [ $? -ne 0 ]; then
		log_error "Failed to move ZIP archive to final destination."
		exit $EXIT_PERMISSION_ERROR
	fi

	# Count only actual files for reporting
	local file_count=$(find "$TEMP_DIR" -type f | wc -l)
	log_message 1 "${BOLD}${GREEN}[${WHITE}Success${GREEN}] Archive created: ${WHITE}$ZIP_FILE${RESET}"
	log_message 1 "${BOLD}${GREEN}[${WHITE}Summary${GREEN}] ${file_count} files added to archive${RESET}"

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
