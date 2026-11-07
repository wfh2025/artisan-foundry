PROJ_DIR 	:= $(CURDIR)
RM 			:= rm -f

XELATEX :=latexmk -r "$(PROJ_DIR)/latexmkrc" -xelatex

IGNORE = \
	*.aux \
	*/*.aux \
	*.bbl \
	*.bbl-SAVE-ERROR \
	*.fls \
	*.lol \
	*.listing \
	*.bcf \
	*.run.xml \
	indent.log

all: main.pdf

%.pdf: %.tex FORCE_MAKE
	$(XELATEX) -g -silent $<
view: main.tex
	$(XELATEX) -pv -silent -time $<
pvc: main.tex
	$(XELATEX) -pvc -silent $<
bug:
	grep -inr -C 5 'LaTeX Error' *.log
pretty:
	find "${PROJ_DIR}" -type f \( -name "*.tex" -o -name "*.sty" \) -exec tex-fmt --config="${PROJ_DIR}/tex-fmt.toml" {} \;
clean: 
	latexmk -r "$(PROJ_DIR)/latexmkrc" -C && $(RM) $(IGNORE)
print-%:
	@echo $* = $($*)
.PHONY: all install view clean bug pretty FORCE_MAKE
