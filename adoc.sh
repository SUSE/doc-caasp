#!/bin/sh
export FILE=$1 #xml/MAIN.caasp.xml
export NAME=`basename $FILE .xml`
echo "Converting $NAME"
rm -rf asciidoctor
docbookrx --strict xml/$NAME.xml
mkdir -p adoc
mv xml/*adoc adoc


(cd asciidoctor/html; ln -s ../../images/src/png images)
asciidoctor -b html -d book -D asciidoctor/html adoc/$NAME.adoc
exit 0


#asciidoctor -b docbook5 -d book -D asciidoctor/xml adoc/$NAME.adoc
# insert ENTITY
sed -i '2i <!DOCTYPE set [ <!ENTITY % entities SYSTEM "entity-decl.ent"> %entities; ]>' asciidoctor/$1
# replace {foo} (but not ${foo}) with &foo;
perl -p -i -e 's/([^\$])\{(\w+)\}/\1\&$2\;/g' asciidoctor/$1
# make .ent files available
cp xml/*ent asciidoctor/xml
daps -m asciidoctor/xml/$NAME.xml --verbosity=0 --styleroot /usr/share/xml/docbook/stylesheet/suse2013-ns html
rm -rf asciidoctor/build/$NAME/html/$NAME/images
ln -sf ../../../../../adoc/images asciidoctor/build/$NAME/html/$NAME
