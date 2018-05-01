build:
	ocamlbuild -Is model -use-ocamlfind control.cmo mega.cmo\
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js

test:
	ocamlbuild -Is model -use-ocamlfind test_main.byte && ./test_main.byte 

clean:
	ocamlbuild -clean
