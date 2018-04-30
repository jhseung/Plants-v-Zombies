open State
open Mega

module Html = Dom_html
let js = Js.string
let document = Html.document


let render_change (context: Html.canvasRenderingContext2D Js.t) mega =
  clear context;
  
