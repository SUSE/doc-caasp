# Makefile for SUSE CaaS Platform Documentation
# Author: Joseph Cayouette and Markus Napp
# Inspired/modified from Owncloud's documentation Makefile written by Matthew Setter

SHELL = bash
FONTS_DIR ?= pdf-constructor/fonts
STYLES_DIR ?= pdf-constructor/resources/themes

#TODO allow setting the style, productname, and output filename prefix from the CLI
#STYLE ?= draft
STYLE ?= suse
PRODUCTNAME ?= SUSE CaaS Platform
FILENAME ?= suse_caasp

REVDATE ?= "$(shell date +'%Y-%m-%d')"
CURDIR ?= .
VERSION ?= beta1
OUTPUT_ADMIN ?= build/$(VERSION)/administration_guide
OUTPUT_DEPLOY ?= build/$(VERSION)/deployment_guide
OUTPUT_QUICK ?= build/$(VERSION)/quickstart_guide
OUTPUT_USER ?= build/$(VERSION)/user_guide

PHONY: help
help: ## Prints a basic help menu about available targets
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "target" "help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-30s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
	done

.PHONY: clean
clean: ## Remove build artifacts from output dir
	-rm -rf build/

.PHONY: pdf-all
pdf-all: pdf-admin pdf-deployment pdf-quickstart pdf-user ## Generate PDF versions of all books

.PHONY: pdf-admin
pdf-admin: ## Generate PDF version of the Administration Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(STYLES_DIR)/ \
		-a pdf-style=$(STYLE) \
		-a pdf-fontsdir=$(FONTS_DIR) \
		-a examplesdir=modules/administration/examples \
		-a imagesdir=modules/administration/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(OUTPUT_ADMIN)/$(FILENAME)_administration_guide.pdf \
		modules/administration/nav-administration-guide.adoc

.PHONY: pdf-deployment
pdf-deployment: ## Generate PDF version of the Administration Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(STYLES_DIR)/ \
		-a pdf-style=$(STYLE) \
		-a pdf-fontsdir=$(FONTS_DIR) \
		-a examplesdir=modules/deployment/examples \
		-a imagesdir=modules/deployment/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(OUTPUT_DEPLOY)/$(FILENAME)_deployment_guide.pdf \
		modules/deployment/nav-deployment-guide.adoc

.PHONY: pdf-quickstart
pdf-quickstart: ## Generate PDF version of the Administration Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(STYLES_DIR)/ \
		-a pdf-style=$(STYLE) \
		-a pdf-fontsdir=$(FONTS_DIR) \
		-a examplesdir=modules/quickstart/examples \
		-a imagesdir=modules/quickstart/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(OUTPUT_QUICK)/$(FILENAME)_quickstart.pdf \
		modules/quickstart/nav-quickstart-guide.adoc

.PHONY: pdf-user
pdf-user: ## Generate PDF version of the Administration Guide
	asciidoctor-pdf \
		-a pdf-stylesdir=$(STYLES_DIR)/ \
		-a pdf-style=$(STYLE) \
		-a pdf-fontsdir=$(FONTS_DIR) \
		-a examplesdir=modules/user/examples \
		-a imagesdir=modules/user/assets/images \
		-a revdate=$(REVDATE) \
		--base-dir . \
		--out-file $(OUTPUT_USER)/$(FILENAME)_user_guide.pdf \
		modules/user/nav-user-guide.adoc
