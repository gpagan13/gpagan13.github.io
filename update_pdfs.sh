#!/bin/zsh
# Copy the latest compiled PDFs of both papers into this website folder
# and publish them to https://gpagan13.github.io
# Usage (from anywhere):  zsh ".../writing/gpagan13.github.io/update_pdfs.sh"

set -e
SITE="${0:A:h}"            # this folder
WRITING="${SITE:h}"        # the parent "writing" folder

cp "$WRITING/JMP/jmp.pdf"                                      "$SITE/jmp.pdf"
cp "$WRITING/Ethnicity_AgAttachment/ethnicity_attachment.pdf"  "$SITE/ethnicity_attachment.pdf"

cd "$SITE"
git add .
if git diff --cached --quiet; then
  echo "PDFs unchanged; nothing to publish."
else
  git commit -m "Update paper PDFs ($(date +%Y-%m-%d))"
  git push
  echo "Published. Changes appear at https://gpagan13.github.io within a minute or two."
fi
