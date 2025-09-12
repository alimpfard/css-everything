ALL_FILES_EXTERN := $(wildcard csswg-drafts/**/*.bs) $(wildcard csswg-drafts/**/*.src.html) $(wildcard css-houdini-drafts/**/*.bs) $(wildcard css-houdini-drafts/**/*.src.html)

install ?= install
pcregrep ?= pcregrep

all: all-the-css.html
	mkdir -p build
	cp all-the-css.html build/index.html
	$(shell ${pcregrep} --buffer-size 2M -M '<(img|object|link) [^>]*(src|href)=' all-the-css.html | grep -E '(src|href)=' | sed -E 's/.*(src|href)="([^"]*)".*/\2/g' | sort | uniq | xargs -I{} echo -o -path '*{}' | xargs find ./css-houdini-drafts/ ./csswg-drafts/ -false | sed -E -e 's#\./[a-z-]*/[a-z0-9-]*/#;&;#g' -e 's#^\./[a-z-]*/#;&;#g' | awk -F';' '{ printf("${install} -D %s%s build/%s;\n", $$2, $$3, $$3) }')

all-the-css.html: all-the-css.bs
	python -m bikeshed --die-on nothing spec all-the-css.bs

all-the-css.bs: all-the-css.prelude $(ALL_FILES_EXTERN)
	cat all-the-css.prelude > all-the-css.bs
	@ $(foreach name,$(ALL_FILES_EXTERN),echo "<pre class=include>\npath: $(name)\n</pre>" >> all-the-css.bs;)

clean:
	rm -fr build
	rm -f all-the-css.bs
	rm -f all-the-css.html

.SECONDEXPANSION:
