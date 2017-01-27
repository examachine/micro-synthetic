open Swig
open Paq8f
open Printf

let _ = 
  Paq8f._init (C_list []);
  let s = "abcdeabcdeabc" in
  let l = (String.length s) * 8 in 
  let hs = Paq8f._compressed_size_bitstring 
      (C_list [(C_string s); (C_int l)]) in 
  printf "|paq8f(s)|=%f bits\n" (get_float hs);
  let s2 = String.make 1 (char_of_int 0xf) in
  printf "|paq8f(00001111)|=%f bits\n" 
    (get_float (Paq8f._compressed_size_bitstring 
       (C_list [(C_string s2); (C_int 8)]) ));
  let s2 = String.make 1 (char_of_int 0xf) in
  printf "|paq8f(00001111)|=%f bits\n" 
    (get_float (Paq8f._compressed_size_bitstring 
       (C_list [(C_string s2); (C_int 8)]) ));
  let s2 = String.make 1 (char_of_int 0xf) in
  printf "|paq8f(00001111)|=%f bits\n" 
    (get_float (Paq8f._compressed_size_bitstring 
       (C_list [(C_string s2); (C_int 8)]) ))
