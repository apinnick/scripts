#!/bin/bash
# Avital Pinnick and Lena Ansorgova
# Extracts modules from a master.adoc file with assemblies and nested assemblies
# If your module names do not have prefixes like "proc_", you can search for 'include::'.
# Example: 'if [[ "$line" =~ "include::" ]]; then'
# This pulls in all included files.
# You can exclude unwanted files from the final module list with a sed command.

REPO_PATH=.
ASMB_DIR=assemblies/
MOD_DIR=modules/

print_help() {
    echo -e "Extract a list of modules from a master.adoc file"
    echo -e "List is written to stdout"
    echo
    echo -e "Usage:"
    echo -e "    $0 [OPTIONS ...] SOURCE_FILE"
    echo
    echo -e "SOURCE_FILE    Path to a master.adoc file"
    echo
    echo -e "Options:"
    echo
    echo -e "  --repo-path, -r REPO_PATH/"
    echo -e "               Path to a git repository"
    echo -e "               Default: current dir"
    echo -e "  --assembly-dir, -a ASSEMBLY_DIR/"
    echo -e "               Location of assemblies within the repository"
    echo -e "               Default: $ASMB_DIR"
    echo -e "  --module-dir, -m MODULE_DIR/"
    echo -e "               Location of modules within the repository"
    echo -e "               Default: $MOD_DIR"
    echo -e "  --help, -h   Print help and exit"
    echo
    echo -e "Path structure:"
    echo
    echo -e "The repo path, assembly dir, and module dir comprise"
    echo -e "the full path of assemblies and modules in the output as follows:"
    echo
    echo -e "  REPO_PATH/ASSEMBLY_DIR/assembly.adoc"
    echo -e "  REPO_PATH/MODULE_DIR/module.adoc"
    echo
    echo "Do not include the repository path in '-a' or '-m'!"
    echo
}

bye() {
    echo -e "$1" >&2
    echo -e 'Exiting ...' >&2
    exit 1
}

# Process user arguments
if [ $# -eq 0 ]; then print_help; exit 0; fi
if [ "$1" = "-h" -o "$1" = "--help" ]; then
    print_help; exit 0;
else if [ $# -eq 1 ]; then bye "E: Invalid option: $1"; fi
fi
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
        --module-dir|-m)
            MOD_DIR="$2"
            shift 2
            ;;
        *)
            bye "E: Invalid option: $1"
            ;;
    esac
done
FILE=$1
ASSEMBLY_PATH=$REPO_PATH/$ASMB_DIR
MODULE_PATH=$REPO_PATH/$MOD_DIR

# Cleanup from a previous run
rm -f assemblies.tmp nested-assemblies.tmp modules.tmp &>/dev/null

# Copy assemblies found in "FILE" to assemblies.tmp
while IFS= read -r line; do
    if [[ "$line" =~ "assembly_" ]]; then
        echo "$line" | sed -E "s/^.*(\/assembly_.*\.adoc).*$/\1/" >> assemblies.tmp
    fi
done < "$FILE"

sed -i "s|^|$ASSEMBLY_PATH|g; s|\/\/|\/|g" assemblies.tmp

# Search for nested assemblies and copy to nested-assemblies.tmp
while IFS= read -r filepath; do
    grep -E -h "assembly_" "$filepath" | sed "s/.*\(assembly_.*\.adoc\).*/\1/p" >> nested-assemblies.tmp
done < "assemblies.tmp"

sed -i "s|^|$ASSEMBLY_PATH|g; s|\/\/|\/|g" nested-assemblies.tmp

# If assemblies.tmp exists, sort list and output to assemblies.txt.
if [[ "assemblies.tmp" ]]; then
    sort assemblies.tmp | uniq > assemblies.txt
fi

# If nested-assemblies.tmp exists, sort list and append to assemblies.txt.
if [[ "nested-assemblies.tmp" ]]; then
    sort nested-assemblies.tmp | uniq >> assemblies.txt
    cat nested-assemblies.tmp | uniq > nested-assemblies.txt
fi

# Search for modules in assemblies.txt and copy to modules.tmp
while IFS= read -r filepath; do
    grep -E -h "proc_|con_|ref_" "$filepath" | sed 's/.*\///' >> modules.tmp
done < "assemblies.txt"

# Copy modules found in "FILE" to modules.tmp
while IFS= read -r line; do
    if [[ "$line" =~ "proc_" || "$line" =~ "con_" || "$line" =~ "ref_" ]]; then
        echo "$(basename $line)" >> modules.tmp
    fi
done < "$FILE"

# Module list cleanup.
# Remove comments.
sed -i 's/\/\/.*//' modules.tmp
# Remove files that you don't want to check.
sed -i 's/proc_providing-feedback-on-red-hat-documentation.adoc//g' modules.tmp
# Remove leveloffsets and empty square brackets.
sed -i 's/\[.*\]$//' modules.tmp
# Prepend module path
sed -i "s|^|$MODULE_PATH|g; s|\/\/|\/|g" modules.tmp

# Sort module names and remove blank lines.
sort modules.tmp | uniq | grep -v '^$' >&1

# Clean up temporary files.
rm *.tmp &>/dev/null
