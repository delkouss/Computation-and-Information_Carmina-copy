# You want latexmk to *always* run, because make does not have all the info.
# # Also, include non-file targets in .PHONY so they are run regardless of any
# # file of the given name existing.
.PHONY: main.pdf all clean

#
# # The first rule in a Makefile is the one executed by default ("make"). It
# # should always be the "all" rule, so that "make" and "make all" are identical.
all: main.idx main.bcf main.ind main.bbl inconly.tex main.pdf 
#
# # CUSTOM BUILD RULES
#
# # In case you didn't know, '$@' is a variable holding the name of the target,
# # and '$<' is a variable holding the (first) dependency of a rule.
# # "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# # you might have.
#
# %.tex: %.raw
# ./raw2tex $< > $@

#                 # MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
#  # -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
#
#  # -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
#
main.bcf: main.tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex 
main.idx: main.tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex 
main.ind: main.idx
	makeindex main.idx -s StyleInd.ist 

main.bbl: main.bcf
	biber main.bcf

inconly.tex: 
	echo "\includeonly{chapters/Chapter7-measures_of_information,chapters/Chapter8-source_coding,chapters/Chapter9-channel-coding}" > inconly.tex
main.pdf: inconly.tex
	echo "\includeonly{chapters/Chapter7-measures_of_information,chapters/Chapter8-source_coding,chapters/Chapter9-channel-coding}" > inconly.tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex 

#
clean: 
	latexmk -CA

