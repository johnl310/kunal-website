#!/usr/bin/env bash
set -e

echo "=== Building site ==="

# 1. Compile Tailwind
npx @tailwindcss/cli -i src/input.css -o assets/style.css --minify
echo "✓ Tailwind compiled"

# 2. Inject partials into pages
for src_file in src/*.html; do
  filename=$(basename "$src_file")
  cp "$src_file" "$filename"
  for partial in partials/_*.html; do
    partial_name=$(basename "$partial")
    perl -0777 -i -pe "
      open(my \$fh, '<', '$partial') or die;
      my \$content = do { local \$/; <\$fh> };
      s/<!-- PARTIAL:${partial_name} -->/\$content/g;
    " "$filename"
  done
  echo "✓ Built $filename"
done

# 3. Build writing articles
if [ -d "src/writing" ]; then
  mkdir -p writing
  for src_file in src/writing/*.html; do
    [ -f "$src_file" ] || continue
    filename=$(basename "$src_file")
    cp "$src_file" "writing/$filename"
    for partial in partials/_*.html; do
      partial_name=$(basename "$partial")
      perl -0777 -i -pe "
        open(my \$fh, '<', '$partial') or die;
        my \$content = do { local \$/; <\$fh> };
        s/<!-- PARTIAL:${partial_name} -->/\$content/g;
      " "writing/$filename"
    done
    echo "✓ Built writing/$filename"
  done
fi

echo "=== Build complete ==="
