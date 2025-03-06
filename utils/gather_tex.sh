#!/bin/bash
#===================================================
#  LaTeX Project Archiver
#  This script creates a ZIP archive for a LaTeX project
#  based on a .dep file, with an option to explicitly
#  include additional files or file patterns.
#===================================================

# Define ANSI color codes for colorful logging
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

# Define exit codes
EXIT_SUCCESS=0
EXIT_MISSING_ARG=1
EXIT_FILE_NOT_FOUND=2
EXIT_INVALID_OPTION=3
EXIT_PERMISSION_ERROR=4
EXIT_ZIP_ERROR=5

# Default verbosity level (0=quiet, 1=normal, 2=verbose)
VERBOSITY=1

#---------------------------------------------------
# Function: log_message
#  Logs messages according to verbosity level
#---------------------------------------------------
log_message() {
    local level=$1
    local color=$2
    local message=$3
    
    if [[ $VERBOSITY -ge $level ]]; then
        echo -e "${color}${message}${RESET}"
    fi
}

#---------------------------------------------------
# Function: log_error
#  Logs error messages (always shown)
#---------------------------------------------------
log_error() {
    local message=$1
    echo -e "${RED}[Error] ${message}${RESET}" >&2
}

#---------------------------------------------------
# Function: show_help
#  Displays a colorful help message and usage info.
#---------------------------------------------------
show_help() {
    echo -e "${CYAN}---------------------------------------------------"
    echo -e " LaTeX Project Archiver"
    echo -e "---------------------------------------------------${RESET}"
    echo -e "${YELLOW}Usage:${RESET}"
    echo -e "  $0 <file.dep or file.tex> [-a <file_pattern> ...]"
    echo -e ""
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  -a <file_pattern>  Explicitly add file(s) to the archive. Glob patterns are supported."
    echo -e "  -q                 Quiet mode (show only errors)"
    echo -e "  -v                 Verbose mode (show detailed information)"
    echo -e "  -h, --help         Show this help message and exit"
    echo -e ""
    echo -e "${YELLOW}Description:${RESET}"
    echo -e "  This script reads a .dep file or parses a .tex file,"
    echo -e "  collects all listed/included files, and packages them"
    echo -e "  into a ZIP archive. Users can manually add extra files"
    echo -e "  using the -a option, which supports glob patterns for"
    echo -e "  matching multiple files at once."
    echo -e ""
    echo -e "${GREEN}Examples:${RESET}"
    echo -e "  gather_tex.sh project.dep -a figures/extra.png -a notes.txt"
    echo -e "  gather_tex.sh project.tex -v"
    echo -e "  gather_tex.sh project.tex -a 'images/*.png'"
    echo -e "  gather_tex.sh project.tex -a 'figures/graph-*.pdf' -a 'data/*.csv'"
    echo -e "  gather_tex.sh project.tex -a 'path-to-folder/file*.png'"
    echo ""
    exit $EXIT_SUCCESS
}

#---------------------------------------------------
# Function: extract_tex_dependencies
#  Extracts dependencies from a .tex file
#---------------------------------------------------
extract_tex_dependencies() {
    local tex_file="$1"
    local tex_dir=$(dirname "$tex_file")
    local deps=()
    
    log_message 2 "$CYAN" "[Processing] Scanning $tex_file for dependencies..."
    
    # Extract includes and inputs
    local includes=$(grep -E '\\(input|include|includeonly|bibliography)\{[^}]+\}' "$tex_file" | 
                   sed -E 's/.*\\(input|include|includeonly|bibliography)\{([^}]+)\}.*/\2/')
    
    # Extract graphics
    local graphics=$(grep -E '\\includegraphics(\[[^]]*\])?\{[^}]+\}' "$tex_file" | 
                    sed -E 's/.*\\includegraphics(\[[^]]*\])?\{([^}]+)\}.*/\2/')
                    
    # Process all includes
    for inc in $includes; do
        # Add .tex extension if not present
        if [[ ! "$inc" =~ \.[a-zA-Z]+$ ]]; then
            inc="${inc}.tex"
        fi
        
        local inc_path="$tex_dir/$inc"
        if [[ -f "$inc_path" ]]; then
            deps+=("$inc")
            # Recursively process included tex files
            local nested_deps=($(extract_tex_dependencies "$inc_path"))
            for nested in "${nested_deps[@]}"; do
                deps+=("$nested")
            done
        fi
    done
    
    # Process graphics
    for img in $graphics; do
        # Check for the file with various extensions if no extension specified
        if [[ ! "$img" =~ \.[a-zA-Z]+$ ]]; then
            for ext in "png" "jpg" "jpeg" "pdf" "eps"; do
                if [[ -f "$tex_dir/${img}.${ext}" ]]; then
                    deps+=("${img}.${ext}")
                    break
                fi
            done
        else
            deps+=("$img")
        fi
    done
    
    # Return all dependencies
    echo "${deps[@]}"
}

#---------------------------------------------------
# Function: process_glob_pattern
#  Processes a glob pattern and adds matching files to archive
#---------------------------------------------------
process_glob_pattern() {
    local pattern="$1"
    local temp_dir="$2"
    local base_dir="$3"
    local count=0
    
    log_message 2 "$CYAN" "[Processing] Glob pattern: $pattern"
    
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
        log_message 1 "$YELLOW" "[Warning] No files match pattern: $pattern"
    else
        log_message 1 "$GREEN" "[Added] $count files matching pattern: $pattern"
    fi
    
    return $count
}

#---------------------------------------------------
# Function: copy_file
#  Copies a file to the temporary directory
#---------------------------------------------------
copy_file() {
    local file="$1"
    local temp_dir="$2"
    local base_dir="$3"
    local target_path
    
    # Check if file exists
    if [[ -f "$file" ]]; then
        # For files in BASE_DIR, make them relative to BASE_DIR
        if [[ "$file" == "$base_dir"* ]]; then
            target_path="${file#$base_dir/}"
        else
            # For files not in BASE_DIR, keep their relative path from current directory
            target_path=$(realpath --relative-base="$(pwd)" "$file")
        fi

        # Remove any leading slash to ensure it's always a relative path
        target_path="${target_path#/}"
        
        # Create directories in TEMP_DIR
        local dir_path="$(dirname "$target_path")"
        mkdir -p "$temp_dir/$dir_path"
        if [ $? -ne 0 ]; then
            log_error "Failed to create directory: $temp_dir/$dir_path"
            return 1
        fi

        # Skip if file already exists at destination
        if [[ -f "$temp_dir/$target_path" ]]; then
            log_message 2 "$YELLOW" "[Skipped] $target_path (already exists)"
            return 0
        fi

        # Copy the file to the temporary directory
        cp "$file" "$temp_dir/$target_path"
        if [ $? -ne 0 ]; then
            log_error "Failed to copy file: $file to $temp_dir/$target_path"
            return 1
        fi
        log_message 2 "$GREEN" "[Added] $target_path"
        return 0
    else
        log_message 1 "$RED" "[Warning] File not found: $file"
        return 1
    fi
}

#---------------------------------------------------
# Function: create_archive
#  Creates the ZIP archive based on the .dep file and options.
#---------------------------------------------------
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

    local BASE_DIR=$(dirname "$INPUT_FILE")
    local INPUT_BASENAME=$(basename "$INPUT_FILE")
    local INPUT_EXT="${INPUT_BASENAME##*.}"
    local PROJECT_NAME="${INPUT_BASENAME%.*}"
    local ZIP_FILE="$BASE_DIR/${PROJECT_NAME}.zip"
    local files_to_process=()

    log_message 1 "$YELLOW" "[Info] Processing file: $INPUT_FILE"
    log_message 1 "$YELLOW" "[Info] Archive name: $ZIP_FILE"

    # Handle different input file types
    if [[ "$INPUT_EXT" == "dep" ]]; then
        log_message 2 "$CYAN" "[Processing] Reading dependency file..."
        # Extract files from .dep file
        files_to_process=($(grep -oP '(?<=\{)[^}]+(?=\})' "$INPUT_FILE"))
        MAIN_FILE="$BASE_DIR/${PROJECT_NAME}.tex"
    elif [[ "$INPUT_EXT" == "tex" ]]; then
        log_message 2 "$CYAN" "[Processing] Extracting dependencies from LaTeX file..."
        # Extract dependencies from .tex file
        files_to_process=($(extract_tex_dependencies "$INPUT_FILE"))
    else
        log_error "Unsupported input file type: .$INPUT_EXT (expected .dep or .tex)"
        exit $EXIT_INVALID_OPTION
    fi

    log_message 1 "$YELLOW" "[Info] Expected main LaTeX file: $MAIN_FILE"

    # Create temporary directory
    local TEMP_DIR=$(mktemp -d)
    if [ $? -ne 0 ]; then
        log_error "Failed to create temporary directory."
        exit $EXIT_PERMISSION_ERROR
    fi
    log_message 2 "$YELLOW" "[Info] Created temporary directory: $TEMP_DIR"

    local image_extensions=("png" "jpeg" "jpg" "bmp" "pdf" "eps")
    local tex_extensions=("tex" "tikz" "bib")
    
    # Keep track of processed patterns to avoid duplicates
    declare -A processed_patterns
    
    # Always include the main file
    copy_file "$MAIN_FILE" "$TEMP_DIR" "$BASE_DIR"
    if [ $? -ne 0 ]; then
        log_error "Failed to copy main file. Aborting."
        rm -rf "$TEMP_DIR"
        exit $EXIT_PERMISSION_ERROR
    fi

    # Process each file from the input file
    for file in "${files_to_process[@]}"; do
        log_message 2 "$CYAN" "[Processing] Checking file: $file"
        ext="${file##*.}"

        if [[ " ${image_extensions[*]} " =~ " ${ext} " ]] || [[ " ${tex_extensions[*]} " =~ " ${ext} " ]]; then
            copy_file "$BASE_DIR/$file" "$TEMP_DIR" "$BASE_DIR"
        fi

        # Handle patterns for image files with numeric suffixes
        if [[ "$file" =~ ^([^/]+/[^/]+)([-_])[0-9]+\.png$ ]]; then
            folder="${file%/*}"
            base_name="${file##*/}"
            prefix="${base_name%[-_]*}"
            separator="${BASH_REMATCH[2]}"  # Get the actual separator (dash or underscore)
            pattern="${prefix}${separator}*.png"
            pattern_key="${folder}/${pattern}"
            
            # Check if we've already processed this pattern
            if [[ -z "${processed_patterns[$pattern_key]}" ]]; then
                log_message 2 "$CYAN" "[Processing] Pattern detected: $pattern_key"
                
                # Create directory if it doesn't exist
                mkdir -p "$TEMP_DIR/$folder"
                if [ $? -ne 0 ]; then
                    log_error "Failed to create directory: $TEMP_DIR/$folder"
                    rm -rf "$TEMP_DIR"
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
                                rm -rf "$TEMP_DIR"
                                exit $EXIT_PERMISSION_ERROR
                            fi
                        fi
                    fi
                done
                
                log_message 1 "$GREEN" "[Added] $folder/$pattern"
                
                # Mark pattern as processed
                processed_patterns[$pattern_key]=1
            else
                log_message 2 "$YELLOW" "[Skipped] Pattern already processed: $pattern_key"
            fi
        fi
    done

    # Process any extra file patterns specified by the user
    for pattern in "${EXTRA_PATTERNS[@]}"; do
        process_glob_pattern "$pattern" "$TEMP_DIR" "$BASE_DIR"
    done

    # Create the ZIP archive
    log_message 2 "$CYAN" "[Processing] Creating ZIP archive..."
    (cd "$TEMP_DIR" && zip -r "$PROJECT_NAME.zip" . > /dev/null)
    if [ $? -ne 0 ]; then
        log_error "Failed to create ZIP archive."
        rm -rf "$TEMP_DIR"
        exit $EXIT_ZIP_ERROR
    fi
    
    mv "$TEMP_DIR/$PROJECT_NAME.zip" "$ZIP_FILE"
    if [ $? -ne 0 ]; then
        log_error "Failed to move ZIP archive to final destination."
        rm -rf "$TEMP_DIR"
        exit $EXIT_PERMISSION_ERROR
    fi
    
    log_message 1 "$GREEN" "[Success] Archive created: $ZIP_FILE"

    rm -rf "$TEMP_DIR"
    log_message 2 "$YELLOW" "[Info] Temporary directory removed."
    
    return $EXIT_SUCCESS
}

if [[ "$#" -eq 0 ]]; then
    show_help
else
    create_archive "$@"
    exit_code=$?
    exit $exit_code
fi