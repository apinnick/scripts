# CQA report

This report describes Content Quality Assessment issues found in Asciidoc assemblies and modules in SOURCE_FILE (TBD).

## File checks

**Content type attribute missing**


_Done_

**ID missing**

- ../foreman-documentation/guides/common/assembly_administer-settings-information.adoc
- ../foreman-documentation/guides/common/assembly_backing-up-server-and-proxy.adoc
- ../foreman-documentation/guides/common/assembly_configuring-email-notifications.adoc
- ../foreman-documentation/guides/common/assembly_limiting-host-resources.adoc
- ../foreman-documentation/guides/common/assembly_logging-and-reporting-problems.adoc
- ../foreman-documentation/guides/common/assembly_maintaining-server.adoc
- ../foreman-documentation/guides/common/assembly_managing-locations.adoc
- ../foreman-documentation/guides/common/assembly_managing-organizations.adoc
- ../foreman-documentation/guides/common/assembly_managing-project-with-ansible-collection.adoc
- ../foreman-documentation/guides/common/assembly_managing-users-and-roles.adoc
- ../foreman-documentation/guides/common/assembly_migrating-from-internal-databases-to-external-databases.adoc
- ../foreman-documentation/guides/common/assembly_monitoring-resources.adoc
- ../foreman-documentation/guides/common/assembly_preparing-for-disaster-recovery-and-recovering-from-data-loss.adoc
- ../foreman-documentation/guides/common/assembly_renaming-server-or-smart-proxy.adoc
- ../foreman-documentation/guides/common/assembly_renewing-certificates.adoc
- ../foreman-documentation/guides/common/assembly_restoring-server-or-smart-proxy-from-a-backup.adoc
- ../foreman-documentation/guides/common/assembly_searching-and-bookmarking.adoc
- ../foreman-documentation/guides/common/assembly_synchronizing-template-repositories.adoc
- ../foreman-documentation/guides/common/assembly_usage-metrics-collection-in-project.adoc
- ../foreman-documentation/guides/common/assembly_using-foreman-webhooks.adoc

_Done_

**Header > 10 words found**

- ../foreman-documentation/guides/common/modules/ref_example-of-a-weekly-full-backup-followed-by-daily-incremental-backups.adoc
- ../foreman-documentation/guides/common/modules/ref_managing-packages-on-the-base-operating-system.adoc

_Done_

**'= ' header not followed by blank line**

- ../foreman-documentation/guides/common/modules/con_creating-and-managing-user-groups.adoc

_Done_

**Admonition with title found**


_Done_

**Image without description found**


_Done_


## Assembly module checks

**More than one '= ' header found**


_Done_

**'=== ' header found**


_Done_

**Block title found**

_Done_

## Procedure module checks

**'== ' header found**
- ../foreman-documentation/guides/common/modules/proc_cloning-satellite-server.adoc
- ../foreman-documentation/guides/common/modules/proc_increasing-the-logging-levels-to-help-with-debugging.adoc

_Done_

**Procedure > 10 steps found**
- ../foreman-documentation/guides/common/modules/proc_cloning-satellite-server.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-an-organization.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-shellhook-to-print-arguments.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-webhook.adoc
- ../foreman-documentation/guides/common/modules/proc_increasing-the-logging-levels-to-help-with-debugging.adoc
- ../foreman-documentation/guides/common/modules/proc_installing-postgresql.adoc

_Done_

**Impermissible block title found**

Block titles other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, Verification

- ../foreman-documentation/guides/common/modules/con_backing-up-server-and-proxy.adoc
- ../foreman-documentation/guides/common/modules/con_postgresql-as-an-external-database-considerations.adoc
- ../foreman-documentation/guides/common/modules/proc_adding-permissions-to-a-role.adoc
- ../foreman-documentation/guides/common/modules/proc_assigning-resource-quotas-to-a-user.adoc
- ../foreman-documentation/guides/common/modules/proc_assigning-resource-quotas-to-a-user-group.adoc
- ../foreman-documentation/guides/common/modules/proc_assigning-roles-to-a-user.adoc
- ../foreman-documentation/guides/common/modules/proc_browsing-repository-content-using-an-organization-debug-certificate.adoc
- ../foreman-documentation/guides/common/modules/proc_cloning-satellite-server.adoc
- ../foreman-documentation/guides/common/modules/proc_configuring-rss-notifications.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-granular-permission-filter.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-location.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-an-organization.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-an-organization-debug-certificate.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-playbook-with-modules-from-project-ansible-collection.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-resource-quota.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-role.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-user.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-user-group.adoc
- ../foreman-documentation/guides/common/modules/proc_creating-a-webhook-template.adoc
- ../foreman-documentation/guides/common/modules/proc_deleting-a-location.adoc
- ../foreman-documentation/guides/common/modules/proc_deleting-an-organization.adoc
- ../foreman-documentation/guides/common/modules/proc_deleting-a-resource-quota.adoc
- ../foreman-documentation/guides/common/modules/proc_editing-a-resource-quota.adoc
- ../foreman-documentation/guides/common/modules/proc_estimating-the-size-of-a-backup.adoc
- ../foreman-documentation/guides/common/modules/proc_exporting-templates.adoc
- ../foreman-documentation/guides/common/modules/proc_importing-templates.adoc
- ../foreman-documentation/guides/common/modules/proc_managing-ssh-keys-for-a-user.adoc
- ../foreman-documentation/guides/common/modules/proc_managing-tasks.adoc
- ../foreman-documentation/guides/common/modules/proc_passing-arguments-to-shellhook-script-using-curl.adoc
- ../foreman-documentation/guides/common/modules/proc_passing-arguments-to-shellhook-script-using-webhooks.adoc
- ../foreman-documentation/guides/common/modules/proc_performing-a-full-backup.adoc
- ../foreman-documentation/guides/common/modules/proc_performing-an-online-backup.adoc
- ../foreman-documentation/guides/common/modules/proc_reclaiming-space-from-on-demand-repositories.adoc
- ../foreman-documentation/guides/common/modules/proc_retrieving-status-of-services.adoc
- ../foreman-documentation/guides/common/modules/proc_reviewing-usage-metrics-collected-from-your-project.adoc
- ../foreman-documentation/guides/common/modules/proc_setting-the-location-context.adoc
- ../foreman-documentation/guides/common/modules/proc_using-the-project-content-dashboard.adoc
- ../foreman-documentation/guides/common/modules/proc_viewing-resource-quotas.adoc
- ../foreman-documentation/guides/common/modules/ref_example-playbooks-based-on-modules-from-project-ansible-collection.adoc
- ../foreman-documentation/guides/common/modules/ref_managing-packages-on-the-base-operating-system.adoc
- ../foreman-documentation/guides/common/modules/ref_query-operators.adoc
- ../foreman-documentation/guides/common/modules/ref_supported-operators-for-granular-search.adoc

_Done_

**More than one procedure found**
- ../foreman-documentation/guides/common/modules/proc_configuring-logging-type-and-layout.adoc

_Done_

**Incorrect 'Procedure' title found**

Example: Procedure for upgrading

- ../foreman-documentation/guides/common/modules/proc_configuring-logging-type-and-layout.adoc

_Done_

