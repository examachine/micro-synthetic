(* support for Barla's DV (document vector) format *)
open Printf
open Scanf
open Util
open Bitv

let print_intlist list = 
    List.iter (fun x ->printf "%d " x) list

let print_bitstrings a =
  List.iter (fun x -> print_string (Bitv.to_string x); print_newline ()) a


let read_binary_ascii fname =
  let f = open_in fname in
  let lines = input_lines f in 
  let process line =
    let buf = Scanning.from_string line in
    let vec = Array.init (String.length line) 
	(fun i -> bscanf buf "%c" (fun x -> if x=='1' then 1 else 0)) in
    Bitv.init (String.length line) (fun i->vec.(i)==1) in
  let bv_list = List.map process lines in
  close_in f; bv_list

