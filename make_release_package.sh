#!/bin/bash
#Fail script on error
set -e

#Get version number from attributes file
MAJOR=$(cat adoc/attributes.adoc| grep :productmajor:|awk '{ print $2}')
MINOR=$(cat adoc/attributes.adoc| grep :productminor:|awk '{ print $2}')
PATCH=$(cat adoc/attributes.adoc| grep :productpatch:|awk '{ print $2}')

#Remove outdated package artifacts if present
rm -rf $PWD/build/pack/

#Generate output
daps -d DC-caasp-admin html --single
daps -d DC-caasp-admin pdf
daps -d DC-caasp-deployment html --single
daps -d DC-caasp-deployment pdf
daps -d DC-caasp-quickstart html --single
daps -d DC-caasp-quickstart pdf

#Create package directory
mkdir $PWD/build/pack/

#Move HTML content to package dir
mv $PWD/build/caasp-admin/single-html/caasp-admin $PWD/build/pack/
mv $PWD/build/caasp-deployment/single-html/caasp-deployment $PWD/build/pack/
mv $PWD/build/caasp-quickstart/single-html/caasp-quickstart $PWD/build/pack/

#Move and rename PDFs to package dir
mv $PWD/build/caasp-admin/caasp-admin_color_en.pdf $PWD/build/pack/SUSE-CaaSP-$MAJOR.$MINOR.$PATCH-Admin-Guide.pdf
mv $PWD/build/caasp-deployment/caasp-deployment_color_en.pdf $PWD/build/pack/SUSE-CaaSP-$MAJOR.$MINOR.$PATCH-Deployment-Guide.pdf
mv $PWD/build/caasp-quickstart/caasp-quickstart_color_en.pdf $PWD/build/pack/SUSE-CaaSP-$MAJOR.$MINOR.$PATCH-Quickstart-Guide.pdf

#Compress contents of package dir
cd build/pack/
tar czvf SUSE-CaaSP-$MAJOR.$MINOR.$PATCH-Docs.tar.gz *
