#!/bin/bash
# Avital Pinnick, July 2, 2025
# Extracts modules from a master.adoc file with assemblies
# Can be used on an assembly, in theory, but I have not tested this thoroughly.

# If your module names do not have prefixes like "proc_", you can search for 'include::'.
# Example: 'if [[ "$line" =~ "include::" ]]; then'
# This pulls in all included files.
# You can exclude unwanted files from the final module list with a sed command.

REPO_PATH=../foreman-documentation/guides
ASSEMBLY_PATH=$REPO_PATH/common
FILE=$REPO_PATH/doc-Upgrading_Project_Disconnected/master.adoc

rm assembly.tmp assembly.txt modules.tmp module-list.txt &>/dev/null

# Copy assemblies found in "FILE" to assembly.tmp
while IFS= read -r line; do
    if [[ "$line" =~ "assembly_" ]]; then
        echo "$line" | sed -E 's/^.*(\/assembly_.*\.adoc).*$/\1/' >> assembly.tmp
    fi
done < "$FILE"

# If assembly.tmp exists, add assembly path, sort, and output to assembly.txt.
if [[ "assembly.tmp" ]]; then
    sed -i "s|^|$ASSEMBLY_PATH|g" assembly.tmp
    sort assembly.tmp | uniq > assembly.txt
fi

# Search for modules in assemblies and copy to modules.tmp
while IFS= read -r filepath; do
    grep -E -h "proc_|con_|ref_" "$filepath" | sed 's/.*\///' >> modules.tmp
done < "assembly.txt"

# Copy modules found in "FILE" to modules.tmp
while IFS= read -r line; do
    if [[ "$line" =~ "proc_" || "$line" =~ "con_" || "$line" =~ "ref_" ]]; then
        echo "$(basename $line)" >> modules.tmp
    fi
done < "$FILE"

# Module name cleanup.
# Remove files that you don't want to check.
sed -i 's/proc_providing-feedback-on-red-hat-documentation.adoc//g' modules.tmp
# Remove leveloffsets and empty square brackets.
sed -i 's/\[.*\]$//' modules.tmp
# Remove comments.
sed -i 's/\/\/.*//' modules.tmp
# Sort module names.
sort modules.tmp | uniq > module-list.txt
# Remove blank lines.
sed -i '/^$/d' module-list.txt

rm *.tmp &>/dev/null

# You can insert the module path if you want to run a script on the files:
# $ sed -i 's|^|path/to/modules/|' module-list.txt
# Example: $ sed -i 's|^|../foreman-documentation/guides/common/modules/|' module-list.txt

# If you have Vale installed in a repo and you want to check only
# the modules on the module list, run the following command within the repo:
# $ while IFS= read -r filepath; do vale "$filepath"; done < /path/to/module-list.txt