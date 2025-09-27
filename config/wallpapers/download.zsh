echo "DEBUG: PATH is $PATH"

#!/usr/bin/env zsh
set -euo pipefail



# Where to save wallpapers
WPDIR="${WALLPAPERS_DIR:-$HOME/wallpapers}"

# Create folder if missing
if [[ ! -d "$WPDIR" ]]; then
  echo "→ Creating $WPDIR"
  mkdir -p "$WPDIR"
fi

echo "→ Saving wallpapers into: $WPDIR"


fetch() {
  local url="$1"
  local out="$2"
  local path="$WPDIR/$out"

  if [[ -f "$path" ]]; then
    echo "⚠️  Skipping $out (already exists)"
    return
  fi

  echo "… Downloading $out"

  # Find curl or wget dynamically
  local dl_cmd=""
  if dl_cmd=$(command -v curl 2>/dev/null); then
    "$dl_cmd" -fL "$url" -o "$path"
  elif dl_cmd=$(command -v wget 2>/dev/null); then
    "$dl_cmd" -O "$path" "$url"
  else
    echo "❌ Neither curl nor wget is available. Please install one." >&2
    return 1
  fi
}

# --- Public-domain picks (hi-res) ---

# Hilma af Klint — The Ten Largest No. 3 (Youth), 1907
fetch "https://upload.wikimedia.org/wikipedia/commons/e/e9/Hilma_af_Klint_-_The_Ten_Largest_No._3_-_Youth_-_1907.jpg" \
      "hilma_af_klint_the_ten_largest_no3_youth_1907.jpg"

# Wassily Kandinsky — Composition VIII (1923)
fetch "https://upload.wikimedia.org/wikipedia/commons/a/ad/Wassily_Kandinsky_Composition_VIII.jpg" \
      "kandinsky_composition_8_1923.jpg"

# Lyubov Popova — Composition (1921)
fetch "https://upload.wikimedia.org/wikipedia/commons/d/db/Composition_-_Lyubov_Popova.jpg" \
      "popova_composition_1921.jpg"

fetch "https://upload.wikimedia.org/wikipedia/commons/f/f0/Vassily_Kandinsky%2C_1923_-_Circles_in_a_Circle.jpg" \
      "kandinsky_circles_in_a_circle_picryl.jpg"



echo "✅ Done!"
ls -lh "$WPDIR"

