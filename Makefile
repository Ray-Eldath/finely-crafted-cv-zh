.PHONY: build watch

build:
	typst compile main.typ lzh_resume.pdf

watch:
	typst watch main.typ lzh_resume.pdf
