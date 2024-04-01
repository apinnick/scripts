# Title case header conversion script

This script changes "title case" headers and captions (aka "dot headers") to "sentence case".

## How to use this script

1. Save the `title-case.sh` and `exclude.txt` files in a local directory.
1. Make the script executable: `$ chmod +x title-case.sh`.
1. Run the script: `$ ./title-case.sh <dir> opt:<files>`.

   ~~~~
   I recommend running the script on a small number of files so that you can see which terms must be excluded.
   ~~~~

## Usage examples

`$ ./title-case.sh ../foreman-documentation/guides/common`

Processes files in the `/common` directory.
Note that the script is not recursive and does not check subdirectories.

`$ ./title-case.sh ../foreman-documentation/guides/common/modules proc_a*`

Processes files beginning with `proc_a` in the `/modules` directory.
You must leave a space between the `directory` and `files` parameters.

## Exclusion lists

Add single words that you do not want to convert to lower case to the `exclusion.txt` file.

Add compound terms to the `complex_lc` and `complex_uc` arrays in the `title-case.sh` file.

This is not very pretty. I could not find a better way to exclude strings that contain spaces. If you think of something, please let me know.

If you want to exclude a compound term like "Red Hat Insights" and are fairly certain that adding "Insights" to `exclusion.txt` will not have undesirable results, feel free to add it.
