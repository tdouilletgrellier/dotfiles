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
GREEN="\e[32m"       # Success messages
YELLOW="\e[33m"      # Warnings and information
RED="\e[31m"         # Error messages
CYAN="\e[36m"        # Processing steps
BLUE="\e[34m"        # File operations
MAGENTA="\e[35m"     # Important information
WHITE="\e[97m"       # Highlighted text
BOLD="\e[1m"         # Bold text
ITALIC="\e[3m"       # Italic text
UNDERLINE="\e[4m"    # Underlined text
RESET="\e[0m"        # Reset formatting

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
    echo -e "  $0 ${UNDERLINE}<file.dep or file.tex>${RESET} [${ITALIC}options${RESET}]"
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
    echo -e "  ${GREEN}$0 project.dep -a figures/extra.png -a notes.txt${RESET}"
    echo -e "  ${GREEN}$0 project.tex -v${RESET}"
    echo -e "  ${GREEN}$0 project.tex -a 'images/*.png'${RESET}"
    echo -e "  ${GREEN}$0 project.tex -a 'figures/graph-*.pdf' -a 'data/*.csv'${RESET}"
    echo -e "  ${GREEN}$0 project.tex -a 'path-to-folder/file*.png'${RESET}"
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
    
    # Extract only uncommented animategraphics commands
    # First, filter out commented lines (those starting with %), then look for animategraphics commands
    local animations=$(grep -v '^\s*%' "$tex_file" | grep -E '\\animategraphics(\[[^]]*\])?\{[^}]+\}\{[^}]+\}\{[^}]+\}\{[^}]+\}')
    
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        
        # Extract the prefix, first and last frame numbers
        local prefix=$(echo "$line" | sed -E 's/.*\\animategraphics(\[[^]]*\])?\{[^}]+\}\{([^}]+)\}\{[^}]+\}\{[^}]+\}.*/\2/')
        local first=$(echo "$line" | sed -E 's/.*\\animategraphics(\[[^]]*\])?\{[^}]+\}\{[^}]+\}\{([^}]+)\}\{[^}]+\}.*/\2/')
        local last=$(echo "$line" | sed -E 's/.*\\animategraphics(\[[^]]*\])?\{[^}]+\}\{[^}]+\}\{[^}]+\}\{([^}]+)\}.*/\2/')
        
        log_message 2 "$MAGENTA" "[${BOLD}Animation${RESET}${MAGENTA}] Found sequence: ${WHITE}$prefix${RESET}${MAGENTA} from ${WHITE}$first${RESET}${MAGENTA} to ${WHITE}$last${RESET}"
        
        # Validate that first and last are numeric
        if ! [[ "$first" =~ ^[0-9]+$ ]] || ! [[ "$last" =~ ^[0-9]+$ ]]; then
            log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Non-numeric frame numbers in: $line"
            continue
        fi
        
        # Generate the frame filenames
        for ((i=first; i<=last; i++)); do
            # Determine if we need to add an extension
            if [[ "$prefix" =~ \.[a-zA-Z]+$ ]]; then
                deps+=("$prefix$i")
            else
                deps+=("$prefix$i.png")
            fi
        done
    done <<< "$animations"
    
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
    local processed_files=()
    
    # To prevent infinite recursion for circular references
    local file_hash=$(realpath "$tex_file")
    if [[ " ${processed_files[*]} " =~ " ${file_hash} " ]]; then
        log_message 2 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] Already processed: $tex_file"
        return
    fi
    processed_files+=("$file_hash")
    
    log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Scanning $tex_file for dependencies..."
    
    # Filter out comments before extracting includes and inputs
    # Extract includes and inputs (only from uncommented lines)
    local includes=$(grep -v '^\s*%' "$tex_file" | grep -E '\\(input|include|includeonly|bibliography)\{[^}]+\}' | 
                   sed -E 's/.*\\(input|include|includeonly|bibliography)\{([^}]+)\}.*/\2/')
    
    # Extract graphics (only from uncommented lines)
    local graphics=$(grep -v '^\s*%' "$tex_file" | grep -E '\\includegraphics(\[[^]]*\])?\{[^}]+\}' | 
                    sed -E 's/.*\\includegraphics(\[[^]]*\])?\{([^}]+)\}.*/\2/')
    
    # Process animated graphics (process_animated_graphics already filters comments)
    local animated_graphics=($(process_animated_graphics "$tex_file"))
    for anim in "${animated_graphics[@]}"; do
        deps+=("$anim")
    done
    
    # Process all includes
    for inc in $includes; do
        # Add .tex extension if not present
        if [[ ! "$inc" =~ \.[a-zA-Z]+$ ]]; then
            inc="${inc}.tex"
        fi
        
        local inc_path
        # First try relative to current tex file directory
        if [[ -f "$tex_dir/$inc" ]]; then
            inc_path="$tex_dir/$inc"
            deps+=("$inc")
        # Then try relative to project root
        elif [[ -f "$BASE_DIR/$inc" ]]; then
            inc_path="$BASE_DIR/$inc"
            # Make path relative to tex_dir for deps
            local rel_path=$(realpath --relative-to="$tex_dir" "$BASE_DIR/$inc")
            deps+=("$rel_path")
        else
            log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Could not find included file: $inc"
            continue
        fi
        
        # Recursively process included tex files
        local nested_deps=($(extract_tex_dependencies "$inc_path"))
        for nested in "${nested_deps[@]}"; do
            deps+=("$nested")
        done
    done
    
    # Process graphics
    for img in $graphics; do
        # Check for the file with various extensions if no extension specified
        if [[ ! "$img" =~ \.[a-zA-Z]+$ ]]; then
            local found=0
            for ext in "png" "jpg" "jpeg" "pdf" "eps"; do
                if [[ -f "$tex_dir/${img}.${ext}" ]]; then
                    deps+=("${img}.${ext}")
                    found=1
                    break
                elif [[ -f "$BASE_DIR/${img}.${ext}" ]]; then
                    # Make path relative to tex_dir for deps
                    local rel_path=$(realpath --relative-to="$tex_dir" "$BASE_DIR/${img}.${ext}")
                    deps+=("$rel_path")
                    found=1
                    break
                fi
            done
            if [[ $found -eq 0 ]]; then
                log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Image not found: $img (tried multiple extensions)"
            fi
        else
            if [[ -f "$tex_dir/$img" ]]; then
                deps+=("$img")
            elif [[ -f "$BASE_DIR/$img" ]]; then
                # Make path relative to tex_dir for deps
                local rel_path=$(realpath --relative-to="$tex_dir" "$BASE_DIR/$img")
                deps+=("$rel_path")
            else
                log_message 1 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] Image not found: $img"
            fi
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
        log_message 2 "$BLUE" "[${BOLD}Added${RESET}${BLUE}] $target_path"
        return 0
    else
        log_message 1 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
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
            -h|--help)
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
        # Extract files from .dep file (exclude commented lines)
        files_to_process=($(grep -v '^\s*%' "$INPUT_FILE" | grep -oP '(?<=\{)[^}]+(?=\})'))
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
    
    local image_extensions=("png" "jpeg" "jpg" "bmp" "pdf" "eps" "gif")
    local tex_extensions=("tex" "tikz" "bib" "sty" "cls")
    
    # Keep track of processed patterns to avoid duplicates
    declare -A processed_patterns
    
    # Always include the main file
    copy_file "$MAIN_FILE" "$TEMP_DIR" "$BASE_DIR"
    if [ $? -ne 0 ]; then
        log_error "Failed to copy main file. Aborting."
        exit $EXIT_PERMISSION_ERROR
    fi

    # Remove duplicates from files_to_process
    readarray -t files_to_process_unique < <(printf '%s\n' "${files_to_process[@]}" | sort -u)
    
    # Process each file from the input file
    for file in "${files_to_process_unique[@]}"; do
        log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Checking file: ${WHITE}$file${RESET}"
        ext="${file##*.}"

        # Check for full path or relative path
        if [[ -f "$file" ]]; then
            copy_file "$file" "$TEMP_DIR" "$BASE_DIR"
            log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $file"
        elif [[ -f "$BASE_DIR/$file" ]]; then
            copy_file "$BASE_DIR/$file" "$TEMP_DIR" "$BASE_DIR"
            log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $file"
        elif [[ " ${image_extensions[*]} " =~ " ${ext} " ]] || [[ " ${tex_extensions[*]} " =~ " ${ext} " ]]; then
            # Try to find the file in BASE_DIR
            log_message 2 "$YELLOW" "[${BOLD}Warning${RESET}${YELLOW}] File not found directly: $file, trying in base directory"
            if [[ -f "$BASE_DIR/$file" ]]; then
                copy_file "$BASE_DIR/$file" "$TEMP_DIR" "$BASE_DIR"
                log_message 1 "$GREEN" "[${BOLD}Added${RESET}${GREEN}] $file"
            else
                log_message 1 "$YELLOW" "[${BOLD}Skipped${RESET}${YELLOW}] File not found: $file"
            fi
        fi

        # Handle patterns for image files with numeric suffixes
        if [[ "$file" =~ ^([^/]+/[^/]+)([-_])[0-9]+\.[a-zA-Z]+$ ]]; then
            folder="${file%/*}"
            base_name="${file##*/}"
            prefix="${base_name%[-_]*}"
            separator="${BASH_REMATCH[2]}"  # Get the actual separator (dash or underscore)
            extension="${base_name##*.}"
            pattern="${prefix}${separator}*.$extension"
            pattern_key="${folder}/${pattern}"
            
            # Check if we've already processed this pattern
            if [[ -z "${processed_patterns[$pattern_key]}" ]]; then
                log_message 2 "$CYAN" "[${BOLD}Processing${RESET}${CYAN}] Pattern detected: ${WHITE}$pattern_key${RESET}"
                
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
                
                # Mark pattern as processed
                processed_patterns[$pattern_key]=1
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
    (cd "$TEMP_DIR" && zip -r "$PROJECT_NAME.zip" . > /dev/null)
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