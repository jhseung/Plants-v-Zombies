build:
	ocamlbuild -Is model -use-ocamlfind control.cmo mega.cmo
	ocamlbuild -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js

test:
	ocamlbuild -use-ocamlfind model_test.byte && ./model_test.byte

check:
	bash checkenv.sh

clean:
	ocamlbuild -clean
