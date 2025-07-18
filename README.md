# Scripts and useful commands

## New: Extract modules for a single guide

This [script](extract-doc-modules.sh) extracts modules from assemblies in a master.adoc file and outputs them as a text file. It can be used on an OpenShift docs assembly but I have not tested this thoroughly. It is designed to work with modules that use prefixes, such as 'proc_', but you can tweak it to search for "include::" lines if your modules do not follow this naming convention.

### Running a Vale check on the module list

You can run an [asciidoctor-dita-vale](https://github.com/jhradilek/asciidoctor-dita-vale) Vale check on the modules list.

1. Run the [extract-doc-modules](extract-doc-modules.sh) script to generate a module list for the _Configuring virt-who for virtual machine subscriptions_ guide:

      ````
      $ sh extract-doc-modules.sh guides/doc-Configuring_virt_who_VM_Subscriptions/master.adoc
      ````

      module-list.txt:

      ````
      con_configuring-virt-who-for-provider.adoc
      con_troubleshooting-virt-who.adoc
      con_virtual-machine-subscriptions-overview.adoc
      proc_checking-for-subscriptions-that-require-virt-who.adoc
      proc_checking-virt-who-status.adoc
      ````

2. Run the Vale check on the files listed in `module-list.txt`:

      ````
      $ while IFS= read -r filepath; do vale "$filepath"; done < module-list.txt
      ````

      Output:
      ````
      ✔ 0 errors, 0 warnings and 0 suggestions in 1 file.
      ✔ 0 errors, 0 warnings and 0 suggestions in 1 file.
      ✔ 0 errors, 0 warnings and 0 suggestions in 1 file.
      ✔ 0 errors, 0 warnings and 0 suggestions in 1 file.

      proc_checking-virt-who-status.adoc
      14:1  warning  Unsupported titles cannot be    AsciiDocDITA.TaskTitle
                      mapped to DITA tasks.
      14:1  warning  Block titles can only be        AsciiDocDITA.BlockTitle
                      assigned to examples, figures,
                      and tables in DITA.
      ````

## Find level 2+ headers

This [script](find-subheadings.sh) checks .adoc files in a specific directory for level 2 or higher headers. If files are found, the script creates an "Output.txt" file with a list. If no files are found, it displays a message.

## Find long procedures

- The [find-long-procedures script](find-long-procedures.sh) checks files in a specific directory for procedures that contain more than 10 steps (`10` is the default; you can change this value). The script outputs the directory name, file name, number of steps, and number of substeps to a CSV file.

## Title case conversion script

- The [title case conversion script](title-case-script/README.md) changes title case headers and captions to sentence case. Update: You can create an exception list.

## Git last commit

Identifies modules that have not been touched for a long time. Useful for doc audits.

- [file-last-commit.sh](file-last-commit.sh) and [csv-last-commit.sh](csv-last-commit.sh) run a git log command on a set of files and output the results as a text file or CSV file, respectively. You can use these scripts to identify old files in a Git repo. See my [blog post](https://source.redhat.com/groups/public/ccs/ccs_blog/script_to_identify_old_content_in_git_repositories) for details.

- [git-exclude-log.sh](git-exclude-log.sh) checks files in a specific directory for commits made by people who are not part of a specific group, for example, technical writers. You can use this script to check for changes made by people outside the group.

## Preview builds

- [asciidoc-build-upload-open.sh](asciidoc-build-upload-open.sh): Builds Asciidoc preview for RHV docs, uploads to remote drive, opens preview in browser. You can adapt this script for other projects by tweaking the paths for folders in your project (images, common).

- [ocp-preview-upload-open.txt](ocp-preview-upload-open.txt): One-line command that builds OpenShift preview, uploads to remote drive, and opens the preview in a browser. Copy/paste to command line, substituting your Kerberos ID and geo. You do not have to create a directory in the remote drive first. Works for updating existing preview as well as for first upload.

- [ocp-preview-update.txt](ocp-preview-update.txt): One-line command that builds OpenShift preview and upload to remote drive, but does not open the preview in a browser. Useful for updating a preview build.

## Generating files

- [CCS onboarding checklists](https://github.com/apinnick/scripts/tree/main/CCS%20onboarding%20checklists): Build HTML files, build ODT files (for Google doc), generate index.html file.

- Update: I finally got around to automating the generation of ODT files with [GitLab CI](CCS%20onboarding%20checklists/.gitlab-ci.yml). I created three jobs:
  - build_a: Builds the HTML files with Asciidoctor.
  - build_b: Converts the HTML files into ODT files with Pandoc.
  - pages: Generates the Jekyll site and the landing page of the site.

## Converting files

- [runbook-conversion.sh](runbook-conversion.sh): Converts Markdown files to Asciidoc with Kramdoc and updates the files with comments and formatting for OpenShift modules. Also generates a list of "include" files to copy/paste to assembly.

- [convert-html-to-nice-format-google-doc](convert-html-to-nice-format-google-doc): Converts HTML preview build to nicely formatted text doc, which you can copy to a Google doc. Doesn't mangle header levels, tables, or bullet lists. Prerequisite: "Links" web browser installed.

## Miscellaneous

- [sed-anchor-ids](sed-anchor-ids): Couple sed commands to add anchor IDs to an Asciidoc file.

- [openshift-sync.sh](openshift-sync-tweaks.sh): Adds Customer Portal-specific content (inclusive language module, DDF) to downstream master.adoc files during sync process and performs other cleanup tasks. My changes start at [line 75](https://github.com/apinnick/scripts/blob/2790321dfb1c556f147f387c6e6b844819d803ce/openshift-sync-tweaks.sh#L75).
