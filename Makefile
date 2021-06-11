
FILES=.Rprofile .emacs .gitconfig .zlogout .zshrc .aliases
FILEZ=$(patsubst %,$(HOME)/%,$(FILES))

install: $(FILEZ)

check:
	@for f in $(FILES) ; do \
		diff -u $(HOME)/$$f $$f ; \
	done

colorcheck:
	make check | colordiff | less

getlatest:
	for i in $(FILES); do cp $(HOME)/$$i .; done


echo:
	echo $(FILES)
	echo $(FILEZ)

$(HOME)/%: %
	cp $< $@

merge:
	git merge-to Mac master
	git merge-to Linux master
