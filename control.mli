open Mega

(*type of the mouse click.
  [Cstart] represents a click on the start button.
  [Cgarden (x,y)] represents a click on coordinates [(x,y)].
  [Cstock f] represents a click on the flora of type [f] in the stock panel.*)
type clicked = Cstart | Cgarden of float*float | Cstock of flora_t

(*[make_move prev curr m] is [(prev',m')] where [prev] is the latest mouse click
  on an available flora in stock that has not been planted yet if there exists
  such a mouse click, otherwise [prev] is a previous valid mouse click (may not
  be on the stock). [curr] is the current mouse click that waits for response of
  the program. [m] is the current mega state. [prev'] satisfies the same
  specification as [prev] for the next call to [make_move]. [m'] is the mega
  state that results from [curr].*)
val make_move : clicked -> clicked -> mega -> clicked * mega
