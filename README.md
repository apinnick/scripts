# Scripts and useful commands

## Preview builds
- [asciidoc-build-upload-open.sh](https://github.com/apinnick/scripts/blob/main/asciidoc-build-upload-open.sh): Builds Asciidoc preview for RHV docs, uploads to remote drive, opens preview in browser. You can adapt this script for other projects by tweaking the paths for folders in your project (images, common).

- [ocp-preview-upload-open.txt](https://github.com/apinnick/scripts/blob/main/ocp-preview-upload-open.txt): One-line command that builds OpenShift preview, uploads to remote drive, and opens the preview in a browser. Copy/paste to command line, substituting your Kerberos ID and geo. You do not have to create a directory in the remote drive first. Works for updating existing preview as well as for first upload.
- [ocp-preview-update.txt](https://github.com/apinnick/scripts/blob/main/ocp-preview-update.txt): One-line command that builds OpenShift preview and upload to remote drive, but does not open the preview in a browser. Useful for updating a preview build.

## Generating files
- [CCS onboarding checklists](https://github.com/apinnick/scripts/tree/main/CCS%20onboarding%20checklists): Build HTML files, build DOCX files (for Google doc), generate index.html file. There is also a script for automating the DOCX build as a cron job because I have not yet created a GitLab CI/CD job for this.

## Converting files
- [runbook-conversion.sh](https://github.com/apinnick/scripts/blob/main/runbook-conversion.sh): Converts Markdown files to Asciidoc with Kramdoc and updates the files with comments and formatting for OpenShift modules. Also generates a list of "include" files to copy/paste to assembly.
- [convert-html-to-nice-format-google-doc](https://github.com/apinnick/scripts/blob/main/convert-html-to-nice-format-google-doc): Converts HTML preview build to nicely formatted text doc, which you can copy to a Google doc. Doesn't mangle header levels, tables, or bullet lists. Prerequisite: "Links" web browser installed.

## Miscellaneous
- [sed-anchor-ids](https://github.com/apinnick/scripts/blob/main/sed-anchor-ids): Couple sed commands to add anchor IDs to an Asciidoc file.
