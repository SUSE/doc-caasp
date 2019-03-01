#!/bin/bash

## Administration
files="admin_administration.adoc admin_integration_ses.adoc admin_intro.adoc admin_logging.adoc admin_misc.adoc admin_monitoring.adoc admin_security.adoc admin_software.adoc admin_troubleshooting.adoc autoyast_example_adminnode.adoc book_admin.adoc"
outpath=modules/administration/pages/
echo "Moving administrator guide files"
for i in $files; do mv -f adoc/$i $outpath$i; done

## Deployment

files="deployment_about.adoc deployment_additional.adoc deployment_appendix.adoc deployment_authors.adoc deployment_cluster_administration.adoc deployment_cluster_deployment.adoc deployment_configuration.adoc deployment_installation.adoc deployment_installing_nodes.adoc deployment_integration.adoc deployment_intro.adoc deployment_preparation.adoc deployment_scenarios.adoc deployment_sysreqs.adoc deployment_upgrade.adoc book_deployment.adoc"
outpath=modules/deployment/pages/
echo "Moving deployment guide files"
for i in $files; do mv -f adoc/$i $outpath$i; done

## Quickstart

files="quick_configuration.adoc quick_install.adoc quick_intro.adoc quick_system_requirements.adoc QS_configuration.adoc QS_intro.adoc QS_system_requirements.adoc book_quick.adoc"
outpath=modules/quickstart/pages/
echo "Moving quickstart guide files"
for i in $files; do mv -f adoc/$i $outpath$i; done

## User Guide

files="user_access.adoc user_cronjob.adoc user_daemonset.adoc user_deploy_app.adoc user_deployments.adoc user_labels.adoc user_pods.adoc user_replicaset.adoc user_services.adoc book_user.adoc"
outpath=modules/user/pages/
echo "Moving user guide files"
for i in $files; do mv -f adoc/$i $outpath$i; done

## Common Files

files="common_authors.adoc common_changelog.adoc common_copyright_gfdl.adoc common_copyright_quick.adoc common_gfdl1.2_i.adoc common_intro_available_doc_i.adoc common_intro_feedback_i.adoc common_intro_making_i.adoc common_intro_target_audience_i.adoc common_intro_typografie_i.adoc common_legal.adoc entitest.adoc entities.adoc network-decl.adoc"
outpath=modules/ROOT/pages/_partials/
echo "Moving common files"
for i in $files; do mv -f adoc/$i $outpath$i; done
