#!/bin/bash
# Avital Pinnick, November 24, 2022
# This script does the following:
# - Converts upstream markdown files to downstream Asciidoc files with Kramdown
# - Cleans up the Asciidoc files, adds metadata, and converts terms for downstream modules
# - Generates a file with 'include::module' lines to copy to the assembly
# This script does NOT copy the files to your OpenShift docs repo because that could be risky.
# *** Prerequisite: You must install Kramdown: "$ gem install kramdown"

# How to use this script:
# 1. Fork and clone https://github.com/kubevirt/monitoring and check out 'main'.
# 2. Save this script in a separate directory and make sure it is executable: '$ chmod +x runbook-conversion.sh'
# 3. Set the 'SOURCE' variable in this script to the correct path for the runbooks, relative to where you run this script.
# 4. Run '$ ./runbook-conversion.sh'
# 5. DELETE ALL runbook modules from 'openshift-docs/modules' to ensure that obsolete runbooks do not remain in the repo.
# 6. Copy files from '/converted runbooks' to 'openshift-docs/modules'.
# 7. Copy 'include::' lines from 'copy-to-assembly.adoc' file to the real assembly file.

# You can update these variables.
SOURCE="../monitoring/docs/runbooks"
# SOURCE="debug"
# Real assembly path/name for the "Module included ..." comment.
ASSEMBLY_NAME="virt/logging_events_monitoring/virt-runbooks.adoc"

# You probably do not need to update these variables.
# Module file prefix
MOD_PREFIX="virt-runbook-"
OUTPUT="converted-runbooks"
ASSEMBLY_FILE="copy-to-assembly.adoc"

# Delete existing converted runbook files, if any
rm -r $OUTPUT &>/dev/null && mkdir $OUTPUT
rm $ASSEMBLY_FILE &>/dev/null

# Convert markdown to asciidoc with kramdoc
echo -e "\nConverting Markdown source files into Asciidoc with Kramdown:"
for s in $SOURCE/*.md; do
  kramdoc $s --output=$OUTPUT/$MOD_PREFIX$(basename $s | sed 's/.md//g').adoc
  echo "$s"
done

# delete README if it exists
rm $OUTPUT/*README.adoc &>/dev/null

# Clean up modules so that they comply with our style guides.
echo -e "\nProcessing Asciidoc files:"

for o in $OUTPUT/*.adoc; do
  echo "$o"
# Add comment lines and content-type attribute
  MOD_COMMENT="\/\/ Module included in the following assemblies:\n\/\/\n\/\/ * $ASSEMBLY_NAME\n\n:_content-type: REFERENCE"
# Create first anchor ID
  FILE_NAME=$(basename $o | sed "s/.adoc//g")
  sed -i "1s|^|$MOD_COMMENT\n\[id=\"$FILE_NAME\_{context}\"\]\n|" $o
# Fix code block syntax
  sed -i 's/\[,bash\]/\[source,terminal\]/g; s/\[,yaml\]/\[source,yaml\]/g; s/\[,json\]/\[source,json\]/g' $o
# Add discrete tag to level 2 and 3 headers. Level 4 already discrete.
  sed -i '/^=/s/^\(=\{2,3\} \).*/\[discrete\]\n&/' $o
# Add anchor ids
  sed -i '/^=/s/^\(=\{2,\} \).*/[id\=\"&\"]\n&/; /^\[id\=\"/s/"=\{2,\} /"/' $o
  sed -i '/^\[id="/s/ /-/g; /^\[id="/s/.*/\L&/; /^\[id="/s/[/`()]//g; /^\[id="/s/\./_/g' $o
# Add runbook name to anchor ids so that they are unique
  RUNBOOK=$(basename $o | sed "s/$MOD_PREFIX//g; s/.adoc//g")
  sed -i "s/\([a-z]\)\(\"\]\)$/\1-$RUNBOOK\2/g" $o
# Replace kubectl with oc
  sed -i 's/kubectl/oc/g' $o
# Change markup of "Example"/"Example output" to dot header
  sed -i 's/^\(.*xample.*\):/.\1/g' $o
# TODO: Fix problem with blank line required before yaml blocks. Also, need to add this to guidelines
# Replace KubeVirt with DS doc attribute unless it is in backticks or a YAML file
  sed -i 's/\([^:=] \)KubeVirt/\1 {VirtProductName}/g; s/^KubeVirt/{VirtProductName}/g' $o
# Replace "OpenShift Virtualization' text with doc attribute and fix article
  sed -i 's/OpenShift Virtualization/{VirtProductName}/g' $o
  sed -i 's/a {VirtProductName}/an {VirtProductName}/g' $o
# Clean up artifacts
  sed -i 's/ +$//g' $o
# Remove upstream content surrounded by US comments
  sed -i '/\/\/ USstart/,/\/\/ USend/c\\' $o
# Uncomment downstream content
  sed -i 's/\/\/ DS: //g' $o
#Remove double line breaks
  sed -i 'N;/^\n$/!P;D' $o
# Write 'include::' lines to temporary file
  echo -e "include::modules/$(basename $o | sed "s/\/output//g")[leveloffset=+1]\n" >> $ASSEMBLY_FILE
done

echo -e "\n*** Job summary ***\n"

echo -e "- Converted $(ls -1 $OUTPUT | wc -l) files."
echo -e "- Generated '$ASSEMBLY_FILE' file with 'include::' lines to copy to the assembly file."

# Search for source files with no comments
echo -e "- Searching for unedited source files, if any."
grep -riL '<!--' $SOURCE/*.md

echo -e "\nDone\n"
