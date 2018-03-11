module CanonCommMonoid

open FStar.List
open FStar.Tactics
open FStar.Reflection
open FStar.Classical
open FStar.OrdMap

(* An expression canonizer for commutative monoids
   Inspired by:
   - http://adam.chlipala.net/cpdt/html/Cpdt.Reflection.html
   - http://poleiro.info/posts/2015-04-13-writing-reflective-tactics.html
*)

(***** Commutative monoids *)

(* Should eventually go to standard library *)

let right_unitality_lemma (a:Type) (u:a) (mult:a -> a -> a) =
  x:a -> Lemma (x `mult` u == x)

let left_unitality_lemma (a:Type) (u:a) (mult:a -> a -> a) =
  x:a -> Lemma (u `mult` x == x)

let associativity_lemma (a:Type) (mult:a -> a -> a) =
  x:a -> y:a -> z:a -> Lemma (x `mult` y `mult` z == x `mult` (y `mult` z))

let commutativity_lemma (a:Type) (mult:a -> a -> a) =
  x:a -> y:a -> Lemma (x `mult` y == y `mult` x)

unopteq
type cm (a:Type) =
  | CM :
    unit:a ->
    mult:(a -> a -> a) ->
    right_unitality:right_unitality_lemma a unit mult ->
    left_unitality:left_unitality_lemma a unit mult ->
    associativity:associativity_lemma a mult ->
    commutativity:commutativity_lemma a mult ->
    cm a

let int_plus_cm : cm int =
  CM 0 (+) (fun x -> ()) (fun x -> ()) (fun x y z -> ()) (fun x y -> ())

(***** Expression syntax *)

let var : eqtype = nat

type exp : Type =
  | Unit : exp
  | Var : var -> exp
  | Mult : exp -> exp -> exp

let rec exp_to_string (e:exp) : string =
  match e with
  | Unit -> "Unit"
  | Var x -> "Var " ^ string_of_int (x <: var)
  | Mult e1 e2 -> "Mult (" ^ exp_to_string e1
                   ^ ") (" ^ exp_to_string e2 ^ ")"

(***** Expression denotation *)

// Use a map that stores for each variable
// (1) its denotation that should be treated abstractly (type a) and
// (2) user-specified extra information depending on its term (type b)
let vmap (a b:Type) = var -> (a*b)
let const (#a #b:Type) (xa:a) (xb:b) (x:var) = (xa,xb)
let select (#a #b:Type) (x:var) (vm:vmap a b) : Tot a = fst (vm x)
let select_extra (#a #b:Type) (x:var) (vm:vmap a b) : Tot b = snd (vm x)
let update (#a #b:Type) (x:var) (xa:a) (xb:b) (vm:vmap a b) (x':var) :
  Tot (a*b) = if x' = x then (xa,xb) else vm x'

let rec mdenote (#a #b:Type) (m:cm a) (vm:vmap a b) (e:exp) : a =
  match e with
  | Unit -> CM?.unit m
  | Var x -> select x vm
  | Mult e1 e2 -> CM?.mult m (mdenote m vm e1) (mdenote m vm e2)

let rec xsdenote (#a #b:Type) (m:cm a) (vm:vmap a b) (xs:list var) : a =
  match xs with
  | [] -> CM?.unit m
  | [x] -> select x vm
  | x::xs' -> CM?.mult m (select x vm) (xsdenote m vm xs')

(***** Flattening expressions to lists of variables *)

let rec flatten (e:exp) : list var =
  match e with
  | Unit -> []
  | Var x -> [x]
  | Mult e1 e2 -> flatten e1 @ flatten e2

let rec flatten_correct_aux (#a #b:Type) (m:cm a) (vm:vmap a b)
                                                  (xs1 xs2:list var) :
    Lemma (xsdenote m vm (xs1 @ xs2) == CM?.mult m (xsdenote m vm xs1)
                                                   (xsdenote m vm xs2)) =
  match xs1 with
  | [] -> CM?.left_unitality m (xsdenote m vm xs2)
  | [x] -> if (Nil? xs2) then CM?.right_unitality m (select x vm)
  | x::xs1' -> (CM?.associativity m (select x vm)
                      (xsdenote m vm xs1') (xsdenote m vm xs2);
                flatten_correct_aux m vm xs1' xs2)

let rec flatten_correct (#a #b:Type) (m:cm a) (vm:vmap a b) (e:exp) :
    Lemma (mdenote m vm e == xsdenote m vm (flatten e)) =
  match e with
  | Unit | Var _ -> ()
  | Mult e1 e2 -> flatten_correct_aux m vm (flatten e1) (flatten e2);
                  flatten_correct m vm e1; flatten_correct m vm e2

(***** Permuting the lists of variables
       by swapping adjacent elements *)

let permute (b:Type) = #a:Type -> vmap a b -> list var -> list var

// high-level correctness criterion for permutations
let permute_correct (#b:Type) (p:permute b) =
  #a:Type -> m:cm a -> vm:vmap a b -> xs:list var ->
    Lemma (xsdenote m vm xs == xsdenote m vm (p vm xs))

// sufficient condition:
// permutation has to be expressible as swaps of adjacent list elements

let swap (n:nat) :Type = x:nat{x < n-1}

let rec apply_swap_aux (#a:Type) (n:nat) (xs:list a) (s:swap (length xs + n)) :
    Pure (list a) (requires True)
                  (ensures (fun zs -> length zs == length xs)) (decreases xs) =
  match xs with
  | [] | [_] -> xs
  | x1 :: x2 :: xs' -> if n = (s <: nat)
                       then x2 :: x1 :: xs'
                       else x1 :: apply_swap_aux (n+1) (x2 :: xs') s

let apply_swap (#a:Type) = apply_swap_aux #a 0

let rec apply_swap_aux_correct (#a #b:Type) (n:nat) (m:cm a) (vm:vmap a b)
                           (xs:list var) (s:swap (length xs + n)) :
    Lemma (requires True)
      (ensures (xsdenote m vm xs == xsdenote m vm (apply_swap_aux n xs s)))
      (decreases xs) =
  match xs with
  | [] | [_] -> ()
  | x1 :: x2 :: xs' ->
      if n = (s <: nat)
      then (// x1 + (x2 + xs') =a (x1 + x2) + xs'
            //                 =c (x2 + x1) + xs' = a x2 + (x1 + xs')
           let a = CM?.associativity m in
           a (select x1 vm) (select x2 vm) (xsdenote m vm xs');
           a (select x2 vm) (select x1 vm) (xsdenote m vm xs');
           CM?.commutativity m (select x1 vm) (select x2 vm))
      else apply_swap_aux_correct (n+1) m vm (x2 :: xs') s

let apply_swap_correct (#a #b:Type) (m:cm a) (vm:vmap a b)
                           (xs:list var) (s:swap (length xs)):
    Lemma (requires True)
          (ensures (xsdenote m vm xs == xsdenote m vm (apply_swap xs s)))
          (decreases xs) = apply_swap_aux_correct 0 m vm xs s

let rec apply_swaps (#a:Type) (xs:list a) (ss:list (swap (length xs))) :
    Pure (list a) (requires True)
                  (ensures (fun zs -> length zs == length xs)) (decreases ss) =
  match ss with
  | [] -> xs
  | s::ss' -> apply_swaps (apply_swap xs s) ss'

let rec apply_swaps_correct (#a #b:Type) (m:cm a) (vm:vmap a b)
                            (xs:list var) (ss:list (swap (length xs))):
    Lemma (requires True)
      (ensures (xsdenote m vm xs == xsdenote m vm (apply_swaps xs ss)))
      (decreases ss) =
  match ss with
  | [] -> ()
  | s::ss' -> apply_swap_correct m vm xs s;
              apply_swaps_correct m vm (apply_swap xs s) ss'

let permute_via_swaps (#b:Type) (p:permute b) =
  (#a:Type) -> (vm:vmap a b) -> xs:list var ->
    Lemma (exists ss. p vm xs == apply_swaps xs ss)

let rec permute_via_swaps_correct_aux
  (#b:Type) (p:permute b) (pvs:permute_via_swaps p)
  (#a:Type) (m:cm a) (vm:vmap a b)  (xs:list var) :
    Lemma (xsdenote m vm xs == xsdenote m vm (p vm xs)) =
  pvs vm xs;
  assert(exists ss. p vm xs == apply_swaps xs ss);
  exists_elim (xsdenote m vm xs == xsdenote m vm (p vm xs))
    (() <: squash (exists ss. p vm xs == apply_swaps xs ss))
    (fun ss -> apply_swaps_correct m vm xs ss)

let permute_via_swaps_correct
  (#b:Type) (p:permute b) (pvs:permute_via_swaps p) : permute_correct p =
     permute_via_swaps_correct_aux p pvs

// TODO In the general case, an arbitrary permutation can be done via
// swaps. To show this we could for instance, write the permutation as
// a sequence of transpositions and then each transposition as a
// series of swaps.

(***** Sorting variables is a correct permutation
       (since it can be done by swaps) *)

// sorting associates no extra information with the variables and only
// looks at the actual identifiers

let sort : permute unit =
  (fun #a vm -> List.Tot.sortWith #nat (compare_of_bool (<)))

// TODO: Show that sorting is a correct way to permute things;
// from sortWith_permutation we get
// (ensures (forall x. count x l = count x (sortWith f l)))
// but need instead a sequence of swaps of adjacent elements
// - can probably use bubble sort to show this special case

let rec bubble_sort_with_aux1 (#a:Type) (f:(a -> a -> Tot int)) (xs:list a) :
    Pure (list a) (requires True)
                  (ensures (fun zs -> length xs == length zs))
                  (decreases (length xs)) =
  match xs with
  | [] | [_] -> xs
  | x1 :: x2 :: xs' ->
      if f x1 x2 > 0 then x2 :: bubble_sort_with_aux1 f (x1::xs')
                     else x1 :: bubble_sort_with_aux1 f (x2::xs')

let rec bubble_sort_with_aux2 (#a:Type) (n:nat) (f:(a -> a -> Tot int))
          (xs:(list a){n <= length xs}) : Tot (list a)
              (decreases (length xs - n <: nat)) =
  if n = length xs then xs
  else bubble_sort_with_aux2 (n+1) f (bubble_sort_with_aux1 f xs)

let bubble_sort_with (#a:Type) = bubble_sort_with_aux2 #a 0

let sort_via_swaps (#a:Type) (vm : vmap a unit)  (xs:list var) :
  Lemma (exists ss. sort vm xs == apply_swaps xs ss) = admit() // TODO

let rec sort_correct_aux (#a:Type) (m:cm a) (vm:vmap a unit) (xs:list var) :
    Lemma (xsdenote m vm xs == xsdenote m vm (sort vm xs)) =
  permute_via_swaps_correct #unit
    (fun #a vm -> sort vm) (fun #a vm -> sort_via_swaps vm) m vm xs

let sort_correct : permute_correct #unit (fun #a vm -> sort vm) =
  (fun #a m vm xs -> sort_correct_aux #a m vm xs)

(***** Canonicalization tactics *)

let canon_with (#a #b:Type) (vm:vmap a b) (p:permute b) (e:exp) = p vm (flatten e)

let canon_with_correct (#a #b:Type) (p:permute b) (pc:permute_correct p)
                       (m:cm a) (vm:vmap a b) (e:exp) :
    Lemma (mdenote m vm e == xsdenote m vm (canon_with vm p e)) =
  flatten_correct m vm e; pc m vm (flatten e)

let monoid_reflect_with (#a #b:Type) (p:permute b) (pc:permute_correct p)
                        (m:cm a) (vm:vmap a b) (e1 e2:exp)
    (_ : squash (xsdenote m vm (canon_with vm p e1) ==
                 xsdenote m vm (canon_with vm p e2)))
    : squash (mdenote m vm e1 == mdenote m vm e2) =
  canon_with_correct p pc m vm e1; canon_with_correct p pc m vm e2

let monoid_reflect (#a:Type) (m:cm a) (vm:vmap a unit) (e1 e2:exp) =
  monoid_reflect_with #a #unit (fun #a vm -> sort vm)
    (fun #a m vm xs -> sort_correct #a m vm xs) m vm e1 e2

(* Finds the position of first occurrence of x in xs;
   this could use eqtype and be completely standard if term was eqtype *)
let rec where_aux (n:nat) (x:term) (xs:list term) : Tot (option nat)
                                                        (decreases xs) =
  match xs with
  | [] -> None
  | x'::xs' -> if term_eq x x' then Some n else where_aux (n+1) x xs'
let where = where_aux 0

// This expects that mult, unit, and t have already been normalized
#reset-options "--z3rlimit 30"
let rec reification_aux (#a #b:Type) (ts:list term) (vm:vmap a b) (f:term->Tac b)
    (mult unit t : term) : Tac (exp * list term * vmap a b) =
  let hd, tl = collect_app_ref t in
  let tl = list_unref tl in
  let fvar (t:term) (ts:list term) (vm:vmap a b) : Tac (exp * list term * vmap a b) =
    match where t ts with
    | Some v -> (Var v, ts, vm)
    | None -> let vfresh = length ts in let z = unquote t in
              (Var vfresh, ts @ [t], update vfresh z (f t) vm)
  in
  match inspect hd, tl with
  | Tv_FVar fv, [(t1, Q_Explicit) ; (t2, Q_Explicit)] ->
    if term_eq (pack (Tv_FVar fv)) mult
    then (let (e1,ts,vm) = reification_aux ts vm f mult unit t1 in
          let (e2,ts,vm) = reification_aux ts vm f mult unit t2 in
          (Mult e1 e2, ts, vm))
    else fvar t ts vm
  | _, _ ->
    if term_eq t unit
    then (Unit, ts, vm)
    else fvar t ts vm
#reset-options "--z3rlimit 5"

// TODO: could guarantee same-length lists
let reification_with (b:Type) (f:term->Tac b) (def:b) (#a:Type) (m:cm a) (ts:list term) :
    Tac (list exp * vmap a b) =
  let mult = norm_term [delta] (quote (CM?.mult m)) in
  let unit = norm_term [delta] (quote (CM?.unit m)) in
  let ts   = Tactics.Derived.map (norm_term [delta]) ts in
  // dump ("mult = " ^ term_to_string mult ^
  //     "; unit = " ^ term_to_string unit ^
  //     ";  t   = " ^ term_to_string t);
  let (es,_, vm) =
    Tactics.Derived.fold_left
      (fun (es,vs,vm) t ->
        let (e,vs,vm) = reification_aux vs vm f mult unit t in (e::es,vs,vm))
      ([],[], const (CM?.unit m) def) ts
  in (List.rev es,vm)

let canon_monoid_with
    (b:Type) (f:term->Tac b) (def:b) (#a:Type) (p:permute b) (pc:permute_correct p)
    (m:cm a) : Tac unit =
  norm [];
  let g = cur_goal () in
  match term_as_formula g with
  | Comp (Eq (Some t)) t1 t2 ->
      // dump ("t1 =" ^ term_to_string t1 ^
      //     "; t2 =" ^ term_to_string t2);
      if term_eq t (quote a) then
        match reification_with b f def m [t1;t2] with
        | [r1;r2], vm ->
          dump ("r1=" ^ exp_to_string r1 ^
              "; r2=" ^ exp_to_string r2);
          dump ("vm =" ^ term_to_string (quote vm));
          change_sq (quote (mdenote m vm r1 == mdenote m vm r2));
          dump ("before =" ^ term_to_string (norm_term [delta;primops]
            (quote (mdenote m vm r1 == mdenote m vm r2))));
          dump ("expected after =" ^ term_to_string (norm_term [delta;primops]
            (quote (xsdenote m vm (canon_with vm p r1) ==
                    xsdenote m vm (canon_with vm p r2)))));
          apply (`monoid_reflect);
          norm [delta_only ["CanonCommMonoid.canon_with";
                            "CanonCommMonoid.sort";
                            "CanonCommMonoid.xsdenote";
                            "CanonCommMonoid.flatten";
                            "CanonCommMonoid.select";
                            "FStar.Pervasives.Native.fst";
                            "FStar.Pervasives.Native.__proj__Mktuple2__item___1";
                            "FStar.List.Tot.Base.sortWith";
                            "FStar.List.Tot.Base.partition";
                            "FStar.List.Tot.Base.bool_of_compare";
                            "FStar.List.Tot.Base.compare_of_bool";
                            "FStar.List.Tot.Base.op_At";
                            "FStar.List.Tot.Base.append"];
                primops]; // TODO: restrict this to less than only
          dump "done"
        | _ -> fail "Unexpected"
      else fail "Goal should be an equality at the right monoid type"
  | _ -> fail "Goal should be an equality"

let canon_monoid = canon_monoid_with unit (fun _ -> ()) ()
  (fun #a vm -> sort vm) (fun #a m vm xs -> sort_correct #a m vm xs)

(***** Examples *)

let lem0 (a b c d : int) =
  assert_by_tactic (0 + 1 + a + b + c + d + 2 == (b + 0) + 2 + d + (c + a + 0) + 1)
  (fun _ -> canon_monoid int_plus_cm; trefl())

// remember if something is a constant or not
let is_const (t:term) : bool = Tv_Const? (inspect t)

// sort things and put the constants last
let const_compare (#a:Type) (vm:vmap a bool) (x y:var) =
  match select_extra x vm, select_extra y vm with
  | false, false | true, true -> 0
  | false, true -> 1
  | true, false -> -1

let const_last (#a:Type) (vm:vmap a bool) (xs:list var) : list var =
  List.Tot.sortWith #nat (const_compare vm) xs

let canon_monoid_const = canon_monoid_with bool is_const false
      (fun #a vm -> const_last vm) (fun #a m vm xs -> admit())

let lem1 (a b c d : int) =
  assert_by_tactic (0 + 1 + a + b + c + d + 2 == (b + 0) + 2 + d + (c + a + 0) + 1)
  (fun _ -> canon_monoid_const int_plus_cm; trefl())

(* TODO: Allow the tactic to compute with constants beyond unit.
         Would it be enough to move all them to the end of the list by
         a careful ordering and let the normalizer do its thing? *)

(* TODO: Allow the user control over the sorting ordering by allowing
         him to store extra information in the vmap and using that for
         the sorting. This would mean that sorting should have access
         to the vmap in the first place. *)

(* TODO: would be nice to just find all terms of monoid type in the
         goal and replace them with their canonicalization;
         basically use flatten_correct instead of monoid_reflect
         - for this to be efficient need Nik's pointwise' that can
           stop traversing when finding something interesting
         - even better, the user would have control over the place(s)
           where the canonicalization is done *)

(* TODO (open ended) Do the things used for reflective tactics really
                     need to be this pure? Can we prove correctness of
                     denotations intrinsically / by monadic
                     reification for an effectful denotation? *)
