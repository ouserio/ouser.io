all: spec.html styles.css

spec.html: spec.md
	aglio -t flatly -i spec.md -o spec.html

styles.css: styles.less
	lessc styles.less > styles.css

.PHONY: all
