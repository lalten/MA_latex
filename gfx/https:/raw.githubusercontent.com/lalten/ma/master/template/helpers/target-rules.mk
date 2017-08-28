# $Id: target-rules.mk,v 1.9 1999/03/09 18:08:12 hopfner Exp $
# vim: ts=8 sw=8 tw=0 wm=0
#
# [GNU]make rules and targets for papers
# based on rapid/*/Makefiles and rapid/etc/rapid.rules
# by Herbert Thielen --- TNXE6!
# DISCLAIMER: 	This is provided by some RTSG members ``as is'',
#		please see the GPL for details.		;-)
ifeq	(,$(BIBPATH))
	BIBPATH =	../bib
endif
ifeq	(,$(TEXPATH))
	TEXPATH =	../inputs:
endif
ifeq	(,$(MAKEINDEXOPT))
	# MAKEINDEXOPT =	-c
	MAKEINDEXOPT =	-c -g -s inputs/german.ist
endif
# define some other needed variables
GENHELPER=$(GENDIR)/._helper_

# include general rules
include		$(GINCDIR)/texmf-rules.mk

# search path for bibliography files
vpath %.bib	$(BIBPATH)
BIBINPUTS :=	$(BIBINPUTS):$(BIBPATH)
export	BIBINPUTS

# search path for tex includes
vpath %.tex	$(TEXPATH)
TEXINPUTS :=	$(TEXINPUTS):$(TEXPATH)
export	TEXINPUTS

PICFILES =	$(EPSPICFILES) $(PDFPICFILES)
# search path for fig, eps, ... files
vpath %.fig	$(PICPATH)
vpath %.ips	$(PICPATH)
vpath %.msps	$(PICPATH)
vpath %.ps	$(PICPATH)
vpath %.gnuplot	$(PICPATH)
# these might be generated, too
vpath %.eps	$(PICPATH) $(GENDIR)
vpath %.gif	$(PICPATH) $(GENDIR)
vpath %.jpg	$(PICPATH) $(GENDIR)
vpath %.pdf	$(PICPATH) $(GENDIR)
vpath %.pnm	$(PICPATH) $(GENDIR)


# bibliographies to create (none, if BIBFILES is empty; for papers
# usually only one) and dependencies for texmf-rules.mk
ifneq	(,$(BIBFILES))
ifeq	(,$(BBLFILES))
	BBLFILES =	$(TARGET).bbl
endif
endif
BIBDEP =	$(BIBFILES)

# phony (non-file) targets:
.PHONY:	usage all bibtex 

# targets
usage:
	@echo "You may use the following targets:"
	@echo "	make pdf	make ${TARGET}.pdf"
	@echo "	make clean	remove temporary files"
	@echo "	make veryclean	clean & remove dvi/ps/pdf files"

pdf:	$(TARGET).pdf
	$(RM) $(TARGET).pdf
	$(MAKE) $(MAKEARGS) $^
bibtex:	$(BBLFILES)

clean::
	$(RM) .\#* *.tmp *.aux *.log *.toc *.lof *.lot *.brf
	$(RM) *.blg *.bbl *.cb *.cb2 *.idx *.ind *.ilg $(TARGET).out
	$(RM) *.bak *.org *~ *.tpt
#	$(RM) thumb[0-9][0-9][0-9].png thumbpdf.pdf thumbpdf.log thumbdta.tex
	$(RM) $(DRAFTFINAL)

veryclean distclean clobber:	clean
	$(RM) *.dvi *.ps *.2ps
	$(RM) *.eps *.pdf *.latex *.pstex *.pstex_t
	$(RM) -rf $(GENDIR)

CLEAN:	veryclean

$(GENHELPER):
	@test -d $(@D) || mkdir $(GENDIR)
	@touch $@

# Dependencies
DVIDEP =	$(TEXFILES) $(DEPFILES) $(EPSPICFILES)
$(TARGET).dvi:	$(DVIDEP) $(BBLFILES)
PDFDEP =	$(TEXFILES) $(DEPFILES) $(PDFPICFILES)
$(TARGET).pdf:	$(PDFDEP) $(BBLFILES)

# BibTeX and Makeindex dependencies:
# TODO: fixme for multiple bibliographies!!!
.PRECIOUS:		$(BBLFILES:.bbl=.aux)
$(TARGET).bbl:	$(TARGET).aux $(BIBFILES) $(wildcard *.aux)
$(TARGET).ind:	$(TARGET).idx
