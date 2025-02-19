# Matrix-style screensaver for your terminal
# Either run execute the script directly,
# Or source it in .zshrc, and start with $ matrix

# Clear terminal when CTRL+C
trap '{ clear; exit 1; }' INT

matrix () {
  local lines=$(tput lines)
  local cols=$(tput cols)
  local start_prob=${1:-1.0}  # Default start probability is 0.8
  local min_length=${2:-5}   # Default min length is 50
  local length_factor=${3:-0.95}  # Default max_length = 0.9 * lines

  # letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
  # letters="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ"
  # letters="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
  # letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"

  awkscript='
  BEGIN {
    min_length = '$min_length';
    max_length = int('$length_factor' * '$lines'); 
    start_prob = '$start_prob';
  }

  {
    letters="ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
    lines=$1
    random_col=$3
    c=$4
    letter=substr(letters,c,1)

    # Initialize new column with random drop length
    if (cols[random_col] == "") {
      if (rand() < start_prob) {  # Controlled probability for starting a new column
        cols[random_col] = 0;
        drops[random_col] = min_length + int(rand() * (max_length - min_length));  # Random drop length
      }
    }

    for (col in cols) {
      if (cols[col] != "") {
        line = cols[col];
        tail = line - drops[col];

 # Print current character in white (including last line)
            if (line <= lines) {
                printf "\033[%s;%sH\033[1;37m%s", line, col, letter;
                
                # Print trailing character in green
                if (line > 0) {
                    printf "\033[%s;%sH\033[2;32m%s", line-1, col, letter;
                }
            }
            
            # Clear character at tail and beyond
            if (tail >= 0) {
                printf "\033[%s;%sH ", tail, col;
            }

        cols[col] = cols[col] + 1;

        # Remove column when entire drop has passed bottom
        if (tail >= lines) {
          delete cols[col];
          delete drops[col];
        }
      }
    }

    # Reset cursor position
    printf "\033[0;0H"
  }
  '

  echo -e "\e[1;40m"
  clear

  while :; do
    echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 117 )) # 117 is the length of letters +1
    sleep 0.05
  done | awk "$awkscript"
}



# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly, start matrix
if [ $sourced -eq 0 ]; then
  matrix
fi
