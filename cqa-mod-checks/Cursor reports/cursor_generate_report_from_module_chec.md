# Generate report from module checks
_Exported on 9/3/2025 at 14:34:57 GMT+3 from Cursor (1.2.4)_

---

**User**

Check the files on modules-list.txt using the criteria in cqa-mod-checks.sh and generate a report showing only issues

---

**Cursor**

I'll check the files listed in `modules-list.txt` using the criteria from `cqa-mod-checks.sh` and generate a report showing only issues. Let me first examine the checking script to understand the criteria.

I'll implement the CQA checks from the script and run them against the files in `modules-list.txt`. Let me start with the file checks:

Now let me implement the various checks from the CQA script. I'll check each category and only report files with issues:

Now let me implement the more complex checks including the blank line check and admonition checks:

Now let me implement the procedure-specific checks:

Now let me add the concept and reference module checks:

Now let me view the generated report to show you the issues found:

I've successfully completed the CQA modularization checks on all 50 files in your `modules-list.txt` and generated a comprehensive issues report. Here's what I found:

## Summary of Issues

**Total files with issues: 21 out of 50 files checked**

### File Checks (General Issues)
- **Content type attribute missing**: 2 files
  - `con_about-node-eligibility-checks.adoc`
  - `proc_ibm-creating-peerpod-vm-image-config-map.adoc`

### Procedure Module Issues
- **Procedures longer than 10 steps**: 3 files
  - `proc_creating-peer-pods-secret.adoc`
  - `proc_creating-ssh-key-secret.adoc`
  - `proc_selecting-a-custom-pod-vm-image.adoc`

- **Invalid block titles in procedures**: 11 files (using titles other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, or Verification)

### Concept and Reference Module Issues
- **Invalid block titles in concept/reference modules**: 5 files (using titles other than "Next steps" or "Additional resources")

## Good News
The majority of files (29 out of 50) passed all checks! No files had issues with:
- Missing IDs
- Titles longer than 10 words
- Header formatting problems
- Admonition title issues
- Images without descriptions

The full detailed report has been saved to `/home/avitalpinnick/scripts/cqa-mod-checks/issues_report.md` and shows exactly which files need attention for each issue type. This gives you a clear action plan for improving the modularization compliance of your documentation.

