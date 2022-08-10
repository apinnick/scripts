#!/bin/bash
# Avital Pinnick, 2021
# This file builds a new 'index.md' file so that new directories do not have to be
# added manually.

BUILD_URL=https://ccs-internal-documentation.pages.redhat.com/onboarding-checklists
HTML=html_files
DOCX=docx_files

rm index.md > /dev/null 2>&1

cat << EOF > index.md
---
layout: home
---

Onboarding checklists:
EOF

for h in $HTML/*; do
  echo -e "- [$(basename $h | sed 's/.html//g; s/_/ /g; s/[a-z]*/\u&/g' )]($BUILD_URL/$HTML/$(basename $h))" >> index.md
done

echo -e "\nDOCX files to import into Google docs:" >> index.md

for d in $DOCX/*; do
  echo -e "- [$(basename $d)]($BUILD_URL/$DOCX/$(basename $d))" >> index.md
done

echo -e "\nIf you see something that needs to be fixed, you can submit a [GitLab issue](https://gitlab.cee.redhat.com/ccs-internal-documentation/onboarding-checklists/-/issues/new?issue%5Bmilestone_id%5D=)." >> index.md

echo -e "\n_Files generated on $(date +%b\ %-e\ %Y -r $h)_" >> index.md

echo "New index file built."
