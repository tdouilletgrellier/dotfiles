#!/bin/bash
#===================================================
#  LaTeX Project Archiver
#  This script creates a ZIP archive for a LaTeX project
#  based on a .dep file, with an option to explicitly
#  include additional files.
#===================================================

# Define ANSI color codes for colorful logging
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[0m"

#---------------------------------------------------
# Function: show_help
#  Displays a colorful help message and usage info.
#---------------------------------------------------
show_help() {
    echo -e "${CYAN}---------------------------------------------------"
    echo -e " LaTeX Project Archiver"
    echo -e "---------------------------------------------------${RESET}"
    echo -e "${YELLOW}Usage:${RESET}"
    echo -e "  $0 <file.dep> [-a <additional_file> ...]"
    echo -e ""
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  -a <file>    Explicitly add a file to the archive"
    echo -e "  -h, --help   Show this help message and exit"
    echo -e ""
    echo -e "${YELLOW}Description:${RESET}"
    echo -e "  This script reads a .dep file, collects all listed files,"
    echo -e "  and packages them into a ZIP archive. Users can manually"
    echo -e "  add extra files using the -a option."
    echo -e ""
    echo -e "${GREEN}Example:${RESET}"
    echo -e "  $0 project.dep -a figures/extra.png -a notes.txt"
    echo ""
    exit 0
}

#---------------------------------------------------
# Function: create_archive
#  Creates the ZIP archive based on the .dep file and options.
#---------------------------------------------------
create_archive() {
    local DEP_FILE="$1"
    shift
    local EXTRA_FILES=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -a)
                if [[ -n "$2" ]]; then
                    EXTRA_FILES+=("$2")
                    shift 2
                else
                    echo -e "${RED}[Error] Missing file after -a option.${RESET}" >&2
                    exit 1
                fi
                ;;
            -h|--help)
                show_help
                ;;
            *)
                echo -e "${RED}[Error] Unknown argument: $1${RESET}" >&2
                show_help
                ;;
        esac
    done

    if [[ ! -f "$DEP_FILE" ]]; then
        echo -e "${RED}[Error] Dependency file not found: $DEP_FILE${RESET}" >&2
        exit 1
    fi

    local BASE_DIR=$(dirname "$DEP_FILE")
    local DEP_NAME=$(basename "$DEP_FILE" .dep)
    local ZIP_FILE="$BASE_DIR/${DEP_NAME}.zip"
    local MAIN_TEX_FILE="$BASE_DIR/${DEP_NAME}.tex"

    echo -e "${YELLOW}[Info] Processing dependency file: $DEP_FILE${RESET}"
    echo -e "${YELLOW}[Info] Archive name: $ZIP_FILE${RESET}"
    echo -e "${YELLOW}[Info] Expected main LaTeX file: $MAIN_TEX_FILE${RESET}"

    local TEMP_DIR=$(mktemp -d)
    echo -e "${YELLOW}[Info] Created temporary directory: $TEMP_DIR${RESET}"

    local image_extensions=("png" "jpeg" "jpg" "bmp" "pdf")
    local tex_extensions=("tex" "tikz")
    
    # Keep track of processed patterns to avoid duplicates
    declare -A processed_patterns
    
    # Function to copy files to the temporary directory
    copy_file() {
        local file="$1"
        local target_path
        
        # Check if file exists
        if [[ -f "$file" ]]; then
            # For files in BASE_DIR, make them relative to BASE_DIR
            if [[ "$file" == "$BASE_DIR"* ]]; then
                target_path="${file#$BASE_DIR/}"
            else
                # For files not in BASE_DIR, keep their relative path from current directory
                target_path=$(realpath --relative-base="$(pwd)" "$file")
            fi

            # Remove any leading slash to ensure it's always a relative path
            target_path="${target_path#/}"
            
            # Create directories in TEMP_DIR
            mkdir -p "$TEMP_DIR/$(dirname "$target_path")"

            # Skip if file already exists at destination
            if [[ -f "$TEMP_DIR/$target_path" ]]; then
                echo -e "${YELLOW}[Skipped] $target_path (already exists)${RESET}"
                return
            fi

            # Copy the file to the temporary directory
            cp "$file" "$TEMP_DIR/$target_path"
            echo -e "${GREEN}[Added] $target_path${RESET}"
        else
            echo -e "${RED}[Warning] File not found: $file${RESET}" >&2
        fi
    }

    copy_file "$MAIN_TEX_FILE"

    # Store all files from the .dep file
    files_to_process=$(grep -oP '(?<=\{)[^}]+(?=\})' "$DEP_FILE")

    # Process each file from the .dep file
    for file in $files_to_process; do
        ext="${file##*.}"

        if [[ " ${image_extensions[*]} " =~ " ${ext} " ]] || [[ " ${tex_extensions[*]} " =~ " ${ext} " ]]; then
            copy_file "$BASE_DIR/$file"
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
                # Copy matching files to temporary directory
                find "$BASE_DIR/$folder" -maxdepth 1 -type f -name "$pattern" -exec bash -c 'for f; do if [[ ! -f "$0/$(basename "$f")" ]]; then cp "$f" "$0"; fi; done' "$TEMP_DIR/$folder" {} \;
                
                echo -e "${GREEN}[Added] $folder/$pattern${RESET}"
                
                # Mark pattern as processed
                processed_patterns[$pattern_key]=1
            fi
        fi
    done

    # Copy any extra files specified by the user
    for extra_file in "${EXTRA_FILES[@]}"; do
        copy_file "$extra_file"
    done

    # Create the ZIP archive
    (cd "$TEMP_DIR" && zip -r "$DEP_NAME.zip" . > /dev/null)
    mv "$TEMP_DIR/$DEP_NAME.zip" "$ZIP_FILE"
    echo -e "${GREEN}[Success] Archive created: $ZIP_FILE${RESET}"

    rm -rf "$TEMP_DIR"
    echo -e "${YELLOW}[Info] Temporary directory removed.${RESET}"
}

if [[ "$#" -eq 0 ]]; then
    show_help
else
    create_archive "$@"
fi