#!/bin/bash

# Trap: When the user presses CTRL+C, clear the terminal and restore the cursor to its normal state
trap '{ tput cnorm; clear; exit 1; }' INT

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
        -h|--help)  # Display help if -h or --help is passed
            echo "Matrix (Terminal Display Effect)"
            echo ""
            echo "A terminal-based visual effect mimicking the Matrix code screen."
            echo "Random characters and colors are displayed in columns that scroll vertically."
            echo ""
            echo "Usage: matrix [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -h, --help           Show this help message"
            echo "  --spacing, -s        Set the spacing (likelihood) of characters appearing (default: 100)"
            echo "  --scroll, -sc        Set scroll speed (default: 0 for static, positive integer for speed)"
            echo "  --random-colors, -rc Toggle between two color modes: the default colors or a full list of colors (default: false)"
            echo ""
            echo "Example 1: matrix --spacing 50 --scroll 2"
            echo "Example 2: matrix -s 200 -sc 1 -rc"
            exit 0
            ;;
        --spacing|-s)  # Parse the --spacing or -s option and set its value
            spacing=$2
            shift 2  # Move past the current argument and its value
            ;;
        --scroll|-sc)  # Parse the --scroll or -sc option and set its value
            scroll=$2
            shift 2  # Move past the current argument and its value
            ;;
        --random-colors|-rc)  # Parse the --random-colors or -rc option and enable random color mode
            random_colors=true
            shift  # Move past this argument
            ;;
        *)
            echo "Invalid option: $arg"  # Invalid option handling
            exit 1
            ;;
    esac
done

### Colors definitions (ANSI escape codes for terminal colors)
magenta="\033[0;35m"
brightmagenta="\033[1;35m"
dimmagenta="\033[2;35m"
yellow="\033[0;33m"
brightyellow="\033[1;33m"
dimyellow="\033[2;33m"
blue="\033[0;34m"
brightblue="\033[1;34m"
dimblue="\033[2;34m"
cyan="\033[0;36m"
brightcyan="\033[1;36m"
dimcyan="\033[2;36m"
green="\033[0;32m"
brightgreen="\033[1;32m"
dimgreen="\033[2;32m"
red="\033[0;31m"
brightred="\033[1;31m"
dimred="\033[2;31m"
white="\033[0;37m"
brightwhite="\033[1;37m"
dimwhite="\033[2;37m"
black="\033[0;30m"
grey="\033[0;37m"
darkgrey="\033[1;30m"

# Declare arrays for different alphabets and characters
katakana=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾋ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ)
hiragana=(あ い う え お か き く け こ さ し す せ そ た ち つ て と な に ぬ ね の は ひ ふ へ ほ ま み む め も や ゆ よ ら り る れ ろ わ ん)
latin=(a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)
symbols=(@ $ % ^ * = + { } ~  / ! ? : . , _ - ± × ÷ √ ∞ ≈ ≠ ≡ ≤ ≥ « » © ® ™ ¢ £ ¥ € ₽ ₿)
cyrillic=(А Б В Г Ґ Д Е Ё Ж З И Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ы Э Ю Я а б в г д е ё ж з и й к л м н о п р с т у ф х ц ч ш щ ы э ю я)
greek=(Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω)
hebrew=(א ב י ג ד ה ו ח ט ך כ ע פ צ ק ר ש)
arabic=(ا أ إ آ ء ؤ ئ ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي ى)
chinese=(你 好 世 界 风 雨 雷 电 火 水 山 川 天 地 人 日 月 星 龙 虎)
devanagari=(अ आ इ ई उ ऊ ए ऐ ओ औ क ख ग घ च छ ज झ ट ठ ड ढ ण त थ द ध न प फ ब भ म य र ल व श ष स ह)
korean=(가 각 간 갇 갈 감 갑 값 갓 강 개 객 거 건 걸 검 겁 것 경 계 고 곡 곤 골 공 과 광 교 구 국 군 굴 궁 권 그 극 근 글 금 급 기 긴 길 김 깊 까 깨 꺼 꼬 꽃)
thai=(ก ข ค ฆ ง จ ฉ ช ซ ญ ฎ ฏ ฐ ฑ ฒ ณ ด ต ถ ท ธ น บ ป ผ พ ภ ม ย ร ล ว ศ ษ ส ห ฬ อ)
tibetan=(ཀ ཁ ག ང ཅ ཆ ཇ ཉ ཏ ཐ ད ན པ ཕ བ མ ཙ ཚ ཛ ཞ ཟ འ ཡ ར ལ ཤ ས ཧ ཨ)
braille=(⠁ ⠃ ⠉ ⠙ ⠑ ⠋ ⠛ ⠓ ⠊ ⠚ ⠅ ⠇ ⠍ ⠝ ⠕ ⠏ ⠟ ⠗ ⠎ ⠞ ⠥ ⠧ ⠭ ⠽)

# Combine all characters from the different alphabets and symbol arrays
chars=()
chars+=("${latin[@]}")
# chars+=("${symbols[@]}")  # Bug: symbols array is commented out because of issues
chars+=("${katakana[@]}")
chars+=("${cyrillic[@]}")
chars+=("${greek[@]}")
chars+=("${hebrew[@]}")
chars+=("${arabic[@]}")
chars+=("${devanagari[@]}")
chars+=("${thai[@]}")
chars+=("${tibetan[@]}")
chars+=("${braille[@]}")

# Check if random color mode is enabled and set color palette accordingly
if [[ $random_colors == true ]]; then
    colors=($blue $brightblue $dimblue $cyan $brightcyan $dimcyan $green $brightgreen $dimgreen $magenta $brightmagenta $dimmagenta $yellow $brightyellow $dimyellow $red $brightred $dimred $brightwhite $dimwhite $white $grey $darkgrey)
else
    colors=($green $brightgreen $dimgreen $dimwhite)
fi

# Assign default values for spacing and scroll based on user input
spacing=${1:-100}   # The likelihood of a character being left in place (lower = denser)
scroll=${2:-0}      # 0 for static display, higher values control scroll speed
screenlines=$(( $(tput lines) - 1 + $scroll))  # Calculate screen height, considering scroll speed
screencols=$(( $(tput cols) / 2 - 1 ))         # Calculate screen width, adjusted for scrolling effect

# Get the number of available characters and colors
count=${#chars[@]}
colorcount=${#colors[@]}

# Show help if -h is passed
if [[ $1 =~ '-h' ]]; then
    echo "Display a Matrix(ish) screen in the terminal"
    echo "Usage: matrix [SPACING [SCROLL]]"
    echo "Example: matrix 100 0"
    exit 0
fi

# Clear screen and hide cursor to create the "Matrix" effect
clear
tput cup 0 0    # Move cursor to top-left corner
tput civis      # Hide the cursor

# Main loop for the Matrix-like effect
while :; do
    # Iterate over the terminal's lines and columns
    for ((i = 1; i <= screenlines; i++)); do
        for ((j = 1; j <= screencols; j++)); do
            rand=$((RANDOM % spacing))  # Generate random number for spacing
            case $rand in
                0)  # Randomly display a character with a color
                    color_idx=$((RANDOM % colorcount))  # Random color index
                    char_idx=$((RANDOM % count))  # Random character index
                    printf "${colors[$color_idx]}${chars[$char_idx]} "
                    ;;
                1)  # Leave space blank
                    printf "  "
                    ;;
                *)  # Empty space with minimal offset for scrolling effect
                    printf "\033[2C"
                    ;;
            esac
        done
        printf "\n"
    done
    tput cup 0 0  # Reset cursor position to the top-left corner for next frame
done
