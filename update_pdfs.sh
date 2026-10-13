#!/bin/zsh
# Refresh the website's PDFs and publish them to https://gpagan13.github.io
#   - copies the latest compiled PDFs of both papers
#   - rebuilds cv.pdf from the general CV, with the phone number removed
# Usage (from anywhere):  zsh ".../writing/gpagan13.github.io/update_pdfs.sh"

set -e
SITE="${0:A:h}"            # this folder
WRITING="${SITE:h}"        # the parent "writing" folder
CV_TEX="$HOME/Library/CloudStorage/Dropbox/Job Market 26-27/CV General/CV.tex"

cp "$WRITING/JMP/jmp.pdf"                                      "$SITE/jmp.pdf"
cp "$WRITING/Ethnicity_AgAttachment/ethnicity_attachment.pdf"  "$SITE/ethnicity_attachment.pdf"

# Web CV: compile a temporary copy of CV.tex without the "Mobile: (xxx) xxx-xxxx" entry
TMP=$(mktemp -d)
sed -E 's/Mobile: \([0-9]{3}\) [0-9-]+//' "$CV_TEX" > "$TMP/CV.tex"
(cd "$TMP" && /Library/TeX/texbin/latexmk -pdf -interaction=nonstopmode -silent CV.tex >/dev/null)
cp "$TMP/CV.pdf" "$SITE/cv.pdf"
rm -rf "$TMP"

cd "$SITE"
git add .
if git diff --cached --quiet; then
  echo "PDFs unchanged; nothing to publish."
else
  git commit -m "Update PDFs ($(date +%Y-%m-%d))"
  git push
  echo "Published. Changes appear at https://gpagan13.github.io within a minute or two."
fi
