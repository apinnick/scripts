# CQA modularization report
Created 2025-09-04

This report describes modularization issues found in 'assemblies.txt' and 'modules-list.txt'. For details, see the [Modular documentation templates checklist](https://docs.google.com/document/d/13NAUVAby1y1qfT77QFIZrMBhi872e7IEvAC9MUpGXbQ/edit?tab=t.0) and [CQA template](https://docs.google.com/spreadsheets/d/11LyS_q40rF0IQ0p-U-ZG1legKHB7dKbv8Kn279wqvpA/edit?usp=drive_link).

The [cqa-mod-checks script](https://github.com/apinnick/scripts/blob/main/cqa-mod-checks/cqa-mod-checks.sh) is a work on progress and might contain errors. Feedback: [Avital Pinnick](mailto:apinnick@redhat.com).

## File checks

Content type attribute missing or invalid:

- _Done_

ID missing:

- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-hyperv.adoc
- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-kubevirt.adoc
- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-kvm.adoc
- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-nutanix.adoc
- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-openstack.adoc
- ../../foreman-documentation/guides/common/assembly_configuring-virt-who-vmware.adoc
- ../../foreman-documentation/guides/common/assembly_overview-of-vm-subscriptions.adoc
- ../../foreman-documentation/guides/common/assembly_troubleshooting-virt-who.adoc
- _Done_

Title longer than 10 words found:

- _Done_

'= ' header not followed by blank line:

- _Done_

Admonition with title found:

- _Done_

Image without description found:

- _Done_

## Assembly checks:

More than one '= ' header found:

- _Done_

'=== ' header found:

- _Done_

Block title ('.Text') found:

- _Done_

'include::' directives on consecutive lines:

- _Done_

Nested assembly conditions:

- 'ifdef::context[:parent-context: {context}]' missing:

  - _Done_

- 'ifdef::parent-context[:context: {parent-context}]' missing:

  - _Done_

- 'ifndef::parent-context[:!context:]' missing:

  - _Done_

## Procedure module checks:

'== ' header found:

- _Done_

Procedure longer than 10 steps found:

- ../../foreman-documentation/guides/common/modules/proc_deploying-a-virt-who-configuration-on-target-server.adoc
- _Done_

Block title other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, or Verification found:

- ../../foreman-documentation/guides/common/modules/proc_checking-virt-who-status.adoc
- ../../foreman-documentation/guides/common/modules/proc_creating-a-virt-who-configuration.adoc
- ../../foreman-documentation/guides/common/modules/proc_editing-a-virt-who-configuration.adoc
- ../../foreman-documentation/guides/common/modules/proc_enabling-rhsm-debug-logging.adoc
- _Done_

More than one procedure found:

- _Done_

Invalid Procedure title found:

- _Done_

Procedure not followed by list found:

- _Done_

## Concept and reference module checks:

Block title other than 'Next steps' or 'Additional resources' found:

- ../../foreman-documentation/guides/common/modules/ref_troubleshooting-virt-who.adoc
- ../../foreman-documentation/guides/common/modules/ref_virt-who-configuration-overview.adoc
- _Done_

'=== ' header found:

- _Done_

