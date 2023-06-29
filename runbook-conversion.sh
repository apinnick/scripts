#!/bin/bash
# Avital Pinnick, February 21, 2023
# This script does the following:
# - Converts markdown files to Asciidoc with Kramdown
# - Cleans up the Asciidoc files, adds metadata, and converts terms for downstream OpenShift modules
# - Generates a file with 'include::module' lines to copy to the assembly
# - Checks for unedited source files and lists them
# Note: "_{context}" has been removed from all anchor IDs and first anchor ID contains caps. See CNV-14380.

# How to use this script:
# *** Prerequisite: You must install Kramdown-Asciidoc: https://github.com/asciidoctor/kramdown-asciidoc
# 1. Fork and clone https://github.com/openshift/runbooks and check out 'master'.
# 2. Save this script in a separate directory and make sure it is executable: '$ chmod +x runbook-conversion.sh'
# 3. Run '$ ./runbook-conversion.sh path/to/source_files'.
# 4. DELETE ALL runbook modules from 'openshift-docs/modules' to ensure that obsolete runbooks do not remain in the repo.
# 5. Copy files from '/converted runbooks' to 'openshift-docs/modules'.
# 6. Copy 'include::' lines from 'copy-to-assembly.adoc' file to the real assembly file.
# See https://docs.engineering.redhat.com/display/cnv/Alert+runbooks+preparation+and+publication for more info.

if [ -z "$1" ];
then
  printf 'No source directory specified.\nUsage: $ ./runbook-conversion.sh path/to/source_files\n\nExiting...\n\n'
  exit 2
fi

SOURCE=$1

# Module variables
ASSEMBLY_NAME="virt/monitoring/virt-runbooks.adoc"
MOD_PREFIX="virt-runbook-"
MOD_COMMENT="\/\/ Do not edit this module. It is generated with a script.\n\/\/ Do not reuse this module. The anchor IDs do not contain a context statement.\n\/\/ Module included in the following assemblies:\n\/\/\n\/\/ * $ASSEMBLY_NAME\n\n:_content-type: REFERENCE"

# Output
OUTPUT="converted-runbooks"
ASSEMBLY_FILE="copy-to-assembly.txt"

# Delete existing converted runbook files, if any
rm -r $OUTPUT &>/dev/null && mkdir $OUTPUT
rm $ASSEMBLY_FILE &>/dev/null

# Convert markdown to asciidoc with kramdoc
echo -e "\nConverting Markdown files in '$SOURCE' with Kramdown-Asciidoc:"
for s in $SOURCE/*.md; do
  kramdoc $s --output=$OUTPUT/$MOD_PREFIX$(basename $s | sed 's/.md//g; s/.*/\L&/').adoc
  echo -e "- $(basename $s)"
done

# delete README if it exists
rm $OUTPUT/*README.adoc &>/dev/null

# Clean up modules so that they comply with our style guides.
echo -e "\nProcessing Asciidoc files in '$OUTPUT':"

for o in $OUTPUT/*.adoc; do
  echo "- $(basename $o)"
# Write comment block to beginning of module
  sed -i "1s|^|$MOD_COMMENT\n|" $o
# Fix code block syntax.
  sed -i 's/,bash\|,console/source,terminal/g' $o
  sed -i 's/\(,text\|,yaml\|,json\]\)/source\1/g' $o
# Add discrete tag to level 2 and 3 headers. Level 4 already discrete.
  sed -i '/^=/s/^\(=\{2,3\} \).*/\[discrete\]\n&/' $o
# Add anchor ids
  sed -i '/^=/s/^\(=\{2,\} \).*/[id\=\"&\"]\n&/; /^\[id\=\"/s/"=\{2,\} /"/' $o
  sed -i '/^\[id="/s/ /-/g; /^\[id="/s/.*/\L&/; /^\[id="/s/[/`()]//g; /^\[id="/s/\./_/g' $o
# Add runbook name to anchor ids so that they are unique
  RUNBOOK=$(basename $o | sed "s/$MOD_PREFIX//g; s/.adoc//g")
  sed -i "s/\([a-z]\)\(\"\]\)$/\1-$RUNBOOK\2/g" $o
# Replace kubectl with oc
  # sed -i 's/kubectl/oc/g' $o
# Change markup of "Example output:" to dot header.
  sed -i 's/^\(Example output\):/.\1/g' $o
# Replace KubeVirt with DS doc attribute unless it is in backticks or a YAML file
  sed -i 's/\([^:=] \)KubeVirt/\1 {VirtProductName}/g; s/^KubeVirt/{VirtProductName}/g' $o
# Replace "OpenShift Virtualization' text with doc attribute, if necessary, and fix indefinite article
  sed -i 's/OpenShift Virtualization/{VirtProductName}/g' $o
  sed -i 's/a {VirtProductName}/an {VirtProductName}/g' $o
# Remove text surrounded by US comments
  # sed -i '/\/\/ USstart/,/\/\/ USend/c\\' $o
# Uncomment DS comment
  # sed -i 's/\/\/ DS: //g' $o
# Fix hyperlinks. Kramdown does not insert 'link:' tag
  sed -i 's/https.*\[/link:&/' $o
# Create first anchor ID
  sed -i "/^= /s/^\(= \).*/[id\=\"&\"]\n&/; /^\[id\=\"/s/\"=\{1,\} /\"$MOD_PREFIX/" $o
#Remove double line breaks
  sed -i 'N;/^\n$/!P;D' $o
# Write 'include::' lines to temporary file to copy to assembly
  echo -e "\ninclude::modules/$(basename $o)[leveloffset=+1]" >> $ASSEMBLY_FILE
done

echo -e "\nTotal files converted: $(ls -1 $OUTPUT | wc -l)\n"
echo -e "Generated files:\n- $ASSEMBLY_FILE. Copy the 'include::' lines from this file to the assembly file."
echo -e "\nDone\n"
