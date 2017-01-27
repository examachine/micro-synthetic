(* Micro-Synthetic algorithm *)
(* Author: Eray Ozkural *)

open Printf
open Scanf
open Util
open Bz
open Bitv
open Swig
(*Open Big_int*)

let print_bitstrings a =
  List.iter (fun x -> print_string (Bitv.to_string x); print_newline ()) a

(* AIT *)


let compress_string str =
  Bz.compress str ~pos:0 ~len:(String.length str)

let zerolen =
  String.length (compress_string "")
(*let zerolen = 
  get_int (Paq8f._compressed_size_bitstring (C_list [C_string " "; C_int 0]))*)

let string_of_int x = 
  let s = String.create 4 in
  let s1 = char_of_int (x land 0xFF)
  and s2 = char_of_int ((x lsr 8) land 0xFF)
  and s3 = char_of_int ((x lsr 16) land 0xFF)
  and s4 = char_of_int ((x lsr 24) land 0xFF) in
  s.[0] <- s1;
  s.[1] <- s2;
  s.[2] <- s3;
  s.[3] <- s4;
  s

let transpose_byte src =
  let t = (src lsl 4) lor (src lsr 4) in 
  let t = ((t land 0xcc) lsr 2 ) lor ((t land 0x33) lsl 2) in
  ((t land 0xaa) lsr 1 ) lor ((t land 0x55) lsl 1)

let string_of_int_ms x = 
  let s = String.create 4 in
  let s1 = char_of_int (transpose_byte (x land 0xFF))
  and s2 = char_of_int (transpose_byte ((x lsr 8) land 0xFF))
  and s3 = char_of_int (transpose_byte ((x lsr 16) land 0xFF))
  and s4 = char_of_int (transpose_byte ((x lsr 24) land 0xFF)) in
  s.[0] <- s1;
  s.[1] <- s2;
  s.[2] <- s3;
  s.[3] <- s4;
  s

let string_of_bv bv = 
  let a = Bitv.bits bv in
  String.concat "" (Array.to_list (Array.map string_of_int a))

let string_of_bv_ms bv = 
  let a = Bitv.bits bv in
  String.concat "" (Array.to_list (Array.map string_of_int_ms a))

let compress_bitv str = 
  compress_string (string_of_bv str)

(*let h bv = (String.length (compress_bitv bv) ) - zerolen*)

(* use PAQ8F *)

let h bv = 
  let s = string_of_bv_ms bv 
  and l = Bitv.length bv in
  get_float (Paq8f._compressed_size_bitstring (C_list [C_string s; C_int l]))

(* for iterating over a list with index *)
let list_iteri f list = 
  let i = ref 0 in 
  List.iter (fun x -> f x i; i:= !i+1) list


(*TODO: better way to do these things with bitstring types, and lazily *)
(* generate bitstrings from 0 to 2^n-1 *)
let generate n =
  (*assert n < 32;  limitation to remove later *)
  let x = ref 0 
  and xend = (1 lsl n)
  and l = ref [] in 
  while (!x < xend) do
    (* make bitv from x *)
    (*print_int !x;*)
    l := Bitv.init (int_of_float (Math.log2 (float_of_int !x))+1)
	(fun ix -> (!x land (1 lsl ix)) >0 ) :: !l;
    incr x;    
  done;
  !l

(* extend a patterns by n bits*)
let extendpattern p n =
  List.map (Bitv.append p) (generate n)

(* extend a list of frequent patterns by n bits*)
let extend f n = 
  List.concat (List.map (fun x->extendpattern x n) f)

let microsynthetic t epsilon r1 r2 ?(n=8) =
  Paq8f._init (C_list []);
  let avgtlen = (List.fold_left (+) 0 (List.map Bitv.length t)) / 
    (List.length t) in
  let ck = ref (generate n) 
  and f = ref []
  and k = ref 1 
  (*and cf x = (float_of_int (h x)) in *)
  and cf = h in 
  while (List.length !ck) != 0 do
    let count = Array.make (List.length !ck) 0 
    and fk = ref [] in
    (*print_bitstrings !ck;*)
    printf "number of candidates=%d\n" (List.length !ck); flush stdout;
    let count_patterns y = (* y in T *)
      list_iteri 
	(fun x i ->  (* x in C_k *)

	  printf "h(x)=%f h(y)=%f h(y,x)=%f, x=%s , y=%s\n" (cf x) (cf y) (cf (Bitv.append
	     y x)) (Bitv.to_string x)  (Bitv.to_string y);
	  flush stdout;

	  if (Bitv.length x) <= avgtlen && 
	    (cf x) <= r1 *. (cf y) && 
	    (cf (Bitv.append y x)) <= (r2 +. 1.0) *. (cf y)
	  then 
	    count.(!i) <- count.(!i) + 1
	) !ck
    in 
    List.iter count_patterns t;
    (*Array.iter (fun x-> printf "%d, " x) count;*)
    list_iteri
      (fun x i ->
	if count.(!i) >= epsilon then
	  fk := x :: !fk
	else
	  ()
      ) !ck;
    printf "number of frequent patterns in level %d is %d\n" !k  (List.length !fk) ;
    print_bitstrings !fk;
    ck := extend !fk n;
    f := List.append !f !fk;
    k := !k+1
  done;
  f

let test () = 
  let a = generate 3 in
  printf "zibam %d\n" (List.length a) ;
  print_bitstrings a;
  let b = extend a 2 in 
  printf "zibam2 %d\n" (List.length b);
  print_bitstrings b;
  let x = Bitv.create 9 true in
  let s = string_of_bv x in
  printf "zort %d %d\n" (int_of_char s.[0]) (int_of_char s.[1]);
  let s = string_of_bv_ms x in
  printf "zortms %d %d\n" (int_of_char s.[0]) (int_of_char s.[1])
 
