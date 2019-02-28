#!/bin/bash

asciidoctor-pdf \
-a toc-title=Contents \
-a chapter-label= \
-a pdf-style=$2 \
-a pdf-stylesdir=$SUSEDOC/pdf_template \
-a icons=font \
-a pdf-fontsdir=$SUSEDOC/pdf_template/fonts \
-a source-highlighter=rb-pygments \
$1
