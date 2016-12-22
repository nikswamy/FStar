
open Prims

type inst_t =
(FStar_Ident.lident * FStar_Syntax_Syntax.universes) Prims.list


let mk = (fun t s -> (let _135_3 = (FStar_ST.read t.FStar_Syntax_Syntax.tk)
in (FStar_Syntax_Syntax.mk s _135_3 t.FStar_Syntax_Syntax.pos)))


let rec inst : (FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term)  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun s t -> (

let t = (FStar_Syntax_Subst.compress t)
in (

let mk = (mk t)
in (match (t.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Tm_delayed (_38_13) -> begin
(FStar_All.failwith "Impossible")
end
| (FStar_Syntax_Syntax.Tm_name (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) | (FStar_Syntax_Syntax.Tm_uvar (_)) | (FStar_Syntax_Syntax.Tm_type (_)) | (FStar_Syntax_Syntax.Tm_bvar (_)) | (FStar_Syntax_Syntax.Tm_constant (_)) | (FStar_Syntax_Syntax.Tm_unknown) | (FStar_Syntax_Syntax.Tm_uinst (_)) -> begin
t
end
| FStar_Syntax_Syntax.Tm_fvar (fv) -> begin
(s t fv)
end
| FStar_Syntax_Syntax.Tm_abs (bs, body, lopt) -> begin
(

let bs = (inst_binders s bs)
in (

let body = (inst s body)
in (let _135_48 = (let _135_47 = (let _135_46 = (inst_lcomp_opt s lopt)
in ((bs), (body), (_135_46)))
in FStar_Syntax_Syntax.Tm_abs (_135_47))
in (mk _135_48))))
end
| FStar_Syntax_Syntax.Tm_arrow (bs, c) -> begin
(

let bs = (inst_binders s bs)
in (

let c = (inst_comp s c)
in (mk (FStar_Syntax_Syntax.Tm_arrow (((bs), (c)))))))
end
| FStar_Syntax_Syntax.Tm_refine (bv, t) -> begin
(

let bv = (

let _38_56 = bv
in (let _135_49 = (inst s bv.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _38_56.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _38_56.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _135_49}))
in (

let t = (inst s t)
in (mk (FStar_Syntax_Syntax.Tm_refine (((bv), (t)))))))
end
| FStar_Syntax_Syntax.Tm_app (t, args) -> begin
(let _135_53 = (let _135_52 = (let _135_51 = (inst s t)
in (let _135_50 = (inst_args s args)
in ((_135_51), (_135_50))))
in FStar_Syntax_Syntax.Tm_app (_135_52))
in (mk _135_53))
end
| FStar_Syntax_Syntax.Tm_match (t, pats) -> begin
(

let pats = (FStar_All.pipe_right pats (FStar_List.map (fun _38_71 -> (match (_38_71) with
| (p, wopt, t) -> begin
(

let wopt = (match (wopt) with
| None -> begin
None
end
| Some (w) -> begin
(let _135_55 = (inst s w)
in Some (_135_55))
end)
in (

let t = (inst s t)
in ((p), (wopt), (t))))
end))))
in (let _135_58 = (let _135_57 = (let _135_56 = (inst s t)
in ((_135_56), (pats)))
in FStar_Syntax_Syntax.Tm_match (_135_57))
in (mk _135_58)))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inl (t2), f) -> begin
(let _135_63 = (let _135_62 = (let _135_61 = (inst s t1)
in (let _135_60 = (let _135_59 = (inst s t2)
in FStar_Util.Inl (_135_59))
in ((_135_61), (_135_60), (f))))
in FStar_Syntax_Syntax.Tm_ascribed (_135_62))
in (mk _135_63))
end
| FStar_Syntax_Syntax.Tm_ascribed (t1, FStar_Util.Inr (c), f) -> begin
(let _135_68 = (let _135_67 = (let _135_66 = (inst s t1)
in (let _135_65 = (let _135_64 = (inst_comp s c)
in FStar_Util.Inr (_135_64))
in ((_135_66), (_135_65), (f))))
in FStar_Syntax_Syntax.Tm_ascribed (_135_67))
in (mk _135_68))
end
| FStar_Syntax_Syntax.Tm_let (lbs, t) -> begin
(

let lbs = (let _135_72 = (FStar_All.pipe_right (Prims.snd lbs) (FStar_List.map (fun lb -> (

let _38_95 = lb
in (let _135_71 = (inst s lb.FStar_Syntax_Syntax.lbtyp)
in (let _135_70 = (inst s lb.FStar_Syntax_Syntax.lbdef)
in {FStar_Syntax_Syntax.lbname = _38_95.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _38_95.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = _135_71; FStar_Syntax_Syntax.lbeff = _38_95.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = _135_70}))))))
in (((Prims.fst lbs)), (_135_72)))
in (let _135_75 = (let _135_74 = (let _135_73 = (inst s t)
in ((lbs), (_135_73)))
in FStar_Syntax_Syntax.Tm_let (_135_74))
in (mk _135_75)))
end
| FStar_Syntax_Syntax.Tm_meta (t, FStar_Syntax_Syntax.Meta_pattern (args)) -> begin
(let _135_80 = (let _135_79 = (let _135_78 = (inst s t)
in (let _135_77 = (let _135_76 = (FStar_All.pipe_right args (FStar_List.map (inst_args s)))
in FStar_Syntax_Syntax.Meta_pattern (_135_76))
in ((_135_78), (_135_77))))
in FStar_Syntax_Syntax.Tm_meta (_135_79))
in (mk _135_80))
end
| FStar_Syntax_Syntax.Tm_meta (t, FStar_Syntax_Syntax.Meta_monadic (m, t')) -> begin
(let _135_86 = (let _135_85 = (let _135_84 = (inst s t)
in (let _135_83 = (let _135_82 = (let _135_81 = (inst s t')
in ((m), (_135_81)))
in FStar_Syntax_Syntax.Meta_monadic (_135_82))
in ((_135_84), (_135_83))))
in FStar_Syntax_Syntax.Tm_meta (_135_85))
in (mk _135_86))
end
| FStar_Syntax_Syntax.Tm_meta (t, tag) -> begin
(let _135_89 = (let _135_88 = (let _135_87 = (inst s t)
in ((_135_87), (tag)))
in FStar_Syntax_Syntax.Tm_meta (_135_88))
in (mk _135_89))
end))))
and inst_binders : (FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term)  ->  FStar_Syntax_Syntax.binders  ->  FStar_Syntax_Syntax.binders = (fun s bs -> (FStar_All.pipe_right bs (FStar_List.map (fun _38_118 -> (match (_38_118) with
| (x, imp) -> begin
(let _135_100 = (

let _38_119 = x
in (let _135_99 = (inst s x.FStar_Syntax_Syntax.sort)
in {FStar_Syntax_Syntax.ppname = _38_119.FStar_Syntax_Syntax.ppname; FStar_Syntax_Syntax.index = _38_119.FStar_Syntax_Syntax.index; FStar_Syntax_Syntax.sort = _135_99}))
in ((_135_100), (imp)))
end)))))
and inst_args : (FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term)  ->  FStar_Syntax_Syntax.args  ->  FStar_Syntax_Syntax.args = (fun s args -> (FStar_All.pipe_right args (FStar_List.map (fun _38_125 -> (match (_38_125) with
| (a, imp) -> begin
(let _135_110 = (inst s a)
in ((_135_110), (imp)))
end)))))
and inst_comp : (FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term)  ->  FStar_Syntax_Syntax.comp  ->  FStar_Syntax_Syntax.comp = (fun s c -> (match (c.FStar_Syntax_Syntax.n) with
| FStar_Syntax_Syntax.Total (t, uopt) -> begin
(let _135_119 = (inst s t)
in (FStar_Syntax_Syntax.mk_Total' _135_119 uopt))
end
| FStar_Syntax_Syntax.GTotal (t, uopt) -> begin
(let _135_120 = (inst s t)
in (FStar_Syntax_Syntax.mk_GTotal' _135_120 uopt))
end
| FStar_Syntax_Syntax.Comp (ct) -> begin
(

let ct = (

let _38_138 = ct
in (let _135_125 = (inst s ct.FStar_Syntax_Syntax.result_typ)
in (let _135_124 = (inst_args s ct.FStar_Syntax_Syntax.effect_args)
in (let _135_123 = (FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags (FStar_List.map (fun _38_1 -> (match (_38_1) with
| FStar_Syntax_Syntax.DECREASES (t) -> begin
(let _135_122 = (inst s t)
in FStar_Syntax_Syntax.DECREASES (_135_122))
end
| f -> begin
f
end))))
in {FStar_Syntax_Syntax.comp_univs = _38_138.FStar_Syntax_Syntax.comp_univs; FStar_Syntax_Syntax.effect_name = _38_138.FStar_Syntax_Syntax.effect_name; FStar_Syntax_Syntax.result_typ = _135_125; FStar_Syntax_Syntax.effect_args = _135_124; FStar_Syntax_Syntax.flags = _135_123}))))
in (FStar_Syntax_Syntax.mk_Comp ct))
end))
and inst_lcomp_opt : (FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.fv  ->  FStar_Syntax_Syntax.term)  ->  (FStar_Syntax_Syntax.lcomp, FStar_Syntax_Syntax.residual_comp) FStar_Util.either Prims.option  ->  (FStar_Syntax_Syntax.lcomp, FStar_Syntax_Syntax.residual_comp) FStar_Util.either Prims.option = (fun s l -> (match (l) with
| (None) | (Some (FStar_Util.Inr (_))) -> begin
l
end
| Some (FStar_Util.Inl (lc)) -> begin
(let _135_138 = (let _135_137 = (

let _38_155 = lc
in (let _135_136 = (inst s lc.FStar_Syntax_Syntax.res_typ)
in {FStar_Syntax_Syntax.eff_name = _38_155.FStar_Syntax_Syntax.eff_name; FStar_Syntax_Syntax.res_typ = _135_136; FStar_Syntax_Syntax.cflags = _38_155.FStar_Syntax_Syntax.cflags; FStar_Syntax_Syntax.comp = (fun _38_157 -> (match (()) with
| () -> begin
(let _135_135 = (lc.FStar_Syntax_Syntax.comp ())
in (inst_comp s _135_135))
end))}))
in FStar_Util.Inl (_135_137))
in Some (_135_138))
end))


let instantiate : inst_t  ->  FStar_Syntax_Syntax.term  ->  FStar_Syntax_Syntax.term = (fun i t -> (match (i) with
| [] -> begin
t
end
| _38_162 -> begin
(

let inst_fv = (fun t fv -> (match ((FStar_Util.find_opt (fun _38_169 -> (match (_38_169) with
| (x, _38_168) -> begin
(FStar_Ident.lid_equals x fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)
end)) i)) with
| None -> begin
t
end
| Some (_38_172, us) -> begin
(mk t (FStar_Syntax_Syntax.Tm_uinst (((t), (us)))))
end))
in (inst inst_fv t))
end))


let disentangle_abbrevs_from_bundle : FStar_Syntax_Syntax.sigelt Prims.list  ->  FStar_Syntax_Syntax.qualifier Prims.list  ->  FStar_Ident.lident Prims.list  ->  FStar_Range.range  ->  (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.sigelt Prims.list) = (fun sigelts quals members rng -> (

let type_abbrev_sigelts = (FStar_All.pipe_right sigelts (FStar_List.collect (fun x -> (match (x) with
| FStar_Syntax_Syntax.Sig_let ((false, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (_38_191); FStar_Syntax_Syntax.lbunivs = _38_189; FStar_Syntax_Syntax.lbtyp = _38_187; FStar_Syntax_Syntax.lbeff = _38_185; FStar_Syntax_Syntax.lbdef = _38_183})::[]), _38_197, _38_199, _38_201, _38_203) -> begin
(x)::[]
end
| FStar_Syntax_Syntax.Sig_let (_38_207, _38_209, _38_211, _38_213, _38_215) -> begin
(FStar_All.failwith "instfv: disentangle_abbrevs_from_bundle: type_abbrev_sigelts: impossible")
end
| _38_219 -> begin
[]
end))))
in (match (type_abbrev_sigelts) with
| [] -> begin
((FStar_Syntax_Syntax.Sig_bundle (((sigelts), (quals), (members), (rng)))), ([]))
end
| _38_223 -> begin
(

let type_abbrevs = (FStar_All.pipe_right type_abbrev_sigelts (FStar_List.map (fun _38_2 -> (match (_38_2) with
| FStar_Syntax_Syntax.Sig_let ((_38_226, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (fv); FStar_Syntax_Syntax.lbunivs = _38_234; FStar_Syntax_Syntax.lbtyp = _38_232; FStar_Syntax_Syntax.lbeff = _38_230; FStar_Syntax_Syntax.lbdef = _38_228})::[]), _38_241, _38_243, _38_245, _38_247) -> begin
fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
end
| _38_251 -> begin
(FStar_All.failwith "instfv: disentangle_abbrevs_from_bundle: type_abbrevs: impossible")
end))))
in (

let unfolded_type_abbrevs = (

let rev_unfolded_type_abbrevs = (FStar_Util.mk_ref [])
in (

let in_progress = (FStar_Util.mk_ref [])
in (

let not_unfolded_yet = (FStar_Util.mk_ref type_abbrev_sigelts)
in (

let remove_not_unfolded = (fun lid -> (let _135_162 = (let _135_161 = (FStar_ST.read not_unfolded_yet)
in (FStar_All.pipe_right _135_161 (FStar_List.filter (fun _38_3 -> (match (_38_3) with
| FStar_Syntax_Syntax.Sig_let ((_38_260, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (fv); FStar_Syntax_Syntax.lbunivs = _38_268; FStar_Syntax_Syntax.lbtyp = _38_266; FStar_Syntax_Syntax.lbeff = _38_264; FStar_Syntax_Syntax.lbdef = _38_262})::[]), _38_275, _38_277, _38_279, _38_281) -> begin
(not ((FStar_Ident.lid_equals lid fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)))
end
| _38_285 -> begin
true
end)))))
in (FStar_ST.op_Colon_Equals not_unfolded_yet _135_162)))
in (

let rec unfold_abbrev_fv = (fun t fv -> (

let replacee = (fun x -> (match (x) with
| FStar_Syntax_Syntax.Sig_let ((_38_293, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (fv'); FStar_Syntax_Syntax.lbunivs = _38_301; FStar_Syntax_Syntax.lbtyp = _38_299; FStar_Syntax_Syntax.lbeff = _38_297; FStar_Syntax_Syntax.lbdef = _38_295})::[]), _38_308, _38_310, _38_312, _38_314) when (FStar_Ident.lid_equals fv'.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v) -> begin
Some (x)
end
| _38_318 -> begin
None
end))
in (

let replacee_term = (fun x -> (match ((replacee x)) with
| Some (FStar_Syntax_Syntax.Sig_let ((_38_322, ({FStar_Syntax_Syntax.lbname = _38_331; FStar_Syntax_Syntax.lbunivs = _38_329; FStar_Syntax_Syntax.lbtyp = _38_327; FStar_Syntax_Syntax.lbeff = _38_325; FStar_Syntax_Syntax.lbdef = tm})::[]), _38_336, _38_338, _38_340, _38_342)) -> begin
Some (tm)
end
| _38_347 -> begin
None
end))
in (match ((let _135_172 = (FStar_ST.read rev_unfolded_type_abbrevs)
in (FStar_Util.find_map _135_172 replacee_term))) with
| Some (x) -> begin
x
end
| None -> begin
(match ((FStar_Util.find_map type_abbrev_sigelts replacee)) with
| Some (se) -> begin
if (let _135_174 = (FStar_ST.read in_progress)
in (FStar_List.existsb (fun x -> (FStar_Ident.lid_equals x fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)) _135_174)) then begin
(

let msg = (FStar_Util.format1 "Cycle on %s in mutually recursive type abbreviations" fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v.FStar_Ident.str)
in (Prims.raise (FStar_Syntax_Syntax.Error (((msg), ((FStar_Ident.range_of_lid fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v)))))))
end else begin
(unfold_abbrev se)
end
end
| _38_356 -> begin
t
end)
end))))
and unfold_abbrev = (fun _38_4 -> (match (_38_4) with
| FStar_Syntax_Syntax.Sig_let ((false, (lb)::[]), rng, _38_364, quals, attr) -> begin
(

let lid = (match (lb.FStar_Syntax_Syntax.lbname) with
| FStar_Util.Inr (fv) -> begin
fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v
end
| _38_372 -> begin
(FStar_All.failwith "instfv: disentangle_abbrevs_from_bundle: rename_abbrev: lid: impossible")
end)
in (

let _38_374 = (let _135_177 = (let _135_176 = (FStar_ST.read in_progress)
in (lid)::_135_176)
in (FStar_ST.op_Colon_Equals in_progress _135_177))
in (match (()) with
| () -> begin
(

let _38_375 = (remove_not_unfolded lid)
in (match (()) with
| () -> begin
(

let ty' = (inst unfold_abbrev_fv lb.FStar_Syntax_Syntax.lbtyp)
in (

let tm' = (inst unfold_abbrev_fv lb.FStar_Syntax_Syntax.lbdef)
in (

let lb' = (

let _38_378 = lb
in {FStar_Syntax_Syntax.lbname = _38_378.FStar_Syntax_Syntax.lbname; FStar_Syntax_Syntax.lbunivs = _38_378.FStar_Syntax_Syntax.lbunivs; FStar_Syntax_Syntax.lbtyp = ty'; FStar_Syntax_Syntax.lbeff = _38_378.FStar_Syntax_Syntax.lbeff; FStar_Syntax_Syntax.lbdef = tm'})
in (

let sigelt' = FStar_Syntax_Syntax.Sig_let (((((false), ((lb')::[]))), (rng), ((lid)::[]), (quals), (attr)))
in (

let _38_382 = (let _135_179 = (let _135_178 = (FStar_ST.read rev_unfolded_type_abbrevs)
in (sigelt')::_135_178)
in (FStar_ST.op_Colon_Equals rev_unfolded_type_abbrevs _135_179))
in (match (()) with
| () -> begin
(

let _38_383 = (let _135_181 = (let _135_180 = (FStar_ST.read in_progress)
in (FStar_List.tl _135_180))
in (FStar_ST.op_Colon_Equals in_progress _135_181))
in (match (()) with
| () -> begin
ty'
end))
end))))))
end))
end)))
end
| _38_385 -> begin
(FStar_All.failwith "instfv: disentangle_abbrevs_from_bundle: rename_abbrev: impossible")
end))
in (

let rec aux = (fun _38_387 -> (match (()) with
| () -> begin
(match ((FStar_ST.read not_unfolded_yet)) with
| (x)::_38_389 -> begin
(

let _unused = (unfold_abbrev x)
in (aux ()))
end
| _38_394 -> begin
(let _135_184 = (FStar_ST.read rev_unfolded_type_abbrevs)
in (FStar_List.rev _135_184))
end)
end))
in (aux ())))))))
in (

let filter_out_type_abbrevs = (fun l -> (FStar_List.filter (fun lid -> (FStar_List.for_all (fun lid' -> (not ((FStar_Ident.lid_equals lid lid')))) type_abbrevs)) l))
in (

let inductives_with_abbrevs_unfolded = (

let find_in_unfolded = (fun fv -> (FStar_Util.find_map unfolded_type_abbrevs (fun x -> (match (x) with
| FStar_Syntax_Syntax.Sig_let ((_38_404, ({FStar_Syntax_Syntax.lbname = FStar_Util.Inr (fv'); FStar_Syntax_Syntax.lbunivs = _38_411; FStar_Syntax_Syntax.lbtyp = _38_409; FStar_Syntax_Syntax.lbeff = _38_407; FStar_Syntax_Syntax.lbdef = tm})::[]), _38_418, _38_420, _38_422, _38_424) when (FStar_Ident.lid_equals fv'.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v fv.FStar_Syntax_Syntax.fv_name.FStar_Syntax_Syntax.v) -> begin
Some (tm)
end
| _38_428 -> begin
None
end))))
in (

let unfold_fv = (fun t fv -> (match ((find_in_unfolded fv)) with
| Some (t') -> begin
t'
end
| _38_435 -> begin
t
end))
in (

let unfold_in_sig = (fun _38_5 -> (match (_38_5) with
| FStar_Syntax_Syntax.Sig_inductive_typ (lid, univs, bnd, ty, mut, dc, quals, rng) -> begin
(

let bnd' = (inst_binders unfold_fv bnd)
in (

let ty' = (inst unfold_fv ty)
in (

let mut' = (filter_out_type_abbrevs mut)
in (FStar_Syntax_Syntax.Sig_inductive_typ (((lid), (univs), (bnd'), (ty'), (mut'), (dc), (quals), (rng))))::[])))
end
| FStar_Syntax_Syntax.Sig_datacon (lid, univs, ty, res, npars, quals, mut, rng) -> begin
(

let ty' = (inst unfold_fv ty)
in (

let mut' = (filter_out_type_abbrevs mut)
in (FStar_Syntax_Syntax.Sig_datacon (((lid), (univs), (ty'), (res), (npars), (quals), (mut'), (rng))))::[]))
end
| FStar_Syntax_Syntax.Sig_let (_38_463, _38_465, _38_467, _38_469, _38_471) -> begin
[]
end
| _38_475 -> begin
(FStar_All.failwith "instfv: inductives_with_abbrevs_unfolded: unfold_in_sig: impossible")
end))
in (FStar_List.collect unfold_in_sig sigelts))))
in (

let new_members = (filter_out_type_abbrevs members)
in (

let new_bundle = FStar_Syntax_Syntax.Sig_bundle (((inductives_with_abbrevs_unfolded), (quals), (new_members), (rng)))
in ((new_bundle), (unfolded_type_abbrevs))))))))
end)))




