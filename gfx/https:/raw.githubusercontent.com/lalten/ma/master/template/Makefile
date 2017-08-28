# define the name
TARGET =	main

# define the files your paper depends on, separated by white space:
TEXFILES =	$(TARGET).tex \
		$(wildcard *.tex)
# if you want to automatically include files in $(PICPATH) you could use
# SRCPICDIRS =	$(subst :, ,$(PICPATH))
SRCPICDIRS =	gfx
SRCPICFILES =	$(filter %.fig %.jpg %.eps %.gif,\
		$(notdir $(foreach dir,$(SRCPICDIRS),$(wildcard $(dir)/*.*))))

SPELLFILES =	$(TEXFILES)
DEPFILES =	$(DRAFTFINAL) \
		$(GENHELPER) \
		shorthands.tex \
		$(TARGET).ind
# must be also referenced in $(TARGET).tex: \bibliography{diss,...}
BIBFILES =	literatur.bib

# define the directory for files to include
INPUTS	= inputs
# define the directory for helper scripts
HELPERS	= helpers
# this is the directory for makefile fragments to include
GINCDIR = $(HELPERS)
# define the places (colon separated path) for your picture sources
# .../foo.{fig,gnuplot,ips} to be converted to ./foo.eps:
PICPATH = gfx:
# other files I depend on are in
TEXPATH = $(INPUTS)
BIBPATH = bib
# define the places for generated files
GENDIR	= .generated

default:	usage

# for more information please see ...
include		$(GINCDIR)/target-rules.mk
