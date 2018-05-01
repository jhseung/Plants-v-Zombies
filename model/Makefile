build:
	ocamlbuild -use-ocamlfind state.cmo

test:
	ocamlbuild -use-ocamlfind model_test.byte && ./model_test.byte

check:
	bash checkenv.sh

clean:
	ocamlbuild -clean