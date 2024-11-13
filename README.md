# Scripts and useful commands

## Finding long procedures

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
