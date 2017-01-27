NAME     = micro-synthetic

OCAMLC   = ocamlfind ocamlc
OCAMLL   = $(OCAMLC) -custom -package "$(REQUIRES)" -linkpkg nums.cma -cclib -lstdc++
OCAMLOPT = ocamlfind ocamlopt -package "$(REQUIRES)" -linkpkg nums.cmx
OCAMLDEP = ocamldep

EXECS = micro-synthetic test test-paq8f

OBJECTS  = 
XOBJECTS = 
ARCHIVE  = $(NAME).cma
XARCHIVE = $(NAME).cmxa

REQUIRES = unix str getopt bigarray gz mathlib
PREDICATES =

.PHONY: all pkg optpkg

all: $(EXECS)

#microSynthetic: microsynthetic.cmo

micro-synthetic: swig.cmo paq7asm.o  paq8f.o paq8f_wrap.o paq8f.cmo \
	bitv.cmo util.cmo data.cmo microSynthetic.cmo micro-synthetic.cmo 
	$(OCAMLL) $^ -o $@

test: swig.cmo paq7asm.o  paq8f.o paq8f_wrap.o paq8f.cmo \
	bitv.cmo util.cmo microSynthetic.cmo test.cmo
	$(OCAMLL) $^ -o $@

#test-paq8f: swig.cmo paq7asm.o paq8f.o paq8f_wrap.o paq8f.cmo test-paq8f.cmo
test-paq8f: swig.cmo paq7asm.o  paq8f.o paq8f_wrap.o paq8f.cmo test-paq8f.cmo
	#	$(OCAMLL) $^ -o $@
	ocamlc -custom $^ -o $@ -cclib -lstdc++

#swig: paq8f.i
#	swig -ocaml paq8f.i
#	swig -ocaml -co swig.mli ; swig -ocaml -co swig.ml
#	ocamlc -c swig.mli ; ocamlc -c swig.ml
#	ocamlc -c paq8f_wrap.c

swig.mli swig.ml:
	swig -ocaml -co swig.mli ; swig -ocaml -co swig.ml

swig.cmi swig.cmo: swig.mli swig.ml
	ocamlc -c swig.mli ; ocamlc -c swig.ml

paq8f.mli paq8f.ml: swig.cmo
	swig -ocaml paq8f.i

paq8f_wrap.o:
	ocamlc -c  paq8f_wrap.c

paq7asm.o:  paq7asm.asm
	nasm -f elf paq7asm.asm

paq8f.o: paq8f.cpp 
	g++ -g -c -o paq8f.o paq8f.cpp -DUNIX -O2 -Os -s -march=pentiumpro -fomit-frame-pointer
#	g++ -o paq8f paq8f.cpp -DUNIX -O2 -Os -s -march=pentiumpro -fomit-frame-pointer -o paq8f paq7asm.o


test-paq8f-cpp: paq7asm.o paq8f.o test-paq8f.cpp
	g++ -g paq7asm.o paq8f.o test-paq8f.cpp -o test-paq8f-cpp

paq8f-cli:  paq7asm.o paq8f.o paq8f-cli.cpp
	g++ -g paq7asm.o paq8f.o paq8f-cli.cpp -o paq8f-cli

pkg: $(ARCHIVE)
optpkg: $(XARCHIVE)

$(ARCHIVE): $(OBJECTS)
	$(OCAMLC) -a -o $(ARCHIVE) -package "$(REQUIRES)" -linkpkg \
	-predicates "$(PREDICATES)" $(OBJECTS)
$(XARCHIVE): $(XOBJECTS)
	$(OCAMLOPT) -a -o $(XARCHIVE) -package "$(REQUIRES)" -linkpkg \
	-predicates "$(PREDICATES)" $(XOBJECTS)

.SUFFIXES: .cmo .cmi .cmx .ml .mli

.ml.cmo:
	$(OCAMLC) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<
.mli.cmi:
	$(OCAMLC) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<
.ml.cmx:
	$(OCAMLOPT) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<

include depend

depend: $(wildcard *.ml*)
	if ! ($(OCAMLDEP) *.mli *.ml >depend); then rm depend; fi

.PHONY: install uninstall clean swig

install: all
	{ test ! -f $(XARCHIVE) || extra="$(XARCHIVE) "`basename $(XARCHIVE) .cmxa`.a }; \
	ocamlfind install $(NAME) *.mli *.cmi $(ARCHIVE) META $$extra

uninstall:
	ocamlfind remove $(NAME)

clean:
	rm -f depend *.cmi *.cmo *.cmx *.cma *.cmxa *.a *.o $(EXECS)
	rm -f depend *.dvi *.log *.aux *.ps
	rm -f swig.* pag8f.ml paq8f.mli *~ paq8f_wrap.c
