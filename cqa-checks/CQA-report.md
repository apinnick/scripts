# Content Quality Assessment report

This report describes Content Quality Assessment issues found in Asciidoc assemblies and modules in a master.adoc file.

For details, see the [Modular documentation templates checklist](https://docs.google.com/document/d/13NAUVAby1y1qfT77QFIZrMBhi872e7IEvAC9MUpGXbQ/edit?tab=t.0).

Important: This report is generated by the [cqa-checks](https://github.com/apinnick/scripts/blob/main/cqa-checks/cqa-checks.sh) script. It is a work on progress. There might be errors. Please send feedback to [Avital Pinnick](mailto:apinnick@redhat.com).

## File checks

Content type attribute missing or invalid:

- ../../sandboxed-containers-documentation/modules/con_about-node-eligibility-checks.adoc
- ../../sandboxed-containers-documentation/modules/proc_ibm-creating-peerpod-vm-image-config-map.adoc
- _Done_

ID missing:

- ../../sandboxed-containers-documentation/modules/
- ../../sandboxed-containers-documentation/modules/ To do: Add an architecture section explaining peer pods and move permanent ID (peer-pods) from ref_common-terms.
- _Done_

Title longer than 10 words found:

- _Done_

'= ' header not followed by blank line:

- ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-aws.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-azure.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-bare-metal.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-gc.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-ibm.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_monitoring.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_troubleshooting.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_uninstalling.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_upgrading.adoc
- ../../sandboxed-containers-documentation/modules/con_about-node-eligibility-checks.adoc
- _Done_

Admonition with title found:

- _Done_

Image without description found:

- _Done_


## Assembly module checks

More than one '= ' header found:

- _Done_

'=== ' header found:

- ../../sandboxed-containers-documentation/assemblies/assembly_uninstalling.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
- _Done_

Block title ('.Text') found:

- ../../sandboxed-containers-documentation/assemblies/assembly_monitoring.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_uninstalling.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_upgrading.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
- ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
- _Done_

Nested assembly conditions


- Missing 'ifdef::context[:parent-context: {context}]':

  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - _Done_


- Missing 'ifdef::parent-context[:context: {parent-context}]':

  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - _Done_


- Missing 'ifndef::parent-context[:!context:]':

  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-web.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_about-osc.adoc
  - ../../sandboxed-containers-documentation/assemblies/assembly_deploying-osc-cli.adoc
  - _Done_

## Procedure module checks

'== ' header found:

- _Done_

Procedure longer than 10 steps found:

- ../../sandboxed-containers-documentation/modules/proc_creating-peer-pods-secret.adoc
- ../../sandboxed-containers-documentation/modules/proc_creating-ssh-key-secret.adoc
- ../../sandboxed-containers-documentation/modules/proc_selecting-a-custom-pod-vm-image.adoc
- _Done_

Block title other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, or Verification found:

- ../../sandboxed-containers-documentation/modules/proc_azure-configuring-the-default-worker-subnet-for-outbound-connections.adoc
- ../../sandboxed-containers-documentation/modules/proc_creating-kataconfig-cr-cli.adoc
- ../../sandboxed-containers-documentation/modules/proc_creating-nfd-cr.adoc
- ../../sandboxed-containers-documentation/modules/proc_deleting-cr-cli.adoc
- ../../sandboxed-containers-documentation/modules/proc_deleting-crd-cli.adoc
- ../../sandboxed-containers-documentation/modules/proc_enabling-debug-logs-crio.adoc
- ../../sandboxed-containers-documentation/modules/proc_gc-creating-podvm-image.adoc
- ../../sandboxed-containers-documentation/modules/proc_installing-operator-cli.adoc
- ../../sandboxed-containers-documentation/modules/proc_optional-enabling-nodes-block-device.adoc
- ../../sandboxed-containers-documentation/modules/proc_optional-provisioning-storage.adoc
- ../../sandboxed-containers-documentation/modules/proc_viewing-debug-logs-components.adoc
- _Done_

More than one procedure found:

- _Done_

Invalid 'Procedure' title found:
- _Done_

'Procedure' title not followed by list found:

- _Done_

## Concept and Reference module checks

Block title other than 'Next steps' or 'Additional resources' found:

- ../../sandboxed-containers-documentation/modules/con_block_volume_support.adoc
- ../../sandboxed-containers-documentation/modules/con_compatibility-with-osc.adoc
- ../../sandboxed-containers-documentation/modules/con_osc-resource-requirements.adoc
- ../../sandboxed-containers-documentation/modules/proc_viewing-metrics.adoc
- ../../sandboxed-containers-documentation/modules/ref_kataconfig-status-messages.adoc
- _Done_

'=== ' header found:

- _Done_

