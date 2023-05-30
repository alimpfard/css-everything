ALL_FILES_EXTERN := $(wildcard csswg-drafts/**/*.bs) $(wildcard csswg-drafts/**/*.src.html)
ALL_FILES_COPIED := $(subst /,@,$(subst csswg-drafts/,,$(ALL_FILES_EXTERN)))

all-the-css.html: all-the-css.bs
	python -m bikeshed --die-on nothing spec all-the-css.bs

all-the-css.bs: all-the-css.prelude $(ALL_FILES_COPIED)
	cat all-the-css.prelude > all-the-css.bs
	@ $(foreach name,$(ALL_FILES_COPIED),echo "<pre class=include>\npath: $(name)\n</pre>" >> all-the-css.bs;)

clean:
	rm -f $(ALL_FILES_COPIED)
	rm -f all-the-css.bs
	rm -f all-the-css.html

.SECONDEXPANSION:

%.bs: csswg-drafts/$$(subst @,/,%).bs
	cp $< $@

%.src.html: csswg-drafts/$$(subst @,/,%).src.html
	cp $< $@

