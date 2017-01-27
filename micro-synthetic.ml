open Printf
open Arg

let write_patterns fname patterns  =
  let f = open_out fname in
  List.iter (fun x -> fprintf f "%s\n" (Bitv.to_string x)) patterns;
  close_out f

let db_fname = ref ""
let epsilon = ref 0
let r1 = ref 0.0
let r2 = ref 0.0
let n = ref 8

let speclist =
  [
    ("-db", String (fun x -> db_fname := x), "input database");
    ("-epsilon", Int (fun x -> epsilon := x), "support threshold");
    ("-r1", Float (fun x -> r1 := x), "ratio 1");
    ("-r2", Float (fun x -> r2 := x), "ratio 2");
    ("-n", Int (fun x -> n := x), "number of bits at each pass");
  ]


let _ =
  Arg.parse speclist (fun x -> ()) "";
  let t = Data.read_binary_ascii !db_fname in
  MicroSynthetic.print_bitstrings t;
  let f = MicroSynthetic.microsynthetic t !epsilon !r1 !r2 ~n:!n in
  printf "|F|=%d\n" (List.length !f);  
  write_patterns (!db_fname ^ ".patterns") !f
