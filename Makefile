build:
	ocamlbuild -Is model -use-ocamlfind control.cmo mega.cmo

test:
	ocamlbuild -use-ocamlfind test.byte && ./test.byte 

clean:
	ocamlbuild -clean
