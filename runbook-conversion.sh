#!/bin/bash
# Avital Pinnick, November 13 2022
# This script converts upstream markdown files to downstream Asciidoc files with Kramdoc. Then it cleans up the files and
# adds metadata and formatting for OpenShift docs. It also generates a file with 'include::module' lines for the assembly.
# It does not copy the files to your OpenShift docs repo because that is risky. You must do that.

# How to use this script:
# 1. Fork and clone https://github.com/kubevirt/monitoring and check out 'main'.
# 2. Set the 'SOURCE' variable in this script to the correct path for the runbooks, relative to where you run this script.
# 3. Run the script: $ ./runbook-conversion.sh
# 4. Delete ALL existing runbook modules from 'openshift-docs/modules'. This ensures that no retired runbooks remain.
# 5. Copy generated runbook modules to 'openshift-docs/modules'.
# 6. Copy 'include' lines from 'copy-to-assembly.adoc' file to the real assembly file.

# You can update these variables.
# SOURCE="../monitoring/docs/runbooks"
SOURCE="debug"
# Real assembly path/name. This goes in module comments.
ASSEMBLY_NAME="virt/logging_events_monitoring/virt-runbooks.adoc"

# You probably do not need to update these variables.
# Module file prefix
MOD_PREFIX="virt-runbooks-"
OUTPUT="converted-runbooks"
ASSEMBLY_FILE="copy-to-assembly.adoc"

# Delete runbook modules in temporary folder, if any
rm $OUTPUT/*.adoc &>/dev/null

# Convert markdown to asciidoc with kramdoc
echo "Converting files into Asciidoc with Kramdoc:"
for s in $SOURCE/*.md; do
  kramdoc $s --output=$OUTPUT/$MOD_PREFIX$(basename $s | sed 's/.md//g').adoc
  echo "$s"
done

# delete README if it exists
rm $OUTPUT/*README.adoc &>/dev/null
echo ""

# Clean up modules so that they comply with our style guides.
echo "Cleaning Asciidoc files for downstream:"

for o in $OUTPUT/*.adoc; do
echo "- $o"
# Comment lines and content-type attribute for each module
  MOD_COMMENT="\/\/ Module included in the following assemblies:\n\/\/\n\/\/ * $ASSEMBLY_NAME\n\n:_content-type: REFERENCE"
# Add module comments and first anchor ID to beginning of module
  sed -i "1s|^|$MOD_COMMENT\n\[id=\"$(basename $o| sed 's/.adoc//g')_{context}\"\]\n|" $o
# Fix code block syntax
  sed -i 's/\[,bash\]/\[source,terminal\]/g; s/\[,yaml\]/\[source,yaml\]/g; s/\[,json\]/\[source,json\]/g' $o
# Add discrete tag to level 2 and 3 headers. Level 4 already discrete.
  sed -i '/^=/s/^\(=\{2,3\} \).*/\[discrete\]\n&/' $o
# Add anchor ids to level 2+ headers.
  sed -i '/^=/s/^\(=\{2,\} \).*/[id\=\"&\"]\n&/; /^\[id\=\"/s/"=\{2,\} /"/' $o
  sed -i '/^\[id="/s/ /-/g; /^\[id="/s/.*/\L&/; /^\[id="/s/[/`()]//g; /^\[id="/s/\./_/g' $o
# Replace kubectl with oc
  sed -i 's/kubectl/oc/g' $o
# Change markup of "Example"/"Example output" header
  sed -i 's/^\(Example.*\):/.\1/g' $o
# Replace KubeVirt with DS doc attribute unless it is in backticks or a YAML file
  sed -i 's/\([^:]\) KubeVirt /\1 {VirtProductName} /g' $o
# Replace OpenShift Virt with doc attribute
  sed -i 's/OpenShift Virtualization/{VirtProductName}/g' $o
  sed -i 's/a {VirtProductName}/an {VirtProductName}/g' $o
# Clean up artifacts
  sed -i 's/ +$//g' $o
# Remove content surrounded by US comments
  sed -i '/\/\/ USstart/,/\/\/ USend/c\\' $o
# Uncomment content in DS comments
  sed -i 's/\/\/ DS: //' $o
done

#Remove double line breaks
for o in $OUTPUT/*.adoc; do
  sed -i 's/\n\n/\n/g' $o
done

# Generate temporary file with included modules
echo ""
echo "Generating '$ASSEMBLY_FILE' file. Copy the 'include' lines from the '$ASSEMBLY_FILE' file into the real assembly file."
cat << EOF > $ASSEMBLY_FILE
Copy the following lines into the assembly file.

EOF

for o in $OUTPUT/*.adoc; do
  echo -e "include::modules/$(basename $o | sed "s/\/output//g")[leveloffset=+1]\n" >> $ASSEMBLY_FILE
done

echo ""
echo "Done"
