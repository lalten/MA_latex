# $Id: texmf-rules.mk,v 1.7 1999/03/10 06:53:44 doenges Exp $
# $Source: /DIST/rtsg/cvs/rapid/etc/texmf-rules.mk,v $
# vim: ts=8 sw=8 tw=0 wm=0
#
# [GNU]make rules for latex and related files/programs, based on
# .../rapid/etc/rapid.rules,v 1.10 1996/08/13 11:32:08 fischer Exp
# initially by Herbert Thielen --- TNXE6!
# DISCLAIMER: 	This is provided by some RTSG members ``as is'',
#		please see the GPL for details.		;-)

# LATEX, ... setzen, wenn nötig
ifeq (,$(LATEX))
	LATEX = latex
endif
ifeq (,$(PDFLATEX))
	PDFLATEX = pdflatex
endif
ifeq (,$(DVIPS))
	DVIPS = dvips
endif
ifeq (,$(TMPDIR))
	TMPDIR = /var/tmp
endif

# Wenn DVIPSFLAGS nicht gesetzt ist, Option '-Z' benutzen,
# um die Größe der PostScript-Datei zu begrenzen.
ifeq (,$(DVIPSFLAGS))
	DVIPSFLAGS = -Z
endif

# Regel zum Erzeugen eines Postscript-Files
%.ps:	%.dvi
	$(DVIPS) $(DVIPSFLAGS) $< -o

%.2ps:	%.ps
	psnup -pa4 -2 $< > $@

# Regeln zum Erzeugen von EPS und PDF aus fig-files 
EPSPICFILES +=	$(SRCPICFILES:.fig=.eps)
PDFPICFILES +=	$(SRCPICFILES:.fig=.pdf)
%.eps:	%.fig $(GENHELPER)
	( cd $(<D) >/dev/null && fig2dev -L eps $(<F) ) >$(GENDIR)/$@
%.pdf:	%.fig $(GENHELPER)
	( cd $(<D) >/dev/null && fig2dev -L eps $(<F) | epstopdf --filter ) >$(GENDIR)/$@
# Regeln zum Erzeugen von EPS und PDF aus PNM
EPSPICFILES +=	$(SRCPICFILES:.pnm=.eps)
PDFPICFILES +=	$(SRCPICFILES:.pnm=.pdf)
%.eps: %.pnm $(GENHELPER)
	convert $< $(GENDIR)/$@
%.pdf: %.pnm $(GENHELPER)
	convert $< $(GENDIR)/$@
# Regeln zum Erzeugen von EPS und PDF aus GIF
EPSPICFILES +=	$(SRCPICFILES:.gif=.eps)
PDFPICFILES +=	$(SRCPICFILES:.gif=.pdf)
%.eps: %.gif $(GENHELPER)
	convert $< EPS2:$(GENDIR)/$@
#	giftopnm $< | pnm2eps --index --rle >$(GENDIR)/$@
%.pdf: %.gif $(GENHELPER)
	convert $< $(GENDIR)/$@
# convert jpg to eps, jpg is a native pdf format, no conversion needed
EPSPICFILES +=	$(SRCPICFILES:.jpg=.eps)
%.eps:  %.jpg $(GENHELPER)
	convert $< EPS2:$(GENDIR)/$@
#	convert $< EPS2:tmpgenerated.eps; convert2dvips <tmpgenerated.eps >$(GENDIR)/$@
#	jpg2eps $<  >$(GENDIR)/$@
# Regeln zum Erzeugen von PDF aus EPS
PDFPICFILES +=	$(SRCPICFILES:.eps=.pdf)
%.pdf:	%.eps $(GENHELPER)
	epstopdf --outfile="$(GENDIR)/$@" $<

# Regel zum Erzeugen von LATEX bzw. PSTEX+PSTEX_T aus fig-files 
%.latex: %.fig $(GENHELPER)
	fig2dev -L latex $< $(GENDIR)/$@

%.pstex: %.fig $(GENHELPER)
	fig2dev -L pstex $< $(GENDIR)/$@
	fig2dev -L pstex_t -p $(GENDIR)/$@ $< $(GENDIR)/$(@:=_t)

# Regel zum Erzeugen von EPS aus (entsprechenden) gnuplot-files 
%.eps:	%.gnuplot $(GENHELPER)
	gnuplot $< > $(GENDIR)/$@

# Regel zum Erzeugen von EPS aus PS 
%.eps:	%.ps $(GENHELPER)
	ps2epsi $< $(GENDIR)/$@
#	ps2epsi-2.6.1 $< $(GENDIR)/$@

# Regel zum Erzeugen von EPS aus Pseudo--(Interleaf) EPS (*.ips)
# bzw. aus Micro$oft--Postscript.
# nach ps2epsi:
# o Preview-Kommentare entfernen (unnötiger Platzverbrauch)
# o showpage in /eop entfernen (sonst Probleme bei psnup etc.)
%.eps:	%.ips $(GENHELPER)
	ps2epsi $< $(GENDIR)/$@
	sed -e "/^%%BeginPreview/,/^%%EndPreview/d" \
	    -e "/^\/eop/s/showpage //" < $(GENDIR)/$@ > $(TMPDIR)/rapid.$$$$;\
	mv $(TMPDIR)/rapid.$$$$ $(GENDIR)/$@

%.eps:	%.msps $(GENHELPER)
	gs -q -dBATCH -sPAPERSIZE=a4 -dNOPLATFONTS -sDEVICE=epswrite \
		-dNOPAUSE -dQUIET -dSAFER -sOutputFile=$(GENDIR)/$@ $<

# Regeln für BibTeX
# Achtung:
# Wenn das *.aux-File nicht existiert und nicht in einer Dependency
# erscheint, löscht gmake es (als ``temporäres File'') womöglich automatisch
# wieder!
%.bbl:	%.aux $(BIBDEP)
	@sleep 1	# Sichergehen, daß *.bbl neuer als *.aux ist
	-BIBINPUTS=$(BIBINPUTS) bibtex $*

%.aux:			# nur falls nicht existent
	@echo "$@ does not exist; ignore the following bibtex warnings!"
	touch $@

# Regeln für makeindex
# Achtung:
# Wenn das *.idx-File nicht existiert und nicht in einer Dependency
# erscheint, löscht gmake es (als ``temporäres File'') womöglich automatisch
# wieder!
%.ind:	%.idx
	@sleep 1	# Sichergehen, daß *.ind neuer als *.idx ist
	makeindex ${MAKEINDEXOPT} $*

%.idx:			# nur falls nicht existent
	touch $@

# Inhaltsverzeichnis, falls nicht existent
%.toc:
	touch $@

# Regel zum genügend häufigen Aufruf von LaTeX:
# o Changeflag-File löschen
# o LaTeX-Hilfsfiles sichern
# o LaTeX aufrufen
# o LaTeX-Hilfsfiles überprüfen:
#	Falls Änderung: touch Changeflag-File,
#			rekursiv make aufrufen;
#	falls keine Änderung: alten Files (Datum!) restaurieren;
# o falls Changeflag-File existiert:
#	In höherem Makelevel wurde kein latex mehr aufgerufen
#	(``nothing to be done for dvi''), da keine File-Abhängigkeiten
#	mehr vorhanden. Der höhere Makelevel wurde aber nur aufgerufen,
#	da $(TEXAUX) Änderungen meldete. Daher nochmals in einer Schleife
#	nur latex aufrufen, bis keine Änderungen mehr erfolgen.
#	Schlimmstenfalls könnte es eine Endlosschleife geben ...
CHANGEFLAG=$(GENDIR)/.change-flag
TEXAUX=$(HELPERS)/texaux
LOOPMESSAGE="Rerunning $(LATEX) at level $(MAKELEVEL) (aux change)"
%.dvi:	%.tex
	@echo
	@rm -f $(CHANGEFLAG)
	$(TEXAUX) -s; $(LATEX) $*
ifneq (-n,$(findstring -n,$(filter-out --%,$(MFLAGS))))
	@$(TEXAUX) -c || \
		{ \
			touch $(CHANGEFLAG) ; \
			echo ; \
			echo "Rerunning $(MAKE) $@ from level $(MAKELEVEL)"; \
			$(MAKE) --no-print-directory $@; \
		}
else
	$(TEXAUX) -c || gmake $@ # recursion avoided here for "make -n"
endif
	@if [ -f $(CHANGEFLAG) ] ; then		\
		rm $(CHANGEFLAG);		\
		echo $(LOOPMESSAGE);		\
		$(TEXAUX) -s; $(LATEX) $*;		\
		until $(TEXAUX) -c; do		\
			echo $(LOOPMESSAGE);	\
			$(TEXAUX) -s; $(LATEX) $*;	\
		done;				\
	fi
	@echo "Finished $(MAKE) $@ at level $(MAKELEVEL)."

%.pdf:	%.tex
	umask $(UMASK)
	@echo
	@rm -f $(CHANGEFLAG)
	$(TEXAUX) -s
	$(PDFLATEX) $*
	@echo "$(TEXAUX) -c"
ifneq (-n,$(findstring -n,$(filter-out --%,$(MFLAGS))))
	@$(TEXAUX) -c || \
		{ \
			touch $(CHANGEFLAG) ; \
			echo ; \
			echo "Rerunning $(MAKE) $@ from level $(MAKELEVEL)"; \
			$(MAKE) --no-print-directory $@; \
		}
else
	$(TEXAUX) -c || gmake $@	# recursion avoided here for ``make -n''
endif

	@if [ -f $(CHANGEFLAG) ] ; then \
	  rm $(CHANGEFLAG) ; \
	  echo "Rerunning $(PDFLATEX) at level $(MAKELEVEL) (aux change)" ; \
	  $(TEXAUX) -s; $(PDFLATEX) $*; \
	  until { $(TEXAUX) -c ; }; do\
	    echo "Rerunning $(PDFLATEX) at level $(MAKELEVEL) (aux change)" ; \
	    $(TEXAUX) -s ; $(PDFLATEX) $* ; \
	  done ;\
	fi
	@echo "Finished $(MAKE) $@ at level $(MAKELEVEL)."

# addition to clean
clean::
	rm -f $(CHANGEFLAG)

# debugging targets
.PHONY:	env
env:
	env
