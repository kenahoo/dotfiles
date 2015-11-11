
FILES=.Rprofile .emacs .gitconfig .zlogout .zshrc
FILEZ=$(patsubst %,$(HOME)/%,$(FILES))

install: $(FILEZ)

check:
	@for f in $(FILES) ; do \
		diff -u $(HOME)/$$f $$f ; \
	done

getlatest:
	for i in $(FILES); do cp $(HOME)/$$i .; done


echo:
	echo $(FILEZ)

$(HOME)/%: %
	cp $< $@

merge:
	git merge-to Mac master
	git merge-to Linux master
	git merge-to MacBook Mac
