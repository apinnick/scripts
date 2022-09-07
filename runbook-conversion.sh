#!/bin/bash
# Avital Pinnick, June 2022
# Script to convert upstream Kubevirt runbooks to downstream modules

# real source folder
# SOURCE="../monitoring/docs/runbooks"
# test source folder
SOURCE="runbooks"
# Output folder, usually "modules"
OUTPUT="output"
# Update with your real assembly path/name for module comments:
ASSEMBLY_NAME="virt/logging_events_monitoring/virt-virtualization-alerts.adoc"
# Module file names will begin with this prefix:
MOD_PREFIX="virt-alert-"

# Delete old runbook modules
rm $OUTPUT/$MOD_PREFIX*.adoc &>/dev/null

# Convert markdown to asciidoc with kramdoc
for s in $SOURCE/*.md; do
  kramdoc $s --output=$OUTPUT/$MOD_PREFIX$(basename $s | sed 's/.md//g').adoc
done

# delete README if it exists
rm $OUTPUT/*README.adoc &>/dev/null

# Clean up modules so that they comply with FCC standards
for o in $OUTPUT/*.adoc; do
# Comment lines and content-type attribute for each module
  MOD_COMMENT="\/\/ Module included in the following assemblies:\n\/\/\n\/\/ * $ASSEMBLY_NAME\n\n:_content-type: REFERENCE"
# Add module comments and first anchor ID to beginning of module
  sed -i "1s|^|$MOD_COMMENT\n\[id=\"$(basename $o| sed 's/.adoc//g')_{context}\"\]\n|" $o
# Fix code block syntax
  sed -i 's/\[,bash\]/\[source,terminal\]/g; s/\[,yaml\]/\[source,yaml\]/g' $o
# Add discrete tag to level 2 and 3 headers. Level 4 already discrete.
  sed -i '/^=/s/^\(=\{2,3\} \).*/\[discrete\]\n&/' $o
# Add anchor ids to level 2+ headers.
  sed -i '/^=/s/^\(=\{2,\} \).*/[id\=\"&\"]\n&/; /^\[id\=\"/s/"=\{2,\} /"/' $o
  sed -i '/^\[id="/s/ /-/g; /^\[id="/s/.*/\L&/; /^\[id="/s/[/`()]//g; /^\[id="/s/\./_/g' $o
# Change kubectl to oc
  sed -i 's/kubectl/oc/g' $o
# # Change kubevirt to CNV unless it's a URL or in backticks - in progress
#   sed -i 's/[^/`][Kk]ubevirt/\{VirtProductName\}/g' $o
# Change Kubevirt CR to HyperConverged CR
  sed -i 's/KubeVirt CR/`HyperConverged` custom resource/g' $o
# Remove upstream content
  sed -i '/\/\/ KVstart/,/\/\/ KVend/c\\' $o
# Uncomment downstream content
  sed -i 's/\/\/ CNV: //' $o
# Clean up artifacts
  sed -i 's/ +//g' $o
done

#Remove double line breaks
for o in $OUTPUT/*.adoc; do
  sed -i 's/\n\n/\n/g' $o
done

# write "COPY-TO-ASSEMBLY.adoc" file with included modules
cat << EOF > COPY-TO-ASSEMBLY.adoc

This is an automatically generated list of included files for your assembly.

EOF

for o in $OUTPUT/*.adoc; do
  echo -e "include::$OUTPUT/$(basename $o | sed "s/\/output//g")[leveloffset=+1]\n" >> COPY-TO-ASSEMBLY.adoc
done

echo "Done!"
