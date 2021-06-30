module AggregateRef

open FStar.PCM
module P = FStar.PCM

(* TODO move to FStar.PCM.fst, use in earlier code to avoid P.p.one *)
let one (p: pcm 'a) = p.P.p.one

(** Very well-behaved lenses *)
noeq type lens (a: Type u#a) (b: Type u#b) = {
  get: a -> b;
  put: b -> a -> a;
  get_put: s: a -> v: b -> Lemma (get (put v s) == v);
  put_get: s: a -> Lemma (put (get s) s == s);
  put_put: s: a -> v: b -> w: b -> Lemma (put v (put w s) == put v s);
}
let get_put' (l: lens 'a 'b) (s: 'a) (v: 'b)
  : Lemma (l.get (l.put v s) == v) [SMTPat (l.get (l.put v s))]
  = l.get_put s v
let put_get' (l: lens 'a 'b) (s: 'a)
  : Lemma (l.put (l.get s) s == s) [SMTPat (l.put (l.get s))]
  = l.put_get s
let put_put' (l: lens 'a 'b) (s: 'a) (v w: 'b)
  : Lemma (l.put v (l.put w s) == l.put v s) [SMTPat (l.put v (l.put w s))]
  = l.put_put s v w

(** Updating the target of a lens *)
let lens_upd (l: lens 'a 'b) (f: 'b -> 'b) (s: 'a): 'a = l.put (f (l.get s)) s

(** The identity lens *)
let const (x: 'a) (b: 'b): 'a = x
let lens_id #a : lens a a = {
  get = id;
  put = const;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

(** Lens composition *)
let get_comp (l: lens 'a 'b) (m: lens 'b 'c) (s: 'a): 'c = m.get (l.get s)
let put_comp (l: lens 'a 'b) (m: lens 'b 'c) (v: 'c) (s: 'a): 'a =
  lens_upd l (m.put v) s
let lens_comp (l: lens 'a 'b) (m: lens 'b 'c): lens 'a 'c = {
  get = get_comp l m;
  put = put_comp l m;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

(** Given PCMs (p: pcm a) and (q: pcm b), a (pcm_lens p q) is a (lens a b) where
    (1) get is a PCM morphism p -> q
    (2) put is a PCM morphism q×p -> p, where (×) = Aggregates.tuple_pcm *)

let morphism_refine (p: pcm 'a) (q: pcm 'b) (f: 'a -> 'b) =
  x:'a -> Lemma (requires p.refine x) (ensures q.refine (f x)) [SMTPat (p.refine x)]
let morphism_one (p: pcm 'a) (q: pcm 'b) (f: 'a -> 'b) =
  unit -> Lemma (f (one p) == one q)
let morphism_op (p: pcm 'a) (q: pcm 'b) (f: 'a -> 'b) =
  x:'a -> y:'a ->
    Lemma 
      (requires composable p x y) 
      (ensures composable q (f x) (f y) /\ f (op p x y) == op q (f x) (f y))
      [SMTPat (composable p x y)]

noeq type pcm_morphism #a #b (p: pcm a) (q: pcm b) (f: a -> b) = {
  f_refine: x:a -> Lemma (requires p.refine x) (ensures q.refine (f x)) [SMTPat (p.refine x)];
  f_one: morphism_one p q f;
  f_op: x:a -> y:a ->
    Lemma 
      (requires composable p x y) 
      (ensures composable q (f x) (f y) /\ f (op p x y) == op q (f x) (f y))
      [SMTPat (composable p x y)]
}

let pcm_morphism_id (#p: pcm 'a): pcm_morphism p p id = {
  f_refine = (fun _ -> ());
  f_one = (fun _ -> ());
  f_op = (fun _ _ -> ());
}

(* TODO is this in stdlib somewhere? *)
let compose (f: 'b -> 'c) (g: 'a -> 'b) (x: 'a): 'c = f (g x)

let pcm_morphism_comp (#p: pcm 'a) (#q: pcm 'b) (#r: pcm 'c) (#f: 'b -> 'c) (#g: 'a -> 'b)
  (mf: pcm_morphism q r f) (mg: pcm_morphism p q g)
: pcm_morphism p r (f `compose` g) = {
  f_refine = (fun x -> mg.f_refine x; mf.f_refine (g x));
  f_one = (fun () -> mg.f_one (); mf.f_one ());
  f_op = (fun x y -> mg.f_op x y; mf.f_op (g x) (g y));
}

(* TODO in stdlib? *)
let both (f: 'a -> 'c) (g: 'b -> 'd) ((x, y): 'a & 'b): 'c & 'd = (f x, g y)

open Aggregates
let pcm_morphism_both (#p: pcm 'a) (#q: pcm 'b) (#r: pcm 'c) (#s: pcm 'd) (#f: 'a -> 'c) (#g: 'b -> 'd)
  (mf: pcm_morphism p r f) (mg: pcm_morphism q s g)
: pcm_morphism (tuple_pcm p q) (tuple_pcm r s) (both f g) = {
  f_refine = (fun (x, y) -> mf.f_refine x; mg.f_refine y);
  f_one = (fun () -> mg.f_one (); mf.f_one ());
  f_op = (fun (x, y) (z, w) -> mf.f_op x z; mg.f_op y w);
}

(* TODO in stdlib? *)
let uncurry (f: 'a -> 'b -> 'c) ((x, y): 'a & 'b): 'c = f x y

noeq type pcm_lens #a #b (p: pcm a) (q: pcm b) = {
  l: lens a b;
  get_morphism: pcm_morphism p q l.get;
  put_morphism: pcm_morphism (tuple_pcm q p) p (uncurry l.put);
}
let get (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q) (s: 'a): 'b = l.l.get s
let put (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q) (v: 'b) (s: 'a): 'a = l.l.put v s
let upd (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q) (f: 'b -> 'b) (s: 'a): 'a = lens_upd l.l f s

(** The upd function of a pcm_lens lifts frame-preserving updates on the target to
    frame-preserving updates on the source *)

let pcm_lens_compatible_get (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q) (x y: 'a)
: Lemma (requires compatible p x y) (ensures compatible q (get l x) (get l y))
= compatible_elim p x y (compatible q (get l x) (get l y)) (fun frame_x ->
  let _ = l.get_morphism.f_op frame_x x in
  compatible_intro q (get l x) (get l y) (get l frame_x))
    
(** The non-computational part of frame_preserving_upd
    TODO: move this and lemmas about this to FStar.PCM.fst *)
let frame_pres_on (p: pcm 'a) (f: 'a -> 'a) (x y: Ghost.erased 'a)
  (v:'a{p.refine v /\ compatible p x v})
= p.refine (f v) /\
  compatible p y (f v) /\
  (forall (frame:'a{composable p x frame}).{:pattern composable p x frame}
     composable p y frame /\
     (op p x frame == v ==> op p y frame == f v))
let frame_pres (p: pcm 'a) (f: 'a -> 'a) (x y: Ghost.erased 'a) =
  forall (v:'a{p.refine v /\ compatible p x v}).{:pattern compatible p x v}
  frame_pres_on p f x y v

(** Every function satisfying frame_pres is a frame_preserving_upd *)
let frame_pres_mk_upd (p: pcm 'a) (x y: Ghost.erased 'a)
  (f:('a -> 'a){frame_pres p f x y})
  : frame_preserving_upd p x y
  = fun v -> f v
(** The converse is not true, because a frame_preserving_upd's domain
    is restricted to v:a{p.refine v /\ compatible p x v}. *)

let frame_pres_intro (p: pcm 'a) (f: 'a -> 'a) (x y: Ghost.erased 'a)
  (g:(v:'a{p.refine v /\ compatible p x v} -> 
     Lemma (p.refine (f v) /\ compatible p y (f v) /\
            (forall (frame:'a{composable p x frame}).
              composable p y frame /\
              (op p x frame == v ==> op p y frame == f v)))
     [SMTPat (compatible p x v)]))
: Lemma (frame_pres p f x y) =
  let _ = g in ()
    
let pcm_lens_frame_pres (p: pcm 'a) (q: pcm 'b) (l: pcm_lens p q) (s: 'a) (v: 'b) (f: 'b -> 'b)
: Lemma
    (requires frame_pres q f (get l s) v)
    (ensures frame_pres p (upd l f) s (put l v s))
    [SMTPat (frame_pres q f (get l s) v)]
= frame_pres_intro p (lens_upd l.l f) s (l.l.put v s) (fun full ->
    assert (p.refine full);
    assert (compatible p s full);
    assert (lens_upd l.l f full == l.l.put (f (l.l.get full)) full);
    let _ = l.get_morphism.f_refine in
    assert (q.refine (l.l.get full));
    pcm_lens_compatible_get l s full;
    assert (compatible q (l.l.get s) (l.l.get full));
    assert (q.refine (f (l.l.get full)));
    l.put_morphism.f_refine (f (l.l.get full), full);
    assert (q.refine (f (l.l.get full)));
    assert (p.refine (l.l.put (f (l.l.get full)) full));
    assert (p.refine (lens_upd l.l f full));
    assert (compatible q v (f (l.l.get full)));
    let goal = frame_pres_on p (lens_upd l.l f) s (l.l.put v s) full in
    compatible_elim p s full goal (fun frame_s ->
    compatible_elim q v (f (l.l.get full)) goal (fun frame_v ->
    assert (composable q v frame_v /\ op q frame_v v == f (l.l.get full));
    let frame_vs: 'a = l.l.put frame_v frame_s in
    l.put_morphism.f_op (v, s) (frame_v, frame_s);
    assert (composable p (l.l.put v s) frame_vs);
    p.comm frame_vs (l.l.put v s);
    q.comm v frame_v;
    p.comm s frame_s;
    assert (op p frame_vs (l.l.put v s) == op p (l.l.put v s) frame_vs);
    assert (op p frame_vs (l.l.put v s) == l.l.put (op q v frame_v) (op p s frame_s));
    assert (op p frame_vs (l.l.put v s) == l.l.put (op q v frame_v) (op p s frame_s));
    assert (op p frame_vs (l.l.put v s) == lens_upd l.l f full);
    compatible_intro p (l.l.put v s) (lens_upd l.l f full) frame_vs;
    let aux (frame:'a{composable p s frame})
    : Lemma (composable p (l.l.put v s) frame /\
             (op p s frame == full ==> op p (l.l.put v s) frame == lens_upd l.l f full))
    = l.get_morphism.f_op s frame;
      assert (composable q (l.l.get s) (l.l.get frame));
      assert (composable q v (l.l.get frame));
      assert (composable p s frame);
      l.put_morphism.f_op (v, s) (l.l.get frame, frame);
      let aux ()
      : Lemma (requires op p s frame == full) 
              (ensures op p (l.l.put v s) frame == lens_upd l.l f full)
      = assert (composable p (l.l.put v s) (l.l.put (l.l.get frame) frame));
        assert (op p (l.l.put v s) frame == op p (l.l.put v s) (l.l.put (l.l.get frame) frame));
        assert (op p (l.l.put v s) frame == l.l.put (op q v (l.l.get frame)) (op p s frame));
        assert (op p (l.l.put v s) frame == l.l.put (op q v (l.l.get frame)) full);
        ()
      in ()
    in FStar.Classical.forall_intro aux)))

(** The identity lens is a pcm_lens *)
let pcm_lens_id (#p: pcm 'a): pcm_lens p p = {
  l = lens_id; 
  get_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
  put_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
}

(** pcm_lens composition is lens composition *)
let pcm_lens_comp (#p: pcm 'a) (#q: pcm 'b) (#r: pcm 'c)
  (l: pcm_lens p q) (m: pcm_lens q r): pcm_lens p r = 
{
  l = lens_comp l.l m.l;
  get_morphism = {
    f_refine = (fun _ ->
      let _ = l.get_morphism.f_refine in
      let _ = m.get_morphism.f_refine in ());
    f_one = (fun _ -> l.get_morphism.f_one (); m.get_morphism.f_one ());
    f_op = (fun s t ->
      l.get_morphism.f_op s t;
      m.get_morphism.f_op (get l s) (get l t));
  };
  put_morphism = {
    f_refine = (fun (v, s) ->
      l.get_morphism.f_refine s;
      m.put_morphism.f_refine (v, get l s);
      l.put_morphism.f_refine (put m v (get l s), s));
    f_one = (fun _ -> l.put_morphism.f_one (); m.put_morphism.f_one ());
    f_op = (fun (v, s) (w, t) ->
      l.get_morphism.f_op s t;
      m.put_morphism.f_op (v, get l s) (w, get l t);
      l.put_morphism.f_op (put m v (get l s), s) (put m w (get l t), t));
  };
}

(** A refinement of a PCM (p: pcm a) consists of:
    (1) A set of elements f:(a -> prop) closed under (op p)
    (2) An element new_unit which satisfies the unit laws on the subset f *)
let refine_t (f: 'a -> prop) = x:'a{f x}
noeq type pcm_refinement #a (p: pcm a) = {
  f: a -> prop;
  f_closed_under_op: x: refine_t f -> y: refine_t f{composable p x y} -> Lemma (f (op p x y));
  new_one: refine_t f;
  new_one_is_refined_unit: x: refine_t f -> Lemma (composable p x new_one /\ op p x new_one == x)
}

let pcm_refine_comp (#p: pcm 'a) (r: pcm_refinement p): symrel (refine_t r.f) = composable p

let pcm_refine_op (#p: pcm 'a) (r: pcm_refinement p)
  (x: refine_t r.f) (y: refine_t r.f{composable p x y}): refine_t r.f
= r.f_closed_under_op x y; op p x y

(** Any refinement r for p can be used to construct a refined PCM with the same product
    and composability predicate, but restricted to elements in r.f *)
let refined_pcm (#p: pcm 'a) (r: pcm_refinement p): pcm (refine_t r.f) = {
  p = {composable = pcm_refine_comp r; op = pcm_refine_op r; one = r.new_one};
  comm = (fun x y -> p.comm x y);
  assoc = (fun x y z -> p.assoc x y z);
  assoc_r = (fun x y z -> p.assoc_r x y z);
  is_unit = (fun x -> r.new_one_is_refined_unit x);
  refine = p.refine;
}

let trivial_refinement (p: pcm 'a): pcm_refinement p = {
  f = (fun x -> True);
  f_closed_under_op = (fun _ _ -> ());
  new_one = one p;
  new_one_is_refined_unit = p.is_unit;
}

open FStar.FunctionalExtensionality

noeq type ref (a:Type) (b:Type): Type = {
  p: pcm a;
  re: pcm_refinement p;
  q: pcm b;
  pl: pcm_lens (refined_pcm re) q;
  r: Steel.Memory.ref a p;
}

let pts_to (r: ref 'a 'b) (v: Ghost.erased 'b): Steel.Memory.slprop =
  Steel.Memory.(r.r `pts_to` put r.pl v (one (refined_pcm r.re)))

(** Basic lenses *)

let lens_fst_put (x:'a) (xy: 'a & 'b): 'a & 'b = (x, snd xy)
let lens_fst #a #b : lens (a & b) a = {
  get = fst;
  put = lens_fst_put;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

let pcm_lens_fst #a #b (p: pcm a) (q: pcm b): pcm_lens (tuple_pcm p q) p = {
  l = lens_fst;
  get_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
  put_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
}

(** We can create lenses for unions if we know which case of the union we are in: *)

let either_l a b = x:either a b{Inl? x}
let lens_left_put (y: 'a) (x:either_l 'a 'b): either_l 'a 'b =
  Inl y
let lens_left #a #b : lens (either_l a b) a = {
  get = Inl?.v;
  put = lens_left_put;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

let lens_left_fst #a #b #c: lens (either_l (a & b) c) a = lens_comp lens_left lens_fst
let lens_fst_left #a #b #c: lens ((either_l a b) & c) a = lens_comp lens_fst lens_left

(** A PCM for binary sums *)

let either_composable (p: pcm 'a) (q: pcm 'b): symrel (option (either 'a 'b)) =
  fun x y -> match x, y with
    | None, _ | _, None -> True
    | Some (Inl x), Some (Inl y) -> composable p x y
    | Some (Inr x), Some (Inr y) -> composable q x y
    | _, _ -> False
let either_op (p: pcm 'a) (q: pcm 'b) (x: option (either 'a 'b))
  (y: option (either 'a 'b){either_composable p q x y})
: option (either 'a 'b) = match x, y with
  | None, z | z, None -> z
  | Some (Inl x), Some (Inl y) -> Some (Inl (op p x y))
  | Some (Inr x), Some (Inr y) -> Some (Inr (op q x y))
    
let either_pcm (p: pcm 'a) (q: pcm 'b): pcm (option (either 'a 'b)) = P.({
  p = {composable = either_composable p q; op = either_op p q; one = None};
  comm = (fun x y -> match x, y with
    | None, _ | _, None -> ()
    | Some (Inl x), Some (Inl y) -> p.comm x y
    | Some (Inr x), Some (Inr y) -> q.comm x y);
  assoc = (fun x y z -> match x, y, z with
    | Some (Inl x), Some (Inl y), Some (Inl z) -> p.assoc x y z
    | Some (Inr x), Some (Inr y), Some (Inr z) -> q.assoc x y z
    | _, _, _ -> ());
  assoc_r = (fun x y z -> match x, y, z with
    | Some (Inl x), Some (Inl y), Some (Inl z) -> p.assoc_r x y z
    | Some (Inr x), Some (Inr y), Some (Inr z) -> q.assoc_r x y z
    | _, _, _ -> ());
  is_unit = (fun x -> ());
  refine = (fun x -> match x with
    | None -> True
    | Some (Inl x) -> p.refine x
    | Some (Inr x) -> q.refine x);
})

let inl_refinement (p: pcm 'a) (q: pcm 'b): pcm_refinement (either_pcm p q) = {
  f = (fun (x: option (either 'a 'b)) -> Some? x /\ Inl? (Some?.v x));
  f_closed_under_op = (fun _ _ -> ());
  new_one = Some (Inl #_ #'b (one p));
  new_one_is_refined_unit = (fun (Some (Inl x)) -> p.is_unit x);
}

(** A PCM for possibly uninitialized data *)

(*
type init a =
| Uninitialized : init a
| Initialized : a -> init a

let init_comp (p: pcm 'a): symrel (init 'a) = fun x y -> match x, y with
  | Uninitialized, Uninitialized -> True
  | Uninitialized, Initialized x | Initialized x, Uninitialized -> x == one p
  | Initialized x, Initialized y -> composable p x y

let init_op (p: pcm 'a) (one_dec:(x:'a -> b:bool{b <==> x == one p})) (x: init 'a)
  (y: init 'a{init_comp p x y})
: init 'a
= match x, y with
  | Uninitialized, Uninitialized -> Uninitialized
  | Uninitialized, Initialized x | Initialized x, Uninitialized ->
    let true = one_dec x in Uninitialized
  | Initialized x, Initialized y -> Initialized (op p x y)

let init_pcm (p: pcm 'a) (one_dec:(x:'a -> b:bool{b <==> x == one p})): pcm (init 'a) = P.({
  p = {composable = init_comp p; op = init_op p one_dec; one = Initialized (one p)};
  comm = (fun x y -> match x, y with
    | Initialized x, Initialized y -> p.comm x y
    | _, _ -> ());
  assoc = (fun x y z -> match x, y, z with
    | Initialized x, Initialized y, Initialized z -> p.assoc x y z
    | _, _, _ -> ());
  assoc_r = (fun x y z -> match x, y, z with
    | Initialized x, Initialized y, Initialized z -> p.assoc_r x y z
    | _, _, _ -> ());
  is_unit = (fun _ -> ());
  refine = (fun x -> match x with
    | Initialized x -> p.refine x
    | _ -> True)
})
*)

(** A lens for the k-th field of an n-ary product *)

let lens_field_get (#a:eqtype) f (k:a) (s:restricted_t a f): f k = s k
let lens_field (#a:eqtype) f (k:a): lens (restricted_t a f) (f k) = {
  get = lens_field_get f k;
  put = fun_upd k;
  get_put = (fun s v -> ());
  put_get = (fun s -> ext (fun_upd k (lens_field_get f k s) s) s (fun _ -> ()));
  put_put = (fun s v w -> ext (fun_upd k v (fun_upd k w s)) (fun_upd k v s) (fun _ -> ()));
}

(** lens_field is a pcm_lens *)

(* TODO move to Aggregates.fst *)
let prod_pcm_composable_intro (p:(k:'a -> pcm ('b k))) (x y: restricted_t 'a 'b)
  (h:(k:'a -> Lemma (composable (p k) (x k) (y k))))
: Lemma (composable (prod_pcm p) x y) = FStar.Classical.forall_intro h

let field (#a:eqtype) #f (p:(k:a -> pcm (f k))) (k:a): pcm_lens (prod_pcm p) (p k) = {
  l = lens_field f k;
  get_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
  put_morphism = {
    f_refine = (fun _ -> ());
    f_one = (fun _ ->
      ext
        (fun_upd k (one (p k)) (one (prod_pcm p)))
        (one (prod_pcm p))
        (fun k -> ()));
    f_op = (fun (v, s) (w, t) ->
      prod_pcm_composable_intro p (fun_upd k v s) (fun_upd k w t) (fun _ -> ());
      ext
        (fun_upd k (op (p k) v w) (op (prod_pcm p) s t))
        (op (prod_pcm p) (fun_upd k v s) (fun_upd k w t))
        (fun _ -> ()));
  }
}

(** The refinement of an n-ary union PCM to the k-th case *)

let case_refinement_f (p:(k:'a -> pcm ('b k))) (k:'a): union 'b -> prop =
  fun kx -> match kx with Some (|k', _|) -> k == k' | None -> False

let case_refinement_new_one (p:(k:'a -> pcm ('b k))) (k:'a)
: refine_t (case_refinement_f p k)
= Some (|k, one (p k)|)

let case_refinement (p:(k:'a -> pcm ('b k))) (k:'a): pcm_refinement (union_pcm p) = {
  f = case_refinement_f p k;
  f_closed_under_op = (fun x y -> ());
  new_one = case_refinement_new_one p k;
  new_one_is_refined_unit = (fun (Some (|k', x|)) -> (p k).is_unit x)
}

(** A lens for the k-th case of an n-ary union *)

let lens_case_get (p:(k:'a -> pcm ('b k))) (k:'a): refine_t (case_refinement_f p k) -> 'b k =
  fun (Some (|_, v|)) -> v
let lens_case_put (p:(k:'a -> pcm ('b k))) (k:'a) (v:'b k)
: refine_t (case_refinement_f p k) -> refine_t (case_refinement_f p k)
= fun _ -> Some (|k, v|)
  
let lens_case (p:(k:'a -> pcm ('b k))) (k:'a): lens (refine_t (case_refinement_f p k)) ('b k) = {
  get = lens_case_get p k;
  put = lens_case_put p k;
  get_put = (fun s v -> ());
  put_get = (fun s -> ());
  put_put = (fun s v w -> ());
}

(** lens_case is a pcm_lens *)
let case (p:(k:'a -> pcm ('b k))) (k:'a): pcm_lens (refined_pcm (case_refinement p k)) (p k) = {
  l = lens_case p k;
  get_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
  put_morphism = {f_refine = (fun _ -> ()); f_one = (fun _ -> ()); f_op = (fun _ _ -> ())};
}

(* Basic operations *)

open Steel.Effect
module M = Steel.Memory
module A = Steel.Effect.Atomic

let ref_focus (r: ref 'a 'b) (q: pcm 'c) (l: pcm_lens r.q q): ref 'a 'c =
  {p = r.p; re = r.re; q = q; pl = pcm_lens_comp r.pl l; r = r.r}

let focus (r: ref 'a 'b) (q: pcm 'c) (l: pcm_lens r.q q) (s: Ghost.erased 'b) (x: Ghost.erased 'c)
: Steel (ref 'a 'c)
    (to_vprop (r `pts_to` s))
    (fun r' -> to_vprop (r' `pts_to` x))
    (fun _ -> Ghost.reveal s == put l x (one r.q))
    (fun _ r' _ -> r' == ref_focus r q l)
= let r' = ref_focus r q l in
  A.change_slprop_rel  
    (to_vprop (r `pts_to` s))
    (to_vprop (r' `pts_to` x))
    (fun _ _ -> True)
    (fun m -> r.pl.get_morphism.f_one ());
  A.return r'

let unfocus #inames (r: ref 'a 'c) (r': ref 'a 'b) (q: pcm 'c)
  (l: pcm_lens r'.q q) (x: Ghost.erased 'c)
: A.SteelGhost unit inames
    (to_vprop (r `pts_to` x))
    (fun _ -> to_vprop (r' `pts_to` put l x (one r'.q)))
    (fun _ -> r == ref_focus r' q l)
    (fun _ _ _ -> True)
= A.change_slprop_rel  
    (to_vprop (r `pts_to` x))
    (to_vprop (r' `pts_to` put l x (one r'.q)))
    (fun _ _ -> True)
    (fun m -> r'.pl.get_morphism.f_one ())

let change_equal_vprop #inames (p q: M.slprop)
: A.SteelGhost unit inames (to_vprop p) (fun _ -> to_vprop q) (fun _ -> p == q) (fun _ _ _ -> True)
= A.change_equal_slprop (to_vprop p) (to_vprop q)
// TODO rename

let split (r: ref 'a 'c) (xy x y: Ghost.erased 'c)
: Steel unit
    (to_vprop (r `pts_to` xy))
    (fun _ -> to_vprop (r `pts_to` x) `star` to_vprop (r `pts_to` y))
    (fun _ -> composable r.q x y /\ xy == Ghost.hide (op r.q x y))
    (fun _ _ _ -> True)
= A.change_equal_slprop
    (to_vprop (r `pts_to` xy))
    (to_vprop (r.r `M.pts_to` Ghost.reveal (Ghost.hide (put r.pl xy (one (refined_pcm r.re))))));
  (refined_pcm r.re).is_unit (one (refined_pcm r.re));
  r.pl.put_morphism.f_op
    (Ghost.reveal x, one (refined_pcm r.re))
    (Ghost.reveal y, one (refined_pcm r.re));
  Steel.PCMReference.split r.r
    (put r.pl xy (one (refined_pcm r.re)))
    (put r.pl x (one (refined_pcm r.re)))
    (put r.pl y (one (refined_pcm r.re)));
  change_equal_vprop
    (r.r `M.pts_to` Ghost.reveal (Ghost.hide (put r.pl x (one (refined_pcm r.re)))))
    (r `pts_to` x);
  change_equal_vprop
    (r.r `M.pts_to` Ghost.reveal (Ghost.hide (put r.pl y (one (refined_pcm r.re)))))
    (r `pts_to` y)

let gather (r: ref 'a 'c) (x y: Ghost.erased 'c)
: SteelT (_:unit{composable r.q x y})
    (to_vprop (r `pts_to` x) `star` to_vprop (r `pts_to` y))
    (fun _ -> to_vprop (r `pts_to` op r.q x y))
= change_equal_vprop
    (r `pts_to` x)
    (r.r `M.pts_to` Ghost.reveal (Ghost.hide (put r.pl x (one (refined_pcm r.re)))));
  change_equal_vprop
    (r `pts_to` y)
    (r.r `M.pts_to` Ghost.reveal (Ghost.hide (put r.pl y (one (refined_pcm r.re)))));
  Steel.PCMReference.gather r.r
    (put r.pl x (one (refined_pcm r.re)))
    (put r.pl y (one (refined_pcm r.re)));
  r.pl.get_morphism.f_op
    (put r.pl x (one (refined_pcm r.re)))
    (put r.pl y (one (refined_pcm r.re)));
  (refined_pcm r.re).is_unit (one (refined_pcm r.re));
  r.pl.put_morphism.f_op
    (Ghost.reveal x, one (refined_pcm r.re))
    (Ghost.reveal y, one (refined_pcm r.re));
  change_equal_vprop _ (r `pts_to` op r.q x y)

let peel (r: ref 'a 'b) (q: pcm 'c) (l: pcm_lens r.q q) (x: Ghost.erased 'b)
: SteelT unit
    (to_vprop (r `pts_to` x))
    (fun _ ->
      to_vprop (r `pts_to` put l (one q) x) `star` 
      to_vprop (r `pts_to` put l (get l x) (one r.q)))
= q.is_unit (get l x);
  r.q.is_unit x;
  q.comm (get l x) (one q);
  l.put_morphism.f_op (one q, Ghost.reveal x) (get l (Ghost.reveal x), one r.q);
  split r x (put l (one q) x) (put l (get l x) (one r.q))

let addr_of_lens (r: ref 'a 'b) (q: pcm 'c) (l: pcm_lens r.q q) (x: Ghost.erased 'b)
: SteelT (ref 'a 'c)
    (to_vprop (r `pts_to` x))
    (fun s ->
      to_vprop (r `pts_to` put l (one q) x) `star` 
      to_vprop (s `pts_to` get l x))
= peel r q l x;
  focus r q l (put l (get l x) (one r.q)) (get l x)

(** Refining a pcm_ref  *)

let extend_refinement_f (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q)
  (re: pcm_refinement q): 'a -> prop = re.f `compose` get l

let extend_refinement_f_closed (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q)
  (re: pcm_refinement q) (x: refine_t (extend_refinement_f l re))
  (y: refine_t (extend_refinement_f l re){composable p x y})
: Lemma (extend_refinement_f l re (op p x y))
= l.get_morphism.f_op x y;
  re.f_closed_under_op (get l x) (get l y)

let extend_refinement_new_one (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q)
  (re: pcm_refinement q): refine_t (extend_refinement_f l re)
= put l re.new_one (one p)

let extend_refinement_new_one_is_refined_unit
  (#p: pcm 'a) (#q: pcm 'b) (l: pcm_lens p q)
  (re: pcm_refinement q) (x: refine_t (extend_refinement_f l re))
: Lemma (composable p x (extend_refinement_new_one l re) /\
         op p x (extend_refinement_new_one l re) == x)
= re.new_one_is_refined_unit (get l x);
  p.is_unit x;
  l.put_morphism.f_op (get l x, x) (re.new_one, one p)

let extend_refinement (l: pcm_lens 'p 'q) (re: pcm_refinement 'q) : pcm_refinement 'p = {
  f = extend_refinement_f l re;
  f_closed_under_op = extend_refinement_f_closed l re;
  new_one = extend_refinement_new_one l re;
  new_one_is_refined_unit = extend_refinement_new_one_is_refined_unit l re;
}

let lens_refine_get (l: lens 'a 'b) f
  (s: refine_t (f `compose` l.get)): refine_t f
= l.get s
let lens_refine_put (l: lens 'a 'b) f
  (v: refine_t f) (s: refine_t (f `compose` l.get)): refine_t (f `compose` l.get)
= l.put v s

let lens_refine (l: lens 'a 'b) (f: 'b -> prop)
: lens (refine_t (f `compose` l.get)) (refine_t f) = {
  get = lens_refine_get l f;
  put = lens_refine_put l f;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

let pcm_lens_refine_get_morphism_refine (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_refine
    (refined_pcm (extend_refinement l re))
    (refined_pcm re)
    (lens_refine l.l re.f).get
= l.get_morphism.f_refine

let pcm_lens_refine_get_morphism_one (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_one
    (refined_pcm (extend_refinement l re))
    (refined_pcm re)
    (lens_refine l.l re.f).get
= l.get_morphism.f_one

let pcm_lens_refine_get_morphism_op (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_op
    (refined_pcm (extend_refinement l re))
    (refined_pcm re)
    (lens_refine l.l re.f).get
= l.get_morphism.f_op

let pcm_lens_refine_put_morphism_refine (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_refine
    (tuple_pcm (refined_pcm re) (refined_pcm (extend_refinement l re)))
    (refined_pcm (extend_refinement l re))
    (uncurry (lens_refine l.l re.f).put)
= fun (v, s) -> l.put_morphism.f_refine (v, s)

let pcm_lens_refine_put_morphism_one (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_one
    (tuple_pcm (refined_pcm re) (refined_pcm (extend_refinement l re)))
    (refined_pcm (extend_refinement l re))
    (uncurry (lens_refine l.l re.f).put)
= l.put_morphism.f_one

let pcm_lens_refine_put_morphism_op (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: morphism_op
    (tuple_pcm (refined_pcm re) (refined_pcm (extend_refinement l re)))
    (refined_pcm (extend_refinement l re))
    (uncurry (lens_refine l.l re.f).put)
= fun (v, s) (w, t) -> l.put_morphism.f_op (v, s) (w, t)

let pcm_lens_refine (#p: pcm 'a) (#q: pcm 'b)
  (l: pcm_lens p q) (re: pcm_refinement q)
: pcm_lens (refined_pcm (extend_refinement l re)) (refined_pcm re) = {
  l = lens_refine l.l re.f;
  get_morphism = {
    f_refine = pcm_lens_refine_get_morphism_refine l re;
    f_one = pcm_lens_refine_get_morphism_one l re;
    f_op = pcm_lens_refine_get_morphism_op l re;
  };
  put_morphism = {
    f_refine = pcm_lens_refine_put_morphism_refine l re;
    f_one = pcm_lens_refine_put_morphism_one l re;
    f_op = pcm_lens_refine_put_morphism_op l re;
  };
}

(* TODO is this in stdlib somewhere? *)
let conj (f: 'a -> prop) (g:(x:'a{f x} -> prop)) (x: 'a): prop = f x /\ g x

let conj_refinement_f (#p: pcm 'a)
  (re1: pcm_refinement p) (re2: pcm_refinement (refined_pcm re1))
: 'a -> prop = conj #'a re1.f re2.f

let conj_refinement_f_closed (#p: pcm 'a)
  (re1: pcm_refinement p) (re2: pcm_refinement (refined_pcm re1))
  (x: refine_t (conj_refinement_f re1 re2))
  (y: refine_t (conj_refinement_f re1 re2){composable p x y})
: Lemma (conj_refinement_f re1 re2 (op p x y))
= re1.f_closed_under_op x y;
  re2.f_closed_under_op x y

(* re1.new_one and re2.new_one both work; we go with re2 *)
let conj_refinement_new_one (#p: pcm 'a)
  (re1: pcm_refinement p) (re2: pcm_refinement (refined_pcm re1))
: refine_t (conj_refinement_f re1 re2)
= re2.new_one

let conj_refinement_new_one_is_refined_unit (#p: pcm 'a)
  (re1: pcm_refinement p) (re2: pcm_refinement (refined_pcm re1))
  (x: refine_t (conj_refinement_f re1 re2))
: Lemma (composable p x (conj_refinement_new_one re1 re2) /\
         op p x (conj_refinement_new_one re1 re2) == x)
= re2.new_one_is_refined_unit x

let conj_refinement (#p: pcm 'a)
  (re1: pcm_refinement p) (re2: pcm_refinement (refined_pcm re1))
: pcm_refinement p = {
  f = conj_refinement_f re1 re2;
  f_closed_under_op = conj_refinement_f_closed re1 re2;
  new_one = conj_refinement_new_one re1 re2;
  new_one_is_refined_unit = conj_refinement_new_one_is_refined_unit re1 re2;
}

noeq type iso a b = {
  fwd: a -> b;
  bwd: b -> a;
  fwd_bwd: x:b -> Lemma (fwd (bwd x) == x);
  bwd_fwd: x:a -> Lemma (bwd (fwd x) == x);
}
let fwd_bwd' (i: iso 'a 'b) (x: 'b): Lemma (i.fwd (i.bwd x) == x) [SMTPat (i.fwd (i.bwd x))] = i.fwd_bwd x
let bwd_fwd' (i: iso 'a 'b) (x: 'a): Lemma (i.bwd (i.fwd x) == x) [SMTPat (i.bwd (i.fwd x))] = i.bwd_fwd x

let iso_lens_comp_get (i: iso 'a 'b) (l: lens 'b 'c): 'a -> 'c = l.get `compose` i.fwd
let iso_lens_comp_put (i: iso 'a 'b) (l: lens 'b 'c) (v: 'c) (s: 'a): 'a = i.bwd (l.put v (i.fwd s))
let iso_lens_comp (i: iso 'a 'b) (l: lens 'b 'c): lens 'a 'c = {
  get = iso_lens_comp_get i l;
  put = iso_lens_comp_put i l;
  get_put = (fun _ _ -> ());
  put_get = (fun _ -> ());
  put_put = (fun _ _ _ -> ());
}

noeq type pcm_iso #a #b (p: pcm a) (q: pcm b) = {
  i: iso a b;
  fwd_morphism: pcm_morphism p q i.fwd;
  bwd_morphism: pcm_morphism q p i.bwd;
}

let refine_conj_iso_fwd (f: 'a -> prop) (g:(x:'a{f x} -> prop))
  (x: refine_t (conj f g))
: refine_t g
= x

let refine_conj_iso_bwd (f: 'a -> prop) (g:(x:'a{f x} -> prop))
  (x: refine_t g)
: refine_t (conj f g)
= x

let refine_conj_iso (f: 'a -> prop) (g:(x:'a{f x} -> prop))
: iso (refine_t #'a (conj #'a f g)) (refine_t #(x:'a{f x}) g) = {
  fwd = refine_conj_iso_fwd f g;
  bwd = refine_conj_iso_bwd f g;
  fwd_bwd = (fun _ -> ());
  bwd_fwd = (fun _ -> ());
}

let pcm_refinement_conj_iso_i (p: pcm 'a)
  (re1: pcm_refinement p)
  (re2: pcm_refinement (refined_pcm re1))
: iso (refine_t #'a (conj #'a re1.f re2.f)) (refine_t #(x:'a{re1.f x}) re2.f) =
  refine_conj_iso re1.f re2.f

let pcm_refinement_conj_iso_fwd_morphism_op (p: pcm 'a)
  (re1: pcm_refinement p)
  (re2: pcm_refinement (refined_pcm re1))
: morphism_op
    (refined_pcm re2) (refined_pcm (conj_refinement re1 re2))
    (pcm_refinement_conj_iso_i p re1 re2).fwd
= fun x y -> ()

let pcm_refinement_conj_iso (p: pcm 'a)
  (re1: pcm_refinement p)
  (re2: pcm_refinement (refined_pcm re1))
: pcm_iso (refined_pcm (conj_refinement re1 re2)) (refined_pcm re2) = {
  i = pcm_refinement_conj_iso_i p re1 re2;
  fwd_morphism = {
    f_refine = (fun _ -> ());
    f_one = (fun _ -> ());
    f_op = pcm_refinement_conj_iso_fwd_morphism_op p re1 re2;
  };
  bwd_morphism = {
    f_refine = (fun _ -> ());
    f_one = (fun _ -> ());
    f_op = (fun _ _ -> ());
  };
}

let pcm_iso_lens_comp (#p: pcm 'a) (#q: pcm 'b) (#r: pcm 'c)
  (i: pcm_iso p q) (l: pcm_lens q r)
: pcm_lens p r = {
  l = iso_lens_comp i.i l.l;
  get_morphism = pcm_morphism_comp l.get_morphism i.fwd_morphism;
  put_morphism = {
    f_refine = (fun (v, s) ->
      i.fwd_morphism.f_refine s; 
      l.put_morphism.f_refine (v, i.i.fwd s);
      i.bwd_morphism.f_refine (l.l.put v (i.i.fwd s)));
    f_one = (fun () ->
      i.fwd_morphism.f_one (); 
      l.put_morphism.f_one ();
      i.bwd_morphism.f_one ());
    f_op = (fun (v, s) (w, t) -> 
     i.fwd_morphism.f_op s t;
     l.put_morphism.f_op (v, i.i.fwd s) (w, i.i.fwd t);
     i.bwd_morphism.f_op (l.l.put v (i.i.fwd s)) (l.l.put w (i.i.fwd t)));
  }
}

let ref_refine (r: ref 'a 'b) (new_re: pcm_refinement r.q) : ref 'a (refine_t new_re.f) = {
  p = r.p;
  re = conj_refinement r.re (extend_refinement r.pl new_re);
  q = refined_pcm new_re;
  pl =
    pcm_iso_lens_comp
      (pcm_refinement_conj_iso r.p r.re (extend_refinement r.pl new_re))
      (pcm_lens_refine r.pl new_re);
  r = r.r
}

assume val refine (r: ref 'a 'b) (re: pcm_refinement r.q) (x: Ghost.erased 'b{re.f x})
: Steel (ref 'a (refine_t re.f))
    (to_vprop (r `pts_to` x))
    (fun r' -> to_vprop (r' `pts_to` Ghost.reveal x))
    (fun _ -> True)
    (fun _ r' _ -> r' == ref_refine r re)

let unrefine #inames (r': ref 'a 'b) (re: pcm_refinement r'.q)
  (r: ref 'a (refine_t re.f)) (x: Ghost.erased 'b{re.f x})
: A.SteelGhost unit inames
    (to_vprop (r `pts_to` Ghost.reveal x))
    (fun _ -> to_vprop (r' `pts_to` x))
    (fun _ -> r == ref_refine r' re)
    (fun _ _ _ -> True)
= A.sladmit()
