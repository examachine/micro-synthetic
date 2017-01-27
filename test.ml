open MicroSynthetic
open Printf

let test_bitv () = 
  let x = Bitv.create 9 true in
  let a = Bitv.bits x in
  printf "a=%d\n" a.(0)

let _ =
  MicroSynthetic.test ();
  test_bitv()


