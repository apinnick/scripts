#!/bin/bash
# Avital Pinnick, 2021
# This file builds a new 'index.md' file so that new directories do not have to be
# added manually.

BUILD_URL=https://ccs-internal-documentation.pages.redhat.com/onboarding-checklists
HTML=html_files
ODT=odt_files

rm index.md > /dev/null 2>&1

cat << EOF > index.md
---
layout: home
---

Welcome to the official site for CCS onboarding checklists.

These checklists are updated regularly and have been approved by the [CCS Onboarding Program team](https://source.redhat.com/groups/public/ccs-onboarding-program).

You can view the checklists in a browser or download them as ODT files and import them into Google docs.

Onboarding checklists (HTML):
EOF

for h in $HTML/*; do
  echo -e "- [$(basename $h | sed 's/.html//g; s/_/ /g; s/[a-z]*/\u&/g' )]($BUILD_URL/$HTML/$(basename $h))" >> index.md
done

echo -e "\nODT files:" >> index.md

for o in $ODT/*; do
  echo -e "- [$(basename $o)]($BUILD_URL/$ODT/$(basename $o))" >> index.md
done

echo -e "\nIf you see something that needs to be fixed, you can submit a [GitLab issue](https://gitlab.cee.redhat.com/ccs-internal-documentation/onboarding-checklists/-/issues/new?issue%5Bmilestone_id%5D=)." >> index.md

echo -e "\nSite maintainers: [Avital Pinnick](mailto:apinnick@redhat.com), [Jiri Herrmann](mailto:jherrman@redhat.com)" >> index.md

echo -e "\n_Files generated on $(date +%b\ %-e\ %Y -r $h)_" >> index.md

echo "New index file built."
