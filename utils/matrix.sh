# Matrix-style screensaver for your terminal
# Execute directly or source it then run $ matrix

# Clear terminal when CTRL+C
trap '{ tput cnorm; clear; exit 1; }' INT

# Function to display help message
show_help() {
  cat << EOF
Usage: matrix [OPTIONS]

Matrix-style terminal screensaver with configurable speed, colors, and effect parameters.

Options:
  -s, --speed=<value>         Set the refresh speed in seconds (default: 0.05).
                               Example: -s 0.03 for faster animation.

  -r, --random-colors         Enable random colors for characters (default: disabled).
                               Without this flag, characters are only green/white.

  -p, --start_prob=<value>    Probability (0.0 to 1.0) for a new drop to start (default: 1.0).
                               Lower values reduce the number of falling streams.

  -l, --length_factor=<value> Adjust the maximum length of each drop relative to screen height.
                               Example: 0.9 means max drop length = 90% of terminal lines (default: 0.95).

  -m, --min_length=<value>    Set the minimum length of each falling drop (default: 5).
                               Longer values make drops more continuous.

  -h, --help                  Show this help message and exit.

Examples:
  matrix -s 0.1 -r -p 0.8
  ./matrixsh --length_factor=0.8 --min_length=10

EOF
  exit 0
}

# Default values
speed=0.05
random_colors=0
start_prob=1.0
length_factor=0.95
min_length=5

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) show_help ;;
    -r|--random-colors) random_colors=1 ;;
    -s|--speed) speed="$2"; shift ;;
    --speed=*) speed="${1#*=}" ;;
    -p|--start_prob) start_prob="$2"; shift ;;
    --start_prob=*) start_prob="${1#*=}" ;;
    -l|--length_factor) length_factor="$2"; shift ;;
    --length_factor=*) length_factor="${1#*=}" ;;
    -m|--min_length) min_length="$2"; shift ;;
    --min_length=*) min_length="${1#*=}" ;;
    *) 
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
  shift
done


matrix () {

  # Get terminal dimensions
  local lines=$(tput lines)
  local cols=$(tput cols)

  # Define characters once
  # Japanese
  katakana="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ"
  hiragana="あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわん"
  kanji="日月火水木金土山川田人名前東京日本語雨風雷電時光影龍虎神"
  # Latin Alphabet (Uppercase & Lowercase) + Numbers
  latin="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  # Symbols
  symbols="@#$%^&*()=+{}~[]<>/!?;:.,_-±×÷√∞≈≠≡≤≥«»©®™¢£¥€₽₿"
  # Cyrillic (Uppercase & Lowercase)
  cyrillic="АБВГҐДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЭЮЯабвгдеёжзийклмнопрстуфхцчшщыэюя"
  # Greek (Uppercase & Lowercase)
  greek="ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω"
  # Hebrew
  hebrew="אביגדהווחטךכעפצקרש"
  # Arabic 
  arabic="اأإآءؤئبتثجحخدذرزسشصضطظعغفقكلمنهوىي"
  # Chinese
  chinese="你好世界风雨雷电火水山川天地人日月星龙虎"
  # Indian
  devanagari="अआइईउऊएऐओऔकखगघचछजझटठडढणतथदधनपफबभमयरलवशषसह"
  # Korean
  korean="가각간갇갈감갑값갓강개객거건걸검겁것경계고곡곤골공과광교구국군굴궁권그극근글금급기긴길김깊까깨꺼꼬꽃"  
  # Thai
  thai="กขคฆงจฉชซญฎฏฐฑฒณดตถทธนบปผพภมยรลวศษสหฬอ"
  # Tibetan
  tibetan="ཀཁགངཅཆཇཉཏཐདནཔཕབམཙཚཛཞཟའཡརལཤསཧཨ"
  # Braille
  braille="⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠭⠽"
  # Final Combination: Just Uncomment What You Want!
  letters=(
    "$latin"
    "$symbols"
    "$katakana"
    # "$hiragana"
    # "$kanji"
    "$cyrillic"
    "$greek"
    "$hebrew"
    "$arabic"
    # "$chinese"
    "$devanagari"
    # "$korean"
    "$thai"
    "$tibetan"
    "$braille"
  )
  # Join all enabled character sets into one string
  letters="${letters[*]}"
  # Compute length
  local letters_length=$(echo -n "$letters" | wc -m)
  # AWK Script
  awkscript='
BEGIN {
    min_length = '$min_length';
    max_length = int('$length_factor' * '$lines'); 
    start_prob = '$start_prob';
    random_colors = '$random_colors';
    
     # ANSI escape codes
    NORMAL_WHITE = "\033[0;37m"
    NORMAL_GREEN = "\033[0;32m" 
    BRIGHT_WHITE = "\033[1;37m"
    BRIGHT_GREEN = "\033[1;32m"
    DIM_WHITE = "\033[2;37m"
    DIM_GREEN = "\033[2;32m"

    WHITE = BRIGHT_WHITE
    WHITE_RAND[0] = NORMAL_WHITE
    WHITE_RAND[1] = BRIGHT_WHITE
    WHITE_RAND[2] = DIM_WHITE
    GREEN = NORMAL_GREEN
    GREEN_RAND[0] = NORMAL_GREEN
    GREEN_RAND[1] = BRIGHT_GREEN
    GREEN_RAND[2] = DIM_GREEN    


    # Random colors array
    # Bright colors
    colors[0] = "\033[1;31m"  # Bright Red
    colors[1] = "\033[1;32m"  # Bright Green
    colors[2] = "\033[1;33m"  # Bright Yellow
    colors[3] = "\033[1;34m"  # Bright Blue
    colors[4] = "\033[1;35m"  # Bright Magenta
    colors[5] = "\033[1;36m"  # Bright Cyan
    # Normal colors
    colors[6] = "\033[0;31m"  # Red
    colors[7] = "\033[0;32m"  # Green
    colors[8] = "\033[0;33m"  # Yellow
    colors[9] = "\033[0;34m" # Blue
    colors[10] = "\033[0;35m" # Magenta
    colors[11] = "\033[0;36m" # Cyan
    
    # Initialize random seed
    srand()
}
{
    lines=$1
    random_col=$3
    c=$4
    letter=substr(letters, c, 1)

    # Choose color: random if enabled, otherwise standard green/white
    GREEN = GREEN_RAND[int(rand() * length(GREEN_RAND))]   
    WHITE = WHITE_RAND[int(rand() * length(WHITE_RAND))]   
    if (random_colors) {
        color = colors[int(rand() * length(colors))]
    } else {
        color = GREEN
    }

    # Different trailing character
    c2 = int(rand() * letters_length) + 1
    trail_letter=substr(letters, c2, 1)
    
     # Initialize column if empty
    if (cols[random_col] == "") {
        if (rand() < start_prob) {
            cols[random_col] = 0
            drops[random_col] = min_length + int(rand() * (max_length - min_length))
        }
    }
    
    for (col in cols) {
        if (cols[col] != "") {
            line = cols[col]
            tail = line - drops[col]
            
            if (line <= lines) {
                # Choose color based on position
                if (line == lines) {
                    # Last line - print in green
                    printf "\033[%s;%sH%s%s", line, col, GREEN, letter
                } else {
                    # Not last line - print in white
                    printf "\033[%s;%sH%s%s", line, col, WHITE, letter
                }
                
                # Print trailing character in green (using different character)
                if (line > 0) {
                    printf "\033[%s;%sH%s%s", line-1, col, color, trail_letter
                }
            }
            
             # Clear tail
            if (tail >= 0) {
                printf "\033[%s;%sH ", tail, col
            }
            
            # Move drop down
            cols[col] = cols[col] + 1
            
            # Remove finished columns
            if (tail >= lines) {
                delete cols[col]
                delete drops[col]
            }
        }
    }
    # Reset cursor position
    printf "\033[0;0H"
}
  '

  echo -e "\e[1;40m"  # Set background
  clear

  while :; do
    printf "%d %d %d %d\n" "$lines" "$cols" "$((RANDOM % cols))" "$((RANDOM % letters_length))"
    sleep "$speed"
  done | awk -v letters="$letters" -v letters_length="$letters_length" "$awkscript"
}

# If script being called directly, start matrix
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  tput civis  # Hide cursor
  matrix
  tput cnorm  # Show cursor when exiting
fi
