.POSIX:

EM = emacs --batch
ELPA := ${HOME}/.emacs.d/elpa
SITE-LISP := ${HOME}/.emacs.d/lisp

LISPINCL ?= $(addprefix -L ,.)
LISPINCL += $(addprefix -L ,${SITE-LISP})
LISPINCL += $(addprefix -L ,$(wildcard ${ELPA}/s-*))
LISPINCL += $(addprefix -L ,$(wildcard ${ELPA}/ts-*))
LISPINCL += $(addprefix -L ,$(wildcard ${ELPA}/peg-*))
LISPINCL += $(addprefix -L ,$(wildcard ${ELPA}/dash-*))
LISPINCL += $(addprefix -L ,$(wildcard ${ELPA}/org-ql-*))

ifeq ($(PREFIX),)
    PREFIX := ${HOME}/.emacs.d/
endif

SRCS := $(wildcard *.el)

.PHONY: clean compile native install uninstall install-native install-all install

%.elc: %.el
	$(EM) $(LISPINCL) -f batch-byte-compile $<

%.eln: %.elc
	$(EM) $(LISPINCL) --eval '(native-compile "$<")'

compile:${patsubst %.el, %.elc, $(SRCS)}

native: ${patsubst %.el, %.eln, $(SRCS)}

install:compile
	mkdir -p $(DESTDIR)$(PREFIX)/lisp
	cp *.el $(DESTDIR)$(PREFIX)/lisp
	cp *.elc $(DESTDIR)$(PREFIX)/lisp

install-native: native
	cp eln-*/* $(DESTDIR)$(PREFIX)/lisp/eln-*

install-all: install install-native

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/lisp/elgantt.*
	rm -f $(DESTDIR)$(PREFIX)/lisp/elgantt-*.*
	rm -f $(DESTDIR)$(PREFIX)/lisp/eln-*/elgantt-*

clean:
	rm -rf *.elc eln-*

