#!/bin/bash
# Avital Pinnick, Nov 2022
# Script to convert upstream Kubevirt runbooks to downstream modules

# real source folder
SOURCE="../monitoring/docs/runbooks"
# test source folder
# SOURCE="runbooks"
# Output folder, usually "modules"
OUTPUT="output"
# Update with your real assembly path/name for module comments:
ASSEMBLY_NAME="virt/logging_events_monitoring/virt-virtualization-alerts.adoc"
# Module file names will begin with this prefix:
MOD_PREFIX="virt-alert-"

# Delete old runbook modules
rm $OUTPUT/$MOD_PREFIX*.adoc &>/dev/null
echo Deleting existing runbook modules

# Convert markdown to asciidoc with kramdoc
for s in $SOURCE/*.md; do
  kramdoc $s --output=$OUTPUT/$MOD_PREFIX$(basename $s | sed 's/.md//g').adoc
  echo Converting $s
done

# delete README if it exists
rm $OUTPUT/*README.adoc &>/dev/null

# Clean up modules so that they comply with FCC standards
for o in $OUTPUT/*.adoc; do
echo Generating $o
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
  sed -i 's/\([^:]\) KubeVirt/\1 \{VirtProductName\}/g' $o
# Replace OpenShift Virt with doc attribute
  sed -i 's/OpenShift Virtualization/\{VirtProductName\}/g' $o
# Remove content surrounded by US comments
  sed -i '/\/\/ USstart/,/\/\/ USend/c\\' $o
# Uncomment content in DS comments
  sed -i 's/\/\/ DS: //' $o
# Clean up artifacts
  sed -i 's/ +//g; s/  $ /$ /g' $o
done

#Remove double line breaks
for o in $OUTPUT/*.adoc; do
  sed -i 's/\n\n/\n/g' $o
done

# write "COPY-TO-ASSEMBLY.adoc" file with included modules
cat << EOF > virt-virtualization-alerts.adoc
:_content-type: ASSEMBLY
[id="virt-virtualization-alerts"]
= {VirtProductName} critical alerts
include::_attributes/common-attributes.adoc[]
:context: virt-virtualization-alerts

toc::[]

{VirtProductName} displays alerts in the web console that inform you when a problem occurs.

Each alert has a runbook that describes the following:

* Meaning of the alert
* Impact of the alert on your system
* Diagnosis of possible causes
* Mitigation

EOF

for o in $OUTPUT/*.adoc; do
  echo -e "include::modules/$(basename $o | sed "s/\/output//g")[leveloffset=+1]\n" >> virt-virtualization-alerts.adoc
done

cat << EOF >> virt-virtualization-alerts.adoc
[role="_additional-resources"]
[id="additional-resources_virt-virtualization-alerts"]
== Additional resources
* xref:../../support/getting-support.adoc[Getting support]
EOF

echo ""
echo "Review the generated assembly file: virt-virtualization-alerts.adoc"

echo "Done"
