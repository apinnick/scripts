#!/bin/bash
# Avital Pinnick, July 2, 2025
# Extracts modules from a master.adoc file with assemblies
# Can be used on an assembly, in theory, but I have not tested this thoroughly.

# If your module names do not have prefixes like "proc_", you can search for 'include::'.
# Example: 'if [[ "$line" =~ "include::" ]]; then'
# This pulls in all included files.
# You can exclude unwanted files from the final module list with a sed command.

FILE=
OUTPUT=
REPO_PATH=.
ASMB_DIR=common
ASSEMBLY_PATH=$REPO_PATH/$ASMB_DIR

print_help() {
    echo -e "Extract a list of modules from a master.adoc file"
    echo
    echo -e "Usage:"
    echo -e "    $0 [OPTIONS ...] SOURCE_FILE"
    echo
    echo -e "SOURCE_FILE    Path to a master.adoc file"
    echo
    echo -e "Options:"
    echo -e "  --repo-path, -r"
    echo -e "               Path to a git repository"
    echo -e "               Default: local dir"
    echo -e "  --assembly-dir, -a"
    echo -e "               Location of assemblies within the repository"
    echo -e "               Default: $ASMB_DIR"
    echo -e "  --output-file, -o"
    echo -e "               Write the list to a file"
    echo -e "               Default: stdout"
    echo -e "  --help, -h   Print help and exit"
}

bye() {
    echo -e ''
    echo -e "$1"
    echo -e 'Exiting ...'
    echo -e ''
    exit 1
}

# Process user arguments
if [ $# -eq 0 ]; then print_help; exit 1; fi
while [ $# -gt 1 ]; do
    case "$1" in
        --repo-path|-r)
            REPO_PATH="$2"
            shift 2
            ;;
        --assembly-dir|-a)
            ASMB_DIR="$2"
            shift 2
            ;;
        --output-file|-o)
            OUTPUT="$2"
            shift 2
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
        *)
            bye "E: Invalid option: $1"
            ;;
    esac
done
FILE=$1

# Cleanup from a previous run
rm -f assemblies.tmp assemblies.txt modules.tmp &>/dev/null

# Copy assemblies found in "FILE" to assemblies.tmp
while IFS= read -r line; do
    if [[ "$line" =~ "assembly_" ]]; then
        echo "$line" | sed -E 's/^.*(\/assembly_.*\.adoc).*$/\1/' >> assemblies.tmp
    fi
done < "$FILE"

# If assemblies.tmp exists, add assembly path, sort, and output to assemblies.txt.
if [[ "assemblies.tmp" ]]; then
    sed -i "s|^|$ASSEMBLY_PATH|g" assemblies.tmp
    sort assemblies.tmp | uniq > assemblies.txt
fi

# Search for modules in assemblies and copy to modules.tmp
while IFS= read -r filepath; do
    grep -E -h "proc_|con_|ref_" "$filepath" | sed 's/.*\///' >> modules.tmp
done < "assemblies.txt"

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

mkfifo output_buffer
# Sort module names and remove blank lines.
sort modules.tmp | uniq | grep -v '^$' >output_buffer &
if [ -n "$OUTPUT" ]; then
    cat output_buffer >$OUTPUT
else
    cat output_buffer >&1
fi
# Clean up temporary files.
rm output_buffer *.tmp &>/dev/null

# You can insert the module path if you want to run a script on the files:
# $ sed -i 's|^|path/to/modules/|' $OUTPUT
# Example: $ sed -i 's|^|../foreman-documentation/guides/common/modules/|' $OUTPUT

# If you have Vale installed in a repo and you want to check only
# the modules on the module list, run the following command within the repo:
# $ while IFS= read -r filepath; do vale "$filepath"; done < /path/to/$OUTPUT