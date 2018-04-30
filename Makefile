build:
	ocamlbuild -Is model -use-ocamlfind control.cmo mega.cmo\
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js

test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte 

clean:
	ocamlbuild -clean