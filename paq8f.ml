open Swig
type c_enum_type = [ 
  `unknown
]
type c_enum_value = [ 
  `Int of int
]

type c_obj = c_enum_value c_obj_t
let module_name = "paq8f"

exception BadArgs of string
exception BadMethodName of c_obj * string * string
exception NotObject of c_obj
exception NotEnumType of c_obj
exception LabelNotFromThisEnum of c_obj
exception InvalidDirectorCall of c_obj

external _init_f : c_obj list -> c_obj list = "_wrap_initpaq8f" ;;
let _init arg = match _init_f (fnhelper arg) with
  [] -> C_void
| [x] -> (if false then Gc.finalise 
  (fun x -> ignore ((invoke x) "~" C_void)) x) ; x
| lst -> C_list lst ;;
external _compressed_size_bitstring_f : c_obj list -> c_obj list = "_wrap_compressed_size_bitstringpaq8f" ;;
let _compressed_size_bitstring arg = match _compressed_size_bitstring_f (fnhelper arg) with
  [] -> C_void
| [x] -> (if false then Gc.finalise 
  (fun x -> ignore ((invoke x) "~" C_void)) x) ; x
| lst -> C_list lst ;;
external f_init : unit -> unit = "f_paq8f_init" ;;
let _ = f_init ()
let enum_to_int x (v : c_obj) =
   match v with
     C_enum _y ->
     (let y = _y in match (x : c_enum_type) with
       `unknown ->          (match y with
           `Int x -> (Swig.C_int x)
           | _ -> raise (LabelNotFromThisEnum v))
) | _ -> (C_int (get_int v))
let _ = Callback.register "paq8f_enum_to_int" enum_to_int
let int_to_enum x y =
    match (x : c_enum_type) with
      `unknown -> C_enum (`Int y)
let _ = Callback.register "paq8f_int_to_enum" int_to_enum

  let rec swig_val t v = 
    match v with
        C_enum e -> enum_to_int t v
      | C_list l -> Swig.C_list (List.map (swig_val t) l)
      | C_array a -> Swig.C_array (Array.map (swig_val t) a)
      | _ -> Obj.magic v

