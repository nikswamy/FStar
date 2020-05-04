(*
   Copyright 2020 Microsoft Research

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*)
#light "off"
(* -------------------------------------------------------------------- *)
module FStar.Extraction.ML.RemoveUnusedParameters
open FStar.ST
open FStar.All
open FStar
open FStar.Ident
open FStar.Util
open FStar.Const
open FStar.BaseTypes
open FStar.Extraction.ML.Syntax

(**
  This module implements a transformation on the FStar.Extraction.ML.Syntax
  AST to remove unused type parameters from type abbreviations.

  This is mainly intended for use with F# code extraction, since the
  F# compiler does not accept type abbreviations with unused
  parameters. However, this transformation may also be useful for use
  with OCaml, since it may lead to nicer code.
*)
module BU = FStar.Util

(**
  The transformation maintains an environment recording which
  arguments of a type definition are to be removed, extending the
  environment at the definition site of each type abbreviation and
  using the environment to determine which arguments should be omitted
  at each use site.

  The environment maps an mlpath, a fully qualified name of a type
  definition, to a list of [Retain | Omit] tags, one for each argument
  of the type definition.
 *)

type argument_tag =
  | Retain
  | Omit

type entry = list<argument_tag>

type env_t = {
  current_module:list<mlsymbol>;
  tydef_map:BU.psmap<entry>;
}

let initial_env : env_t = {
  current_module = [];
  tydef_map = BU.psmap_empty ()
}

let extend_env (env:env_t) (i:mlsymbol) (e:entry) : env_t = {
    env with
    tydef_map = BU.psmap_add env.tydef_map (string_of_mlpath (env.current_module,i)) e
}

let lookup_tyname (env:env_t) (name:mlpath)
  : option<entry>
  = BU.psmap_try_find env.tydef_map (string_of_mlpath name)

(** Free variables of a type: Computed to check which parameters are used *)
type var_set = BU.set<mlident>
let empty_var_set = BU.new_set (fun x y -> String.compare x y)
let rec freevars_of_mlty' (vars:var_set) (t:mlty) =
  match t with
  | MLTY_Var i ->
    BU.set_add i vars
  | MLTY_Fun (t0, _, t1) ->
    freevars_of_mlty' (freevars_of_mlty' vars t0) t1
  | MLTY_Named (tys, _)
  | MLTY_Tuple tys ->
    List.fold_left freevars_of_mlty' vars tys
  | _ -> vars
let freevars_of_mlty = freevars_of_mlty' empty_var_set

(** The main rewriting in on MLTY_Named (args, name),
    which eliminates some of the args in case `name` has
    parameters that are marked as Omit in the environment *)
let rec elim_mlty env mlty =
  match mlty with
  | MLTY_Var _ -> mlty

  | MLTY_Fun (t0, e, t1) ->
    MLTY_Fun(elim_mlty env t0, e, elim_mlty env t1)

  | MLTY_Named (args, name) ->
    let args = List.map (elim_mlty env) args in
    begin
    match lookup_tyname env name with
    | None ->
      MLTY_Named(args, name)
    | Some entry ->
      if List.length entry <> List.length args
      then failwith "Impossible: arity mismatch between definition and use";
      let args =
        List.fold_right2
          (fun arg tag out ->
            match tag with
            | Retain -> arg::out
            | _ -> out)
          args
          entry
          []
      in
      MLTY_Named(args, name)
    end
   | MLTY_Tuple tys -> //arity of tuples do not change
     MLTY_Tuple (List.map (elim_mlty env) tys)
   | MLTY_Top
   | MLTY_Erased -> mlty

(** Note, the arity of expressions do not change.
    So, this just traverses an expression an eliminates
    type arguments in any subterm to e that is an mlty *)
let rec elim_mlexpr' (env:env_t) (e:mlexpr') =
  match e with
  | MLE_Const _
  | MLE_Var _
  | MLE_Name _ -> e
  | MLE_Let (lb, e) -> MLE_Let(elim_letbinding env lb, elim_mlexpr env e)
  | MLE_App(e, es) -> MLE_App(elim_mlexpr env e, List.map (elim_mlexpr env) es)
  | MLE_TApp (e, tys) -> MLE_TApp(e, List.map (elim_mlty env) tys)
  | MLE_Fun(bvs, e) -> MLE_Fun(List.map (fun (x, t) -> x, elim_mlty env t) bvs, elim_mlexpr env e)
  | MLE_Match(e, branches) -> MLE_Match(elim_mlexpr env e, List.map (elim_branch env) branches)
  | MLE_Coerce(e, t0, t1) -> MLE_Coerce(elim_mlexpr env e, elim_mlty env t0, elim_mlty env t1)
  | MLE_CTor(l, es) -> MLE_CTor(l, List.map (elim_mlexpr env) es)
  | MLE_Seq es -> MLE_Seq (List.map (elim_mlexpr env) es)
  | MLE_Tuple es -> MLE_Tuple (List.map (elim_mlexpr env) es)
  | MLE_Record(syms, fields) -> MLE_Record(syms, List.map (fun (s, e) -> s, elim_mlexpr env e) fields)
  | MLE_Proj (e, p) -> MLE_Proj(elim_mlexpr env e, p)
  | MLE_If(e, e1, e2_opt) -> MLE_If(elim_mlexpr env e, elim_mlexpr env e1, BU.map_opt e2_opt (elim_mlexpr env))
  | MLE_Raise(p, es) -> MLE_Raise (p, List.map (elim_mlexpr env) es)
  | MLE_Try(e, branches) -> MLE_Try(elim_mlexpr env e, List.map (elim_branch env) branches)

and elim_letbinding env (flavor, lbs) =
  let elim_one_lb lb =
    let ts = BU.map_opt lb.mllb_tysc (fun (vars, t) -> vars, elim_mlty env t) in
    let expr = elim_mlexpr env lb.mllb_def in
    { lb with
      mllb_tysc = ts;
      mllb_def = expr }
  in
  flavor, List.map elim_one_lb lbs

and elim_branch env (pat, wopt, e) =
  pat, BU.map_opt wopt (elim_mlexpr env), elim_mlexpr env e

and elim_mlexpr (env:env_t) (e:mlexpr) =
  { e with expr = elim_mlexpr' env e.expr; mlty = elim_mlty env e.mlty }

(** This is the main function that actually extends the environment:
    When encountering a type definition (MLTD_Abbrev), it
    computes the variables that are used and marks the unused ones as Omit
    in the environment and removes them from the definition here *)
let elim_one_mltydecl (env:env_t) (td:one_mltydecl)
  : env_t
  * one_mltydecl
  = let _assumed, name, _ignored, parameters, _metadata, body = td in
    let elim_td td =
      match td with
      | MLTD_Abbrev mlty ->
        let mlty = elim_mlty env mlty in
        let freevars = freevars_of_mlty mlty in
        let parameters, entry =
          List.fold_right
              (fun p (params, entry) ->
                if BU.set_mem p freevars
                then p::params, Retain::entry
                else params, Omit::entry)
                parameters
              ([], [])
        in
        extend_env env name entry,
        parameters,
        MLTD_Abbrev mlty

      | MLTD_Record fields ->
        env,
        parameters,
        MLTD_Record (List.map (fun (name, ty) -> name, elim_mlty env ty) fields)

      | MLTD_DType inductive ->
        env,
        parameters,
        MLTD_DType (
          List.map
            (fun (i, constrs) ->
                i, List.map (fun (constr, ty) -> constr, elim_mlty env ty) constrs)
            inductive
        )
    in
    let env, parameters, body =
      match body with
      | None ->
        env, parameters, body
      | Some td ->
        let env, parameters, td = elim_td td in
        env, parameters, Some td
    in
    env,
    (_assumed, name, _ignored, parameters, _metadata, body)

let elim_module env m =
  let elim_module1 env m =
    match m with
    | MLM_Ty td ->
      let env, td = BU.fold_map elim_one_mltydecl env td in
      env, MLM_Ty td
    | MLM_Let lb ->
      env, MLM_Let (elim_letbinding env lb)
    | MLM_Exn (name, sym_tys) ->
      env, MLM_Exn (name, List.map (fun (s, t) -> s, elim_mlty env t) sym_tys)
    | MLM_Top e ->
      env, MLM_Top (elim_mlexpr env e)
    | _ ->
      env, m
  in
  BU.fold_map elim_module1 env m

let elim_mllib (env:env_t) (m:mllib) =
  let (MLLib libs) = m in
  let elim_one_lib env lib =
    let name, sig_mod, _libs = lib in
    let env = {env with current_module = fst name @ [snd name]} in
    let sig_mod, env =
        match sig_mod with
        | Some (sig_, mod_)  ->
          //intentionally discard the environment from the module translation
          let env, mod_ = elim_module env mod_ in
          // The sig is currently empty
          Some (sig_, mod_), env
        | None ->
          None, env
    in
    env, (name, sig_mod, _libs)
  in
  let env, libs =
    BU.fold_map elim_one_lib env libs
  in
  env, MLLib libs

let elim_mllibs (l:list<mllib>) : list<mllib> =
  snd (BU.fold_map elim_mllib initial_env l)
