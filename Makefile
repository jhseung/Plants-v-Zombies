build:
	ocamlbuild -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js
	ocamlbuild -use-ocamlfind state.cmo

test:
	ocamlbuild -use-ocamlfind model_test.byte && ./model_test.byte

check:
	bash checkenv.sh

clean:
	ocamlbuild -clean
