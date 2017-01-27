open Unix

(* Misc. utilities *)

(* compute random permutation of an array of indices from 0 to n-1 *)
let random_permute n =
  let a = Array.init n (function i -> i)
  and swap a i j = let t = a.(i) in a.(i) <- a.(j); a.(j) <- t
  in
    Random.self_init ();
    for i=1 to n-1 do
      swap a (Random.int i) i
    done;
    a

let input_lines file =
  let rec input_aux file =
    try
      let line = input_line file in
      let tail = input_aux file in
	line :: tail
    with End_of_file -> []
  in
    input_aux file

let read_file fname =
  let f = open_in fname in
  let n = in_channel_length f in
  let buf = String.create n in
    really_input f buf 0 n;
    close_in f;
    buf
      
let read_directory dir =
  let rec read_dir_aux h =
    try
      let head = readdir h in
      let tail = read_dir_aux h in
	head::tail
    with End_of_file -> []
  in
    read_dir_aux (opendir dir)

(* remove . and .., then sort entries *)
let read_dir_files dir =
  let entries = read_directory dir in
  let notdir s = (s <> ".") && (s <> "..") in
    List.sort String.compare (List.filter notdir entries)

(* given n integers a, compute
s_0 = 0
s_k_{k=1 to n}  = \sigma_i=1^{i=k} a_i *)
let sum_from_start a =
  let n = Array.length a in
  let s = Array.make (n+1) 0 in
    s.(0) <- 0;
    for i = 1 to n do
      s.(i) <- s.(i-1) + a.(i-1)
    done;
    s
