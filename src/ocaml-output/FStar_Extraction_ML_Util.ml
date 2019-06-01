
open Prims
open FStar_Pervasives

let codegen_fsharp : unit  ->  Prims.bool = (fun uu____5 -> (

let uu____6 = (FStar_Options.codegen ())
in (Prims.op_Equality uu____6 (FStar_Pervasives_Native.Some (FStar_Options.FSharp)))))


let pruneNones : 'a . 'a FStar_Pervasives_Native.option Prims.list  ->  'a Prims.list = (fun l -> (FStar_List.fold_right (fun x ll -> (match (x) with
| FStar_Pervasives_Native.Some (xs) -> begin
(xs)::ll
end
| FStar_Pervasives_Native.None -> begin
ll
end)) l []))


let mk_range_mle : FStar_Extraction_ML_Syntax.mlexpr = (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) (FStar_Extraction_ML_Syntax.MLE_Name (((("Prims")::[]), ("mk_range")))))


let dummy_range_mle : FStar_Extraction_ML_Syntax.mlexpr = (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) (FStar_Extraction_ML_Syntax.MLE_Name (((("FStar")::("Range")::[]), ("dummyRange")))))


let mlconst_of_const' : FStar_Const.sconst  ->  FStar_Extraction_ML_Syntax.mlconstant = (fun sctt -> (match (sctt) with
| FStar_Const.Const_effect -> begin
(failwith "Unsupported constant")
end
| FStar_Const.Const_range (uu____75) -> begin
FStar_Extraction_ML_Syntax.MLC_Unit
end
| FStar_Const.Const_unit -> begin
FStar_Extraction_ML_Syntax.MLC_Unit
end
| FStar_Const.Const_char (c) -> begin
FStar_Extraction_ML_Syntax.MLC_Char (c)
end
| FStar_Const.Const_int (s, i) -> begin
FStar_Extraction_ML_Syntax.MLC_Int (((s), (i)))
end
| FStar_Const.Const_bool (b) -> begin
FStar_Extraction_ML_Syntax.MLC_Bool (b)
end
| FStar_Const.Const_float (d) -> begin
FStar_Extraction_ML_Syntax.MLC_Float (d)
end
| FStar_Const.Const_bytearray (bytes, uu____105) -> begin
FStar_Extraction_ML_Syntax.MLC_Bytes (bytes)
end
| FStar_Const.Const_string (s, uu____111) -> begin
FStar_Extraction_ML_Syntax.MLC_String (s)
end
| FStar_Const.Const_range_of -> begin
(failwith "Unhandled constant: range_of/set_range_of")
end
| FStar_Const.Const_set_range_of -> begin
(failwith "Unhandled constant: range_of/set_range_of")
end
| FStar_Const.Const_real (uu____116) -> begin
(failwith "Unhandled constant: real/reify/reflect")
end
| FStar_Const.Const_reify -> begin
(failwith "Unhandled constant: real/reify/reflect")
end
| FStar_Const.Const_reflect (uu____120) -> begin
(failwith "Unhandled constant: real/reify/reflect")
end))


let mlconst_of_const : FStar_Range.range  ->  FStar_Const.sconst  ->  FStar_Extraction_ML_Syntax.mlconstant = (fun p c -> (FStar_All.try_with (fun uu___51_134 -> (match (()) with
| () -> begin
(mlconst_of_const' c)
end)) (fun uu___50_137 -> (

let uu____138 = (

let uu____140 = (FStar_Range.string_of_range p)
in (

let uu____142 = (FStar_Syntax_Print.const_to_string c)
in (FStar_Util.format2 "(%s) Failed to translate constant %s " uu____140 uu____142)))
in (failwith uu____138)))))


let mlexpr_of_range : FStar_Range.range  ->  FStar_Extraction_ML_Syntax.mlexpr' = (fun r -> (

let cint = (fun i -> (

let uu____159 = (

let uu____160 = (

let uu____161 = (

let uu____173 = (FStar_Util.string_of_int i)
in ((uu____173), (FStar_Pervasives_Native.None)))
in FStar_Extraction_ML_Syntax.MLC_Int (uu____161))
in (FStar_All.pipe_right uu____160 (fun _186 -> FStar_Extraction_ML_Syntax.MLE_Const (_186))))
in (FStar_All.pipe_right uu____159 (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.ml_int_ty))))
in (

let cstr = (fun s -> (

let uu____195 = (FStar_All.pipe_right (FStar_Extraction_ML_Syntax.MLC_String (s)) (fun _196 -> FStar_Extraction_ML_Syntax.MLE_Const (_196)))
in (FStar_All.pipe_right uu____195 (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.ml_string_ty))))
in (

let uu____197 = (

let uu____204 = (

let uu____207 = (

let uu____208 = (FStar_Range.file_of_range r)
in (FStar_All.pipe_right uu____208 cstr))
in (

let uu____211 = (

let uu____214 = (

let uu____215 = (

let uu____217 = (FStar_Range.start_of_range r)
in (FStar_All.pipe_right uu____217 FStar_Range.line_of_pos))
in (FStar_All.pipe_right uu____215 cint))
in (

let uu____220 = (

let uu____223 = (

let uu____224 = (

let uu____226 = (FStar_Range.start_of_range r)
in (FStar_All.pipe_right uu____226 FStar_Range.col_of_pos))
in (FStar_All.pipe_right uu____224 cint))
in (

let uu____229 = (

let uu____232 = (

let uu____233 = (

let uu____235 = (FStar_Range.end_of_range r)
in (FStar_All.pipe_right uu____235 FStar_Range.line_of_pos))
in (FStar_All.pipe_right uu____233 cint))
in (

let uu____238 = (

let uu____241 = (

let uu____242 = (

let uu____244 = (FStar_Range.end_of_range r)
in (FStar_All.pipe_right uu____244 FStar_Range.col_of_pos))
in (FStar_All.pipe_right uu____242 cint))
in (uu____241)::[])
in (uu____232)::uu____238))
in (uu____223)::uu____229))
in (uu____214)::uu____220))
in (uu____207)::uu____211))
in ((mk_range_mle), (uu____204)))
in FStar_Extraction_ML_Syntax.MLE_App (uu____197)))))


let mlexpr_of_const : FStar_Range.range  ->  FStar_Const.sconst  ->  FStar_Extraction_ML_Syntax.mlexpr' = (fun p c -> (match (c) with
| FStar_Const.Const_range (r) -> begin
(mlexpr_of_range r)
end
| uu____261 -> begin
(

let uu____262 = (mlconst_of_const p c)
in FStar_Extraction_ML_Syntax.MLE_Const (uu____262))
end))


let rec subst_aux : (FStar_Extraction_ML_Syntax.mlident * FStar_Extraction_ML_Syntax.mlty) Prims.list  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty = (fun subst1 t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Var (x) -> begin
(

let uu____290 = (FStar_Util.find_opt (fun uu____306 -> (match (uu____306) with
| (y, uu____314) -> begin
(Prims.op_Equality y x)
end)) subst1)
in (match (uu____290) with
| FStar_Pervasives_Native.Some (ts) -> begin
(FStar_Pervasives_Native.snd ts)
end
| FStar_Pervasives_Native.None -> begin
t
end))
end
| FStar_Extraction_ML_Syntax.MLTY_Fun (t1, f, t2) -> begin
(

let uu____338 = (

let uu____345 = (subst_aux subst1 t1)
in (

let uu____346 = (subst_aux subst1 t2)
in ((uu____345), (f), (uu____346))))
in FStar_Extraction_ML_Syntax.MLTY_Fun (uu____338))
end
| FStar_Extraction_ML_Syntax.MLTY_Named (args, path) -> begin
(

let uu____353 = (

let uu____360 = (FStar_List.map (subst_aux subst1) args)
in ((uu____360), (path)))
in FStar_Extraction_ML_Syntax.MLTY_Named (uu____353))
end
| FStar_Extraction_ML_Syntax.MLTY_Tuple (ts) -> begin
(

let uu____368 = (FStar_List.map (subst_aux subst1) ts)
in FStar_Extraction_ML_Syntax.MLTY_Tuple (uu____368))
end
| FStar_Extraction_ML_Syntax.MLTY_Top -> begin
t
end
| FStar_Extraction_ML_Syntax.MLTY_Erased -> begin
t
end))


let try_subst : FStar_Extraction_ML_Syntax.mltyscheme  ->  FStar_Extraction_ML_Syntax.mlty Prims.list  ->  FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option = (fun uu____384 args -> (match (uu____384) with
| (formals, t) -> begin
(match ((Prims.op_disEquality (FStar_List.length formals) (FStar_List.length args))) with
| true -> begin
FStar_Pervasives_Native.None
end
| uu____396 -> begin
(

let uu____398 = (

let uu____399 = (FStar_List.zip formals args)
in (subst_aux uu____399 t))
in FStar_Pervasives_Native.Some (uu____398))
end)
end))


let subst : (FStar_Extraction_ML_Syntax.mlidents * FStar_Extraction_ML_Syntax.mlty)  ->  FStar_Extraction_ML_Syntax.mlty Prims.list  ->  FStar_Extraction_ML_Syntax.mlty = (fun ts args -> (

let uu____431 = (try_subst ts args)
in (match (uu____431) with
| FStar_Pervasives_Native.None -> begin
(failwith "Substitution must be fully applied (see GitHub issue #490)")
end
| FStar_Pervasives_Native.Some (t) -> begin
t
end)))


let udelta_unfold : FStar_Extraction_ML_UEnv.uenv  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option = (fun g uu___0_448 -> (match (uu___0_448) with
| FStar_Extraction_ML_Syntax.MLTY_Named (args, n1) -> begin
(

let uu____457 = (FStar_Extraction_ML_UEnv.lookup_ty_const g n1)
in (match (uu____457) with
| FStar_Pervasives_Native.Some (ts) -> begin
(

let uu____463 = (try_subst ts args)
in (match (uu____463) with
| FStar_Pervasives_Native.None -> begin
(

let uu____468 = (

let uu____470 = (FStar_Extraction_ML_Syntax.string_of_mlpath n1)
in (

let uu____472 = (FStar_Util.string_of_int (FStar_List.length args))
in (

let uu____474 = (FStar_Util.string_of_int (FStar_List.length (FStar_Pervasives_Native.fst ts)))
in (FStar_Util.format3 "Substitution must be fully applied; got an application of %s with %s args whereas %s were expected (see GitHub issue #490)" uu____470 uu____472 uu____474))))
in (failwith uu____468))
end
| FStar_Pervasives_Native.Some (r) -> begin
FStar_Pervasives_Native.Some (r)
end))
end
| uu____481 -> begin
FStar_Pervasives_Native.None
end))
end
| uu____484 -> begin
FStar_Pervasives_Native.None
end))


let eff_leq : FStar_Extraction_ML_Syntax.e_tag  ->  FStar_Extraction_ML_Syntax.e_tag  ->  Prims.bool = (fun f f' -> (match (((f), (f'))) with
| (FStar_Extraction_ML_Syntax.E_PURE, uu____498) -> begin
true
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
true
end
| (FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_IMPURE) -> begin
true
end
| uu____502 -> begin
false
end))


let eff_to_string : FStar_Extraction_ML_Syntax.e_tag  ->  Prims.string = (fun uu___1_514 -> (match (uu___1_514) with
| FStar_Extraction_ML_Syntax.E_PURE -> begin
"Pure"
end
| FStar_Extraction_ML_Syntax.E_GHOST -> begin
"Ghost"
end
| FStar_Extraction_ML_Syntax.E_IMPURE -> begin
"Impure"
end))


let join : FStar_Range.range  ->  FStar_Extraction_ML_Syntax.e_tag  ->  FStar_Extraction_ML_Syntax.e_tag  ->  FStar_Extraction_ML_Syntax.e_tag = (fun r f f' -> (match (((f), (f'))) with
| (FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_PURE) -> begin
FStar_Extraction_ML_Syntax.E_IMPURE
end
| (FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_IMPURE) -> begin
FStar_Extraction_ML_Syntax.E_IMPURE
end
| (FStar_Extraction_ML_Syntax.E_IMPURE, FStar_Extraction_ML_Syntax.E_IMPURE) -> begin
FStar_Extraction_ML_Syntax.E_IMPURE
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_GHOST) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_GHOST, FStar_Extraction_ML_Syntax.E_PURE) -> begin
FStar_Extraction_ML_Syntax.E_GHOST
end
| (FStar_Extraction_ML_Syntax.E_PURE, FStar_Extraction_ML_Syntax.E_PURE) -> begin
FStar_Extraction_ML_Syntax.E_PURE
end
| uu____535 -> begin
(

let uu____540 = (

let uu____542 = (FStar_Range.string_of_range r)
in (

let uu____544 = (eff_to_string f)
in (

let uu____546 = (eff_to_string f')
in (FStar_Util.format3 "Impossible (%s): Inconsistent effects %s and %s" uu____542 uu____544 uu____546))))
in (failwith uu____540))
end))


let join_l : FStar_Range.range  ->  FStar_Extraction_ML_Syntax.e_tag Prims.list  ->  FStar_Extraction_ML_Syntax.e_tag = (fun r fs -> (FStar_List.fold_left (join r) FStar_Extraction_ML_Syntax.E_PURE fs))


let mk_ty_fun : (FStar_Extraction_ML_Syntax.mlident * FStar_Extraction_ML_Syntax.mlty) Prims.list  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty = (FStar_List.fold_right (fun uu____589 t -> (match (uu____589) with
| (uu____596, t0) -> begin
FStar_Extraction_ML_Syntax.MLTY_Fun (((t0), (FStar_Extraction_ML_Syntax.E_PURE), (t)))
end)))


type unfold_t =
FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty FStar_Pervasives_Native.option


let rec type_leq_c : unfold_t  ->  FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty  ->  (Prims.bool * FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option) = (fun unfold_ty e t t' -> (match (((t), (t'))) with
| (FStar_Extraction_ML_Syntax.MLTY_Var (x), FStar_Extraction_ML_Syntax.MLTY_Var (y)) -> begin
(match ((Prims.op_Equality x y)) with
| true -> begin
((true), (e))
end
| uu____677 -> begin
((false), (FStar_Pervasives_Native.None))
end)
end
| (FStar_Extraction_ML_Syntax.MLTY_Fun (t1, f, t2), FStar_Extraction_ML_Syntax.MLTY_Fun (t1', f', t2')) -> begin
(

let mk_fun = (fun xs body -> (match (xs) with
| [] -> begin
body
end
| uu____719 -> begin
(

let e1 = (match (body.FStar_Extraction_ML_Syntax.expr) with
| FStar_Extraction_ML_Syntax.MLE_Fun (ys, body1) -> begin
FStar_Extraction_ML_Syntax.MLE_Fun ((((FStar_List.append xs ys)), (body1)))
end
| uu____756 -> begin
FStar_Extraction_ML_Syntax.MLE_Fun (((xs), (body)))
end)
in (

let uu____764 = (mk_ty_fun xs body.FStar_Extraction_ML_Syntax.mlty)
in (FStar_Extraction_ML_Syntax.with_ty uu____764 e1)))
end))
in (match (e) with
| FStar_Pervasives_Native.Some ({FStar_Extraction_ML_Syntax.expr = FStar_Extraction_ML_Syntax.MLE_Fun ((x)::xs, body); FStar_Extraction_ML_Syntax.mlty = uu____775; FStar_Extraction_ML_Syntax.loc = uu____776}) -> begin
(

let uu____801 = ((type_leq unfold_ty t1' t1) && (eff_leq f f'))
in (match (uu____801) with
| true -> begin
(match (((Prims.op_Equality f FStar_Extraction_ML_Syntax.E_PURE) && (Prims.op_Equality f' FStar_Extraction_ML_Syntax.E_GHOST))) with
| true -> begin
(

let uu____819 = (type_leq unfold_ty t2 t2')
in (match (uu____819) with
| true -> begin
(

let body1 = (

let uu____830 = (type_leq unfold_ty t2 FStar_Extraction_ML_Syntax.ml_unit_ty)
in (match (uu____830) with
| true -> begin
FStar_Extraction_ML_Syntax.ml_unit
end
| uu____833 -> begin
(FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty t2') (FStar_Extraction_ML_Syntax.MLE_Coerce (((FStar_Extraction_ML_Syntax.ml_unit), (FStar_Extraction_ML_Syntax.ml_unit_ty), (t2')))))
end))
in (

let uu____835 = (

let uu____838 = (

let uu____839 = (

let uu____844 = (mk_ty_fun ((x)::[]) body1.FStar_Extraction_ML_Syntax.mlty)
in (FStar_Extraction_ML_Syntax.with_ty uu____844))
in (FStar_All.pipe_left uu____839 (FStar_Extraction_ML_Syntax.MLE_Fun ((((x)::[]), (body1))))))
in FStar_Pervasives_Native.Some (uu____838))
in ((true), (uu____835))))
end
| uu____876 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| uu____882 -> begin
(

let uu____884 = (

let uu____892 = (

let uu____895 = (mk_fun xs body)
in (FStar_All.pipe_left (fun _898 -> FStar_Pervasives_Native.Some (_898)) uu____895))
in (type_leq_c unfold_ty uu____892 t2 t2'))
in (match (uu____884) with
| (ok, body1) -> begin
(

let res = (match (body1) with
| FStar_Pervasives_Native.Some (body2) -> begin
(

let uu____920 = (mk_fun ((x)::[]) body2)
in FStar_Pervasives_Native.Some (uu____920))
end
| uu____931 -> begin
FStar_Pervasives_Native.None
end)
in ((ok), (res)))
end))
end)
end
| uu____937 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| uu____943 -> begin
(

let uu____946 = (((type_leq unfold_ty t1' t1) && (eff_leq f f')) && (type_leq unfold_ty t2 t2'))
in (match (uu____946) with
| true -> begin
((true), (e))
end
| uu____960 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end))
end
| (FStar_Extraction_ML_Syntax.MLTY_Named (args, path), FStar_Extraction_ML_Syntax.MLTY_Named (args', path')) -> begin
(match ((Prims.op_Equality path path')) with
| true -> begin
(

let uu____986 = (FStar_List.forall2 (type_leq unfold_ty) args args')
in (match (uu____986) with
| true -> begin
((true), (e))
end
| uu____1000 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| uu____1006 -> begin
(

let uu____1008 = (unfold_ty t)
in (match (uu____1008) with
| FStar_Pervasives_Native.Some (t1) -> begin
(type_leq_c unfold_ty e t1 t')
end
| FStar_Pervasives_Native.None -> begin
(

let uu____1019 = (unfold_ty t')
in (match (uu____1019) with
| FStar_Pervasives_Native.None -> begin
((false), (FStar_Pervasives_Native.None))
end
| FStar_Pervasives_Native.Some (t'1) -> begin
(type_leq_c unfold_ty e t t'1)
end))
end))
end)
end
| (FStar_Extraction_ML_Syntax.MLTY_Tuple (ts), FStar_Extraction_ML_Syntax.MLTY_Tuple (ts')) -> begin
(

let uu____1040 = (FStar_List.forall2 (type_leq unfold_ty) ts ts')
in (match (uu____1040) with
| true -> begin
((true), (e))
end
| uu____1054 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| (FStar_Extraction_ML_Syntax.MLTY_Top, FStar_Extraction_ML_Syntax.MLTY_Top) -> begin
((true), (e))
end
| (FStar_Extraction_ML_Syntax.MLTY_Named (uu____1064), uu____1065) -> begin
(

let uu____1072 = (unfold_ty t)
in (match (uu____1072) with
| FStar_Pervasives_Native.Some (t1) -> begin
(type_leq_c unfold_ty e t1 t')
end
| uu____1083 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| (uu____1090, FStar_Extraction_ML_Syntax.MLTY_Named (uu____1091)) -> begin
(

let uu____1098 = (unfold_ty t')
in (match (uu____1098) with
| FStar_Pervasives_Native.Some (t'1) -> begin
(type_leq_c unfold_ty e t t'1)
end
| uu____1109 -> begin
((false), (FStar_Pervasives_Native.None))
end))
end
| (FStar_Extraction_ML_Syntax.MLTY_Erased, FStar_Extraction_ML_Syntax.MLTY_Erased) -> begin
((true), (e))
end
| uu____1120 -> begin
((false), (FStar_Pervasives_Native.None))
end))
and type_leq : unfold_t  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty  ->  Prims.bool = (fun g t1 t2 -> (

let uu____1134 = (type_leq_c g FStar_Pervasives_Native.None t1 t2)
in (FStar_All.pipe_right uu____1134 FStar_Pervasives_Native.fst)))


let rec erase_effect_annotations : FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty = (fun t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (t1, f, t2) -> begin
(

let uu____1162 = (

let uu____1169 = (erase_effect_annotations t1)
in (

let uu____1170 = (erase_effect_annotations t2)
in ((uu____1169), (FStar_Extraction_ML_Syntax.E_PURE), (uu____1170))))
in FStar_Extraction_ML_Syntax.MLTY_Fun (uu____1162))
end
| uu____1171 -> begin
t
end))


let is_type_abstraction : 'a 'b 'c . (('a, 'b) FStar_Util.either * 'c) Prims.list  ->  Prims.bool = (fun uu___2_1199 -> (match (uu___2_1199) with
| ((FStar_Util.Inl (uu____1211), uu____1212))::uu____1213 -> begin
true
end
| uu____1237 -> begin
false
end))


let is_xtuple : (Prims.string Prims.list * Prims.string)  ->  Prims.int FStar_Pervasives_Native.option = (fun uu____1265 -> (match (uu____1265) with
| (ns, n1) -> begin
(

let uu____1287 = (

let uu____1289 = (FStar_Util.concat_l "." (FStar_List.append ns ((n1)::[])))
in (FStar_Parser_Const.is_tuple_datacon_string uu____1289))
in (match (uu____1287) with
| true -> begin
(

let uu____1299 = (

let uu____1301 = (FStar_Util.char_at n1 (Prims.parse_int "7"))
in (FStar_Util.int_of_char uu____1301))
in FStar_Pervasives_Native.Some (uu____1299))
end
| uu____1305 -> begin
FStar_Pervasives_Native.None
end))
end))


let resugar_exp : FStar_Extraction_ML_Syntax.mlexpr  ->  FStar_Extraction_ML_Syntax.mlexpr = (fun e -> (match (e.FStar_Extraction_ML_Syntax.expr) with
| FStar_Extraction_ML_Syntax.MLE_CTor (mlp, args) -> begin
(

let uu____1320 = (is_xtuple mlp)
in (match (uu____1320) with
| FStar_Pervasives_Native.Some (n1) -> begin
(FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty e.FStar_Extraction_ML_Syntax.mlty) (FStar_Extraction_ML_Syntax.MLE_Tuple (args)))
end
| uu____1327 -> begin
e
end))
end
| uu____1331 -> begin
e
end))


let record_field_path : FStar_Ident.lident Prims.list  ->  Prims.string Prims.list = (fun uu___3_1342 -> (match (uu___3_1342) with
| (f)::uu____1349 -> begin
(

let uu____1352 = (FStar_Util.prefix f.FStar_Ident.ns)
in (match (uu____1352) with
| (ns, uu____1363) -> begin
(FStar_All.pipe_right ns (FStar_List.map (fun id1 -> id1.FStar_Ident.idText)))
end))
end
| uu____1376 -> begin
(failwith "impos")
end))


let record_fields : 'a . FStar_Ident.lident Prims.list  ->  'a Prims.list  ->  (Prims.string * 'a) Prims.list = (fun fs vs -> (FStar_List.map2 (fun f e -> ((f.FStar_Ident.ident.FStar_Ident.idText), (e))) fs vs))


let is_xtuple_ty : (Prims.string Prims.list * Prims.string)  ->  Prims.int FStar_Pervasives_Native.option = (fun uu____1442 -> (match (uu____1442) with
| (ns, n1) -> begin
(

let uu____1464 = (

let uu____1466 = (FStar_Util.concat_l "." (FStar_List.append ns ((n1)::[])))
in (FStar_Parser_Const.is_tuple_constructor_string uu____1466))
in (match (uu____1464) with
| true -> begin
(

let uu____1476 = (

let uu____1478 = (FStar_Util.char_at n1 (Prims.parse_int "5"))
in (FStar_Util.int_of_char uu____1478))
in FStar_Pervasives_Native.Some (uu____1476))
end
| uu____1482 -> begin
FStar_Pervasives_Native.None
end))
end))


let resugar_mlty : FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty = (fun t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Named (args, mlp) -> begin
(

let uu____1497 = (is_xtuple_ty mlp)
in (match (uu____1497) with
| FStar_Pervasives_Native.Some (n1) -> begin
FStar_Extraction_ML_Syntax.MLTY_Tuple (args)
end
| uu____1504 -> begin
t
end))
end
| uu____1508 -> begin
t
end))


let flatten_ns : Prims.string Prims.list  ->  Prims.string = (fun ns -> (

let uu____1522 = (codegen_fsharp ())
in (match (uu____1522) with
| true -> begin
(FStar_String.concat "." ns)
end
| uu____1527 -> begin
(FStar_String.concat "_" ns)
end)))


let flatten_mlpath : (Prims.string Prims.list * Prims.string)  ->  Prims.string = (fun uu____1544 -> (match (uu____1544) with
| (ns, n1) -> begin
(

let uu____1564 = (codegen_fsharp ())
in (match (uu____1564) with
| true -> begin
(FStar_String.concat "." (FStar_List.append ns ((n1)::[])))
end
| uu____1572 -> begin
(FStar_String.concat "_" (FStar_List.append ns ((n1)::[])))
end))
end))


let mlpath_of_lid : FStar_Ident.lident  ->  (Prims.string Prims.list * Prims.string) = (fun l -> (

let uu____1592 = (FStar_All.pipe_right l.FStar_Ident.ns (FStar_List.map (fun i -> i.FStar_Ident.idText)))
in ((uu____1592), (l.FStar_Ident.ident.FStar_Ident.idText))))


let rec erasableType : unfold_t  ->  FStar_Extraction_ML_Syntax.mlty  ->  Prims.bool = (fun unfold_ty t -> (

let uu____1623 = (FStar_Extraction_ML_UEnv.erasableTypeNoDelta t)
in (match (uu____1623) with
| true -> begin
true
end
| uu____1628 -> begin
(

let uu____1630 = (unfold_ty t)
in (match (uu____1630) with
| FStar_Pervasives_Native.Some (t1) -> begin
(erasableType unfold_ty t1)
end
| FStar_Pervasives_Native.None -> begin
false
end))
end)))


let rec eraseTypeDeep : unfold_t  ->  FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty = (fun unfold_ty t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (tyd, etag, tycd) -> begin
(match ((Prims.op_Equality etag FStar_Extraction_ML_Syntax.E_PURE)) with
| true -> begin
(

let uu____1653 = (

let uu____1660 = (eraseTypeDeep unfold_ty tyd)
in (

let uu____1661 = (eraseTypeDeep unfold_ty tycd)
in ((uu____1660), (etag), (uu____1661))))
in FStar_Extraction_ML_Syntax.MLTY_Fun (uu____1653))
end
| uu____1662 -> begin
t
end)
end
| FStar_Extraction_ML_Syntax.MLTY_Named (lty, mlp) -> begin
(

let uu____1670 = (erasableType unfold_ty t)
in (match (uu____1670) with
| true -> begin
FStar_Extraction_ML_UEnv.erasedContent
end
| uu____1673 -> begin
(

let uu____1675 = (

let uu____1682 = (FStar_List.map (eraseTypeDeep unfold_ty) lty)
in ((uu____1682), (mlp)))
in FStar_Extraction_ML_Syntax.MLTY_Named (uu____1675))
end))
end
| FStar_Extraction_ML_Syntax.MLTY_Tuple (lty) -> begin
(

let uu____1690 = (FStar_List.map (eraseTypeDeep unfold_ty) lty)
in FStar_Extraction_ML_Syntax.MLTY_Tuple (uu____1690))
end
| uu____1693 -> begin
t
end))


let prims_op_equality : FStar_Extraction_ML_Syntax.mlexpr = (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) (FStar_Extraction_ML_Syntax.MLE_Name (((("Prims")::[]), ("op_Equality")))))


let prims_op_amp_amp : FStar_Extraction_ML_Syntax.mlexpr = (

let uu____1704 = (

let uu____1709 = (mk_ty_fun (((("x"), (FStar_Extraction_ML_Syntax.ml_bool_ty)))::((("y"), (FStar_Extraction_ML_Syntax.ml_bool_ty)))::[]) FStar_Extraction_ML_Syntax.ml_bool_ty)
in (FStar_Extraction_ML_Syntax.with_ty uu____1709))
in (FStar_All.pipe_left uu____1704 (FStar_Extraction_ML_Syntax.MLE_Name (((("Prims")::[]), ("op_AmpAmp"))))))


let conjoin : FStar_Extraction_ML_Syntax.mlexpr  ->  FStar_Extraction_ML_Syntax.mlexpr  ->  FStar_Extraction_ML_Syntax.mlexpr = (fun e1 e2 -> (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.ml_bool_ty) (FStar_Extraction_ML_Syntax.MLE_App (((prims_op_amp_amp), ((e1)::(e2)::[]))))))


let conjoin_opt : FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option  ->  FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option  ->  FStar_Extraction_ML_Syntax.mlexpr FStar_Pervasives_Native.option = (fun e1 e2 -> (match (((e1), (e2))) with
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None) -> begin
FStar_Pervasives_Native.None
end
| (FStar_Pervasives_Native.Some (x), FStar_Pervasives_Native.None) -> begin
FStar_Pervasives_Native.Some (x)
end
| (FStar_Pervasives_Native.None, FStar_Pervasives_Native.Some (x)) -> begin
FStar_Pervasives_Native.Some (x)
end
| (FStar_Pervasives_Native.Some (x), FStar_Pervasives_Native.Some (y)) -> begin
(

let uu____1797 = (conjoin x y)
in FStar_Pervasives_Native.Some (uu____1797))
end))


let mlloc_of_range : FStar_Range.range  ->  (Prims.int * Prims.string) = (fun r -> (

let pos = (FStar_Range.start_of_range r)
in (

let line = (FStar_Range.line_of_pos pos)
in (

let uu____1813 = (FStar_Range.file_of_range r)
in ((line), (uu____1813))))))


let rec doms_and_cod : FStar_Extraction_ML_Syntax.mlty  ->  (FStar_Extraction_ML_Syntax.mlty Prims.list * FStar_Extraction_ML_Syntax.mlty) = (fun t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (a, uu____1836, b) -> begin
(

let uu____1838 = (doms_and_cod b)
in (match (uu____1838) with
| (ds, c) -> begin
(((a)::ds), (c))
end))
end
| uu____1859 -> begin
(([]), (t))
end))


let argTypes : FStar_Extraction_ML_Syntax.mlty  ->  FStar_Extraction_ML_Syntax.mlty Prims.list = (fun t -> (

let uu____1872 = (doms_and_cod t)
in (FStar_Pervasives_Native.fst uu____1872)))


let rec uncurry_mlty_fun : FStar_Extraction_ML_Syntax.mlty  ->  (FStar_Extraction_ML_Syntax.mlty Prims.list * FStar_Extraction_ML_Syntax.mlty) = (fun t -> (match (t) with
| FStar_Extraction_ML_Syntax.MLTY_Fun (a, uu____1900, b) -> begin
(

let uu____1902 = (uncurry_mlty_fun b)
in (match (uu____1902) with
| (args, res) -> begin
(((a)::args), (res))
end))
end
| uu____1923 -> begin
(([]), (t))
end))

exception NoTacticEmbedding of (Prims.string)


let uu___is_NoTacticEmbedding : Prims.exn  ->  Prims.bool = (fun projectee -> (match (projectee) with
| NoTacticEmbedding (uu____1939) -> begin
true
end
| uu____1942 -> begin
false
end))


let __proj__NoTacticEmbedding__item__uu___ : Prims.exn  ->  Prims.string = (fun projectee -> (match (projectee) with
| NoTacticEmbedding (uu____1952) -> begin
uu____1952
end))


let not_implemented_warning : FStar_Range.range  ->  Prims.string  ->  Prims.string  ->  unit = (fun r t msg -> (

let uu____1974 = (

let uu____1980 = (FStar_Util.format2 "Plugin %s will not run natively because %s.\n" t msg)
in ((FStar_Errors.Warning_CallNotImplementedAsWarning), (uu____1980)))
in (FStar_Errors.log_issue r uu____1974)))

type emb_loc =
| Syntax_term
| Refl_emb
| NBE_t
| NBERefl_emb


let uu___is_Syntax_term : emb_loc  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Syntax_term -> begin
true
end
| uu____1993 -> begin
false
end))


let uu___is_Refl_emb : emb_loc  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Refl_emb -> begin
true
end
| uu____2004 -> begin
false
end))


let uu___is_NBE_t : emb_loc  ->  Prims.bool = (fun projectee -> (match (projectee) with
| NBE_t -> begin
true
end
| uu____2015 -> begin
false
end))


let uu___is_NBERefl_emb : emb_loc  ->  Prims.bool = (fun projectee -> (match (projectee) with
| NBERefl_emb -> begin
true
end
| uu____2026 -> begin
false
end))


type wrapped_term =
(FStar_Extraction_ML_Syntax.mlexpr * FStar_Extraction_ML_Syntax.mlexpr * Prims.int * Prims.bool)


let interpret_plugin_as_term_fun : FStar_TypeChecker_Env.env  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.typ  ->  Prims.int FStar_Pervasives_Native.option  ->  FStar_Extraction_ML_Syntax.mlexpr'  ->  (FStar_Extraction_ML_Syntax.mlexpr * FStar_Extraction_ML_Syntax.mlexpr * Prims.int * Prims.bool) FStar_Pervasives_Native.option = (fun tcenv fv t arity_opt ml_fv -> (

let fv_lid1 = fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let t1 = (FStar_TypeChecker_Normalize.normalize ((FStar_TypeChecker_Env.EraseUniverses)::(FStar_TypeChecker_Env.AllowUnboundUniverses)::(FStar_TypeChecker_Env.UnfoldUntil (FStar_Syntax_Syntax.delta_constant))::[]) tcenv t)
in (

let w = (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top)
in (

let lid_to_name = (fun l -> (

let uu____2097 = (

let uu____2098 = (FStar_Extraction_ML_Syntax.mlpath_of_lident l)
in FStar_Extraction_ML_Syntax.MLE_Name (uu____2098))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____2097)))
in (

let lid_to_top_name = (fun l -> (

let uu____2105 = (

let uu____2106 = (FStar_Extraction_ML_Syntax.mlpath_of_lident l)
in FStar_Extraction_ML_Syntax.MLE_Name (uu____2106))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____2105)))
in (

let str_to_name = (fun s -> (

let uu____2115 = (FStar_Ident.lid_of_str s)
in (lid_to_name uu____2115)))
in (

let str_to_top_name = (fun s -> (

let uu____2124 = (FStar_Ident.lid_of_str s)
in (lid_to_top_name uu____2124)))
in (

let fstar_tc_nbe_prefix = (fun s -> (str_to_name (Prims.op_Hat "FStar_TypeChecker_NBETerm." s)))
in (

let fstar_syn_emb_prefix = (fun s -> (str_to_name (Prims.op_Hat "FStar_Syntax_Embeddings." s)))
in (

let fstar_refl_emb_prefix = (fun s -> (str_to_name (Prims.op_Hat "FStar_Reflection_Embeddings." s)))
in (

let fstar_refl_nbeemb_prefix = (fun s -> (str_to_name (Prims.op_Hat "FStar_Reflection_NBEEmbeddings." s)))
in (

let fv_lid_embedded = (

let uu____2162 = (

let uu____2163 = (

let uu____2170 = (str_to_name "FStar_Ident.lid_of_str")
in (

let uu____2172 = (

let uu____2175 = (

let uu____2176 = (

let uu____2177 = (

let uu____2178 = (FStar_Ident.string_of_lid fv_lid1)
in FStar_Extraction_ML_Syntax.MLC_String (uu____2178))
in FStar_Extraction_ML_Syntax.MLE_Const (uu____2177))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____2176))
in (uu____2175)::[])
in ((uu____2170), (uu____2172))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____2163))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____2162))
in (

let emb_prefix = (fun uu___4_2193 -> (match (uu___4_2193) with
| Syntax_term -> begin
fstar_syn_emb_prefix
end
| Refl_emb -> begin
fstar_refl_emb_prefix
end
| NBE_t -> begin
fstar_tc_nbe_prefix
end
| NBERefl_emb -> begin
fstar_refl_nbeemb_prefix
end))
in (

let mk_tactic_interpretation = (fun l -> (match (l) with
| Syntax_term -> begin
"FStar_Tactics_InterpFuns.mk_tactic_interpretation_"
end
| uu____2207 -> begin
"FStar_Tactics_InterpFuns.mk_nbe_tactic_interpretation_"
end))
in (

let mk_from_tactic = (fun l -> (match (l) with
| Syntax_term -> begin
"FStar_Tactics_Native.from_tactic_"
end
| uu____2218 -> begin
"FStar_Tactics_Native.from_nbe_tactic_"
end))
in (

let mk_basic_embedding = (fun l s -> (emb_prefix l (Prims.op_Hat "e_" s)))
in (

let mk_arrow_as_prim_step = (fun l arity -> (

let uu____2247 = (

let uu____2249 = (FStar_Util.string_of_int arity)
in (Prims.op_Hat "arrow_as_prim_step_" uu____2249))
in (emb_prefix l uu____2247)))
in (

let mk_any_embedding = (fun l s -> (

let uu____2265 = (

let uu____2266 = (

let uu____2273 = (emb_prefix l "mk_any_emb")
in (

let uu____2275 = (

let uu____2278 = (str_to_name s)
in (uu____2278)::[])
in ((uu____2273), (uu____2275))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____2266))
in (FStar_All.pipe_left w uu____2265)))
in (

let mk_lam = (fun nm e -> (FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_Fun ((((((nm), (FStar_Extraction_ML_Syntax.MLTY_Top)))::[]), (e))))))
in (

let emb_arrow = (fun l e1 e2 -> (

let uu____2328 = (

let uu____2329 = (

let uu____2336 = (emb_prefix l "e_arrow")
in ((uu____2336), ((e1)::(e2)::[])))
in FStar_Extraction_ML_Syntax.MLE_App (uu____2329))
in (FStar_All.pipe_left w uu____2328)))
in (

let known_type_constructors = (

let term_cs = (

let uu____2374 = (

let uu____2389 = (

let uu____2404 = (

let uu____2419 = (

let uu____2434 = (

let uu____2449 = (

let uu____2464 = (

let uu____2479 = (

let uu____2492 = (

let uu____2501 = (FStar_Parser_Const.mk_tuple_lid (Prims.parse_int "2") FStar_Range.dummyRange)
in ((uu____2501), ((Prims.parse_int "2")), ("tuple2")))
in ((uu____2492), (Syntax_term)))
in (

let uu____2515 = (

let uu____2530 = (

let uu____2543 = (

let uu____2552 = (FStar_Reflection_Data.fstar_refl_types_lid "term")
in ((uu____2552), ((Prims.parse_int "0")), ("term")))
in ((uu____2543), (Refl_emb)))
in (

let uu____2566 = (

let uu____2581 = (

let uu____2594 = (

let uu____2603 = (FStar_Reflection_Data.fstar_refl_types_lid "fv")
in ((uu____2603), ((Prims.parse_int "0")), ("fv")))
in ((uu____2594), (Refl_emb)))
in (

let uu____2617 = (

let uu____2632 = (

let uu____2645 = (

let uu____2654 = (FStar_Reflection_Data.fstar_refl_types_lid "binder")
in ((uu____2654), ((Prims.parse_int "0")), ("binder")))
in ((uu____2645), (Refl_emb)))
in (

let uu____2668 = (

let uu____2683 = (

let uu____2696 = (

let uu____2705 = (FStar_Reflection_Data.fstar_refl_syntax_lid "binders")
in ((uu____2705), ((Prims.parse_int "0")), ("binders")))
in ((uu____2696), (Refl_emb)))
in (

let uu____2719 = (

let uu____2734 = (

let uu____2747 = (

let uu____2756 = (FStar_Reflection_Data.fstar_refl_data_lid "exp")
in ((uu____2756), ((Prims.parse_int "0")), ("exp")))
in ((uu____2747), (Refl_emb)))
in (uu____2734)::[])
in (uu____2683)::uu____2719))
in (uu____2632)::uu____2668))
in (uu____2581)::uu____2617))
in (uu____2530)::uu____2566))
in (uu____2479)::uu____2515))
in (((((FStar_Parser_Const.option_lid), ((Prims.parse_int "1")), ("option"))), (Syntax_term)))::uu____2464)
in (((((FStar_Parser_Const.list_lid), ((Prims.parse_int "1")), ("list"))), (Syntax_term)))::uu____2449)
in (((((FStar_Parser_Const.norm_step_lid), ((Prims.parse_int "0")), ("norm_step"))), (Syntax_term)))::uu____2434)
in (((((FStar_Parser_Const.string_lid), ((Prims.parse_int "0")), ("string"))), (Syntax_term)))::uu____2419)
in (((((FStar_Parser_Const.unit_lid), ((Prims.parse_int "0")), ("unit"))), (Syntax_term)))::uu____2404)
in (((((FStar_Parser_Const.bool_lid), ((Prims.parse_int "0")), ("bool"))), (Syntax_term)))::uu____2389)
in (((((FStar_Parser_Const.int_lid), ((Prims.parse_int "0")), ("int"))), (Syntax_term)))::uu____2374)
in (

let nbe_cs = (FStar_List.map (fun uu___5_3063 -> (match (uu___5_3063) with
| (x, Syntax_term) -> begin
((x), (NBE_t))
end
| (x, Refl_emb) -> begin
((x), (NBERefl_emb))
end
| uu____3138 -> begin
(failwith "Impossible")
end)) term_cs)
in (fun uu___6_3164 -> (match (uu___6_3164) with
| Syntax_term -> begin
term_cs
end
| Refl_emb -> begin
term_cs
end
| uu____3179 -> begin
nbe_cs
end))))
in (

let is_known_type_constructor = (fun l fv1 n1 -> (FStar_Util.for_some (fun uu____3216 -> (match (uu____3216) with
| ((x, args, uu____3232), uu____3233) -> begin
((FStar_Syntax_Syntax.fv_eq_lid fv1 x) && (Prims.op_Equality n1 args))
end)) (known_type_constructors l)))
in (

let find_env_entry = (fun bv uu____3263 -> (match (uu____3263) with
| (bv', uu____3271) -> begin
(FStar_Syntax_Syntax.bv_eq bv bv')
end))
in (

let rec mk_embedding = (fun l env t2 -> (

let t3 = (FStar_TypeChecker_Normalize.unfold_whnf tcenv t2)
in (

let uu____3305 = (

let uu____3306 = (FStar_Syntax_Subst.compress t3)
in uu____3306.FStar_Syntax_Syntax.n)
in (match (uu____3305) with
| FStar_Syntax_Syntax.Tm_name (bv) when (FStar_Util.for_some (find_env_entry bv) env) -> begin
(

let uu____3315 = (

let uu____3317 = (

let uu____3323 = (FStar_Util.find_opt (find_env_entry bv) env)
in (FStar_Util.must uu____3323))
in (FStar_Pervasives_Native.snd uu____3317))
in (FStar_All.pipe_left (mk_any_embedding l) uu____3315))
end
| FStar_Syntax_Syntax.Tm_refine (x, uu____3344) -> begin
(mk_embedding l env x.FStar_Syntax_Syntax.sort)
end
| FStar_Syntax_Syntax.Tm_ascribed (t4, uu____3350, uu____3351) -> begin
(mk_embedding l env t4)
end
| FStar_Syntax_Syntax.Tm_arrow ((b)::[], c) when (FStar_Syntax_Util.is_pure_comp c) -> begin
(

let uu____3424 = (FStar_Syntax_Subst.open_comp ((b)::[]) c)
in (match (uu____3424) with
| (bs, c1) -> begin
(

let t0 = (

let uu____3446 = (

let uu____3447 = (FStar_List.hd bs)
in (FStar_Pervasives_Native.fst uu____3447))
in uu____3446.FStar_Syntax_Syntax.sort)
in (

let t11 = (FStar_Syntax_Util.comp_result c1)
in (

let uu____3465 = (mk_embedding l env t0)
in (

let uu____3466 = (mk_embedding l env t11)
in (emb_arrow l uu____3465 uu____3466)))))
end))
end
| FStar_Syntax_Syntax.Tm_arrow ((b)::(more)::bs, c) -> begin
(

let tail1 = (FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_arrow ((((more)::bs), (c)))) FStar_Pervasives_Native.None t3.FStar_Syntax_Syntax.pos)
in (

let t4 = (

let uu____3537 = (

let uu____3544 = (

let uu____3545 = (

let uu____3560 = (FStar_Syntax_Syntax.mk_Total tail1)
in (((b)::[]), (uu____3560)))
in FStar_Syntax_Syntax.Tm_arrow (uu____3545))
in (FStar_Syntax_Syntax.mk uu____3544))
in (uu____3537 FStar_Pervasives_Native.None t3.FStar_Syntax_Syntax.pos))
in (mk_embedding l env t4)))
end
| FStar_Syntax_Syntax.Tm_fvar (uu____3585) -> begin
(

let uu____3586 = (FStar_Syntax_Util.head_and_args t3)
in (match (uu____3586) with
| (head1, args) -> begin
(

let n_args = (FStar_List.length args)
in (

let uu____3638 = (

let uu____3639 = (FStar_Syntax_Util.un_uinst head1)
in uu____3639.FStar_Syntax_Syntax.n)
in (match (uu____3638) with
| FStar_Syntax_Syntax.Tm_fvar (fv1) when (is_known_type_constructor l fv1 n_args) -> begin
(

let arg_embeddings = (FStar_All.pipe_right args (FStar_List.map (fun uu____3665 -> (match (uu____3665) with
| (t4, uu____3673) -> begin
(mk_embedding l env t4)
end))))
in (

let nm = fv1.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.ident.FStar_Ident.idText
in (

let uu____3680 = (

let uu____3693 = (FStar_Util.find_opt (fun uu____3725 -> (match (uu____3725) with
| ((x, uu____3740, uu____3741), uu____3742) -> begin
(FStar_Syntax_Syntax.fv_eq_lid fv1 x)
end)) (known_type_constructors l))
in (FStar_All.pipe_right uu____3693 FStar_Util.must))
in (match (uu____3680) with
| ((uu____3793, t_arity, _trepr_head), loc_embedding) -> begin
(

let head2 = (mk_basic_embedding loc_embedding nm)
in (match (t_arity) with
| _3810 when (_3810 = (Prims.parse_int "0")) -> begin
head2
end
| n1 -> begin
(FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((head2), (arg_embeddings)))))
end))
end))))
end
| uu____3815 -> begin
(

let uu____3816 = (

let uu____3817 = (

let uu____3819 = (FStar_Syntax_Print.term_to_string t3)
in (Prims.op_Hat "Embedding not defined for type " uu____3819))
in NoTacticEmbedding (uu____3817))
in (FStar_Exn.raise uu____3816))
end)))
end))
end
| FStar_Syntax_Syntax.Tm_uinst (uu____3822) -> begin
(

let uu____3829 = (FStar_Syntax_Util.head_and_args t3)
in (match (uu____3829) with
| (head1, args) -> begin
(

let n_args = (FStar_List.length args)
in (

let uu____3881 = (

let uu____3882 = (FStar_Syntax_Util.un_uinst head1)
in uu____3882.FStar_Syntax_Syntax.n)
in (match (uu____3881) with
| FStar_Syntax_Syntax.Tm_fvar (fv1) when (is_known_type_constructor l fv1 n_args) -> begin
(

let arg_embeddings = (FStar_All.pipe_right args (FStar_List.map (fun uu____3908 -> (match (uu____3908) with
| (t4, uu____3916) -> begin
(mk_embedding l env t4)
end))))
in (

let nm = fv1.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.ident.FStar_Ident.idText
in (

let uu____3923 = (

let uu____3936 = (FStar_Util.find_opt (fun uu____3968 -> (match (uu____3968) with
| ((x, uu____3983, uu____3984), uu____3985) -> begin
(FStar_Syntax_Syntax.fv_eq_lid fv1 x)
end)) (known_type_constructors l))
in (FStar_All.pipe_right uu____3936 FStar_Util.must))
in (match (uu____3923) with
| ((uu____4036, t_arity, _trepr_head), loc_embedding) -> begin
(

let head2 = (mk_basic_embedding loc_embedding nm)
in (match (t_arity) with
| _4053 when (_4053 = (Prims.parse_int "0")) -> begin
head2
end
| n1 -> begin
(FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((head2), (arg_embeddings)))))
end))
end))))
end
| uu____4058 -> begin
(

let uu____4059 = (

let uu____4060 = (

let uu____4062 = (FStar_Syntax_Print.term_to_string t3)
in (Prims.op_Hat "Embedding not defined for type " uu____4062))
in NoTacticEmbedding (uu____4060))
in (FStar_Exn.raise uu____4059))
end)))
end))
end
| FStar_Syntax_Syntax.Tm_app (uu____4065) -> begin
(

let uu____4082 = (FStar_Syntax_Util.head_and_args t3)
in (match (uu____4082) with
| (head1, args) -> begin
(

let n_args = (FStar_List.length args)
in (

let uu____4134 = (

let uu____4135 = (FStar_Syntax_Util.un_uinst head1)
in uu____4135.FStar_Syntax_Syntax.n)
in (match (uu____4134) with
| FStar_Syntax_Syntax.Tm_fvar (fv1) when (is_known_type_constructor l fv1 n_args) -> begin
(

let arg_embeddings = (FStar_All.pipe_right args (FStar_List.map (fun uu____4161 -> (match (uu____4161) with
| (t4, uu____4169) -> begin
(mk_embedding l env t4)
end))))
in (

let nm = fv1.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.ident.FStar_Ident.idText
in (

let uu____4176 = (

let uu____4189 = (FStar_Util.find_opt (fun uu____4221 -> (match (uu____4221) with
| ((x, uu____4236, uu____4237), uu____4238) -> begin
(FStar_Syntax_Syntax.fv_eq_lid fv1 x)
end)) (known_type_constructors l))
in (FStar_All.pipe_right uu____4189 FStar_Util.must))
in (match (uu____4176) with
| ((uu____4289, t_arity, _trepr_head), loc_embedding) -> begin
(

let head2 = (mk_basic_embedding loc_embedding nm)
in (match (t_arity) with
| _4306 when (_4306 = (Prims.parse_int "0")) -> begin
head2
end
| n1 -> begin
(FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((head2), (arg_embeddings)))))
end))
end))))
end
| uu____4311 -> begin
(

let uu____4312 = (

let uu____4313 = (

let uu____4315 = (FStar_Syntax_Print.term_to_string t3)
in (Prims.op_Hat "Embedding not defined for type " uu____4315))
in NoTacticEmbedding (uu____4313))
in (FStar_Exn.raise uu____4312))
end)))
end))
end
| uu____4318 -> begin
(

let uu____4319 = (

let uu____4320 = (

let uu____4322 = (FStar_Syntax_Print.term_to_string t3)
in (Prims.op_Hat "Embedding not defined for type " uu____4322))
in NoTacticEmbedding (uu____4320))
in (FStar_Exn.raise uu____4319))
end))))
in (

let abstract_tvars = (fun tvar_names body -> (match (tvar_names) with
| [] -> begin
(

let body1 = (

let uu____4344 = (

let uu____4345 = (

let uu____4352 = (str_to_name "FStar_Syntax_Embeddings.debug_wrap")
in (

let uu____4354 = (

let uu____4357 = (

let uu____4358 = (

let uu____4359 = (

let uu____4360 = (FStar_Ident.string_of_lid fv_lid1)
in FStar_Extraction_ML_Syntax.MLC_String (uu____4360))
in FStar_Extraction_ML_Syntax.MLE_Const (uu____4359))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____4358))
in (

let uu____4362 = (

let uu____4365 = (

let uu____4366 = (

let uu____4367 = (

let uu____4368 = (

let uu____4375 = (

let uu____4378 = (str_to_name "args")
in (uu____4378)::[])
in ((body), (uu____4375)))
in FStar_Extraction_ML_Syntax.MLE_App (uu____4368))
in (FStar_All.pipe_left w uu____4367))
in (mk_lam "_" uu____4366))
in (uu____4365)::[])
in (uu____4357)::uu____4362))
in ((uu____4352), (uu____4354))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____4345))
in (FStar_All.pipe_left w uu____4344))
in (mk_lam "args" body1))
end
| uu____4386 -> begin
(

let args_tail = FStar_Extraction_ML_Syntax.MLP_Var ("args_tail")
in (

let mk_cons = (fun hd_pat tail_pat -> FStar_Extraction_ML_Syntax.MLP_CTor (((((("Prims")::[]), ("Cons"))), ((hd_pat)::(tail_pat)::[]))))
in (

let fst_pat = (fun v1 -> FStar_Extraction_ML_Syntax.MLP_Tuple ((FStar_Extraction_ML_Syntax.MLP_Var (v1))::(FStar_Extraction_ML_Syntax.MLP_Wild)::[]))
in (

let pattern = (FStar_List.fold_right (fun hd_var -> (mk_cons (fst_pat hd_var))) tvar_names args_tail)
in (

let branch1 = (

let uu____4435 = (

let uu____4436 = (

let uu____4437 = (

let uu____4444 = (

let uu____4447 = (str_to_name "args")
in (uu____4447)::[])
in ((body), (uu____4444)))
in FStar_Extraction_ML_Syntax.MLE_App (uu____4437))
in (FStar_All.pipe_left w uu____4436))
in ((pattern), (FStar_Pervasives_Native.None), (uu____4435)))
in (

let default_branch = (

let uu____4462 = (

let uu____4463 = (

let uu____4464 = (

let uu____4471 = (str_to_name "failwith")
in (

let uu____4473 = (

let uu____4476 = (

let uu____4477 = (mlexpr_of_const FStar_Range.dummyRange (FStar_Const.Const_string ((("arity mismatch"), (FStar_Range.dummyRange)))))
in (FStar_All.pipe_left w uu____4477))
in (uu____4476)::[])
in ((uu____4471), (uu____4473))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____4464))
in (FStar_All.pipe_left w uu____4463))
in ((FStar_Extraction_ML_Syntax.MLP_Wild), (FStar_Pervasives_Native.None), (uu____4462)))
in (

let body1 = (

let uu____4485 = (

let uu____4486 = (

let uu____4501 = (str_to_name "args")
in ((uu____4501), ((branch1)::(default_branch)::[])))
in FStar_Extraction_ML_Syntax.MLE_Match (uu____4486))
in (FStar_All.pipe_left w uu____4485))
in (

let body2 = (

let uu____4538 = (

let uu____4539 = (

let uu____4546 = (str_to_name "FStar_Syntax_Embeddings.debug_wrap")
in (

let uu____4548 = (

let uu____4551 = (

let uu____4552 = (

let uu____4553 = (

let uu____4554 = (FStar_Ident.string_of_lid fv_lid1)
in FStar_Extraction_ML_Syntax.MLC_String (uu____4554))
in FStar_Extraction_ML_Syntax.MLE_Const (uu____4553))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____4552))
in (

let uu____4556 = (

let uu____4559 = (mk_lam "_" body1)
in (uu____4559)::[])
in (uu____4551)::uu____4556))
in ((uu____4546), (uu____4548))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____4539))
in (FStar_All.pipe_left w uu____4538))
in (mk_lam "args" body2)))))))))
end))
in (

let uu____4564 = (FStar_Syntax_Util.arrow_formals_comp t1)
in (match (uu____4564) with
| (bs, c) -> begin
(

let uu____4597 = (match (arity_opt) with
| FStar_Pervasives_Native.None -> begin
((bs), (c))
end
| FStar_Pervasives_Native.Some (n1) -> begin
(

let n_bs = (FStar_List.length bs)
in (match ((Prims.op_Equality n1 n_bs)) with
| true -> begin
((bs), (c))
end
| uu____4673 -> begin
(match ((n1 < n_bs)) with
| true -> begin
(

let uu____4690 = (FStar_Util.first_N n1 bs)
in (match (uu____4690) with
| (bs1, rest) -> begin
(

let c1 = (

let uu____4768 = (FStar_Syntax_Util.arrow rest c)
in (FStar_All.pipe_left FStar_Syntax_Syntax.mk_Total uu____4768))
in ((bs1), (c1)))
end))
end
| uu____4781 -> begin
(

let msg = (

let uu____4785 = (FStar_Ident.string_of_lid fv_lid1)
in (

let uu____4787 = (FStar_Util.string_of_int n1)
in (

let uu____4789 = (FStar_Util.string_of_int n_bs)
in (FStar_Util.format3 "Embedding not defined for %s; expected arity at least %s; got %s" uu____4785 uu____4787 uu____4789))))
in (FStar_Exn.raise (NoTacticEmbedding (msg))))
end)
end))
end)
in (match (uu____4597) with
| (bs1, c1) -> begin
(

let result_typ = (FStar_Syntax_Util.comp_result c1)
in (

let arity = (FStar_List.length bs1)
in (

let uu____4840 = (

let uu____4861 = (FStar_Util.prefix_until (fun uu____4903 -> (match (uu____4903) with
| (b, uu____4912) -> begin
(

let uu____4917 = (

let uu____4918 = (FStar_Syntax_Subst.compress b.FStar_Syntax_Syntax.sort)
in uu____4918.FStar_Syntax_Syntax.n)
in (match (uu____4917) with
| FStar_Syntax_Syntax.Tm_type (uu____4922) -> begin
false
end
| uu____4924 -> begin
true
end))
end)) bs1)
in (match (uu____4861) with
| FStar_Pervasives_Native.None -> begin
((bs1), ([]))
end
| FStar_Pervasives_Native.Some (tvars, x, rest) -> begin
((tvars), ((x)::rest))
end))
in (match (uu____4840) with
| (type_vars, bs2) -> begin
(

let tvar_arity = (FStar_List.length type_vars)
in (

let non_tvar_arity = (FStar_List.length bs2)
in (

let tvar_names = (FStar_List.mapi (fun i tv -> (

let uu____5166 = (FStar_Util.string_of_int i)
in (Prims.op_Hat "tv_" uu____5166))) type_vars)
in (

let tvar_context = (FStar_List.map2 (fun b nm -> (((FStar_Pervasives_Native.fst b)), (nm))) type_vars tvar_names)
in (

let rec aux = (fun loc accum_embeddings bs3 -> (match (bs3) with
| [] -> begin
(

let arg_unembeddings = (FStar_List.rev accum_embeddings)
in (

let res_embedding = (mk_embedding loc tvar_context result_typ)
in (

let fv_lid2 = fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
in (

let uu____5266 = (FStar_Syntax_Util.is_pure_comp c1)
in (match (uu____5266) with
| true -> begin
(

let cb = (str_to_name "cb")
in (

let embed_fun_N = (mk_arrow_as_prim_step loc non_tvar_arity)
in (

let args = (

let uu____5283 = (

let uu____5286 = (

let uu____5289 = (lid_to_top_name fv_lid2)
in (

let uu____5290 = (

let uu____5293 = (

let uu____5294 = (

let uu____5295 = (

let uu____5296 = (

let uu____5308 = (FStar_Util.string_of_int tvar_arity)
in ((uu____5308), (FStar_Pervasives_Native.None)))
in FStar_Extraction_ML_Syntax.MLC_Int (uu____5296))
in FStar_Extraction_ML_Syntax.MLE_Const (uu____5295))
in (FStar_All.pipe_left (FStar_Extraction_ML_Syntax.with_ty FStar_Extraction_ML_Syntax.MLTY_Top) uu____5294))
in (uu____5293)::(fv_lid_embedded)::(cb)::[])
in (uu____5289)::uu____5290))
in (res_embedding)::uu____5286)
in (FStar_List.append arg_unembeddings uu____5283))
in (

let fun_embedding = (FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((embed_fun_N), (args)))))
in (

let tabs = (abstract_tvars tvar_names fun_embedding)
in (

let cb_tabs = (mk_lam "cb" tabs)
in (

let uu____5327 = (match ((Prims.op_Equality loc NBE_t)) with
| true -> begin
cb_tabs
end
| uu____5329 -> begin
(mk_lam "_psc" cb_tabs)
end)
in ((uu____5327), (arity), (true)))))))))
end
| uu____5335 -> begin
(

let uu____5337 = (

let uu____5339 = (FStar_TypeChecker_Env.norm_eff_name tcenv (FStar_Syntax_Util.comp_effect_name c1))
in (FStar_Ident.lid_equals uu____5339 FStar_Parser_Const.effect_TAC_lid))
in (match (uu____5337) with
| true -> begin
(

let h = (

let uu____5350 = (

let uu____5352 = (FStar_Util.string_of_int non_tvar_arity)
in (Prims.op_Hat (mk_tactic_interpretation loc) uu____5352))
in (str_to_top_name uu____5350))
in (

let tac_fun = (

let uu____5355 = (

let uu____5356 = (

let uu____5363 = (

let uu____5364 = (

let uu____5366 = (FStar_Util.string_of_int non_tvar_arity)
in (Prims.op_Hat (mk_from_tactic loc) uu____5366))
in (str_to_top_name uu____5364))
in (

let uu____5368 = (

let uu____5371 = (lid_to_top_name fv_lid2)
in (uu____5371)::[])
in ((uu____5363), (uu____5368))))
in FStar_Extraction_ML_Syntax.MLE_App (uu____5356))
in (FStar_All.pipe_left w uu____5355))
in (

let psc = (str_to_name "psc")
in (

let ncb = (str_to_name "ncb")
in (

let all_args = (str_to_name "args")
in (

let args = (FStar_List.append ((tac_fun)::[]) (FStar_List.append arg_unembeddings ((res_embedding)::(psc)::(ncb)::[])))
in (

let tabs = (match (tvar_names) with
| [] -> begin
(

let uu____5385 = (FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((h), ((FStar_List.append args ((all_args)::[])))))))
in (mk_lam "args" uu____5385))
end
| uu____5389 -> begin
(

let uu____5393 = (FStar_All.pipe_left w (FStar_Extraction_ML_Syntax.MLE_App (((h), (args)))))
in (abstract_tvars tvar_names uu____5393))
end)
in (

let uu____5396 = (

let uu____5397 = (mk_lam "ncb" tabs)
in (mk_lam "psc" uu____5397))
in ((uu____5396), ((arity + (Prims.parse_int "1"))), (false))))))))))
end
| uu____5404 -> begin
(

let uu____5406 = (

let uu____5407 = (

let uu____5409 = (FStar_Syntax_Print.term_to_string t1)
in (Prims.op_Hat "Plugins not defined for type " uu____5409))
in NoTacticEmbedding (uu____5407))
in (FStar_Exn.raise uu____5406))
end))
end)))))
end
| ((b, uu____5421))::bs4 -> begin
(

let uu____5441 = (

let uu____5444 = (mk_embedding loc tvar_context b.FStar_Syntax_Syntax.sort)
in (uu____5444)::accum_embeddings)
in (aux loc uu____5441 bs4))
end))
in (FStar_All.try_with (fun uu___687_5466 -> (match (()) with
| () -> begin
(

let uu____5479 = (aux Syntax_term [] bs2)
in (match (uu____5479) with
| (w1, a, b) -> begin
(

let uu____5507 = (aux NBE_t [] bs2)
in (match (uu____5507) with
| (w', uu____5529, uu____5530) -> begin
FStar_Pervasives_Native.Some (((w1), (w'), (a), (b)))
end))
end))
end)) (fun uu___686_5550 -> (match (uu___686_5550) with
| NoTacticEmbedding (msg) -> begin
((

let uu____5566 = (FStar_Syntax_Print.fv_to_string fv)
in (not_implemented_warning t1.FStar_Syntax_Syntax.pos uu____5566 msg));
FStar_Pervasives_Native.None;
)
end))))))))
end))))
end))
end))))))))))))))))))))))))))))




