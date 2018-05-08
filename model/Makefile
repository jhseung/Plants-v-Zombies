build:
	ocamlbuild -use-ocamlfind object.cmo state.cmo

test:
	ocamlbuild -use-ocamlfind model_test.byte && ./model_test.byte

check:
	bash checkenv.sh

clean:
	ocamlbuild -clean