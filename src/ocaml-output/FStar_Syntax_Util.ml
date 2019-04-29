open Prims
let (tts_f :
  (FStar_Syntax_Syntax.term -> Prims.string) FStar_Pervasives_Native.option
    FStar_ST.ref)
  = FStar_Util.mk_ref FStar_Pervasives_Native.None
let (tts : FStar_Syntax_Syntax.term -> Prims.string) =
  fun t ->
    let uu____26 = FStar_ST.op_Bang tts_f in
    match uu____26 with
    | FStar_Pervasives_Native.None -> "<<hook unset>>"
    | FStar_Pervasives_Native.Some f -> f t
let (qual_id : FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident)
  =
  fun lid ->
    fun id1 ->
      let uu____90 =
        FStar_Ident.lid_of_ids
          (FStar_List.append lid.FStar_Ident.ns [lid.FStar_Ident.ident; id1]) in
      FStar_Ident.set_lid_range uu____90 id1.FStar_Ident.idRange
let (mk_discriminator : FStar_Ident.lident -> FStar_Ident.lident) =
  fun lid ->
    let uu____97 =
      let uu____100 =
        let uu____103 =
          FStar_Ident.mk_ident
            ((Prims.op_Hat FStar_Ident.reserved_prefix
                (Prims.op_Hat "is_"
                   (lid.FStar_Ident.ident).FStar_Ident.idText)),
              ((lid.FStar_Ident.ident).FStar_Ident.idRange)) in
        [uu____103] in
      FStar_List.append lid.FStar_Ident.ns uu____100 in
    FStar_Ident.lid_of_ids uu____97
let (is_name : FStar_Ident.lident -> Prims.bool) =
  fun lid ->
    let c =
      FStar_Util.char_at (lid.FStar_Ident.ident).FStar_Ident.idText
        (Prims.parse_int "0") in
    FStar_Util.is_upper c
let arg_of_non_null_binder :
  'Auu____121 .
    (FStar_Syntax_Syntax.bv * 'Auu____121) ->
      (FStar_Syntax_Syntax.term * 'Auu____121)
  =
  fun uu____134 ->
    match uu____134 with
    | (b, imp) ->
        let uu____141 = FStar_Syntax_Syntax.bv_to_name b in (uu____141, imp)
let (args_of_non_null_binders :
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.term * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list)
  =
  fun binders ->
    FStar_All.pipe_right binders
      (FStar_List.collect
         (fun b ->
            let uu____193 = FStar_Syntax_Syntax.is_null_binder b in
            if uu____193
            then []
            else (let uu____212 = arg_of_non_null_binder b in [uu____212])))
let (args_of_binders :
  FStar_Syntax_Syntax.binders ->
    (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.args))
  =
  fun binders ->
    let uu____247 =
      FStar_All.pipe_right binders
        (FStar_List.map
           (fun b ->
              let uu____329 = FStar_Syntax_Syntax.is_null_binder b in
              if uu____329
              then
                let b1 =
                  let uu____355 =
                    FStar_Syntax_Syntax.new_bv FStar_Pervasives_Native.None
                      (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                  (uu____355, (FStar_Pervasives_Native.snd b)) in
                let uu____362 = arg_of_non_null_binder b1 in (b1, uu____362)
              else
                (let uu____385 = arg_of_non_null_binder b in (b, uu____385)))) in
    FStar_All.pipe_right uu____247 FStar_List.unzip
let (name_binders :
  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
    FStar_Pervasives_Native.option) Prims.list ->
    (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list)
  =
  fun binders ->
    FStar_All.pipe_right binders
      (FStar_List.mapi
         (fun i ->
            fun b ->
              let uu____519 = FStar_Syntax_Syntax.is_null_binder b in
              if uu____519
              then
                let uu____528 = b in
                match uu____528 with
                | (a, imp) ->
                    let b1 =
                      let uu____548 =
                        let uu____550 = FStar_Util.string_of_int i in
                        Prims.op_Hat "_" uu____550 in
                      FStar_Ident.id_of_text uu____548 in
                    let b2 =
                      {
                        FStar_Syntax_Syntax.ppname = b1;
                        FStar_Syntax_Syntax.index = (Prims.parse_int "0");
                        FStar_Syntax_Syntax.sort =
                          (a.FStar_Syntax_Syntax.sort)
                      } in
                    (b2, imp)
              else b))
let (name_function_binders :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (binders, comp) ->
        let uu____595 =
          let uu____602 =
            let uu____603 =
              let uu____618 = name_binders binders in (uu____618, comp) in
            FStar_Syntax_Syntax.Tm_arrow uu____603 in
          FStar_Syntax_Syntax.mk uu____602 in
        uu____595 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
    | uu____637 -> t
let (null_binders_of_tks :
  (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.aqual) Prims.list ->
    FStar_Syntax_Syntax.binders)
  =
  fun tks ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____674 ->
            match uu____674 with
            | (t, imp) ->
                let uu____685 =
                  let uu____686 = FStar_Syntax_Syntax.null_binder t in
                  FStar_All.pipe_left FStar_Pervasives_Native.fst uu____686 in
                (uu____685, imp)))
let (binders_of_tks :
  (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.aqual) Prims.list ->
    FStar_Syntax_Syntax.binders)
  =
  fun tks ->
    FStar_All.pipe_right tks
      (FStar_List.map
         (fun uu____741 ->
            match uu____741 with
            | (t, imp) ->
                let uu____758 =
                  FStar_Syntax_Syntax.new_bv
                    (FStar_Pervasives_Native.Some (t.FStar_Syntax_Syntax.pos))
                    t in
                (uu____758, imp)))
let (binders_of_freevars :
  FStar_Syntax_Syntax.bv FStar_Util.set ->
    FStar_Syntax_Syntax.binder Prims.list)
  =
  fun fvs ->
    let uu____771 = FStar_Util.set_elements fvs in
    FStar_All.pipe_right uu____771
      (FStar_List.map FStar_Syntax_Syntax.mk_binder)
let mk_subst : 'Auu____783 . 'Auu____783 -> 'Auu____783 Prims.list =
  fun s -> [s]
let (subst_of_list :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.subst_t)
  =
  fun formals ->
    fun actuals ->
      if (FStar_List.length formals) = (FStar_List.length actuals)
      then
        FStar_List.fold_right2
          (fun f ->
             fun a ->
               fun out ->
                 (FStar_Syntax_Syntax.NT
                    ((FStar_Pervasives_Native.fst f),
                      (FStar_Pervasives_Native.fst a)))
                 :: out) formals actuals []
      else failwith "Ill-formed substitution"
let (rename_binders :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.subst_t)
  =
  fun replace_xs ->
    fun with_ys ->
      if (FStar_List.length replace_xs) = (FStar_List.length with_ys)
      then
        FStar_List.map2
          (fun uu____909 ->
             fun uu____910 ->
               match (uu____909, uu____910) with
               | ((x, uu____936), (y, uu____938)) ->
                   let uu____959 =
                     let uu____966 = FStar_Syntax_Syntax.bv_to_name y in
                     (x, uu____966) in
                   FStar_Syntax_Syntax.NT uu____959) replace_xs with_ys
      else failwith "Ill-formed substitution"
let rec (unmeta : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun e ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e2, uu____982) -> unmeta e2
    | FStar_Syntax_Syntax.Tm_ascribed (e2, uu____988, uu____989) -> unmeta e2
    | uu____1030 -> e1
let rec (unmeta_safe : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun e ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_meta (e', m) ->
        (match m with
         | FStar_Syntax_Syntax.Meta_monadic uu____1044 -> e1
         | FStar_Syntax_Syntax.Meta_monadic_lift uu____1051 -> e1
         | uu____1060 -> unmeta_safe e')
    | FStar_Syntax_Syntax.Tm_ascribed (e2, uu____1062, uu____1063) ->
        unmeta_safe e2
    | uu____1104 -> e1
let rec (univ_kernel :
  FStar_Syntax_Syntax.universe -> (FStar_Syntax_Syntax.universe * Prims.int))
  =
  fun u ->
    match u with
    | FStar_Syntax_Syntax.U_unknown -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_name uu____1123 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_unif uu____1126 -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_zero -> (u, (Prims.parse_int "0"))
    | FStar_Syntax_Syntax.U_succ u1 ->
        let uu____1140 = univ_kernel u1 in
        (match uu____1140 with | (k, n1) -> (k, (n1 + (Prims.parse_int "1"))))
    | FStar_Syntax_Syntax.U_max uu____1157 ->
        failwith "Imposible: univ_kernel (U_max _)"
    | FStar_Syntax_Syntax.U_bvar uu____1166 ->
        failwith "Imposible: univ_kernel (U_bvar _)"
let (constant_univ_as_nat : FStar_Syntax_Syntax.universe -> Prims.int) =
  fun u ->
    let uu____1181 = univ_kernel u in FStar_Pervasives_Native.snd uu____1181
let rec (compare_univs :
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.int)
  =
  fun u1 ->
    fun u2 ->
      match (u1, u2) with
      | (FStar_Syntax_Syntax.U_bvar uu____1201, uu____1202) ->
          failwith "Impossible: compare_univs"
      | (uu____1206, FStar_Syntax_Syntax.U_bvar uu____1207) ->
          failwith "Impossible: compare_univs"
      | (FStar_Syntax_Syntax.U_unknown, FStar_Syntax_Syntax.U_unknown) ->
          (Prims.parse_int "0")
      | (FStar_Syntax_Syntax.U_unknown, uu____1212) ->
          ~- (Prims.parse_int "1")
      | (uu____1214, FStar_Syntax_Syntax.U_unknown) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_zero, FStar_Syntax_Syntax.U_zero) ->
          (Prims.parse_int "0")
      | (FStar_Syntax_Syntax.U_zero, uu____1217) -> ~- (Prims.parse_int "1")
      | (uu____1219, FStar_Syntax_Syntax.U_zero) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_name u11, FStar_Syntax_Syntax.U_name u21) ->
          FStar_String.compare u11.FStar_Ident.idText u21.FStar_Ident.idText
      | (FStar_Syntax_Syntax.U_name uu____1223, FStar_Syntax_Syntax.U_unif
         uu____1224) -> ~- (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_unif uu____1234, FStar_Syntax_Syntax.U_name
         uu____1235) -> (Prims.parse_int "1")
      | (FStar_Syntax_Syntax.U_unif u11, FStar_Syntax_Syntax.U_unif u21) ->
          let uu____1263 = FStar_Syntax_Unionfind.univ_uvar_id u11 in
          let uu____1265 = FStar_Syntax_Unionfind.univ_uvar_id u21 in
          uu____1263 - uu____1265
      | (FStar_Syntax_Syntax.U_max us1, FStar_Syntax_Syntax.U_max us2) ->
          let n1 = FStar_List.length us1 in
          let n2 = FStar_List.length us2 in
          if n1 <> n2
          then n1 - n2
          else
            (let copt =
               let uu____1283 = FStar_List.zip us1 us2 in
               FStar_Util.find_map uu____1283
                 (fun uu____1299 ->
                    match uu____1299 with
                    | (u11, u21) ->
                        let c = compare_univs u11 u21 in
                        if c <> (Prims.parse_int "0")
                        then FStar_Pervasives_Native.Some c
                        else FStar_Pervasives_Native.None) in
             match copt with
             | FStar_Pervasives_Native.None -> (Prims.parse_int "0")
             | FStar_Pervasives_Native.Some c -> c)
      | (FStar_Syntax_Syntax.U_max uu____1327, uu____1328) ->
          ~- (Prims.parse_int "1")
      | (uu____1332, FStar_Syntax_Syntax.U_max uu____1333) ->
          (Prims.parse_int "1")
      | uu____1337 ->
          let uu____1342 = univ_kernel u1 in
          (match uu____1342 with
           | (k1, n1) ->
               let uu____1353 = univ_kernel u2 in
               (match uu____1353 with
                | (k2, n2) ->
                    let r = compare_univs k1 k2 in
                    if r = (Prims.parse_int "0") then n1 - n2 else r))
let (eq_univs :
  FStar_Syntax_Syntax.universe -> FStar_Syntax_Syntax.universe -> Prims.bool)
  =
  fun u1 ->
    fun u2 ->
      let uu____1384 = compare_univs u1 u2 in
      uu____1384 = (Prims.parse_int "0")
let (ml_comp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Range.range -> FStar_Syntax_Syntax.comp)
  =
  fun t ->
    fun r ->
      let uu____1403 =
        let uu____1404 =
          FStar_Ident.set_lid_range FStar_Parser_Const.effect_ML_lid r in
        {
          FStar_Syntax_Syntax.comp_univs = [FStar_Syntax_Syntax.U_zero];
          FStar_Syntax_Syntax.effect_name = uu____1404;
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = [FStar_Syntax_Syntax.MLEFFECT]
        } in
      FStar_Syntax_Syntax.mk_Comp uu____1403
let (comp_effect_name :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> FStar_Ident.lident)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1.FStar_Syntax_Syntax.effect_name
    | FStar_Syntax_Syntax.Total uu____1424 ->
        FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.GTotal uu____1433 ->
        FStar_Parser_Const.effect_GTot_lid
let (comp_flags :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.cflag Prims.list)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1456 -> [FStar_Syntax_Syntax.TOTAL]
    | FStar_Syntax_Syntax.GTotal uu____1465 ->
        [FStar_Syntax_Syntax.SOMETRIVIAL]
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.flags
let (comp_to_comp_typ_nouniv :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1
    | FStar_Syntax_Syntax.Total (t, u_opt) ->
        let uu____1492 =
          let uu____1493 = FStar_Util.map_opt u_opt (fun x -> [x]) in
          FStar_Util.dflt [] uu____1493 in
        {
          FStar_Syntax_Syntax.comp_univs = uu____1492;
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | FStar_Syntax_Syntax.GTotal (t, u_opt) ->
        let uu____1522 =
          let uu____1523 = FStar_Util.map_opt u_opt (fun x -> [x]) in
          FStar_Util.dflt [] uu____1523 in
        {
          FStar_Syntax_Syntax.comp_univs = uu____1522;
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
let (comp_set_flags :
  FStar_Syntax_Syntax.comp ->
    FStar_Syntax_Syntax.cflag Prims.list ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
  =
  fun c ->
    fun f ->
      let uu___229_1559 = c in
      let uu____1560 =
        let uu____1561 =
          let uu___231_1562 = comp_to_comp_typ_nouniv c in
          {
            FStar_Syntax_Syntax.comp_univs =
              (uu___231_1562.FStar_Syntax_Syntax.comp_univs);
            FStar_Syntax_Syntax.effect_name =
              (uu___231_1562.FStar_Syntax_Syntax.effect_name);
            FStar_Syntax_Syntax.result_typ =
              (uu___231_1562.FStar_Syntax_Syntax.result_typ);
            FStar_Syntax_Syntax.effect_args =
              (uu___231_1562.FStar_Syntax_Syntax.effect_args);
            FStar_Syntax_Syntax.flags = f
          } in
        FStar_Syntax_Syntax.Comp uu____1561 in
      {
        FStar_Syntax_Syntax.n = uu____1560;
        FStar_Syntax_Syntax.pos = (uu___229_1559.FStar_Syntax_Syntax.pos);
        FStar_Syntax_Syntax.vars = (uu___229_1559.FStar_Syntax_Syntax.vars)
      }
let (lcomp_set_flags :
  FStar_Syntax_Syntax.lcomp ->
    FStar_Syntax_Syntax.cflag Prims.list -> FStar_Syntax_Syntax.lcomp)
  =
  fun lc ->
    fun fs ->
      let comp_typ_set_flags c =
        match c.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Total uu____1588 -> c
        | FStar_Syntax_Syntax.GTotal uu____1597 -> c
        | FStar_Syntax_Syntax.Comp ct ->
            let ct1 =
              let uu___243_1608 = ct in
              {
                FStar_Syntax_Syntax.comp_univs =
                  (uu___243_1608.FStar_Syntax_Syntax.comp_univs);
                FStar_Syntax_Syntax.effect_name =
                  (uu___243_1608.FStar_Syntax_Syntax.effect_name);
                FStar_Syntax_Syntax.result_typ =
                  (uu___243_1608.FStar_Syntax_Syntax.result_typ);
                FStar_Syntax_Syntax.effect_args =
                  (uu___243_1608.FStar_Syntax_Syntax.effect_args);
                FStar_Syntax_Syntax.flags = fs
              } in
            let uu___246_1609 = c in
            {
              FStar_Syntax_Syntax.n = (FStar_Syntax_Syntax.Comp ct1);
              FStar_Syntax_Syntax.pos =
                (uu___246_1609.FStar_Syntax_Syntax.pos);
              FStar_Syntax_Syntax.vars =
                (uu___246_1609.FStar_Syntax_Syntax.vars)
            } in
      FStar_Syntax_Syntax.mk_lcomp lc.FStar_Syntax_Syntax.eff_name
        lc.FStar_Syntax_Syntax.res_typ fs
        (fun uu____1612 ->
           let uu____1613 = FStar_Syntax_Syntax.lcomp_comp lc in
           comp_typ_set_flags uu____1613)
let (comp_to_comp_typ :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.comp_typ) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 -> c1
    | FStar_Syntax_Syntax.Total (t, FStar_Pervasives_Native.Some u) ->
        {
          FStar_Syntax_Syntax.comp_univs = [u];
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | FStar_Syntax_Syntax.GTotal (t, FStar_Pervasives_Native.Some u) ->
        {
          FStar_Syntax_Syntax.comp_univs = [u];
          FStar_Syntax_Syntax.effect_name = (comp_effect_name c);
          FStar_Syntax_Syntax.result_typ = t;
          FStar_Syntax_Syntax.effect_args = [];
          FStar_Syntax_Syntax.flags = (comp_flags c)
        }
    | uu____1653 ->
        failwith "Assertion failed: Computation type without universe"
let (is_named_tot :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Tot_lid
    | FStar_Syntax_Syntax.Total uu____1668 -> true
    | FStar_Syntax_Syntax.GTotal uu____1678 -> false
let (is_total_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    (FStar_Ident.lid_equals (comp_effect_name c)
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right (comp_flags c)
         (FStar_Util.for_some
            (fun uu___0_1703 ->
               match uu___0_1703 with
               | FStar_Syntax_Syntax.TOTAL -> true
               | FStar_Syntax_Syntax.RETURN -> true
               | uu____1707 -> false)))
let (is_total_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c ->
    (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
       FStar_Parser_Const.effect_Tot_lid)
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___1_1720 ->
               match uu___1_1720 with
               | FStar_Syntax_Syntax.TOTAL -> true
               | FStar_Syntax_Syntax.RETURN -> true
               | uu____1724 -> false)))
let (is_tot_or_gtot_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c ->
    ((FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
        FStar_Parser_Const.effect_Tot_lid)
       ||
       (FStar_Ident.lid_equals c.FStar_Syntax_Syntax.eff_name
          FStar_Parser_Const.effect_GTot_lid))
      ||
      (FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___2_1737 ->
               match uu___2_1737 with
               | FStar_Syntax_Syntax.TOTAL -> true
               | FStar_Syntax_Syntax.RETURN -> true
               | uu____1741 -> false)))
let (is_partial_return :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___3_1758 ->
            match uu___3_1758 with
            | FStar_Syntax_Syntax.RETURN -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN -> true
            | uu____1762 -> false))
let (is_lcomp_partial_return : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c ->
    FStar_All.pipe_right c.FStar_Syntax_Syntax.cflags
      (FStar_Util.for_some
         (fun uu___4_1775 ->
            match uu___4_1775 with
            | FStar_Syntax_Syntax.RETURN -> true
            | FStar_Syntax_Syntax.PARTIAL_RETURN -> true
            | uu____1779 -> false))
let (is_tot_or_gtot_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    (is_total_comp c) ||
      (FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid
         (comp_effect_name c))
let (is_pure_effect : FStar_Ident.lident -> Prims.bool) =
  fun l ->
    ((FStar_Ident.lid_equals l FStar_Parser_Const.effect_Tot_lid) ||
       (FStar_Ident.lid_equals l FStar_Parser_Const.effect_PURE_lid))
      || (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Pure_lid)
let (is_pure_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____1811 -> true
    | FStar_Syntax_Syntax.GTotal uu____1821 -> false
    | FStar_Syntax_Syntax.Comp ct ->
        ((is_total_comp c) ||
           (is_pure_effect ct.FStar_Syntax_Syntax.effect_name))
          ||
          (FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___5_1836 ->
                   match uu___5_1836 with
                   | FStar_Syntax_Syntax.LEMMA -> true
                   | uu____1839 -> false)))
let (is_ghost_effect : FStar_Ident.lident -> Prims.bool) =
  fun l ->
    ((FStar_Ident.lid_equals FStar_Parser_Const.effect_GTot_lid l) ||
       (FStar_Ident.lid_equals FStar_Parser_Const.effect_GHOST_lid l))
      || (FStar_Ident.lid_equals FStar_Parser_Const.effect_Ghost_lid l)
let (is_div_effect : FStar_Ident.lident -> Prims.bool) =
  fun l ->
    ((FStar_Ident.lid_equals l FStar_Parser_Const.effect_DIV_lid) ||
       (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Div_lid))
      || (FStar_Ident.lid_equals l FStar_Parser_Const.effect_Dv_lid)
let (is_pure_or_ghost_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c -> (is_pure_comp c) || (is_ghost_effect (comp_effect_name c))
let (is_pure_or_ghost_effect : FStar_Ident.lident -> Prims.bool) =
  fun l -> (is_pure_effect l) || (is_ghost_effect l)
let (is_pure_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun lc ->
    ((is_total_lcomp lc) || (is_pure_effect lc.FStar_Syntax_Syntax.eff_name))
      ||
      (FStar_All.pipe_right lc.FStar_Syntax_Syntax.cflags
         (FStar_Util.for_some
            (fun uu___6_1884 ->
               match uu___6_1884 with
               | FStar_Syntax_Syntax.LEMMA -> true
               | uu____1887 -> false)))
let (is_pure_or_ghost_lcomp : FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun lc ->
    (is_pure_lcomp lc) || (is_ghost_effect lc.FStar_Syntax_Syntax.eff_name)
let (is_pure_or_ghost_function : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____1903 =
      let uu____1904 = FStar_Syntax_Subst.compress t in
      uu____1904.FStar_Syntax_Syntax.n in
    match uu____1903 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1908, c) -> is_pure_or_ghost_comp c
    | uu____1930 -> true
let (is_lemma_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp ct ->
        FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
          FStar_Parser_Const.effect_Lemma_lid
    | uu____1945 -> false
let (is_lemma : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____1954 =
      let uu____1955 = FStar_Syntax_Subst.compress t in
      uu____1955.FStar_Syntax_Syntax.n in
    match uu____1954 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____1959, c) -> is_lemma_comp c
    | uu____1981 -> false
let rec (head_of : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let uu____1989 =
      let uu____1990 = FStar_Syntax_Subst.compress t in
      uu____1990.FStar_Syntax_Syntax.n in
    match uu____1989 with
    | FStar_Syntax_Syntax.Tm_app (t1, uu____1994) -> head_of t1
    | FStar_Syntax_Syntax.Tm_match (t1, uu____2020) -> head_of t1
    | FStar_Syntax_Syntax.Tm_abs (uu____2057, t1, uu____2059) -> head_of t1
    | FStar_Syntax_Syntax.Tm_ascribed (t1, uu____2085, uu____2086) ->
        head_of t1
    | FStar_Syntax_Syntax.Tm_meta (t1, uu____2128) -> head_of t1
    | uu____2133 -> t
let (head_and_args :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
      Prims.list))
  =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1, args) -> (head1, args)
    | uu____2211 -> (t1, [])
let rec (head_and_args' :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.term * (FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list))
  =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_app (head1, args) ->
        let uu____2293 = head_and_args' head1 in
        (match uu____2293 with
         | (head2, args') -> (head2, (FStar_List.append args' args)))
    | uu____2362 -> (t1, [])
let (un_uinst : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_uinst (t2, uu____2389) ->
        FStar_Syntax_Subst.compress t2
    | uu____2394 -> t1
let (is_ml_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Comp c1 ->
        (FStar_Ident.lid_equals c1.FStar_Syntax_Syntax.effect_name
           FStar_Parser_Const.effect_ML_lid)
          ||
          (FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
             (FStar_Util.for_some
                (fun uu___7_2412 ->
                   match uu___7_2412 with
                   | FStar_Syntax_Syntax.MLEFFECT -> true
                   | uu____2415 -> false)))
    | uu____2417 -> false
let (comp_result :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total (t, uu____2434) -> t
    | FStar_Syntax_Syntax.GTotal (t, uu____2444) -> t
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.result_typ
let (set_result_typ :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.comp)
  =
  fun c ->
    fun t ->
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____2473 ->
          FStar_Syntax_Syntax.mk_Total t
      | FStar_Syntax_Syntax.GTotal uu____2482 ->
          FStar_Syntax_Syntax.mk_GTotal t
      | FStar_Syntax_Syntax.Comp ct ->
          FStar_Syntax_Syntax.mk_Comp
            (let uu___399_2494 = ct in
             {
               FStar_Syntax_Syntax.comp_univs =
                 (uu___399_2494.FStar_Syntax_Syntax.comp_univs);
               FStar_Syntax_Syntax.effect_name =
                 (uu___399_2494.FStar_Syntax_Syntax.effect_name);
               FStar_Syntax_Syntax.result_typ = t;
               FStar_Syntax_Syntax.effect_args =
                 (uu___399_2494.FStar_Syntax_Syntax.effect_args);
               FStar_Syntax_Syntax.flags =
                 (uu___399_2494.FStar_Syntax_Syntax.flags)
             })
let (set_result_typ_lc :
  FStar_Syntax_Syntax.lcomp ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.lcomp)
  =
  fun lc ->
    fun t ->
      FStar_Syntax_Syntax.mk_lcomp lc.FStar_Syntax_Syntax.eff_name t
        lc.FStar_Syntax_Syntax.cflags
        (fun uu____2508 ->
           let uu____2509 = FStar_Syntax_Syntax.lcomp_comp lc in
           set_result_typ uu____2509 t)
let (is_trivial_wp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun c ->
    FStar_All.pipe_right (comp_flags c)
      (FStar_Util.for_some
         (fun uu___8_2527 ->
            match uu___8_2527 with
            | FStar_Syntax_Syntax.TOTAL -> true
            | FStar_Syntax_Syntax.RETURN -> true
            | uu____2531 -> false))
let (comp_effect_args : FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.args)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Total uu____2539 -> []
    | FStar_Syntax_Syntax.GTotal uu____2556 -> []
    | FStar_Syntax_Syntax.Comp ct -> ct.FStar_Syntax_Syntax.effect_args
let (primops : FStar_Ident.lident Prims.list) =
  [FStar_Parser_Const.op_Eq;
  FStar_Parser_Const.op_notEq;
  FStar_Parser_Const.op_LT;
  FStar_Parser_Const.op_LTE;
  FStar_Parser_Const.op_GT;
  FStar_Parser_Const.op_GTE;
  FStar_Parser_Const.op_Subtraction;
  FStar_Parser_Const.op_Minus;
  FStar_Parser_Const.op_Addition;
  FStar_Parser_Const.op_Multiply;
  FStar_Parser_Const.op_Division;
  FStar_Parser_Const.op_Modulus;
  FStar_Parser_Const.op_And;
  FStar_Parser_Const.op_Or;
  FStar_Parser_Const.op_Negation]
let (is_primop_lid : FStar_Ident.lident -> Prims.bool) =
  fun l ->
    FStar_All.pipe_right primops
      (FStar_Util.for_some (FStar_Ident.lid_equals l))
let (is_primop :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.bool) =
  fun f ->
    match f.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        is_primop_lid (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____2600 -> false
let rec (unascribe : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun e ->
    let e1 = FStar_Syntax_Subst.compress e in
    match e1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_ascribed (e2, uu____2610, uu____2611) ->
        unascribe e2
    | uu____2652 -> e1
let rec (ascribe :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    ((FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax,
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax) FStar_Util.either
      * FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option) ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    fun k ->
      match t.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_ascribed (t', uu____2705, uu____2706) ->
          ascribe t' k
      | uu____2747 ->
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_ascribed
               (t, k, FStar_Pervasives_Native.None))
            FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
let (unfold_lazy : FStar_Syntax_Syntax.lazyinfo -> FStar_Syntax_Syntax.term)
  =
  fun i ->
    let uu____2774 =
      let uu____2783 = FStar_ST.op_Bang FStar_Syntax_Syntax.lazy_chooser in
      FStar_Util.must uu____2783 in
    uu____2774 i.FStar_Syntax_Syntax.lkind i
let rec (unlazy : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let uu____2839 =
      let uu____2840 = FStar_Syntax_Subst.compress t in
      uu____2840.FStar_Syntax_Syntax.n in
    match uu____2839 with
    | FStar_Syntax_Syntax.Tm_lazy i ->
        let uu____2844 = unfold_lazy i in
        FStar_All.pipe_left unlazy uu____2844
    | uu____2845 -> t
let rec (unlazy_emb : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let uu____2852 =
      let uu____2853 = FStar_Syntax_Subst.compress t in
      uu____2853.FStar_Syntax_Syntax.n in
    match uu____2852 with
    | FStar_Syntax_Syntax.Tm_lazy i ->
        (match i.FStar_Syntax_Syntax.lkind with
         | FStar_Syntax_Syntax.Lazy_embedding uu____2857 ->
             let uu____2866 = unfold_lazy i in
             FStar_All.pipe_left unlazy uu____2866
         | uu____2867 -> t)
    | uu____2868 -> t
let (eq_lazy_kind :
  FStar_Syntax_Syntax.lazy_kind ->
    FStar_Syntax_Syntax.lazy_kind -> Prims.bool)
  =
  fun k ->
    fun k' ->
      match (k, k') with
      | (FStar_Syntax_Syntax.BadLazy, FStar_Syntax_Syntax.BadLazy) -> true
      | (FStar_Syntax_Syntax.Lazy_bv, FStar_Syntax_Syntax.Lazy_bv) -> true
      | (FStar_Syntax_Syntax.Lazy_binder, FStar_Syntax_Syntax.Lazy_binder) ->
          true
      | (FStar_Syntax_Syntax.Lazy_fvar, FStar_Syntax_Syntax.Lazy_fvar) ->
          true
      | (FStar_Syntax_Syntax.Lazy_comp, FStar_Syntax_Syntax.Lazy_comp) ->
          true
      | (FStar_Syntax_Syntax.Lazy_env, FStar_Syntax_Syntax.Lazy_env) -> true
      | (FStar_Syntax_Syntax.Lazy_proofstate,
         FStar_Syntax_Syntax.Lazy_proofstate) -> true
      | (FStar_Syntax_Syntax.Lazy_goal, FStar_Syntax_Syntax.Lazy_goal) ->
          true
      | (FStar_Syntax_Syntax.Lazy_sigelt, FStar_Syntax_Syntax.Lazy_sigelt) ->
          true
      | (FStar_Syntax_Syntax.Lazy_uvar, FStar_Syntax_Syntax.Lazy_uvar) ->
          true
      | uu____2892 -> false
let rec unlazy_as_t :
  'Auu____2905 .
    FStar_Syntax_Syntax.lazy_kind -> FStar_Syntax_Syntax.term -> 'Auu____2905
  =
  fun k ->
    fun t ->
      let uu____2916 =
        let uu____2917 = FStar_Syntax_Subst.compress t in
        uu____2917.FStar_Syntax_Syntax.n in
      match uu____2916 with
      | FStar_Syntax_Syntax.Tm_lazy
          { FStar_Syntax_Syntax.blob = v1; FStar_Syntax_Syntax.lkind = k';
            FStar_Syntax_Syntax.ltyp = uu____2922;
            FStar_Syntax_Syntax.rng = uu____2923;_}
          when eq_lazy_kind k k' -> FStar_Dyn.undyn v1
      | uu____2926 -> failwith "Not a Tm_lazy of the expected kind"
let mk_lazy :
  'a .
    'a ->
      FStar_Syntax_Syntax.typ ->
        FStar_Syntax_Syntax.lazy_kind ->
          FStar_Range.range FStar_Pervasives_Native.option ->
            FStar_Syntax_Syntax.term
  =
  fun t ->
    fun typ ->
      fun k ->
        fun r ->
          let rng =
            match r with
            | FStar_Pervasives_Native.Some r1 -> r1
            | FStar_Pervasives_Native.None -> FStar_Range.dummyRange in
          let i =
            let uu____2967 = FStar_Dyn.mkdyn t in
            {
              FStar_Syntax_Syntax.blob = uu____2967;
              FStar_Syntax_Syntax.lkind = k;
              FStar_Syntax_Syntax.ltyp = typ;
              FStar_Syntax_Syntax.rng = rng
            } in
          FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_lazy i)
            FStar_Pervasives_Native.None rng
let (canon_app :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    let uu____2980 =
      let uu____2995 = unascribe t in head_and_args' uu____2995 in
    match uu____2980 with
    | (hd1, args) ->
        FStar_Syntax_Syntax.mk_Tm_app hd1 args FStar_Pervasives_Native.None
          t.FStar_Syntax_Syntax.pos
type eq_result =
  | Equal 
  | NotEqual 
  | Unknown 
let (uu___is_Equal : eq_result -> Prims.bool) =
  fun projectee -> match projectee with | Equal -> true | uu____3029 -> false
let (uu___is_NotEqual : eq_result -> Prims.bool) =
  fun projectee ->
    match projectee with | NotEqual -> true | uu____3040 -> false
let (uu___is_Unknown : eq_result -> Prims.bool) =
  fun projectee ->
    match projectee with | Unknown -> true | uu____3051 -> false
let (injectives : Prims.string Prims.list) =
  ["FStar.Int8.int_to_t";
  "FStar.Int16.int_to_t";
  "FStar.Int32.int_to_t";
  "FStar.Int64.int_to_t";
  "FStar.UInt8.uint_to_t";
  "FStar.UInt16.uint_to_t";
  "FStar.UInt32.uint_to_t";
  "FStar.UInt64.uint_to_t";
  "FStar.Int8.__int_to_t";
  "FStar.Int16.__int_to_t";
  "FStar.Int32.__int_to_t";
  "FStar.Int64.__int_to_t";
  "FStar.UInt8.__uint_to_t";
  "FStar.UInt16.__uint_to_t";
  "FStar.UInt32.__uint_to_t";
  "FStar.UInt64.__uint_to_t"]
let (eq_inj : eq_result -> eq_result -> eq_result) =
  fun f ->
    fun g ->
      match (f, g) with
      | (Equal, Equal) -> Equal
      | (NotEqual, uu____3101) -> NotEqual
      | (uu____3102, NotEqual) -> NotEqual
      | (Unknown, uu____3103) -> Unknown
      | (uu____3104, Unknown) -> Unknown
let rec (eq_tm :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> eq_result) =
  fun t1 ->
    fun t2 ->
      let t11 = canon_app t1 in
      let t21 = canon_app t2 in
      let equal_if uu___9_3225 = if uu___9_3225 then Equal else Unknown in
      let equal_iff uu___10_3236 = if uu___10_3236 then Equal else NotEqual in
      let eq_and f g = match f with | Equal -> g () | uu____3257 -> Unknown in
      let equal_data f1 args1 f2 args2 =
        let uu____3279 = FStar_Syntax_Syntax.fv_eq f1 f2 in
        if uu____3279
        then
          let uu____3283 = FStar_List.zip args1 args2 in
          FStar_All.pipe_left
            (FStar_List.fold_left
               (fun acc ->
                  fun uu____3360 ->
                    match uu____3360 with
                    | ((a1, q1), (a2, q2)) ->
                        let uu____3401 = eq_tm a1 a2 in eq_inj acc uu____3401)
               Equal) uu____3283
        else NotEqual in
      let heads_and_args_in_case_both_data =
        let uu____3415 =
          let uu____3432 = FStar_All.pipe_right t11 unmeta in
          FStar_All.pipe_right uu____3432 head_and_args in
        match uu____3415 with
        | (head1, args1) ->
            let uu____3485 =
              let uu____3502 = FStar_All.pipe_right t21 unmeta in
              FStar_All.pipe_right uu____3502 head_and_args in
            (match uu____3485 with
             | (head2, args2) ->
                 let uu____3555 =
                   let uu____3560 =
                     let uu____3561 = un_uinst head1 in
                     uu____3561.FStar_Syntax_Syntax.n in
                   let uu____3564 =
                     let uu____3565 = un_uinst head2 in
                     uu____3565.FStar_Syntax_Syntax.n in
                   (uu____3560, uu____3564) in
                 (match uu____3555 with
                  | (FStar_Syntax_Syntax.Tm_fvar f,
                     FStar_Syntax_Syntax.Tm_fvar g) when
                      (f.FStar_Syntax_Syntax.fv_qual =
                         (FStar_Pervasives_Native.Some
                            FStar_Syntax_Syntax.Data_ctor))
                        &&
                        (g.FStar_Syntax_Syntax.fv_qual =
                           (FStar_Pervasives_Native.Some
                              FStar_Syntax_Syntax.Data_ctor))
                      -> FStar_Pervasives_Native.Some (f, args1, g, args2)
                  | uu____3592 -> FStar_Pervasives_Native.None)) in
      let uu____3605 =
        let uu____3610 =
          let uu____3611 = unmeta t11 in uu____3611.FStar_Syntax_Syntax.n in
        let uu____3614 =
          let uu____3615 = unmeta t21 in uu____3615.FStar_Syntax_Syntax.n in
        (uu____3610, uu____3614) in
      match uu____3605 with
      | (FStar_Syntax_Syntax.Tm_bvar bv1, FStar_Syntax_Syntax.Tm_bvar bv2) ->
          equal_if
            (bv1.FStar_Syntax_Syntax.index = bv2.FStar_Syntax_Syntax.index)
      | (FStar_Syntax_Syntax.Tm_lazy uu____3621, uu____3622) ->
          let uu____3623 = unlazy t11 in eq_tm uu____3623 t21
      | (uu____3624, FStar_Syntax_Syntax.Tm_lazy uu____3625) ->
          let uu____3626 = unlazy t21 in eq_tm t11 uu____3626
      | (FStar_Syntax_Syntax.Tm_name a, FStar_Syntax_Syntax.Tm_name b) ->
          equal_if (FStar_Syntax_Syntax.bv_eq a b)
      | uu____3629 when
          FStar_All.pipe_right heads_and_args_in_case_both_data
            FStar_Util.is_some
          ->
          let uu____3653 =
            FStar_All.pipe_right heads_and_args_in_case_both_data
              FStar_Util.must in
          FStar_All.pipe_right uu____3653
            (fun uu____3701 ->
               match uu____3701 with
               | (f, args1, g, args2) -> equal_data f args1 g args2)
      | (FStar_Syntax_Syntax.Tm_fvar f, FStar_Syntax_Syntax.Tm_fvar g) ->
          let uu____3716 = FStar_Syntax_Syntax.fv_eq f g in
          equal_if uu____3716
      | (FStar_Syntax_Syntax.Tm_uinst (f, us), FStar_Syntax_Syntax.Tm_uinst
         (g, vs)) ->
          let uu____3730 = eq_tm f g in
          eq_and uu____3730
            (fun uu____3733 ->
               let uu____3734 = eq_univs_list us vs in equal_if uu____3734)
      | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
         uu____3736), uu____3737) -> Unknown
      | (uu____3738, FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
         uu____3739)) -> Unknown
      | (FStar_Syntax_Syntax.Tm_constant c, FStar_Syntax_Syntax.Tm_constant
         d) ->
          let uu____3742 = FStar_Const.eq_const c d in equal_iff uu____3742
      | (FStar_Syntax_Syntax.Tm_uvar (u1, ([], uu____3745)),
         FStar_Syntax_Syntax.Tm_uvar (u2, ([], uu____3747))) ->
          let uu____3776 =
            FStar_Syntax_Unionfind.equiv u1.FStar_Syntax_Syntax.ctx_uvar_head
              u2.FStar_Syntax_Syntax.ctx_uvar_head in
          equal_if uu____3776
      | (FStar_Syntax_Syntax.Tm_app (h1, args1), FStar_Syntax_Syntax.Tm_app
         (h2, args2)) ->
          let uu____3830 =
            let uu____3835 =
              let uu____3836 = un_uinst h1 in
              uu____3836.FStar_Syntax_Syntax.n in
            let uu____3839 =
              let uu____3840 = un_uinst h2 in
              uu____3840.FStar_Syntax_Syntax.n in
            (uu____3835, uu____3839) in
          (match uu____3830 with
           | (FStar_Syntax_Syntax.Tm_fvar f1, FStar_Syntax_Syntax.Tm_fvar f2)
               when
               (FStar_Syntax_Syntax.fv_eq f1 f2) &&
                 (let uu____3846 =
                    let uu____3848 = FStar_Syntax_Syntax.lid_of_fv f1 in
                    FStar_Ident.string_of_lid uu____3848 in
                  FStar_List.mem uu____3846 injectives)
               -> equal_data f1 args1 f2 args2
           | uu____3850 ->
               let uu____3855 = eq_tm h1 h2 in
               eq_and uu____3855 (fun uu____3857 -> eq_args args1 args2))
      | (FStar_Syntax_Syntax.Tm_match (t12, bs1),
         FStar_Syntax_Syntax.Tm_match (t22, bs2)) ->
          if (FStar_List.length bs1) = (FStar_List.length bs2)
          then
            let uu____3963 = FStar_List.zip bs1 bs2 in
            let uu____4026 = eq_tm t12 t22 in
            FStar_List.fold_right
              (fun uu____4063 ->
                 fun a ->
                   match uu____4063 with
                   | (b1, b2) ->
                       eq_and a (fun uu____4156 -> branch_matches b1 b2))
              uu____3963 uu____4026
          else Unknown
      | (FStar_Syntax_Syntax.Tm_type u, FStar_Syntax_Syntax.Tm_type v1) ->
          let uu____4161 = eq_univs u v1 in equal_if uu____4161
      | (FStar_Syntax_Syntax.Tm_quoted (t12, q1),
         FStar_Syntax_Syntax.Tm_quoted (t22, q2)) ->
          let uu____4175 = eq_quoteinfo q1 q2 in
          eq_and uu____4175 (fun uu____4177 -> eq_tm t12 t22)
      | (FStar_Syntax_Syntax.Tm_refine (t12, phi1),
         FStar_Syntax_Syntax.Tm_refine (t22, phi2)) ->
          let uu____4190 =
            eq_tm t12.FStar_Syntax_Syntax.sort t22.FStar_Syntax_Syntax.sort in
          eq_and uu____4190 (fun uu____4192 -> eq_tm phi1 phi2)
      | uu____4193 -> Unknown
and (eq_quoteinfo :
  FStar_Syntax_Syntax.quoteinfo -> FStar_Syntax_Syntax.quoteinfo -> eq_result)
  =
  fun q1 ->
    fun q2 ->
      if q1.FStar_Syntax_Syntax.qkind <> q2.FStar_Syntax_Syntax.qkind
      then NotEqual
      else
        eq_antiquotes q1.FStar_Syntax_Syntax.antiquotes
          q2.FStar_Syntax_Syntax.antiquotes
and (eq_antiquotes :
  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term'
    FStar_Syntax_Syntax.syntax) Prims.list ->
    (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax) Prims.list -> eq_result)
  =
  fun a1 ->
    fun a2 ->
      match (a1, a2) with
      | ([], []) -> Equal
      | ([], uu____4265) -> NotEqual
      | (uu____4296, []) -> NotEqual
      | ((x1, t1)::a11, (x2, t2)::a21) ->
          if Prims.op_Negation (FStar_Syntax_Syntax.bv_eq x1 x2)
          then NotEqual
          else
            (let uu____4388 = eq_tm t1 t2 in
             match uu____4388 with
             | NotEqual -> NotEqual
             | Unknown ->
                 let uu____4389 = eq_antiquotes a11 a21 in
                 (match uu____4389 with
                  | NotEqual -> NotEqual
                  | uu____4390 -> Unknown)
             | Equal -> eq_antiquotes a11 a21)
and (eq_aqual :
  FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option ->
      eq_result)
  =
  fun a1 ->
    fun a2 ->
      match (a1, a2) with
      | (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None) -> Equal
      | (FStar_Pervasives_Native.None, uu____4405) -> NotEqual
      | (uu____4412, FStar_Pervasives_Native.None) -> NotEqual
      | (FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit b1),
         FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit b2)) when
          b1 = b2 -> Equal
      | (FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t1),
         FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Meta t2)) ->
          eq_tm t1 t2
      | (FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Equality),
         FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Equality)) ->
          Equal
      | uu____4442 -> NotEqual
and (branch_matches :
  (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t *
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
    FStar_Pervasives_Native.option * FStar_Syntax_Syntax.term'
    FStar_Syntax_Syntax.syntax) ->
    (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t *
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax) -> eq_result)
  =
  fun b1 ->
    fun b2 ->
      let related_by f o1 o2 =
        match (o1, o2) with
        | (FStar_Pervasives_Native.None, FStar_Pervasives_Native.None) ->
            true
        | (FStar_Pervasives_Native.Some x, FStar_Pervasives_Native.Some y) ->
            f x y
        | (uu____4534, uu____4535) -> false in
      let uu____4545 = b1 in
      match uu____4545 with
      | (p1, w1, t1) ->
          let uu____4579 = b2 in
          (match uu____4579 with
           | (p2, w2, t2) ->
               let uu____4613 = FStar_Syntax_Syntax.eq_pat p1 p2 in
               if uu____4613
               then
                 let uu____4616 =
                   (let uu____4620 = eq_tm t1 t2 in uu____4620 = Equal) &&
                     (related_by
                        (fun t11 ->
                           fun t21 ->
                             let uu____4629 = eq_tm t11 t21 in
                             uu____4629 = Equal) w1 w2) in
                 (if uu____4616 then Equal else Unknown)
               else Unknown)
and (eq_args :
  FStar_Syntax_Syntax.args -> FStar_Syntax_Syntax.args -> eq_result) =
  fun a1 ->
    fun a2 ->
      match (a1, a2) with
      | ([], []) -> Equal
      | ((a, uu____4694)::a11, (b, uu____4697)::b1) ->
          let uu____4771 = eq_tm a b in
          (match uu____4771 with
           | Equal -> eq_args a11 b1
           | uu____4772 -> Unknown)
      | uu____4773 -> Unknown
and (eq_univs_list :
  FStar_Syntax_Syntax.universes ->
    FStar_Syntax_Syntax.universes -> Prims.bool)
  =
  fun us ->
    fun vs ->
      ((FStar_List.length us) = (FStar_List.length vs)) &&
        (FStar_List.forall2 eq_univs us vs)
let rec (unrefine : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x, uu____4809) ->
        unrefine x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2, uu____4815, uu____4816) ->
        unrefine t2
    | uu____4857 -> t1
let rec (is_uvar : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____4865 =
      let uu____4866 = FStar_Syntax_Subst.compress t in
      uu____4866.FStar_Syntax_Syntax.n in
    match uu____4865 with
    | FStar_Syntax_Syntax.Tm_uvar uu____4870 -> true
    | FStar_Syntax_Syntax.Tm_uinst (t1, uu____4885) -> is_uvar t1
    | FStar_Syntax_Syntax.Tm_app uu____4890 ->
        let uu____4907 =
          let uu____4908 = FStar_All.pipe_right t head_and_args in
          FStar_All.pipe_right uu____4908 FStar_Pervasives_Native.fst in
        FStar_All.pipe_right uu____4907 is_uvar
    | FStar_Syntax_Syntax.Tm_ascribed (t1, uu____4971, uu____4972) ->
        is_uvar t1
    | uu____5013 -> false
let rec (is_unit : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____5022 =
      let uu____5023 = unrefine t in uu____5023.FStar_Syntax_Syntax.n in
    match uu____5022 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
           (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid))
          ||
          (FStar_Syntax_Syntax.fv_eq_lid fv
             FStar_Parser_Const.auto_squash_lid)
    | FStar_Syntax_Syntax.Tm_app (head1, uu____5029) -> is_unit head1
    | FStar_Syntax_Syntax.Tm_uinst (t1, uu____5055) -> is_unit t1
    | uu____5060 -> false
let (is_eqtype_no_unrefine : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____5069 =
      let uu____5070 = FStar_Syntax_Subst.compress t in
      uu____5070.FStar_Syntax_Syntax.n in
    match uu____5069 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.eqtype_lid
    | uu____5075 -> false
let rec (non_informative : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____5084 =
      let uu____5085 = unrefine t in uu____5085.FStar_Syntax_Syntax.n in
    match uu____5084 with
    | FStar_Syntax_Syntax.Tm_type uu____5089 -> true
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.unit_lid) ||
           (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid))
          || (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.erased_lid)
    | FStar_Syntax_Syntax.Tm_app (head1, uu____5093) -> non_informative head1
    | FStar_Syntax_Syntax.Tm_uinst (t1, uu____5119) -> non_informative t1
    | FStar_Syntax_Syntax.Tm_arrow (uu____5124, c) ->
        (is_tot_or_gtot_comp c) && (non_informative (comp_result c))
    | uu____5146 -> false
let (is_fun : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun e ->
    let uu____5155 =
      let uu____5156 = FStar_Syntax_Subst.compress e in
      uu____5156.FStar_Syntax_Syntax.n in
    match uu____5155 with
    | FStar_Syntax_Syntax.Tm_abs uu____5160 -> true
    | uu____5180 -> false
let (is_function_typ : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____5189 =
      let uu____5190 = FStar_Syntax_Subst.compress t in
      uu____5190.FStar_Syntax_Syntax.n in
    match uu____5189 with
    | FStar_Syntax_Syntax.Tm_arrow uu____5194 -> true
    | uu____5210 -> false
let rec (pre_typ : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_refine (x, uu____5220) ->
        pre_typ x.FStar_Syntax_Syntax.sort
    | FStar_Syntax_Syntax.Tm_ascribed (t2, uu____5226, uu____5227) ->
        pre_typ t2
    | uu____5268 -> t1
let (destruct :
  FStar_Syntax_Syntax.term ->
    FStar_Ident.lident ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
        FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
        Prims.list FStar_Pervasives_Native.option)
  =
  fun typ ->
    fun lid ->
      let typ1 = FStar_Syntax_Subst.compress typ in
      let uu____5293 =
        let uu____5294 = un_uinst typ1 in uu____5294.FStar_Syntax_Syntax.n in
      match uu____5293 with
      | FStar_Syntax_Syntax.Tm_app (head1, args) ->
          let head2 = un_uinst head1 in
          (match head2.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Tm_fvar tc when
               FStar_Syntax_Syntax.fv_eq_lid tc lid ->
               FStar_Pervasives_Native.Some args
           | uu____5359 -> FStar_Pervasives_Native.None)
      | FStar_Syntax_Syntax.Tm_fvar tc when
          FStar_Syntax_Syntax.fv_eq_lid tc lid ->
          FStar_Pervasives_Native.Some []
      | uu____5389 -> FStar_Pervasives_Native.None
let (lids_of_sigelt :
  FStar_Syntax_Syntax.sigelt -> FStar_Ident.lident Prims.list) =
  fun se ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_let (uu____5410, lids) -> lids
    | FStar_Syntax_Syntax.Sig_splice (lids, uu____5417) -> lids
    | FStar_Syntax_Syntax.Sig_bundle (uu____5422, lids) -> lids
    | FStar_Syntax_Syntax.Sig_inductive_typ
        (lid, uu____5433, uu____5434, uu____5435, uu____5436, uu____5437) ->
        [lid]
    | FStar_Syntax_Syntax.Sig_effect_abbrev
        (lid, uu____5447, uu____5448, uu____5449, uu____5450) -> [lid]
    | FStar_Syntax_Syntax.Sig_datacon
        (lid, uu____5456, uu____5457, uu____5458, uu____5459, uu____5460) ->
        [lid]
    | FStar_Syntax_Syntax.Sig_declare_typ (lid, uu____5468, uu____5469) ->
        [lid]
    | FStar_Syntax_Syntax.Sig_assume (lid, uu____5471, uu____5472) -> [lid]
    | FStar_Syntax_Syntax.Sig_new_effect_for_free n1 ->
        [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_new_effect n1 -> [n1.FStar_Syntax_Syntax.mname]
    | FStar_Syntax_Syntax.Sig_sub_effect uu____5475 -> []
    | FStar_Syntax_Syntax.Sig_pragma uu____5476 -> []
    | FStar_Syntax_Syntax.Sig_main uu____5477 -> []
let (lid_of_sigelt :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Ident.lident FStar_Pervasives_Native.option)
  =
  fun se ->
    match lids_of_sigelt se with
    | l::[] -> FStar_Pervasives_Native.Some l
    | uu____5491 -> FStar_Pervasives_Native.None
let (quals_of_sigelt :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.qualifier Prims.list) =
  fun x -> x.FStar_Syntax_Syntax.sigquals
let (range_of_sigelt : FStar_Syntax_Syntax.sigelt -> FStar_Range.range) =
  fun x -> x.FStar_Syntax_Syntax.sigrng
let (range_of_lbname :
  (FStar_Syntax_Syntax.bv, FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Range.range)
  =
  fun uu___11_5517 ->
    match uu___11_5517 with
    | FStar_Util.Inl x -> FStar_Syntax_Syntax.range_of_bv x
    | FStar_Util.Inr fv ->
        FStar_Ident.range_of_lid
          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
let range_of_arg :
  'Auu____5531 'Auu____5532 .
    ('Auu____5531 FStar_Syntax_Syntax.syntax * 'Auu____5532) ->
      FStar_Range.range
  =
  fun uu____5543 ->
    match uu____5543 with | (hd1, uu____5551) -> hd1.FStar_Syntax_Syntax.pos
let range_of_args :
  'Auu____5565 'Auu____5566 .
    ('Auu____5565 FStar_Syntax_Syntax.syntax * 'Auu____5566) Prims.list ->
      FStar_Range.range -> FStar_Range.range
  =
  fun args ->
    fun r ->
      FStar_All.pipe_right args
        (FStar_List.fold_left
           (fun r1 -> fun a -> FStar_Range.union_ranges r1 (range_of_arg a))
           r)
let (mk_app :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
      Prims.list -> FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun f ->
    fun args ->
      match args with
      | [] -> f
      | uu____5664 ->
          let r = range_of_args args f.FStar_Syntax_Syntax.pos in
          FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_app (f, args))
            FStar_Pervasives_Native.None r
let (mk_app_binders :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun f ->
    fun bs ->
      let uu____5723 =
        FStar_List.map
          (fun uu____5750 ->
             match uu____5750 with
             | (bv, aq) ->
                 let uu____5769 = FStar_Syntax_Syntax.bv_to_name bv in
                 (uu____5769, aq)) bs in
      mk_app f uu____5723
let (mk_data :
  FStar_Ident.lident ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
      Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
        FStar_Syntax_Syntax.syntax)
  =
  fun l ->
    fun args ->
      match args with
      | [] ->
          let uu____5819 = FStar_Ident.range_of_lid l in
          let uu____5820 =
            let uu____5829 =
              FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
            FStar_Syntax_Syntax.mk uu____5829 in
          uu____5820 FStar_Pervasives_Native.None uu____5819
      | uu____5834 ->
          let e =
            let uu____5848 =
              FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
                (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
            mk_app uu____5848 args in
          FStar_Syntax_Syntax.mk e FStar_Pervasives_Native.None
            e.FStar_Syntax_Syntax.pos
let (field_projector_prefix : Prims.string) = "__proj__"
let (field_projector_sep : Prims.string) = "__item__"
let (field_projector_contains_constructor : Prims.string -> Prims.bool) =
  fun s -> FStar_Util.starts_with s field_projector_prefix
let (mk_field_projector_name_from_string :
  Prims.string -> Prims.string -> Prims.string) =
  fun constr ->
    fun field ->
      Prims.op_Hat field_projector_prefix
        (Prims.op_Hat constr (Prims.op_Hat field_projector_sep field))
let (mk_field_projector_name_from_ident :
  FStar_Ident.lident -> FStar_Ident.ident -> FStar_Ident.lident) =
  fun lid ->
    fun i ->
      let itext = i.FStar_Ident.idText in
      let newi =
        if field_projector_contains_constructor itext
        then i
        else
          FStar_Ident.mk_ident
            ((mk_field_projector_name_from_string
                (lid.FStar_Ident.ident).FStar_Ident.idText itext),
              (i.FStar_Ident.idRange)) in
      FStar_Ident.lid_of_ids (FStar_List.append lid.FStar_Ident.ns [newi])
let (mk_field_projector_name :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.bv ->
      Prims.int -> (FStar_Ident.lident * FStar_Syntax_Syntax.bv))
  =
  fun lid ->
    fun x ->
      fun i ->
        let nm =
          let uu____5925 = FStar_Syntax_Syntax.is_null_bv x in
          if uu____5925
          then
            let uu____5928 =
              let uu____5934 =
                let uu____5936 = FStar_Util.string_of_int i in
                Prims.op_Hat "_" uu____5936 in
              let uu____5939 = FStar_Syntax_Syntax.range_of_bv x in
              (uu____5934, uu____5939) in
            FStar_Ident.mk_ident uu____5928
          else x.FStar_Syntax_Syntax.ppname in
        let y =
          let uu___993_5944 = x in
          {
            FStar_Syntax_Syntax.ppname = nm;
            FStar_Syntax_Syntax.index =
              (uu___993_5944.FStar_Syntax_Syntax.index);
            FStar_Syntax_Syntax.sort =
              (uu___993_5944.FStar_Syntax_Syntax.sort)
          } in
        let uu____5945 = mk_field_projector_name_from_ident lid nm in
        (uu____5945, y)
let (ses_of_sigbundle :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list) =
  fun se ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_bundle (ses, uu____5957) -> ses
    | uu____5966 -> failwith "ses_of_sigbundle: not a Sig_bundle"
let (eff_decl_of_new_effect :
  FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.eff_decl) =
  fun se ->
    match se.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_new_effect ne -> ne
    | uu____5977 -> failwith "eff_decl_of_new_effect: not a Sig_new_effect"
let (set_uvar : FStar_Syntax_Syntax.uvar -> FStar_Syntax_Syntax.term -> unit)
  =
  fun uv ->
    fun t ->
      let uu____5990 = FStar_Syntax_Unionfind.find uv in
      match uu____5990 with
      | FStar_Pervasives_Native.Some uu____5993 ->
          let uu____5994 =
            let uu____5996 =
              let uu____5998 = FStar_Syntax_Unionfind.uvar_id uv in
              FStar_All.pipe_left FStar_Util.string_of_int uu____5998 in
            FStar_Util.format1 "Changing a fixed uvar! ?%s\n" uu____5996 in
          failwith uu____5994
      | uu____6003 -> FStar_Syntax_Unionfind.change uv t
let (qualifier_equal :
  FStar_Syntax_Syntax.qualifier ->
    FStar_Syntax_Syntax.qualifier -> Prims.bool)
  =
  fun q1 ->
    fun q2 ->
      match (q1, q2) with
      | (FStar_Syntax_Syntax.Discriminator l1,
         FStar_Syntax_Syntax.Discriminator l2) ->
          FStar_Ident.lid_equals l1 l2
      | (FStar_Syntax_Syntax.Projector (l1a, l1b),
         FStar_Syntax_Syntax.Projector (l2a, l2b)) ->
          (FStar_Ident.lid_equals l1a l2a) &&
            (l1b.FStar_Ident.idText = l2b.FStar_Ident.idText)
      | (FStar_Syntax_Syntax.RecordType (ns1, f1),
         FStar_Syntax_Syntax.RecordType (ns2, f2)) ->
          ((((FStar_List.length ns1) = (FStar_List.length ns2)) &&
              (FStar_List.forall2
                 (fun x1 ->
                    fun x2 -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
                 f1 f2))
             && ((FStar_List.length f1) = (FStar_List.length f2)))
            &&
            (FStar_List.forall2
               (fun x1 ->
                  fun x2 -> x1.FStar_Ident.idText = x2.FStar_Ident.idText) f1
               f2)
      | (FStar_Syntax_Syntax.RecordConstructor (ns1, f1),
         FStar_Syntax_Syntax.RecordConstructor (ns2, f2)) ->
          ((((FStar_List.length ns1) = (FStar_List.length ns2)) &&
              (FStar_List.forall2
                 (fun x1 ->
                    fun x2 -> x1.FStar_Ident.idText = x2.FStar_Ident.idText)
                 f1 f2))
             && ((FStar_List.length f1) = (FStar_List.length f2)))
            &&
            (FStar_List.forall2
               (fun x1 ->
                  fun x2 -> x1.FStar_Ident.idText = x2.FStar_Ident.idText) f1
               f2)
      | uu____6086 -> q1 = q2
let (abs :
  FStar_Syntax_Syntax.binders ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs ->
    fun t ->
      fun lopt ->
        let close_lopt lopt1 =
          match lopt1 with
          | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
          | FStar_Pervasives_Native.Some rc ->
              let uu____6132 =
                let uu___1054_6133 = rc in
                let uu____6134 =
                  FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                    (FStar_Syntax_Subst.close bs) in
                {
                  FStar_Syntax_Syntax.residual_effect =
                    (uu___1054_6133.FStar_Syntax_Syntax.residual_effect);
                  FStar_Syntax_Syntax.residual_typ = uu____6134;
                  FStar_Syntax_Syntax.residual_flags =
                    (uu___1054_6133.FStar_Syntax_Syntax.residual_flags)
                } in
              FStar_Pervasives_Native.Some uu____6132 in
        match bs with
        | [] -> t
        | uu____6151 ->
            let body =
              let uu____6153 = FStar_Syntax_Subst.close bs t in
              FStar_Syntax_Subst.compress uu____6153 in
            (match body.FStar_Syntax_Syntax.n with
             | FStar_Syntax_Syntax.Tm_abs (bs', t1, lopt') ->
                 let uu____6183 =
                   let uu____6190 =
                     let uu____6191 =
                       let uu____6210 =
                         let uu____6219 = FStar_Syntax_Subst.close_binders bs in
                         FStar_List.append uu____6219 bs' in
                       let uu____6234 = close_lopt lopt' in
                       (uu____6210, t1, uu____6234) in
                     FStar_Syntax_Syntax.Tm_abs uu____6191 in
                   FStar_Syntax_Syntax.mk uu____6190 in
                 uu____6183 FStar_Pervasives_Native.None
                   t1.FStar_Syntax_Syntax.pos
             | uu____6249 ->
                 let uu____6250 =
                   let uu____6257 =
                     let uu____6258 =
                       let uu____6277 = FStar_Syntax_Subst.close_binders bs in
                       let uu____6286 = close_lopt lopt in
                       (uu____6277, body, uu____6286) in
                     FStar_Syntax_Syntax.Tm_abs uu____6258 in
                   FStar_Syntax_Syntax.mk uu____6257 in
                 uu____6250 FStar_Pervasives_Native.None
                   t.FStar_Syntax_Syntax.pos)
let (arrow :
  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
    FStar_Pervasives_Native.option) Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs ->
    fun c ->
      match bs with
      | [] -> comp_result c
      | uu____6342 ->
          let uu____6351 =
            let uu____6358 =
              let uu____6359 =
                let uu____6374 = FStar_Syntax_Subst.close_binders bs in
                let uu____6383 = FStar_Syntax_Subst.close_comp bs c in
                (uu____6374, uu____6383) in
              FStar_Syntax_Syntax.Tm_arrow uu____6359 in
            FStar_Syntax_Syntax.mk uu____6358 in
          uu____6351 FStar_Pervasives_Native.None c.FStar_Syntax_Syntax.pos
let (flat_arrow :
  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
    FStar_Pervasives_Native.option) Prims.list ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun bs ->
    fun c ->
      let t = arrow bs c in
      let uu____6432 =
        let uu____6433 = FStar_Syntax_Subst.compress t in
        uu____6433.FStar_Syntax_Syntax.n in
      match uu____6432 with
      | FStar_Syntax_Syntax.Tm_arrow (bs1, c1) ->
          (match c1.FStar_Syntax_Syntax.n with
           | FStar_Syntax_Syntax.Total (tres, uu____6463) ->
               let uu____6472 =
                 let uu____6473 = FStar_Syntax_Subst.compress tres in
                 uu____6473.FStar_Syntax_Syntax.n in
               (match uu____6472 with
                | FStar_Syntax_Syntax.Tm_arrow (bs', c') ->
                    FStar_Syntax_Syntax.mk
                      (FStar_Syntax_Syntax.Tm_arrow
                         ((FStar_List.append bs1 bs'), c'))
                      FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
                | uu____6516 -> t)
           | uu____6517 -> t)
      | uu____6518 -> t
let (refine :
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun b ->
    fun t ->
      let uu____6536 =
        let uu____6537 = FStar_Syntax_Syntax.range_of_bv b in
        FStar_Range.union_ranges uu____6537 t.FStar_Syntax_Syntax.pos in
      let uu____6538 =
        let uu____6545 =
          let uu____6546 =
            let uu____6553 =
              let uu____6556 =
                let uu____6557 = FStar_Syntax_Syntax.mk_binder b in
                [uu____6557] in
              FStar_Syntax_Subst.close uu____6556 t in
            (b, uu____6553) in
          FStar_Syntax_Syntax.Tm_refine uu____6546 in
        FStar_Syntax_Syntax.mk uu____6545 in
      uu____6538 FStar_Pervasives_Native.None uu____6536
let (branch : FStar_Syntax_Syntax.branch -> FStar_Syntax_Syntax.branch) =
  fun b -> FStar_Syntax_Subst.close_branch b
let rec (arrow_formals_comp :
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list * FStar_Syntax_Syntax.comp))
  =
  fun k ->
    let k1 = FStar_Syntax_Subst.compress k in
    match k1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (bs, c) ->
        let uu____6637 = FStar_Syntax_Subst.open_comp bs c in
        (match uu____6637 with
         | (bs1, c1) ->
             let uu____6656 = is_total_comp c1 in
             if uu____6656
             then
               let uu____6671 = arrow_formals_comp (comp_result c1) in
               (match uu____6671 with
                | (bs', k2) -> ((FStar_List.append bs1 bs'), k2))
             else (bs1, c1))
    | FStar_Syntax_Syntax.Tm_refine
        ({ FStar_Syntax_Syntax.ppname = uu____6738;
           FStar_Syntax_Syntax.index = uu____6739;
           FStar_Syntax_Syntax.sort = s;_},
         uu____6741)
        ->
        let rec aux s1 k2 =
          let uu____6772 =
            let uu____6773 = FStar_Syntax_Subst.compress s1 in
            uu____6773.FStar_Syntax_Syntax.n in
          match uu____6772 with
          | FStar_Syntax_Syntax.Tm_arrow uu____6788 -> arrow_formals_comp s1
          | FStar_Syntax_Syntax.Tm_refine
              ({ FStar_Syntax_Syntax.ppname = uu____6803;
                 FStar_Syntax_Syntax.index = uu____6804;
                 FStar_Syntax_Syntax.sort = s2;_},
               uu____6806)
              -> aux s2 k2
          | uu____6814 ->
              let uu____6815 = FStar_Syntax_Syntax.mk_Total k2 in
              ([], uu____6815) in
        aux s k1
    | uu____6830 ->
        let uu____6831 = FStar_Syntax_Syntax.mk_Total k1 in ([], uu____6831)
let rec (arrow_formals :
  FStar_Syntax_Syntax.term ->
    ((FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax))
  =
  fun k ->
    let uu____6866 = arrow_formals_comp k in
    match uu____6866 with | (bs, c) -> (bs, (comp_result c))
let (let_rec_arity :
  FStar_Syntax_Syntax.letbinding ->
    (Prims.int * Prims.bool Prims.list FStar_Pervasives_Native.option))
  =
  fun lb ->
    let rec arrow_until_decreases k =
      let k1 = FStar_Syntax_Subst.compress k in
      match k1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_arrow (bs, c) ->
          let uu____7008 = FStar_Syntax_Subst.open_comp bs c in
          (match uu____7008 with
           | (bs1, c1) ->
               let ct = comp_to_comp_typ c1 in
               let uu____7032 =
                 FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
                   (FStar_Util.find_opt
                      (fun uu___12_7041 ->
                         match uu___12_7041 with
                         | FStar_Syntax_Syntax.DECREASES uu____7043 -> true
                         | uu____7047 -> false)) in
               (match uu____7032 with
                | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.DECREASES
                    d) -> (bs1, (FStar_Pervasives_Native.Some d))
                | uu____7082 ->
                    let uu____7085 = is_total_comp c1 in
                    if uu____7085
                    then
                      let uu____7104 = arrow_until_decreases (comp_result c1) in
                      (match uu____7104 with
                       | (bs', d) -> ((FStar_List.append bs1 bs'), d))
                    else (bs1, FStar_Pervasives_Native.None)))
      | FStar_Syntax_Syntax.Tm_refine
          ({ FStar_Syntax_Syntax.ppname = uu____7197;
             FStar_Syntax_Syntax.index = uu____7198;
             FStar_Syntax_Syntax.sort = k2;_},
           uu____7200)
          -> arrow_until_decreases k2
      | uu____7208 -> ([], FStar_Pervasives_Native.None) in
    let uu____7229 = arrow_until_decreases lb.FStar_Syntax_Syntax.lbtyp in
    match uu____7229 with
    | (bs, dopt) ->
        let n_univs = FStar_List.length lb.FStar_Syntax_Syntax.lbunivs in
        let uu____7283 =
          FStar_Util.map_opt dopt
            (fun d ->
               let d_bvs = FStar_Syntax_Free.names d in
               let uu____7304 =
                 FStar_Common.tabulate n_univs (fun uu____7310 -> false) in
               let uu____7313 =
                 FStar_All.pipe_right bs
                   (FStar_List.map
                      (fun uu____7338 ->
                         match uu____7338 with
                         | (x, uu____7347) -> FStar_Util.set_mem x d_bvs)) in
               FStar_List.append uu____7304 uu____7313) in
        ((n_univs + (FStar_List.length bs)), uu____7283)
let (abs_formals :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.term *
      FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option))
  =
  fun t ->
    let subst_lcomp_opt s l =
      match l with
      | FStar_Pervasives_Native.Some rc ->
          let uu____7403 =
            let uu___1176_7404 = rc in
            let uu____7405 =
              FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ
                (FStar_Syntax_Subst.subst s) in
            {
              FStar_Syntax_Syntax.residual_effect =
                (uu___1176_7404.FStar_Syntax_Syntax.residual_effect);
              FStar_Syntax_Syntax.residual_typ = uu____7405;
              FStar_Syntax_Syntax.residual_flags =
                (uu___1176_7404.FStar_Syntax_Syntax.residual_flags)
            } in
          FStar_Pervasives_Native.Some uu____7403
      | uu____7414 -> l in
    let rec aux t1 abs_body_lcomp =
      let uu____7448 =
        let uu____7449 =
          let uu____7452 = FStar_Syntax_Subst.compress t1 in
          FStar_All.pipe_left unascribe uu____7452 in
        uu____7449.FStar_Syntax_Syntax.n in
      match uu____7448 with
      | FStar_Syntax_Syntax.Tm_abs (bs, t2, what) ->
          let uu____7498 = aux t2 what in
          (match uu____7498 with
           | (bs', t3, what1) -> ((FStar_List.append bs bs'), t3, what1))
      | uu____7570 -> ([], t1, abs_body_lcomp) in
    let uu____7587 = aux t FStar_Pervasives_Native.None in
    match uu____7587 with
    | (bs, t1, abs_body_lcomp) ->
        let uu____7635 = FStar_Syntax_Subst.open_term' bs t1 in
        (match uu____7635 with
         | (bs1, t2, opening) ->
             let abs_body_lcomp1 = subst_lcomp_opt opening abs_body_lcomp in
             (bs1, t2, abs_body_lcomp1))
let (mk_letbinding :
  (FStar_Syntax_Syntax.bv, FStar_Syntax_Syntax.fv) FStar_Util.either ->
    FStar_Syntax_Syntax.univ_name Prims.list ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Ident.lident ->
          FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
            FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list
              -> FStar_Range.range -> FStar_Syntax_Syntax.letbinding)
  =
  fun lbname ->
    fun univ_vars ->
      fun typ ->
        fun eff ->
          fun def ->
            fun lbattrs ->
              fun pos ->
                {
                  FStar_Syntax_Syntax.lbname = lbname;
                  FStar_Syntax_Syntax.lbunivs = univ_vars;
                  FStar_Syntax_Syntax.lbtyp = typ;
                  FStar_Syntax_Syntax.lbeff = eff;
                  FStar_Syntax_Syntax.lbdef = def;
                  FStar_Syntax_Syntax.lbattrs = lbattrs;
                  FStar_Syntax_Syntax.lbpos = pos
                }
let (close_univs_and_mk_letbinding :
  FStar_Syntax_Syntax.fv Prims.list FStar_Pervasives_Native.option ->
    (FStar_Syntax_Syntax.bv, FStar_Syntax_Syntax.fv) FStar_Util.either ->
      FStar_Syntax_Syntax.univ_name Prims.list ->
        FStar_Syntax_Syntax.term ->
          FStar_Ident.lident ->
            FStar_Syntax_Syntax.term ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list
                -> FStar_Range.range -> FStar_Syntax_Syntax.letbinding)
  =
  fun recs ->
    fun lbname ->
      fun univ_vars ->
        fun typ ->
          fun eff ->
            fun def ->
              fun attrs ->
                fun pos ->
                  let def1 =
                    match (recs, univ_vars) with
                    | (FStar_Pervasives_Native.None, uu____7798) -> def
                    | (uu____7809, []) -> def
                    | (FStar_Pervasives_Native.Some fvs, uu____7821) ->
                        let universes =
                          FStar_All.pipe_right univ_vars
                            (FStar_List.map
                               (fun _7837 -> FStar_Syntax_Syntax.U_name _7837)) in
                        let inst1 =
                          FStar_All.pipe_right fvs
                            (FStar_List.map
                               (fun fv ->
                                  (((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v),
                                    universes))) in
                        FStar_Syntax_InstFV.instantiate inst1 def in
                  let typ1 = FStar_Syntax_Subst.close_univ_vars univ_vars typ in
                  let def2 =
                    FStar_Syntax_Subst.close_univ_vars univ_vars def1 in
                  mk_letbinding lbname univ_vars typ1 eff def2 attrs pos
let (open_univ_vars_binders_and_comp :
  FStar_Syntax_Syntax.univ_names ->
    (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) Prims.list ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
        (FStar_Syntax_Syntax.univ_names * (FStar_Syntax_Syntax.bv *
          FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
          Prims.list * FStar_Syntax_Syntax.comp))
  =
  fun uvs ->
    fun binders ->
      fun c ->
        match binders with
        | [] ->
            let uu____7919 = FStar_Syntax_Subst.open_univ_vars_comp uvs c in
            (match uu____7919 with | (uvs1, c1) -> (uvs1, [], c1))
        | uu____7954 ->
            let t' = arrow binders c in
            let uu____7966 = FStar_Syntax_Subst.open_univ_vars uvs t' in
            (match uu____7966 with
             | (uvs1, t'1) ->
                 let uu____7987 =
                   let uu____7988 = FStar_Syntax_Subst.compress t'1 in
                   uu____7988.FStar_Syntax_Syntax.n in
                 (match uu____7987 with
                  | FStar_Syntax_Syntax.Tm_arrow (binders1, c1) ->
                      (uvs1, binders1, c1)
                  | uu____8037 -> failwith "Impossible"))
let (is_tuple_constructor : FStar_Syntax_Syntax.typ -> Prims.bool) =
  fun t ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_tuple_constructor_string
          ((fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v).FStar_Ident.str
    | uu____8062 -> false
let (is_dtuple_constructor : FStar_Syntax_Syntax.typ -> Prims.bool) =
  fun t ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Parser_Const.is_dtuple_constructor_lid
          (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____8073 -> false
let (is_lid_equality : FStar_Ident.lident -> Prims.bool) =
  fun x -> FStar_Ident.lid_equals x FStar_Parser_Const.eq2_lid
let (is_forall : FStar_Ident.lident -> Prims.bool) =
  fun lid -> FStar_Ident.lid_equals lid FStar_Parser_Const.forall_lid
let (is_exists : FStar_Ident.lident -> Prims.bool) =
  fun lid -> FStar_Ident.lid_equals lid FStar_Parser_Const.exists_lid
let (is_qlid : FStar_Ident.lident -> Prims.bool) =
  fun lid -> (is_forall lid) || (is_exists lid)
let (is_equality :
  FStar_Ident.lident FStar_Syntax_Syntax.withinfo_t -> Prims.bool) =
  fun x -> is_lid_equality x.FStar_Syntax_Syntax.v
let (lid_is_connective : FStar_Ident.lident -> Prims.bool) =
  let lst =
    [FStar_Parser_Const.and_lid;
    FStar_Parser_Const.or_lid;
    FStar_Parser_Const.not_lid;
    FStar_Parser_Const.iff_lid;
    FStar_Parser_Const.imp_lid] in
  fun lid -> FStar_Util.for_some (FStar_Ident.lid_equals lid) lst
let (is_constructor :
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool) =
  fun t ->
    fun lid ->
      let uu____8136 =
        let uu____8137 = pre_typ t in uu____8137.FStar_Syntax_Syntax.n in
      match uu____8136 with
      | FStar_Syntax_Syntax.Tm_fvar tc ->
          FStar_Ident.lid_equals
            (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v lid
      | uu____8142 -> false
let rec (is_constructed_typ :
  FStar_Syntax_Syntax.term -> FStar_Ident.lident -> Prims.bool) =
  fun t ->
    fun lid ->
      let uu____8156 =
        let uu____8157 = pre_typ t in uu____8157.FStar_Syntax_Syntax.n in
      match uu____8156 with
      | FStar_Syntax_Syntax.Tm_fvar uu____8161 -> is_constructor t lid
      | FStar_Syntax_Syntax.Tm_app (t1, uu____8163) ->
          is_constructed_typ t1 lid
      | FStar_Syntax_Syntax.Tm_uinst (t1, uu____8189) ->
          is_constructed_typ t1 lid
      | uu____8194 -> false
let rec (get_tycon :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term FStar_Pervasives_Native.option)
  =
  fun t ->
    let t1 = pre_typ t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_bvar uu____8207 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_name uu____8208 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_fvar uu____8209 ->
        FStar_Pervasives_Native.Some t1
    | FStar_Syntax_Syntax.Tm_app (t2, uu____8211) -> get_tycon t2
    | uu____8236 -> FStar_Pervasives_Native.None
let (is_fstar_tactics_by_tactic : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____8244 =
      let uu____8245 = un_uinst t in uu____8245.FStar_Syntax_Syntax.n in
    match uu____8244 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.by_tactic_lid
    | uu____8250 -> false
let (is_builtin_tactic : FStar_Ident.lident -> Prims.bool) =
  fun md ->
    let path = FStar_Ident.path_of_lid md in
    if (FStar_List.length path) > (Prims.parse_int "2")
    then
      let uu____8264 =
        let uu____8268 = FStar_List.splitAt (Prims.parse_int "2") path in
        FStar_Pervasives_Native.fst uu____8268 in
      match uu____8264 with
      | "FStar"::"Tactics"::[] -> true
      | "FStar"::"Reflection"::[] -> true
      | uu____8300 -> false
    else false
let (ktype : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_unknown)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let (ktype0 : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_type FStar_Syntax_Syntax.U_zero)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let (type_u :
  unit -> (FStar_Syntax_Syntax.typ * FStar_Syntax_Syntax.universe)) =
  fun uu____8319 ->
    let u =
      let uu____8325 = FStar_Syntax_Unionfind.univ_fresh () in
      FStar_All.pipe_left (fun _8342 -> FStar_Syntax_Syntax.U_unif _8342)
        uu____8325 in
    let uu____8343 =
      FStar_Syntax_Syntax.mk (FStar_Syntax_Syntax.Tm_type u)
        FStar_Pervasives_Native.None FStar_Range.dummyRange in
    (uu____8343, u)
let (attr_eq :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun a ->
    fun a' ->
      let uu____8356 = eq_tm a a' in
      match uu____8356 with | Equal -> true | uu____8359 -> false
let (attr_substitute : FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  let uu____8364 =
    let uu____8371 =
      let uu____8372 =
        let uu____8373 =
          FStar_Ident.lid_of_path ["FStar"; "Pervasives"; "Substitute"]
            FStar_Range.dummyRange in
        FStar_Syntax_Syntax.lid_as_fv uu____8373
          FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None in
      FStar_Syntax_Syntax.Tm_fvar uu____8372 in
    FStar_Syntax_Syntax.mk uu____8371 in
  uu____8364 FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_true_bool : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool true))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_false_bool : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_bool false))
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_unit : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.mk
    (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_unit)
    FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_int : Prims.string -> FStar_Syntax_Syntax.term) =
  fun s ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_int (s, FStar_Pervasives_Native.None)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_char : FStar_BaseTypes.char -> FStar_Syntax_Syntax.term) =
  fun c ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_char c))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
let (exp_string : Prims.string -> FStar_Syntax_Syntax.term) =
  fun s ->
    FStar_Syntax_Syntax.mk
      (FStar_Syntax_Syntax.Tm_constant
         (FStar_Const.Const_string (s, FStar_Range.dummyRange)))
      FStar_Pervasives_Native.None FStar_Range.dummyRange
let (fvar_const : FStar_Ident.lident -> FStar_Syntax_Syntax.term) =
  fun l ->
    FStar_Syntax_Syntax.fvar l FStar_Syntax_Syntax.delta_constant
      FStar_Pervasives_Native.None
let (tand : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.and_lid
let (tor : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.or_lid
let (timp : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.imp_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
let (tiff : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.iff_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "2"))
    FStar_Pervasives_Native.None
let (t_bool : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.bool_lid
let (b2t_v : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.b2t_lid
let (t_not : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.not_lid
let (t_false : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.false_lid
let (t_true : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.true_lid
let (tac_opaque_attr : FStar_Syntax_Syntax.term) = exp_string "tac_opaque"
let (dm4f_bind_range_attr : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.dm4f_bind_range_attr
let (tcdecltime_attr : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.tcdecltime_attr
let (inline_let_attr : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.inline_let_attr
let (t_ctx_uvar_and_sust : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.ctx_uvar_and_subst_lid
let (mk_conj_opt :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
    FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
        FStar_Pervasives_Native.option)
  =
  fun phi1 ->
    fun phi2 ->
      match phi1 with
      | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.Some phi2
      | FStar_Pervasives_Native.Some phi11 ->
          let uu____8485 =
            let uu____8488 =
              FStar_Range.union_ranges phi11.FStar_Syntax_Syntax.pos
                phi2.FStar_Syntax_Syntax.pos in
            let uu____8489 =
              let uu____8496 =
                let uu____8497 =
                  let uu____8514 =
                    let uu____8525 = FStar_Syntax_Syntax.as_arg phi11 in
                    let uu____8534 =
                      let uu____8545 = FStar_Syntax_Syntax.as_arg phi2 in
                      [uu____8545] in
                    uu____8525 :: uu____8534 in
                  (tand, uu____8514) in
                FStar_Syntax_Syntax.Tm_app uu____8497 in
              FStar_Syntax_Syntax.mk uu____8496 in
            uu____8489 FStar_Pervasives_Native.None uu____8488 in
          FStar_Pervasives_Native.Some uu____8485
let (mk_binop :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun op_t ->
    fun phi1 ->
      fun phi2 ->
        let uu____8622 =
          FStar_Range.union_ranges phi1.FStar_Syntax_Syntax.pos
            phi2.FStar_Syntax_Syntax.pos in
        let uu____8623 =
          let uu____8630 =
            let uu____8631 =
              let uu____8648 =
                let uu____8659 = FStar_Syntax_Syntax.as_arg phi1 in
                let uu____8668 =
                  let uu____8679 = FStar_Syntax_Syntax.as_arg phi2 in
                  [uu____8679] in
                uu____8659 :: uu____8668 in
              (op_t, uu____8648) in
            FStar_Syntax_Syntax.Tm_app uu____8631 in
          FStar_Syntax_Syntax.mk uu____8630 in
        uu____8623 FStar_Pervasives_Native.None uu____8622
let (mk_neg :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi ->
    let uu____8736 =
      let uu____8743 =
        let uu____8744 =
          let uu____8761 =
            let uu____8772 = FStar_Syntax_Syntax.as_arg phi in [uu____8772] in
          (t_not, uu____8761) in
        FStar_Syntax_Syntax.Tm_app uu____8744 in
      FStar_Syntax_Syntax.mk uu____8743 in
    uu____8736 FStar_Pervasives_Native.None phi.FStar_Syntax_Syntax.pos
let (mk_conj :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  = fun phi1 -> fun phi2 -> mk_binop tand phi1 phi2
let (mk_conj_l :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi ->
    match phi with
    | [] ->
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.true_lid
          FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
    | hd1::tl1 -> FStar_List.fold_right mk_conj tl1 hd1
let (mk_disj :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  = fun phi1 -> fun phi2 -> mk_binop tor phi1 phi2
let (mk_disj_l :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun phi ->
    match phi with
    | [] -> t_false
    | hd1::tl1 -> FStar_List.fold_right mk_disj tl1 hd1
let (mk_imp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term)
  = fun phi1 -> fun phi2 -> mk_binop timp phi1 phi2
let (mk_iff :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term)
  = fun phi1 -> fun phi2 -> mk_binop tiff phi1 phi2
let (b2t :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun e ->
    let uu____8969 =
      let uu____8976 =
        let uu____8977 =
          let uu____8994 =
            let uu____9005 = FStar_Syntax_Syntax.as_arg e in [uu____9005] in
          (b2t_v, uu____8994) in
        FStar_Syntax_Syntax.Tm_app uu____8977 in
      FStar_Syntax_Syntax.mk uu____8976 in
    uu____8969 FStar_Pervasives_Native.None e.FStar_Syntax_Syntax.pos
let (is_t_true : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____9049 =
      let uu____9050 = unmeta t in uu____9050.FStar_Syntax_Syntax.n in
    match uu____9049 with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.true_lid
    | uu____9055 -> false
let (mk_conj_simp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1 ->
    fun t2 ->
      let uu____9078 = is_t_true t1 in
      if uu____9078
      then t2
      else
        (let uu____9085 = is_t_true t2 in
         if uu____9085 then t1 else mk_conj t1 t2)
let (mk_disj_simp :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t1 ->
    fun t2 ->
      let uu____9113 = is_t_true t1 in
      if uu____9113
      then t_true
      else
        (let uu____9120 = is_t_true t2 in
         if uu____9120 then t_true else mk_disj t1 t2)
let (teq : FStar_Syntax_Syntax.term) = fvar_const FStar_Parser_Const.eq2_lid
let (mk_untyped_eq2 :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun e1 ->
    fun e2 ->
      let uu____9149 =
        FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
          e2.FStar_Syntax_Syntax.pos in
      let uu____9150 =
        let uu____9157 =
          let uu____9158 =
            let uu____9175 =
              let uu____9186 = FStar_Syntax_Syntax.as_arg e1 in
              let uu____9195 =
                let uu____9206 = FStar_Syntax_Syntax.as_arg e2 in
                [uu____9206] in
              uu____9186 :: uu____9195 in
            (teq, uu____9175) in
          FStar_Syntax_Syntax.Tm_app uu____9158 in
        FStar_Syntax_Syntax.mk uu____9157 in
      uu____9150 FStar_Pervasives_Native.None uu____9149
let (mk_eq2 :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun u ->
    fun t ->
      fun e1 ->
        fun e2 ->
          let eq_inst = FStar_Syntax_Syntax.mk_Tm_uinst teq [u] in
          let uu____9273 =
            FStar_Range.union_ranges e1.FStar_Syntax_Syntax.pos
              e2.FStar_Syntax_Syntax.pos in
          let uu____9274 =
            let uu____9281 =
              let uu____9282 =
                let uu____9299 =
                  let uu____9310 = FStar_Syntax_Syntax.iarg t in
                  let uu____9319 =
                    let uu____9330 = FStar_Syntax_Syntax.as_arg e1 in
                    let uu____9339 =
                      let uu____9350 = FStar_Syntax_Syntax.as_arg e2 in
                      [uu____9350] in
                    uu____9330 :: uu____9339 in
                  uu____9310 :: uu____9319 in
                (eq_inst, uu____9299) in
              FStar_Syntax_Syntax.Tm_app uu____9282 in
            FStar_Syntax_Syntax.mk uu____9281 in
          uu____9274 FStar_Pervasives_Native.None uu____9273
let (mk_has_type :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    fun x ->
      fun t' ->
        let t_has_type = fvar_const FStar_Parser_Const.has_type_lid in
        let t_has_type1 =
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_uinst
               (t_has_type,
                 [FStar_Syntax_Syntax.U_zero; FStar_Syntax_Syntax.U_zero]))
            FStar_Pervasives_Native.None FStar_Range.dummyRange in
        let uu____9427 =
          let uu____9434 =
            let uu____9435 =
              let uu____9452 =
                let uu____9463 = FStar_Syntax_Syntax.iarg t in
                let uu____9472 =
                  let uu____9483 = FStar_Syntax_Syntax.as_arg x in
                  let uu____9492 =
                    let uu____9503 = FStar_Syntax_Syntax.as_arg t' in
                    [uu____9503] in
                  uu____9483 :: uu____9492 in
                uu____9463 :: uu____9472 in
              (t_has_type1, uu____9452) in
            FStar_Syntax_Syntax.Tm_app uu____9435 in
          FStar_Syntax_Syntax.mk uu____9434 in
        uu____9427 FStar_Pervasives_Native.None FStar_Range.dummyRange
let (mk_with_type :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u ->
    fun t ->
      fun e ->
        let t_with_type =
          FStar_Syntax_Syntax.fvar FStar_Parser_Const.with_type_lid
            FStar_Syntax_Syntax.delta_equational FStar_Pervasives_Native.None in
        let t_with_type1 =
          FStar_Syntax_Syntax.mk
            (FStar_Syntax_Syntax.Tm_uinst (t_with_type, [u]))
            FStar_Pervasives_Native.None FStar_Range.dummyRange in
        let uu____9580 =
          let uu____9587 =
            let uu____9588 =
              let uu____9605 =
                let uu____9616 = FStar_Syntax_Syntax.iarg t in
                let uu____9625 =
                  let uu____9636 = FStar_Syntax_Syntax.as_arg e in
                  [uu____9636] in
                uu____9616 :: uu____9625 in
              (t_with_type1, uu____9605) in
            FStar_Syntax_Syntax.Tm_app uu____9588 in
          FStar_Syntax_Syntax.mk uu____9587 in
        uu____9580 FStar_Pervasives_Native.None FStar_Range.dummyRange
let (lex_t : FStar_Syntax_Syntax.term) =
  fvar_const FStar_Parser_Const.lex_t_lid
let (lex_top : FStar_Syntax_Syntax.term) =
  let uu____9683 =
    let uu____9690 =
      let uu____9691 =
        let uu____9698 =
          FStar_Syntax_Syntax.fvar FStar_Parser_Const.lextop_lid
            FStar_Syntax_Syntax.delta_constant
            (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
        (uu____9698, [FStar_Syntax_Syntax.U_zero]) in
      FStar_Syntax_Syntax.Tm_uinst uu____9691 in
    FStar_Syntax_Syntax.mk uu____9690 in
  uu____9683 FStar_Pervasives_Native.None FStar_Range.dummyRange
let (lex_pair : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.lexcons_lid
    FStar_Syntax_Syntax.delta_constant
    (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor)
let (tforall : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.forall_lid
    (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
    FStar_Pervasives_Native.None
let (t_haseq : FStar_Syntax_Syntax.term) =
  FStar_Syntax_Syntax.fvar FStar_Parser_Const.haseq_lid
    FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
let (lcomp_of_comp : FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.lcomp) =
  fun c0 ->
    let uu____9713 =
      match c0.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total uu____9726 ->
          (FStar_Parser_Const.effect_Tot_lid, [FStar_Syntax_Syntax.TOTAL])
      | FStar_Syntax_Syntax.GTotal uu____9737 ->
          (FStar_Parser_Const.effect_GTot_lid,
            [FStar_Syntax_Syntax.SOMETRIVIAL])
      | FStar_Syntax_Syntax.Comp c ->
          ((c.FStar_Syntax_Syntax.effect_name),
            (c.FStar_Syntax_Syntax.flags)) in
    match uu____9713 with
    | (eff_name, flags) ->
        FStar_Syntax_Syntax.mk_lcomp eff_name (comp_result c0) flags
          (fun uu____9758 -> c0)
let (mk_residual_comp :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.cflag Prims.list ->
        FStar_Syntax_Syntax.residual_comp)
  =
  fun l ->
    fun t ->
      fun f ->
        {
          FStar_Syntax_Syntax.residual_effect = l;
          FStar_Syntax_Syntax.residual_typ = t;
          FStar_Syntax_Syntax.residual_flags = f
        }
let (residual_tot :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.residual_comp)
  =
  fun t ->
    {
      FStar_Syntax_Syntax.residual_effect = FStar_Parser_Const.effect_Tot_lid;
      FStar_Syntax_Syntax.residual_typ = (FStar_Pervasives_Native.Some t);
      FStar_Syntax_Syntax.residual_flags = [FStar_Syntax_Syntax.TOTAL]
    }
let (residual_comp_of_comp :
  FStar_Syntax_Syntax.comp -> FStar_Syntax_Syntax.residual_comp) =
  fun c ->
    {
      FStar_Syntax_Syntax.residual_effect = (comp_effect_name c);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (comp_result c));
      FStar_Syntax_Syntax.residual_flags = (comp_flags c)
    }
let (residual_comp_of_lcomp :
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.residual_comp) =
  fun lc ->
    {
      FStar_Syntax_Syntax.residual_effect = (lc.FStar_Syntax_Syntax.eff_name);
      FStar_Syntax_Syntax.residual_typ =
        (FStar_Pervasives_Native.Some (lc.FStar_Syntax_Syntax.res_typ));
      FStar_Syntax_Syntax.residual_flags = (lc.FStar_Syntax_Syntax.cflags)
    }
let (mk_forall_aux :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun fa ->
    fun x ->
      fun body ->
        let uu____9841 =
          let uu____9848 =
            let uu____9849 =
              let uu____9866 =
                let uu____9877 =
                  FStar_Syntax_Syntax.iarg x.FStar_Syntax_Syntax.sort in
                let uu____9886 =
                  let uu____9897 =
                    let uu____9906 =
                      let uu____9907 =
                        let uu____9908 = FStar_Syntax_Syntax.mk_binder x in
                        [uu____9908] in
                      abs uu____9907 body
                        (FStar_Pervasives_Native.Some (residual_tot ktype0)) in
                    FStar_Syntax_Syntax.as_arg uu____9906 in
                  [uu____9897] in
                uu____9877 :: uu____9886 in
              (fa, uu____9866) in
            FStar_Syntax_Syntax.Tm_app uu____9849 in
          FStar_Syntax_Syntax.mk uu____9848 in
        uu____9841 FStar_Pervasives_Native.None FStar_Range.dummyRange
let (mk_forall_no_univ :
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  = fun x -> fun body -> mk_forall_aux tforall x body
let (mk_forall :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.bv ->
      FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun u ->
    fun x ->
      fun body ->
        let tforall1 = FStar_Syntax_Syntax.mk_Tm_uinst tforall [u] in
        mk_forall_aux tforall1 x body
let (close_forall_no_univs :
  (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
    FStar_Pervasives_Native.option) Prims.list ->
    FStar_Syntax_Syntax.typ -> FStar_Syntax_Syntax.typ)
  =
  fun bs ->
    fun f ->
      FStar_List.fold_right
        (fun b ->
           fun f1 ->
             let uu____10035 = FStar_Syntax_Syntax.is_null_binder b in
             if uu____10035
             then f1
             else mk_forall_no_univ (FStar_Pervasives_Native.fst b) f1) bs f
let rec (is_wild_pat :
  FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t -> Prims.bool) =
  fun p ->
    match p.FStar_Syntax_Syntax.v with
    | FStar_Syntax_Syntax.Pat_wild uu____10054 -> true
    | uu____10056 -> false
let (if_then_else :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun b ->
    fun t1 ->
      fun t2 ->
        let then_branch =
          let uu____10103 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant (FStar_Const.Const_bool true))
              t1.FStar_Syntax_Syntax.pos in
          (uu____10103, FStar_Pervasives_Native.None, t1) in
        let else_branch =
          let uu____10132 =
            FStar_Syntax_Syntax.withinfo
              (FStar_Syntax_Syntax.Pat_constant
                 (FStar_Const.Const_bool false)) t2.FStar_Syntax_Syntax.pos in
          (uu____10132, FStar_Pervasives_Native.None, t2) in
        let uu____10146 =
          let uu____10147 =
            FStar_Range.union_ranges t1.FStar_Syntax_Syntax.pos
              t2.FStar_Syntax_Syntax.pos in
          FStar_Range.union_ranges b.FStar_Syntax_Syntax.pos uu____10147 in
        FStar_Syntax_Syntax.mk
          (FStar_Syntax_Syntax.Tm_match (b, [then_branch; else_branch]))
          FStar_Pervasives_Native.None uu____10146
let (mk_squash :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u ->
    fun p ->
      let sq =
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.squash_lid
          (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "1"))
          FStar_Pervasives_Native.None in
      let uu____10223 = FStar_Syntax_Syntax.mk_Tm_uinst sq [u] in
      let uu____10226 =
        let uu____10237 = FStar_Syntax_Syntax.as_arg p in [uu____10237] in
      mk_app uu____10223 uu____10226
let (mk_auto_squash :
  FStar_Syntax_Syntax.universe ->
    FStar_Syntax_Syntax.term ->
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun u ->
    fun p ->
      let sq =
        FStar_Syntax_Syntax.fvar FStar_Parser_Const.auto_squash_lid
          (FStar_Syntax_Syntax.Delta_constant_at_level (Prims.parse_int "2"))
          FStar_Pervasives_Native.None in
      let uu____10277 = FStar_Syntax_Syntax.mk_Tm_uinst sq [u] in
      let uu____10280 =
        let uu____10291 = FStar_Syntax_Syntax.as_arg p in [uu____10291] in
      mk_app uu____10277 uu____10280
let (un_squash :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option)
  =
  fun t ->
    let uu____10326 = head_and_args t in
    match uu____10326 with
    | (head1, args) ->
        let head2 = unascribe head1 in
        let head3 = un_uinst head2 in
        let uu____10375 =
          let uu____10390 =
            let uu____10391 = FStar_Syntax_Subst.compress head3 in
            uu____10391.FStar_Syntax_Syntax.n in
          (uu____10390, args) in
        (match uu____10375 with
         | (FStar_Syntax_Syntax.Tm_fvar fv, (p, uu____10410)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid
             -> FStar_Pervasives_Native.Some p
         | (FStar_Syntax_Syntax.Tm_refine (b, p), []) ->
             (match (b.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_fvar fv when
                  FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.unit_lid
                  ->
                  let uu____10476 =
                    let uu____10481 =
                      let uu____10482 = FStar_Syntax_Syntax.mk_binder b in
                      [uu____10482] in
                    FStar_Syntax_Subst.open_term uu____10481 p in
                  (match uu____10476 with
                   | (bs, p1) ->
                       let b1 =
                         match bs with
                         | b1::[] -> b1
                         | uu____10539 -> failwith "impossible" in
                       let uu____10547 =
                         let uu____10549 = FStar_Syntax_Free.names p1 in
                         FStar_Util.set_mem (FStar_Pervasives_Native.fst b1)
                           uu____10549 in
                       if uu____10547
                       then FStar_Pervasives_Native.None
                       else FStar_Pervasives_Native.Some p1)
              | uu____10565 -> FStar_Pervasives_Native.None)
         | uu____10568 -> FStar_Pervasives_Native.None)
let (is_squash :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.universe * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax) FStar_Pervasives_Native.option)
  =
  fun t ->
    let uu____10599 = head_and_args t in
    match uu____10599 with
    | (head1, args) ->
        let uu____10650 =
          let uu____10665 =
            let uu____10666 = FStar_Syntax_Subst.compress head1 in
            uu____10666.FStar_Syntax_Syntax.n in
          (uu____10665, args) in
        (match uu____10650 with
         | (FStar_Syntax_Syntax.Tm_uinst
            ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
               FStar_Syntax_Syntax.pos = uu____10688;
               FStar_Syntax_Syntax.vars = uu____10689;_},
             u::[]),
            (t1, uu____10692)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.squash_lid
             -> FStar_Pervasives_Native.Some (u, t1)
         | uu____10739 -> FStar_Pervasives_Native.None)
let (is_auto_squash :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.universe * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax) FStar_Pervasives_Native.option)
  =
  fun t ->
    let uu____10774 = head_and_args t in
    match uu____10774 with
    | (head1, args) ->
        let uu____10825 =
          let uu____10840 =
            let uu____10841 = FStar_Syntax_Subst.compress head1 in
            uu____10841.FStar_Syntax_Syntax.n in
          (uu____10840, args) in
        (match uu____10825 with
         | (FStar_Syntax_Syntax.Tm_uinst
            ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
               FStar_Syntax_Syntax.pos = uu____10863;
               FStar_Syntax_Syntax.vars = uu____10864;_},
             u::[]),
            (t1, uu____10867)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv
               FStar_Parser_Const.auto_squash_lid
             -> FStar_Pervasives_Native.Some (u, t1)
         | uu____10914 -> FStar_Pervasives_Native.None)
let (is_sub_singleton : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____10942 = let uu____10959 = unmeta t in head_and_args uu____10959 in
    match uu____10942 with
    | (head1, uu____10962) ->
        let uu____10987 =
          let uu____10988 = un_uinst head1 in
          uu____10988.FStar_Syntax_Syntax.n in
        (match uu____10987 with
         | FStar_Syntax_Syntax.Tm_fvar fv ->
             (((((((((((((((((FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.squash_lid)
                               ||
                               (FStar_Syntax_Syntax.fv_eq_lid fv
                                  FStar_Parser_Const.auto_squash_lid))
                              ||
                              (FStar_Syntax_Syntax.fv_eq_lid fv
                                 FStar_Parser_Const.and_lid))
                             ||
                             (FStar_Syntax_Syntax.fv_eq_lid fv
                                FStar_Parser_Const.or_lid))
                            ||
                            (FStar_Syntax_Syntax.fv_eq_lid fv
                               FStar_Parser_Const.not_lid))
                           ||
                           (FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Parser_Const.imp_lid))
                          ||
                          (FStar_Syntax_Syntax.fv_eq_lid fv
                             FStar_Parser_Const.iff_lid))
                         ||
                         (FStar_Syntax_Syntax.fv_eq_lid fv
                            FStar_Parser_Const.ite_lid))
                        ||
                        (FStar_Syntax_Syntax.fv_eq_lid fv
                           FStar_Parser_Const.exists_lid))
                       ||
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.forall_lid))
                      ||
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.true_lid))
                     ||
                     (FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.false_lid))
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.eq2_lid))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.eq3_lid))
                  ||
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.b2t_lid))
                 ||
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.haseq_lid))
                ||
                (FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.has_type_lid))
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.precedes_lid)
         | uu____10993 -> false)
let (arrow_one :
  FStar_Syntax_Syntax.typ ->
    (FStar_Syntax_Syntax.binder * FStar_Syntax_Syntax.comp)
      FStar_Pervasives_Native.option)
  =
  fun t ->
    let uu____11013 =
      let uu____11026 =
        let uu____11027 = FStar_Syntax_Subst.compress t in
        uu____11027.FStar_Syntax_Syntax.n in
      match uu____11026 with
      | FStar_Syntax_Syntax.Tm_arrow ([], c) ->
          failwith "fatal: empty binders on arrow?"
      | FStar_Syntax_Syntax.Tm_arrow (b::[], c) ->
          FStar_Pervasives_Native.Some (b, c)
      | FStar_Syntax_Syntax.Tm_arrow (b::bs, c) ->
          let uu____11157 =
            let uu____11168 =
              let uu____11169 = arrow bs c in
              FStar_Syntax_Syntax.mk_Total uu____11169 in
            (b, uu____11168) in
          FStar_Pervasives_Native.Some uu____11157
      | uu____11186 -> FStar_Pervasives_Native.None in
    FStar_Util.bind_opt uu____11013
      (fun uu____11224 ->
         match uu____11224 with
         | (b, c) ->
             let uu____11261 = FStar_Syntax_Subst.open_comp [b] c in
             (match uu____11261 with
              | (bs, c1) ->
                  let b1 =
                    match bs with
                    | b1::[] -> b1
                    | uu____11324 ->
                        failwith
                          "impossible: open_comp returned different amount of binders" in
                  FStar_Pervasives_Native.Some (b1, c1)))
let (is_free_in :
  FStar_Syntax_Syntax.bv -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun bv ->
    fun t ->
      let uu____11361 = FStar_Syntax_Free.names t in
      FStar_Util.set_mem bv uu____11361
type qpats = FStar_Syntax_Syntax.args Prims.list
type connective =
  | QAll of (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ) 
  | QEx of (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ) 
  | BaseConn of (FStar_Ident.lident * FStar_Syntax_Syntax.args) 
let (uu___is_QAll : connective -> Prims.bool) =
  fun projectee ->
    match projectee with | QAll _0 -> true | uu____11413 -> false
let (__proj__QAll__item___0 :
  connective ->
    (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ))
  = fun projectee -> match projectee with | QAll _0 -> _0
let (uu___is_QEx : connective -> Prims.bool) =
  fun projectee ->
    match projectee with | QEx _0 -> true | uu____11456 -> false
let (__proj__QEx__item___0 :
  connective ->
    (FStar_Syntax_Syntax.binders * qpats * FStar_Syntax_Syntax.typ))
  = fun projectee -> match projectee with | QEx _0 -> _0
let (uu___is_BaseConn : connective -> Prims.bool) =
  fun projectee ->
    match projectee with | BaseConn _0 -> true | uu____11497 -> false
let (__proj__BaseConn__item___0 :
  connective -> (FStar_Ident.lident * FStar_Syntax_Syntax.args)) =
  fun projectee -> match projectee with | BaseConn _0 -> _0
let (destruct_typ_as_formula :
  FStar_Syntax_Syntax.term -> connective FStar_Pervasives_Native.option) =
  fun f ->
    let rec unmeta_monadic f1 =
      let f2 = FStar_Syntax_Subst.compress f1 in
      match f2.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t, FStar_Syntax_Syntax.Meta_monadic uu____11536) ->
          unmeta_monadic t
      | FStar_Syntax_Syntax.Tm_meta
          (t, FStar_Syntax_Syntax.Meta_monadic_lift uu____11548) ->
          unmeta_monadic t
      | uu____11561 -> f2 in
    let destruct_base_conn f1 =
      let connectives =
        [(FStar_Parser_Const.true_lid, (Prims.parse_int "0"));
        (FStar_Parser_Const.false_lid, (Prims.parse_int "0"));
        (FStar_Parser_Const.and_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.or_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.imp_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.iff_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.ite_lid, (Prims.parse_int "3"));
        (FStar_Parser_Const.not_lid, (Prims.parse_int "1"));
        (FStar_Parser_Const.eq2_lid, (Prims.parse_int "3"));
        (FStar_Parser_Const.eq2_lid, (Prims.parse_int "2"));
        (FStar_Parser_Const.eq3_lid, (Prims.parse_int "4"));
        (FStar_Parser_Const.eq3_lid, (Prims.parse_int "2"))] in
      let aux f2 uu____11657 =
        match uu____11657 with
        | (lid, arity) ->
            let uu____11666 =
              let uu____11683 = unmeta_monadic f2 in
              head_and_args uu____11683 in
            (match uu____11666 with
             | (t, args) ->
                 let t1 = un_uinst t in
                 let uu____11713 =
                   (is_constructor t1 lid) &&
                     ((FStar_List.length args) = arity) in
                 if uu____11713
                 then FStar_Pervasives_Native.Some (BaseConn (lid, args))
                 else FStar_Pervasives_Native.None) in
      FStar_Util.find_map connectives (aux f1) in
    let patterns t =
      let t1 = FStar_Syntax_Subst.compress t in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_meta
          (t2, FStar_Syntax_Syntax.Meta_pattern pats) ->
          let uu____11789 = FStar_Syntax_Subst.compress t2 in
          (pats, uu____11789)
      | uu____11802 -> ([], t1) in
    let destruct_q_conn t =
      let is_q fa fv =
        if fa
        then is_forall (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
        else is_exists (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
      let flat t1 =
        let uu____11869 = head_and_args t1 in
        match uu____11869 with
        | (t2, args) ->
            let uu____11924 = un_uinst t2 in
            let uu____11925 =
              FStar_All.pipe_right args
                (FStar_List.map
                   (fun uu____11966 ->
                      match uu____11966 with
                      | (t3, imp) ->
                          let uu____11985 = unascribe t3 in
                          (uu____11985, imp))) in
            (uu____11924, uu____11925) in
      let rec aux qopt out t1 =
        let uu____12036 = let uu____12060 = flat t1 in (qopt, uu____12060) in
        match uu____12036 with
        | (FStar_Pervasives_Native.Some fa,
           ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
              FStar_Syntax_Syntax.pos = uu____12100;
              FStar_Syntax_Syntax.vars = uu____12101;_},
            ({
               FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs
                 (b::[], t2, uu____12104);
               FStar_Syntax_Syntax.pos = uu____12105;
               FStar_Syntax_Syntax.vars = uu____12106;_},
             uu____12107)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.Some fa,
           ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
              FStar_Syntax_Syntax.pos = uu____12209;
              FStar_Syntax_Syntax.vars = uu____12210;_},
            uu____12211::({
                            FStar_Syntax_Syntax.n =
                              FStar_Syntax_Syntax.Tm_abs
                              (b::[], t2, uu____12214);
                            FStar_Syntax_Syntax.pos = uu____12215;
                            FStar_Syntax_Syntax.vars = uu____12216;_},
                          uu____12217)::[]))
            when is_q fa tc -> aux qopt (b :: out) t2
        | (FStar_Pervasives_Native.None,
           ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
              FStar_Syntax_Syntax.pos = uu____12334;
              FStar_Syntax_Syntax.vars = uu____12335;_},
            ({
               FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_abs
                 (b::[], t2, uu____12338);
               FStar_Syntax_Syntax.pos = uu____12339;
               FStar_Syntax_Syntax.vars = uu____12340;_},
             uu____12341)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            let uu____12434 =
              let uu____12438 =
                is_forall
                  (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
              FStar_Pervasives_Native.Some uu____12438 in
            aux uu____12434 (b :: out) t2
        | (FStar_Pervasives_Native.None,
           ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar tc;
              FStar_Syntax_Syntax.pos = uu____12448;
              FStar_Syntax_Syntax.vars = uu____12449;_},
            uu____12450::({
                            FStar_Syntax_Syntax.n =
                              FStar_Syntax_Syntax.Tm_abs
                              (b::[], t2, uu____12453);
                            FStar_Syntax_Syntax.pos = uu____12454;
                            FStar_Syntax_Syntax.vars = uu____12455;_},
                          uu____12456)::[]))
            when
            is_qlid (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v ->
            let uu____12565 =
              let uu____12569 =
                is_forall
                  (tc.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
              FStar_Pervasives_Native.Some uu____12569 in
            aux uu____12565 (b :: out) t2
        | (FStar_Pervasives_Native.Some b, uu____12579) ->
            let bs = FStar_List.rev out in
            let uu____12632 = FStar_Syntax_Subst.open_term bs t1 in
            (match uu____12632 with
             | (bs1, t2) ->
                 let uu____12641 = patterns t2 in
                 (match uu____12641 with
                  | (pats, body) ->
                      if b
                      then
                        FStar_Pervasives_Native.Some (QAll (bs1, pats, body))
                      else
                        FStar_Pervasives_Native.Some (QEx (bs1, pats, body))))
        | uu____12691 -> FStar_Pervasives_Native.None in
      aux FStar_Pervasives_Native.None [] t in
    let u_connectives =
      [(FStar_Parser_Const.true_lid, FStar_Parser_Const.c_true_lid,
         (Prims.parse_int "0"));
      (FStar_Parser_Const.false_lid, FStar_Parser_Const.c_false_lid,
        (Prims.parse_int "0"));
      (FStar_Parser_Const.and_lid, FStar_Parser_Const.c_and_lid,
        (Prims.parse_int "2"));
      (FStar_Parser_Const.or_lid, FStar_Parser_Const.c_or_lid,
        (Prims.parse_int "2"))] in
    let destruct_sq_base_conn t =
      let uu____12783 = un_squash t in
      FStar_Util.bind_opt uu____12783
        (fun t1 ->
           let uu____12799 = head_and_args' t1 in
           match uu____12799 with
           | (hd1, args) ->
               let uu____12838 =
                 let uu____12844 =
                   let uu____12845 = un_uinst hd1 in
                   uu____12845.FStar_Syntax_Syntax.n in
                 (uu____12844, (FStar_List.length args)) in
               (match uu____12838 with
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12861) when
                    (_12861 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_and_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.and_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12864) when
                    (_12864 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_or_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.or_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12867) when
                    (_12867 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.c_eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12870) when
                    (_12870 = (Prims.parse_int "3")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq2_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.c_eq2_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12873) when
                    (_12873 = (Prims.parse_int "2")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.c_eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12876) when
                    (_12876 = (Prims.parse_int "4")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_eq3_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.c_eq3_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12879) when
                    (_12879 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_true_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.true_lid, args))
                | (FStar_Syntax_Syntax.Tm_fvar fv, _12882) when
                    (_12882 = (Prims.parse_int "0")) &&
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.c_false_lid)
                    ->
                    FStar_Pervasives_Native.Some
                      (BaseConn (FStar_Parser_Const.false_lid, args))
                | uu____12883 -> FStar_Pervasives_Native.None)) in
    let rec destruct_sq_forall t =
      let uu____12913 = un_squash t in
      FStar_Util.bind_opt uu____12913
        (fun t1 ->
           let uu____12928 = arrow_one t1 in
           match uu____12928 with
           | FStar_Pervasives_Native.Some (b, c) ->
               let uu____12943 =
                 let uu____12945 = is_tot_or_gtot_comp c in
                 Prims.op_Negation uu____12945 in
               if uu____12943
               then FStar_Pervasives_Native.None
               else
                 (let q =
                    let uu____12955 = comp_to_comp_typ_nouniv c in
                    uu____12955.FStar_Syntax_Syntax.result_typ in
                  let uu____12956 =
                    is_free_in (FStar_Pervasives_Native.fst b) q in
                  if uu____12956
                  then
                    let uu____12963 = patterns q in
                    match uu____12963 with
                    | (pats, q1) ->
                        FStar_All.pipe_left maybe_collect
                          (FStar_Pervasives_Native.Some
                             (QAll ([b], pats, q1)))
                  else
                    (let uu____13026 =
                       let uu____13027 =
                         let uu____13032 =
                           let uu____13033 =
                             FStar_Syntax_Syntax.as_arg
                               (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                           let uu____13044 =
                             let uu____13055 = FStar_Syntax_Syntax.as_arg q in
                             [uu____13055] in
                           uu____13033 :: uu____13044 in
                         (FStar_Parser_Const.imp_lid, uu____13032) in
                       BaseConn uu____13027 in
                     FStar_Pervasives_Native.Some uu____13026))
           | uu____13088 -> FStar_Pervasives_Native.None)
    and destruct_sq_exists t =
      let uu____13096 = un_squash t in
      FStar_Util.bind_opt uu____13096
        (fun t1 ->
           let uu____13127 = head_and_args' t1 in
           match uu____13127 with
           | (hd1, args) ->
               let uu____13166 =
                 let uu____13181 =
                   let uu____13182 = un_uinst hd1 in
                   uu____13182.FStar_Syntax_Syntax.n in
                 (uu____13181, args) in
               (match uu____13166 with
                | (FStar_Syntax_Syntax.Tm_fvar fv,
                   (a1, uu____13199)::(a2, uu____13201)::[]) when
                    FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.dtuple2_lid
                    ->
                    let uu____13252 =
                      let uu____13253 = FStar_Syntax_Subst.compress a2 in
                      uu____13253.FStar_Syntax_Syntax.n in
                    (match uu____13252 with
                     | FStar_Syntax_Syntax.Tm_abs (b::[], q, uu____13260) ->
                         let uu____13295 = FStar_Syntax_Subst.open_term [b] q in
                         (match uu____13295 with
                          | (bs, q1) ->
                              let b1 =
                                match bs with
                                | b1::[] -> b1
                                | uu____13348 -> failwith "impossible" in
                              let uu____13356 = patterns q1 in
                              (match uu____13356 with
                               | (pats, q2) ->
                                   FStar_All.pipe_left maybe_collect
                                     (FStar_Pervasives_Native.Some
                                        (QEx ([b1], pats, q2)))))
                     | uu____13417 -> FStar_Pervasives_Native.None)
                | uu____13418 -> FStar_Pervasives_Native.None))
    and maybe_collect f1 =
      match f1 with
      | FStar_Pervasives_Native.Some (QAll (bs, pats, phi)) ->
          let uu____13441 = destruct_sq_forall phi in
          (match uu____13441 with
           | FStar_Pervasives_Native.Some (QAll (bs', pats', psi)) ->
               FStar_All.pipe_left
                 (fun _13451 -> FStar_Pervasives_Native.Some _13451)
                 (QAll
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____13458 -> f1)
      | FStar_Pervasives_Native.Some (QEx (bs, pats, phi)) ->
          let uu____13464 = destruct_sq_exists phi in
          (match uu____13464 with
           | FStar_Pervasives_Native.Some (QEx (bs', pats', psi)) ->
               FStar_All.pipe_left
                 (fun _13474 -> FStar_Pervasives_Native.Some _13474)
                 (QEx
                    ((FStar_List.append bs bs'),
                      (FStar_List.append pats pats'), psi))
           | uu____13481 -> f1)
      | uu____13484 -> f1 in
    let phi = unmeta_monadic f in
    let uu____13488 = destruct_base_conn phi in
    FStar_Util.catch_opt uu____13488
      (fun uu____13493 ->
         let uu____13494 = destruct_q_conn phi in
         FStar_Util.catch_opt uu____13494
           (fun uu____13499 ->
              let uu____13500 = destruct_sq_base_conn phi in
              FStar_Util.catch_opt uu____13500
                (fun uu____13505 ->
                   let uu____13506 = destruct_sq_forall phi in
                   FStar_Util.catch_opt uu____13506
                     (fun uu____13511 ->
                        let uu____13512 = destruct_sq_exists phi in
                        FStar_Util.catch_opt uu____13512
                          (fun uu____13516 -> FStar_Pervasives_Native.None)))))
let (action_as_lb :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.action ->
      FStar_Range.range -> FStar_Syntax_Syntax.sigelt)
  =
  fun eff_lid ->
    fun a ->
      fun pos ->
        let lb =
          let uu____13534 =
            let uu____13539 =
              FStar_Syntax_Syntax.lid_as_fv a.FStar_Syntax_Syntax.action_name
                FStar_Syntax_Syntax.delta_equational
                FStar_Pervasives_Native.None in
            FStar_Util.Inr uu____13539 in
          let uu____13540 =
            let uu____13541 =
              FStar_Syntax_Syntax.mk_Total a.FStar_Syntax_Syntax.action_typ in
            arrow a.FStar_Syntax_Syntax.action_params uu____13541 in
          let uu____13544 =
            abs a.FStar_Syntax_Syntax.action_params
              a.FStar_Syntax_Syntax.action_defn FStar_Pervasives_Native.None in
          close_univs_and_mk_letbinding FStar_Pervasives_Native.None
            uu____13534 a.FStar_Syntax_Syntax.action_univs uu____13540
            FStar_Parser_Const.effect_Tot_lid uu____13544 [] pos in
        {
          FStar_Syntax_Syntax.sigel =
            (FStar_Syntax_Syntax.Sig_let
               ((false, [lb]), [a.FStar_Syntax_Syntax.action_name]));
          FStar_Syntax_Syntax.sigrng =
            ((a.FStar_Syntax_Syntax.action_defn).FStar_Syntax_Syntax.pos);
          FStar_Syntax_Syntax.sigquals =
            [FStar_Syntax_Syntax.Visible_default;
            FStar_Syntax_Syntax.Action eff_lid];
          FStar_Syntax_Syntax.sigmeta = FStar_Syntax_Syntax.default_sigmeta;
          FStar_Syntax_Syntax.sigattrs = []
        }
let (mk_reify :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    let reify_1 =
      FStar_Syntax_Syntax.mk
        (FStar_Syntax_Syntax.Tm_constant FStar_Const.Const_reify)
        FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos in
    let uu____13570 =
      let uu____13577 =
        let uu____13578 =
          let uu____13595 =
            let uu____13606 = FStar_Syntax_Syntax.as_arg t in [uu____13606] in
          (reify_1, uu____13595) in
        FStar_Syntax_Syntax.Tm_app uu____13578 in
      FStar_Syntax_Syntax.mk uu____13577 in
    uu____13570 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
let (mk_reflect :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    let reflect_ =
      let uu____13658 =
        let uu____13665 =
          let uu____13666 =
            let uu____13667 = FStar_Ident.lid_of_str "Bogus.Effect" in
            FStar_Const.Const_reflect uu____13667 in
          FStar_Syntax_Syntax.Tm_constant uu____13666 in
        FStar_Syntax_Syntax.mk uu____13665 in
      uu____13658 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos in
    let uu____13669 =
      let uu____13676 =
        let uu____13677 =
          let uu____13694 =
            let uu____13705 = FStar_Syntax_Syntax.as_arg t in [uu____13705] in
          (reflect_, uu____13694) in
        FStar_Syntax_Syntax.Tm_app uu____13677 in
      FStar_Syntax_Syntax.mk uu____13676 in
    uu____13669 FStar_Pervasives_Native.None t.FStar_Syntax_Syntax.pos
let rec (delta_qualifier :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth) =
  fun t ->
    let t1 = FStar_Syntax_Subst.compress t in
    match t1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____13749 -> failwith "Impossible"
    | FStar_Syntax_Syntax.Tm_lazy i ->
        let uu____13774 = unfold_lazy i in delta_qualifier uu____13774
    | FStar_Syntax_Syntax.Tm_fvar fv -> fv.FStar_Syntax_Syntax.fv_delta
    | FStar_Syntax_Syntax.Tm_bvar uu____13776 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_name uu____13777 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_match uu____13778 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_uvar uu____13801 ->
        FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_unknown -> FStar_Syntax_Syntax.delta_equational
    | FStar_Syntax_Syntax.Tm_type uu____13814 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_quoted uu____13815 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_constant uu____13822 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_arrow uu____13823 ->
        FStar_Syntax_Syntax.delta_constant
    | FStar_Syntax_Syntax.Tm_uinst (t2, uu____13839) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_refine
        ({ FStar_Syntax_Syntax.ppname = uu____13844;
           FStar_Syntax_Syntax.index = uu____13845;
           FStar_Syntax_Syntax.sort = t2;_},
         uu____13847)
        -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_meta (t2, uu____13856) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_ascribed (t2, uu____13862, uu____13863) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_app (t2, uu____13905) -> delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_abs (uu____13930, t2, uu____13932) ->
        delta_qualifier t2
    | FStar_Syntax_Syntax.Tm_let (uu____13957, t2) -> delta_qualifier t2
let rec (incr_delta_depth :
  FStar_Syntax_Syntax.delta_depth -> FStar_Syntax_Syntax.delta_depth) =
  fun d ->
    match d with
    | FStar_Syntax_Syntax.Delta_constant_at_level i ->
        FStar_Syntax_Syntax.Delta_constant_at_level
          (i + (Prims.parse_int "1"))
    | FStar_Syntax_Syntax.Delta_equational_at_level i ->
        FStar_Syntax_Syntax.Delta_equational_at_level
          (i + (Prims.parse_int "1"))
    | FStar_Syntax_Syntax.Delta_abstract d1 -> incr_delta_depth d1
let (incr_delta_qualifier :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.delta_depth) =
  fun t ->
    let uu____13996 = delta_qualifier t in incr_delta_depth uu____13996
let (is_unknown : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____14004 =
      let uu____14005 = FStar_Syntax_Subst.compress t in
      uu____14005.FStar_Syntax_Syntax.n in
    match uu____14004 with
    | FStar_Syntax_Syntax.Tm_unknown -> true
    | uu____14010 -> false
let rec apply_last :
  'Auu____14019 .
    ('Auu____14019 -> 'Auu____14019) ->
      'Auu____14019 Prims.list -> 'Auu____14019 Prims.list
  =
  fun f ->
    fun l ->
      match l with
      | [] -> failwith "apply_last: got empty list"
      | a::[] -> let uu____14045 = f a in [uu____14045]
      | x::xs -> let uu____14050 = apply_last f xs in x :: uu____14050
let (dm4f_lid :
  FStar_Syntax_Syntax.eff_decl -> Prims.string -> FStar_Ident.lident) =
  fun ed ->
    fun name ->
      let p = FStar_Ident.path_of_lid ed.FStar_Syntax_Syntax.mname in
      let p' =
        apply_last
          (fun s ->
             Prims.op_Hat "_dm4f_" (Prims.op_Hat s (Prims.op_Hat "_" name)))
          p in
      FStar_Ident.lid_of_path p' FStar_Range.dummyRange
let rec (mk_list :
  FStar_Syntax_Syntax.term ->
    FStar_Range.range ->
      FStar_Syntax_Syntax.term Prims.list -> FStar_Syntax_Syntax.term)
  =
  fun typ ->
    fun rng ->
      fun l ->
        let ctor l1 =
          let uu____14105 =
            let uu____14112 =
              let uu____14113 =
                FStar_Syntax_Syntax.lid_as_fv l1
                  FStar_Syntax_Syntax.delta_constant
                  (FStar_Pervasives_Native.Some FStar_Syntax_Syntax.Data_ctor) in
              FStar_Syntax_Syntax.Tm_fvar uu____14113 in
            FStar_Syntax_Syntax.mk uu____14112 in
          uu____14105 FStar_Pervasives_Native.None rng in
        let cons1 args pos =
          let uu____14127 =
            let uu____14132 =
              let uu____14133 = ctor FStar_Parser_Const.cons_lid in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____14133
                [FStar_Syntax_Syntax.U_zero] in
            FStar_Syntax_Syntax.mk_Tm_app uu____14132 args in
          uu____14127 FStar_Pervasives_Native.None pos in
        let nil args pos =
          let uu____14147 =
            let uu____14152 =
              let uu____14153 = ctor FStar_Parser_Const.nil_lid in
              FStar_Syntax_Syntax.mk_Tm_uinst uu____14153
                [FStar_Syntax_Syntax.U_zero] in
            FStar_Syntax_Syntax.mk_Tm_app uu____14152 args in
          uu____14147 FStar_Pervasives_Native.None pos in
        let uu____14154 =
          let uu____14155 =
            let uu____14156 = FStar_Syntax_Syntax.iarg typ in [uu____14156] in
          nil uu____14155 rng in
        FStar_List.fold_right
          (fun t ->
             fun a ->
               let uu____14190 =
                 let uu____14191 = FStar_Syntax_Syntax.iarg typ in
                 let uu____14200 =
                   let uu____14211 = FStar_Syntax_Syntax.as_arg t in
                   let uu____14220 =
                     let uu____14231 = FStar_Syntax_Syntax.as_arg a in
                     [uu____14231] in
                   uu____14211 :: uu____14220 in
                 uu____14191 :: uu____14200 in
               cons1 uu____14190 t.FStar_Syntax_Syntax.pos) l uu____14154
let rec eqlist :
  'a .
    ('a -> 'a -> Prims.bool) -> 'a Prims.list -> 'a Prims.list -> Prims.bool
  =
  fun eq1 ->
    fun xs ->
      fun ys ->
        match (xs, ys) with
        | ([], []) -> true
        | (x::xs1, y::ys1) -> (eq1 x y) && (eqlist eq1 xs1 ys1)
        | uu____14340 -> false
let eqsum :
  'a 'b .
    ('a -> 'a -> Prims.bool) ->
      ('b -> 'b -> Prims.bool) ->
        ('a, 'b) FStar_Util.either ->
          ('a, 'b) FStar_Util.either -> Prims.bool
  =
  fun e1 ->
    fun e2 ->
      fun x ->
        fun y ->
          match (x, y) with
          | (FStar_Util.Inl x1, FStar_Util.Inl y1) -> e1 x1 y1
          | (FStar_Util.Inr x1, FStar_Util.Inr y1) -> e2 x1 y1
          | uu____14454 -> false
let eqprod :
  'a 'b .
    ('a -> 'a -> Prims.bool) ->
      ('b -> 'b -> Prims.bool) -> ('a * 'b) -> ('a * 'b) -> Prims.bool
  =
  fun e1 ->
    fun e2 ->
      fun x ->
        fun y ->
          match (x, y) with
          | ((x1, x2), (y1, y2)) -> (e1 x1 y1) && (e2 x2 y2)
let eqopt :
  'a .
    ('a -> 'a -> Prims.bool) ->
      'a FStar_Pervasives_Native.option ->
        'a FStar_Pervasives_Native.option -> Prims.bool
  =
  fun e ->
    fun x ->
      fun y ->
        match (x, y) with
        | (FStar_Pervasives_Native.Some x1, FStar_Pervasives_Native.Some y1)
            -> e x1 y1
        | uu____14620 -> false
let (debug_term_eq : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false
let (check : Prims.string -> Prims.bool -> Prims.bool) =
  fun msg ->
    fun cond ->
      if cond
      then true
      else
        ((let uu____14658 = FStar_ST.op_Bang debug_term_eq in
          if uu____14658
          then FStar_Util.print1 ">>> term_eq failing: %s\n" msg
          else ());
         false)
let (fail : Prims.string -> Prims.bool) = fun msg -> check msg false
let rec (term_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool)
  =
  fun dbg ->
    fun t1 ->
      fun t2 ->
        let t11 = let uu____14880 = unmeta_safe t1 in canon_app uu____14880 in
        let t21 = let uu____14886 = unmeta_safe t2 in canon_app uu____14886 in
        let uu____14889 =
          let uu____14894 =
            let uu____14895 =
              let uu____14898 = un_uinst t11 in
              FStar_Syntax_Subst.compress uu____14898 in
            uu____14895.FStar_Syntax_Syntax.n in
          let uu____14899 =
            let uu____14900 =
              let uu____14903 = un_uinst t21 in
              FStar_Syntax_Subst.compress uu____14903 in
            uu____14900.FStar_Syntax_Syntax.n in
          (uu____14894, uu____14899) in
        match uu____14889 with
        | (FStar_Syntax_Syntax.Tm_uinst uu____14905, uu____14906) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____14915, FStar_Syntax_Syntax.Tm_uinst uu____14916) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_delayed uu____14925, uu____14926) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____14951, FStar_Syntax_Syntax.Tm_delayed uu____14952) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_ascribed uu____14977, uu____14978) ->
            failwith "term_eq: impossible, should have been removed"
        | (uu____15007, FStar_Syntax_Syntax.Tm_ascribed uu____15008) ->
            failwith "term_eq: impossible, should have been removed"
        | (FStar_Syntax_Syntax.Tm_bvar x, FStar_Syntax_Syntax.Tm_bvar y) ->
            check "bvar"
              (x.FStar_Syntax_Syntax.index = y.FStar_Syntax_Syntax.index)
        | (FStar_Syntax_Syntax.Tm_name x, FStar_Syntax_Syntax.Tm_name y) ->
            check "name"
              (x.FStar_Syntax_Syntax.index = y.FStar_Syntax_Syntax.index)
        | (FStar_Syntax_Syntax.Tm_fvar x, FStar_Syntax_Syntax.Tm_fvar y) ->
            let uu____15047 = FStar_Syntax_Syntax.fv_eq x y in
            check "fvar" uu____15047
        | (FStar_Syntax_Syntax.Tm_constant c1,
           FStar_Syntax_Syntax.Tm_constant c2) ->
            let uu____15052 = FStar_Const.eq_const c1 c2 in
            check "const" uu____15052
        | (FStar_Syntax_Syntax.Tm_type uu____15055,
           FStar_Syntax_Syntax.Tm_type uu____15056) -> true
        | (FStar_Syntax_Syntax.Tm_abs (b1, t12, k1),
           FStar_Syntax_Syntax.Tm_abs (b2, t22, k2)) ->
            (let uu____15114 = eqlist (binder_eq_dbg dbg) b1 b2 in
             check "abs binders" uu____15114) &&
              (let uu____15124 = term_eq_dbg dbg t12 t22 in
               check "abs bodies" uu____15124)
        | (FStar_Syntax_Syntax.Tm_arrow (b1, c1),
           FStar_Syntax_Syntax.Tm_arrow (b2, c2)) ->
            (let uu____15173 = eqlist (binder_eq_dbg dbg) b1 b2 in
             check "arrow binders" uu____15173) &&
              (let uu____15183 = comp_eq_dbg dbg c1 c2 in
               check "arrow comp" uu____15183)
        | (FStar_Syntax_Syntax.Tm_refine (b1, t12),
           FStar_Syntax_Syntax.Tm_refine (b2, t22)) ->
            (check "refine bv"
               (b1.FStar_Syntax_Syntax.index = b2.FStar_Syntax_Syntax.index))
              &&
              (let uu____15201 = term_eq_dbg dbg t12 t22 in
               check "refine formula" uu____15201)
        | (FStar_Syntax_Syntax.Tm_app (f1, a1), FStar_Syntax_Syntax.Tm_app
           (f2, a2)) ->
            (let uu____15258 = term_eq_dbg dbg f1 f2 in
             check "app head" uu____15258) &&
              (let uu____15262 = eqlist (arg_eq_dbg dbg) a1 a2 in
               check "app args" uu____15262)
        | (FStar_Syntax_Syntax.Tm_match (t12, bs1),
           FStar_Syntax_Syntax.Tm_match (t22, bs2)) ->
            (let uu____15351 = term_eq_dbg dbg t12 t22 in
             check "match head" uu____15351) &&
              (let uu____15355 = eqlist (branch_eq_dbg dbg) bs1 bs2 in
               check "match branches" uu____15355)
        | (FStar_Syntax_Syntax.Tm_lazy uu____15372, uu____15373) ->
            let uu____15374 =
              let uu____15376 = unlazy t11 in term_eq_dbg dbg uu____15376 t21 in
            check "lazy_l" uu____15374
        | (uu____15378, FStar_Syntax_Syntax.Tm_lazy uu____15379) ->
            let uu____15380 =
              let uu____15382 = unlazy t21 in term_eq_dbg dbg t11 uu____15382 in
            check "lazy_r" uu____15380
        | (FStar_Syntax_Syntax.Tm_let ((b1, lbs1), t12),
           FStar_Syntax_Syntax.Tm_let ((b2, lbs2), t22)) ->
            ((check "let flag" (b1 = b2)) &&
               (let uu____15427 = eqlist (letbinding_eq_dbg dbg) lbs1 lbs2 in
                check "let lbs" uu____15427))
              &&
              (let uu____15431 = term_eq_dbg dbg t12 t22 in
               check "let body" uu____15431)
        | (FStar_Syntax_Syntax.Tm_uvar (u1, uu____15435),
           FStar_Syntax_Syntax.Tm_uvar (u2, uu____15437)) ->
            check "uvar"
              (u1.FStar_Syntax_Syntax.ctx_uvar_head =
                 u2.FStar_Syntax_Syntax.ctx_uvar_head)
        | (FStar_Syntax_Syntax.Tm_quoted (qt1, qi1),
           FStar_Syntax_Syntax.Tm_quoted (qt2, qi2)) ->
            (let uu____15495 =
               let uu____15497 = eq_quoteinfo qi1 qi2 in uu____15497 = Equal in
             check "tm_quoted qi" uu____15495) &&
              (let uu____15500 = term_eq_dbg dbg qt1 qt2 in
               check "tm_quoted payload" uu____15500)
        | (FStar_Syntax_Syntax.Tm_meta (t12, m1), FStar_Syntax_Syntax.Tm_meta
           (t22, m2)) ->
            (match (m1, m2) with
             | (FStar_Syntax_Syntax.Meta_monadic (n1, ty1),
                FStar_Syntax_Syntax.Meta_monadic (n2, ty2)) ->
                 (let uu____15530 = FStar_Ident.lid_equals n1 n2 in
                  check "meta_monadic lid" uu____15530) &&
                   (let uu____15534 = term_eq_dbg dbg ty1 ty2 in
                    check "meta_monadic type" uu____15534)
             | (FStar_Syntax_Syntax.Meta_monadic_lift (s1, t13, ty1),
                FStar_Syntax_Syntax.Meta_monadic_lift (s2, t23, ty2)) ->
                 ((let uu____15553 = FStar_Ident.lid_equals s1 s2 in
                   check "meta_monadic_lift src" uu____15553) &&
                    (let uu____15557 = FStar_Ident.lid_equals t13 t23 in
                     check "meta_monadic_lift tgt" uu____15557))
                   &&
                   (let uu____15561 = term_eq_dbg dbg ty1 ty2 in
                    check "meta_monadic_lift type" uu____15561)
             | uu____15564 -> fail "metas")
        | (FStar_Syntax_Syntax.Tm_unknown, uu____15570) -> fail "unk"
        | (uu____15572, FStar_Syntax_Syntax.Tm_unknown) -> fail "unk"
        | (FStar_Syntax_Syntax.Tm_bvar uu____15574, uu____15575) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_name uu____15577, uu____15578) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_fvar uu____15580, uu____15581) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_constant uu____15583, uu____15584) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_type uu____15586, uu____15587) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_abs uu____15589, uu____15590) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_arrow uu____15610, uu____15611) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_refine uu____15627, uu____15628) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_app uu____15636, uu____15637) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_match uu____15655, uu____15656) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_let uu____15680, uu____15681) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_uvar uu____15696, uu____15697) ->
            fail "bottom"
        | (FStar_Syntax_Syntax.Tm_meta uu____15711, uu____15712) ->
            fail "bottom"
        | (uu____15720, FStar_Syntax_Syntax.Tm_bvar uu____15721) ->
            fail "bottom"
        | (uu____15723, FStar_Syntax_Syntax.Tm_name uu____15724) ->
            fail "bottom"
        | (uu____15726, FStar_Syntax_Syntax.Tm_fvar uu____15727) ->
            fail "bottom"
        | (uu____15729, FStar_Syntax_Syntax.Tm_constant uu____15730) ->
            fail "bottom"
        | (uu____15732, FStar_Syntax_Syntax.Tm_type uu____15733) ->
            fail "bottom"
        | (uu____15735, FStar_Syntax_Syntax.Tm_abs uu____15736) ->
            fail "bottom"
        | (uu____15756, FStar_Syntax_Syntax.Tm_arrow uu____15757) ->
            fail "bottom"
        | (uu____15773, FStar_Syntax_Syntax.Tm_refine uu____15774) ->
            fail "bottom"
        | (uu____15782, FStar_Syntax_Syntax.Tm_app uu____15783) ->
            fail "bottom"
        | (uu____15801, FStar_Syntax_Syntax.Tm_match uu____15802) ->
            fail "bottom"
        | (uu____15826, FStar_Syntax_Syntax.Tm_let uu____15827) ->
            fail "bottom"
        | (uu____15842, FStar_Syntax_Syntax.Tm_uvar uu____15843) ->
            fail "bottom"
        | (uu____15857, FStar_Syntax_Syntax.Tm_meta uu____15858) ->
            fail "bottom"
and (arg_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option) ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
        FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option) ->
        Prims.bool)
  =
  fun dbg ->
    fun a1 ->
      fun a2 ->
        eqprod
          (fun t1 ->
             fun t2 ->
               let uu____15893 = term_eq_dbg dbg t1 t2 in
               check "arg tm" uu____15893)
          (fun q1 ->
             fun q2 ->
               let uu____15905 =
                 let uu____15907 = eq_aqual q1 q2 in uu____15907 = Equal in
               check "arg qual" uu____15905) a1 a2
and (binder_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
      FStar_Pervasives_Native.option) ->
      (FStar_Syntax_Syntax.bv * FStar_Syntax_Syntax.arg_qualifier
        FStar_Pervasives_Native.option) -> Prims.bool)
  =
  fun dbg ->
    fun b1 ->
      fun b2 ->
        eqprod
          (fun b11 ->
             fun b21 ->
               let uu____15932 =
                 term_eq_dbg dbg b11.FStar_Syntax_Syntax.sort
                   b21.FStar_Syntax_Syntax.sort in
               check "binder sort" uu____15932)
          (fun q1 ->
             fun q2 ->
               let uu____15944 =
                 let uu____15946 = eq_aqual q1 q2 in uu____15946 = Equal in
               check "binder qual" uu____15944) b1 b2
and (lcomp_eq_dbg :
  FStar_Syntax_Syntax.lcomp -> FStar_Syntax_Syntax.lcomp -> Prims.bool) =
  fun c1 -> fun c2 -> fail "lcomp"
and (residual_eq_dbg :
  FStar_Syntax_Syntax.residual_comp ->
    FStar_Syntax_Syntax.residual_comp -> Prims.bool)
  = fun r1 -> fun r2 -> fail "residual"
and (comp_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax -> Prims.bool)
  =
  fun dbg ->
    fun c1 ->
      fun c2 ->
        let c11 = comp_to_comp_typ_nouniv c1 in
        let c21 = comp_to_comp_typ_nouniv c2 in
        ((let uu____15966 =
            FStar_Ident.lid_equals c11.FStar_Syntax_Syntax.effect_name
              c21.FStar_Syntax_Syntax.effect_name in
          check "comp eff" uu____15966) &&
           (let uu____15970 =
              term_eq_dbg dbg c11.FStar_Syntax_Syntax.result_typ
                c21.FStar_Syntax_Syntax.result_typ in
            check "comp result typ" uu____15970))
          && true
and (eq_flags_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.cflag -> FStar_Syntax_Syntax.cflag -> Prims.bool)
  = fun dbg -> fun f1 -> fun f2 -> true
and (branch_eq_dbg :
  Prims.bool ->
    (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t *
      FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
      FStar_Pervasives_Native.option * FStar_Syntax_Syntax.term'
      FStar_Syntax_Syntax.syntax) ->
      (FStar_Syntax_Syntax.pat' FStar_Syntax_Syntax.withinfo_t *
        FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax
        FStar_Pervasives_Native.option * FStar_Syntax_Syntax.term'
        FStar_Syntax_Syntax.syntax) -> Prims.bool)
  =
  fun dbg ->
    fun uu____15980 ->
      fun uu____15981 ->
        match (uu____15980, uu____15981) with
        | ((p1, w1, t1), (p2, w2, t2)) ->
            ((let uu____16108 = FStar_Syntax_Syntax.eq_pat p1 p2 in
              check "branch pat" uu____16108) &&
               (let uu____16112 = term_eq_dbg dbg t1 t2 in
                check "branch body" uu____16112))
              &&
              (let uu____16116 =
                 match (w1, w2) with
                 | (FStar_Pervasives_Native.Some x,
                    FStar_Pervasives_Native.Some y) -> term_eq_dbg dbg x y
                 | (FStar_Pervasives_Native.None,
                    FStar_Pervasives_Native.None) -> true
                 | uu____16158 -> false in
               check "branch when" uu____16116)
and (letbinding_eq_dbg :
  Prims.bool ->
    FStar_Syntax_Syntax.letbinding ->
      FStar_Syntax_Syntax.letbinding -> Prims.bool)
  =
  fun dbg ->
    fun lb1 ->
      fun lb2 ->
        ((let uu____16179 =
            eqsum (fun bv1 -> fun bv2 -> true) FStar_Syntax_Syntax.fv_eq
              lb1.FStar_Syntax_Syntax.lbname lb2.FStar_Syntax_Syntax.lbname in
          check "lb bv" uu____16179) &&
           (let uu____16188 =
              term_eq_dbg dbg lb1.FStar_Syntax_Syntax.lbtyp
                lb2.FStar_Syntax_Syntax.lbtyp in
            check "lb typ" uu____16188))
          &&
          (let uu____16192 =
             term_eq_dbg dbg lb1.FStar_Syntax_Syntax.lbdef
               lb2.FStar_Syntax_Syntax.lbdef in
           check "lb def" uu____16192)
let (term_eq :
  FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t1 ->
    fun t2 ->
      let r =
        let uu____16209 = FStar_ST.op_Bang debug_term_eq in
        term_eq_dbg uu____16209 t1 t2 in
      FStar_ST.op_Colon_Equals debug_term_eq false; r
let rec (sizeof : FStar_Syntax_Syntax.term -> Prims.int) =
  fun t ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____16263 ->
        let uu____16286 =
          let uu____16288 = FStar_Syntax_Subst.compress t in
          sizeof uu____16288 in
        (Prims.parse_int "1") + uu____16286
    | FStar_Syntax_Syntax.Tm_bvar bv ->
        let uu____16291 = sizeof bv.FStar_Syntax_Syntax.sort in
        (Prims.parse_int "1") + uu____16291
    | FStar_Syntax_Syntax.Tm_name bv ->
        let uu____16295 = sizeof bv.FStar_Syntax_Syntax.sort in
        (Prims.parse_int "1") + uu____16295
    | FStar_Syntax_Syntax.Tm_uinst (t1, us) ->
        let uu____16304 = sizeof t1 in (FStar_List.length us) + uu____16304
    | FStar_Syntax_Syntax.Tm_abs (bs, t1, uu____16308) ->
        let uu____16333 = sizeof t1 in
        let uu____16335 =
          FStar_List.fold_left
            (fun acc ->
               fun uu____16350 ->
                 match uu____16350 with
                 | (bv, uu____16360) ->
                     let uu____16365 = sizeof bv.FStar_Syntax_Syntax.sort in
                     acc + uu____16365) (Prims.parse_int "0") bs in
        uu____16333 + uu____16335
    | FStar_Syntax_Syntax.Tm_app (hd1, args) ->
        let uu____16394 = sizeof hd1 in
        let uu____16396 =
          FStar_List.fold_left
            (fun acc ->
               fun uu____16411 ->
                 match uu____16411 with
                 | (arg, uu____16421) ->
                     let uu____16426 = sizeof arg in acc + uu____16426)
            (Prims.parse_int "0") args in
        uu____16394 + uu____16396
    | uu____16429 -> (Prims.parse_int "1")
let (is_fvar : FStar_Ident.lident -> FStar_Syntax_Syntax.term -> Prims.bool)
  =
  fun lid ->
    fun t ->
      let uu____16443 =
        let uu____16444 = un_uinst t in uu____16444.FStar_Syntax_Syntax.n in
      match uu____16443 with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          FStar_Syntax_Syntax.fv_eq_lid fv lid
      | uu____16449 -> false
let (is_synth_by_tactic : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t -> is_fvar FStar_Parser_Const.synth_lid t
let (has_attribute :
  FStar_Syntax_Syntax.attribute Prims.list ->
    FStar_Ident.lident -> Prims.bool)
  = fun attrs -> fun attr -> FStar_Util.for_some (is_fvar attr) attrs
let (process_pragma :
  FStar_Syntax_Syntax.pragma -> FStar_Range.range -> unit) =
  fun p ->
    fun r ->
      let set_options1 t s =
        let uu____16498 = FStar_Options.set_options t s in
        match uu____16498 with
        | FStar_Getopt.Success -> ()
        | FStar_Getopt.Help ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                "Failed to process pragma: use 'fstar --help' to see which options are available")
              r
        | FStar_Getopt.Error s1 ->
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                (Prims.op_Hat "Failed to process pragma: " s1)) r in
      match p with
      | FStar_Syntax_Syntax.LightOff ->
          if p = FStar_Syntax_Syntax.LightOff
          then FStar_Options.set_ml_ish ()
          else ()
      | FStar_Syntax_Syntax.SetOptions o -> set_options1 FStar_Options.Set o
      | FStar_Syntax_Syntax.ResetOptions sopt ->
          ((let uu____16515 = FStar_Options.restore_cmd_line_options false in
            FStar_All.pipe_right uu____16515 (fun a1 -> ()));
           (match sopt with
            | FStar_Pervasives_Native.None -> ()
            | FStar_Pervasives_Native.Some s ->
                set_options1 FStar_Options.Reset s))
      | FStar_Syntax_Syntax.PushOptions sopt ->
          (FStar_Options.internal_push ();
           (match sopt with
            | FStar_Pervasives_Native.None -> ()
            | FStar_Pervasives_Native.Some s ->
                set_options1 FStar_Options.Reset s))
      | FStar_Syntax_Syntax.PopOptions ->
          let uu____16530 = FStar_Options.internal_pop () in
          if uu____16530
          then ()
          else
            FStar_Errors.raise_error
              (FStar_Errors.Fatal_FailToProcessPragma,
                "Cannot #pop-options, stack would become empty") r
let rec (unbound_variables :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv Prims.list)
  =
  fun tm ->
    let t = FStar_Syntax_Subst.compress tm in
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_delayed uu____16562 -> failwith "Impossible"
    | FStar_Syntax_Syntax.Tm_name x -> []
    | FStar_Syntax_Syntax.Tm_uvar uu____16589 -> []
    | FStar_Syntax_Syntax.Tm_type u -> []
    | FStar_Syntax_Syntax.Tm_bvar x -> [x]
    | FStar_Syntax_Syntax.Tm_fvar uu____16604 -> []
    | FStar_Syntax_Syntax.Tm_constant uu____16605 -> []
    | FStar_Syntax_Syntax.Tm_lazy uu____16606 -> []
    | FStar_Syntax_Syntax.Tm_unknown -> []
    | FStar_Syntax_Syntax.Tm_uinst (t1, us) -> unbound_variables t1
    | FStar_Syntax_Syntax.Tm_abs (bs, t1, uu____16615) ->
        let uu____16640 = FStar_Syntax_Subst.open_term bs t1 in
        (match uu____16640 with
         | (bs1, t2) ->
             let uu____16649 =
               FStar_List.collect
                 (fun uu____16661 ->
                    match uu____16661 with
                    | (b, uu____16671) ->
                        unbound_variables b.FStar_Syntax_Syntax.sort) bs1 in
             let uu____16676 = unbound_variables t2 in
             FStar_List.append uu____16649 uu____16676)
    | FStar_Syntax_Syntax.Tm_arrow (bs, c) ->
        let uu____16701 = FStar_Syntax_Subst.open_comp bs c in
        (match uu____16701 with
         | (bs1, c1) ->
             let uu____16710 =
               FStar_List.collect
                 (fun uu____16722 ->
                    match uu____16722 with
                    | (b, uu____16732) ->
                        unbound_variables b.FStar_Syntax_Syntax.sort) bs1 in
             let uu____16737 = unbound_variables_comp c1 in
             FStar_List.append uu____16710 uu____16737)
    | FStar_Syntax_Syntax.Tm_refine (b, t1) ->
        let uu____16746 =
          FStar_Syntax_Subst.open_term [(b, FStar_Pervasives_Native.None)] t1 in
        (match uu____16746 with
         | (bs, t2) ->
             let uu____16769 =
               FStar_List.collect
                 (fun uu____16781 ->
                    match uu____16781 with
                    | (b1, uu____16791) ->
                        unbound_variables b1.FStar_Syntax_Syntax.sort) bs in
             let uu____16796 = unbound_variables t2 in
             FStar_List.append uu____16769 uu____16796)
    | FStar_Syntax_Syntax.Tm_app (t1, args) ->
        let uu____16825 =
          FStar_List.collect
            (fun uu____16839 ->
               match uu____16839 with
               | (x, uu____16851) -> unbound_variables x) args in
        let uu____16860 = unbound_variables t1 in
        FStar_List.append uu____16825 uu____16860
    | FStar_Syntax_Syntax.Tm_match (t1, pats) ->
        let uu____16901 = unbound_variables t1 in
        let uu____16904 =
          FStar_All.pipe_right pats
            (FStar_List.collect
               (fun br ->
                  let uu____16919 = FStar_Syntax_Subst.open_branch br in
                  match uu____16919 with
                  | (p, wopt, t2) ->
                      let uu____16941 = unbound_variables t2 in
                      let uu____16944 =
                        match wopt with
                        | FStar_Pervasives_Native.None -> []
                        | FStar_Pervasives_Native.Some t3 ->
                            unbound_variables t3 in
                      FStar_List.append uu____16941 uu____16944)) in
        FStar_List.append uu____16901 uu____16904
    | FStar_Syntax_Syntax.Tm_ascribed (t1, asc, uu____16958) ->
        let uu____16999 = unbound_variables t1 in
        let uu____17002 =
          let uu____17005 =
            match FStar_Pervasives_Native.fst asc with
            | FStar_Util.Inl t2 -> unbound_variables t2
            | FStar_Util.Inr c2 -> unbound_variables_comp c2 in
          let uu____17036 =
            match FStar_Pervasives_Native.snd asc with
            | FStar_Pervasives_Native.None -> []
            | FStar_Pervasives_Native.Some tac -> unbound_variables tac in
          FStar_List.append uu____17005 uu____17036 in
        FStar_List.append uu____16999 uu____17002
    | FStar_Syntax_Syntax.Tm_let ((false, lb::[]), t1) ->
        let uu____17077 = unbound_variables lb.FStar_Syntax_Syntax.lbtyp in
        let uu____17080 =
          let uu____17083 = unbound_variables lb.FStar_Syntax_Syntax.lbdef in
          let uu____17086 =
            match lb.FStar_Syntax_Syntax.lbname with
            | FStar_Util.Inr uu____17091 -> unbound_variables t1
            | FStar_Util.Inl bv ->
                let uu____17093 =
                  FStar_Syntax_Subst.open_term
                    [(bv, FStar_Pervasives_Native.None)] t1 in
                (match uu____17093 with
                 | (uu____17114, t2) -> unbound_variables t2) in
          FStar_List.append uu____17083 uu____17086 in
        FStar_List.append uu____17077 uu____17080
    | FStar_Syntax_Syntax.Tm_let ((uu____17116, lbs), t1) ->
        let uu____17136 = FStar_Syntax_Subst.open_let_rec lbs t1 in
        (match uu____17136 with
         | (lbs1, t2) ->
             let uu____17151 = unbound_variables t2 in
             let uu____17154 =
               FStar_List.collect
                 (fun lb ->
                    let uu____17161 =
                      unbound_variables lb.FStar_Syntax_Syntax.lbtyp in
                    let uu____17164 =
                      unbound_variables lb.FStar_Syntax_Syntax.lbdef in
                    FStar_List.append uu____17161 uu____17164) lbs1 in
             FStar_List.append uu____17151 uu____17154)
    | FStar_Syntax_Syntax.Tm_quoted (tm1, qi) ->
        (match qi.FStar_Syntax_Syntax.qkind with
         | FStar_Syntax_Syntax.Quote_static -> []
         | FStar_Syntax_Syntax.Quote_dynamic -> unbound_variables tm1)
    | FStar_Syntax_Syntax.Tm_meta (t1, m) ->
        let uu____17181 = unbound_variables t1 in
        let uu____17184 =
          match m with
          | FStar_Syntax_Syntax.Meta_pattern args ->
              FStar_List.collect
                (FStar_List.collect
                   (fun uu____17223 ->
                      match uu____17223 with
                      | (a, uu____17235) -> unbound_variables a)) args
          | FStar_Syntax_Syntax.Meta_monadic_lift
              (uu____17244, uu____17245, t') -> unbound_variables t'
          | FStar_Syntax_Syntax.Meta_monadic (uu____17251, t') ->
              unbound_variables t'
          | FStar_Syntax_Syntax.Meta_labeled uu____17257 -> []
          | FStar_Syntax_Syntax.Meta_desugared uu____17266 -> []
          | FStar_Syntax_Syntax.Meta_named uu____17267 -> [] in
        FStar_List.append uu____17181 uu____17184
and (unbound_variables_comp :
  FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.bv Prims.list)
  =
  fun c ->
    match c.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.GTotal (t, uu____17274) -> unbound_variables t
    | FStar_Syntax_Syntax.Total (t, uu____17284) -> unbound_variables t
    | FStar_Syntax_Syntax.Comp ct ->
        let uu____17294 = unbound_variables ct.FStar_Syntax_Syntax.result_typ in
        let uu____17297 =
          FStar_List.collect
            (fun uu____17311 ->
               match uu____17311 with
               | (a, uu____17323) -> unbound_variables a)
            ct.FStar_Syntax_Syntax.effect_args in
        FStar_List.append uu____17294 uu____17297
let (extract_attr' :
  FStar_Ident.lid ->
    FStar_Syntax_Syntax.term Prims.list ->
      (FStar_Syntax_Syntax.term Prims.list * FStar_Syntax_Syntax.args)
        FStar_Pervasives_Native.option)
  =
  fun attr_lid ->
    fun attrs ->
      let rec aux acc attrs1 =
        match attrs1 with
        | [] -> FStar_Pervasives_Native.None
        | h::t ->
            let uu____17438 = head_and_args h in
            (match uu____17438 with
             | (head1, args) ->
                 let uu____17499 =
                   let uu____17500 = FStar_Syntax_Subst.compress head1 in
                   uu____17500.FStar_Syntax_Syntax.n in
                 (match uu____17499 with
                  | FStar_Syntax_Syntax.Tm_fvar fv when
                      FStar_Syntax_Syntax.fv_eq_lid fv attr_lid ->
                      let attrs' = FStar_List.rev_acc acc t in
                      FStar_Pervasives_Native.Some (attrs', args)
                  | uu____17553 -> aux (h :: acc) t)) in
      aux [] attrs
let (extract_attr :
  FStar_Ident.lid ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.args)
        FStar_Pervasives_Native.option)
  =
  fun attr_lid ->
    fun se ->
      let uu____17577 =
        extract_attr' attr_lid se.FStar_Syntax_Syntax.sigattrs in
      match uu____17577 with
      | FStar_Pervasives_Native.None -> FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some (attrs', t) ->
          FStar_Pervasives_Native.Some
            ((let uu___2524_17619 = se in
              {
                FStar_Syntax_Syntax.sigel =
                  (uu___2524_17619.FStar_Syntax_Syntax.sigel);
                FStar_Syntax_Syntax.sigrng =
                  (uu___2524_17619.FStar_Syntax_Syntax.sigrng);
                FStar_Syntax_Syntax.sigquals =
                  (uu___2524_17619.FStar_Syntax_Syntax.sigquals);
                FStar_Syntax_Syntax.sigmeta =
                  (uu___2524_17619.FStar_Syntax_Syntax.sigmeta);
                FStar_Syntax_Syntax.sigattrs = attrs'
              }), t)
let (is_smt_lemma : FStar_Syntax_Syntax.term -> Prims.bool) =
  fun t ->
    let uu____17627 =
      let uu____17628 = FStar_Syntax_Subst.compress t in
      uu____17628.FStar_Syntax_Syntax.n in
    match uu____17627 with
    | FStar_Syntax_Syntax.Tm_arrow (uu____17632, c) ->
        (match c.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Comp ct when
             FStar_Ident.lid_equals ct.FStar_Syntax_Syntax.effect_name
               FStar_Parser_Const.effect_Lemma_lid
             ->
             (match ct.FStar_Syntax_Syntax.effect_args with
              | _req::_ens::(pats, uu____17660)::uu____17661 ->
                  let pats' = unmeta pats in
                  let uu____17721 = head_and_args pats' in
                  (match uu____17721 with
                   | (head1, uu____17740) ->
                       let uu____17765 =
                         let uu____17766 = un_uinst head1 in
                         uu____17766.FStar_Syntax_Syntax.n in
                       (match uu____17765 with
                        | FStar_Syntax_Syntax.Tm_fvar fv ->
                            FStar_Syntax_Syntax.fv_eq_lid fv
                              FStar_Parser_Const.cons_lid
                        | uu____17771 -> false))
              | uu____17773 -> false)
         | uu____17785 -> false)
    | uu____17787 -> false
let rec (list_elements :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.term Prims.list FStar_Pervasives_Native.option)
  =
  fun e ->
    let uu____17803 = let uu____17820 = unmeta e in head_and_args uu____17820 in
    match uu____17803 with
    | (head1, args) ->
        let uu____17851 =
          let uu____17866 =
            let uu____17867 = un_uinst head1 in
            uu____17867.FStar_Syntax_Syntax.n in
          (uu____17866, args) in
        (match uu____17851 with
         | (FStar_Syntax_Syntax.Tm_fvar fv, uu____17885) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.nil_lid ->
             FStar_Pervasives_Native.Some []
         | (FStar_Syntax_Syntax.Tm_fvar fv,
            uu____17909::(hd1, uu____17911)::(tl1, uu____17913)::[]) when
             FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.cons_lid ->
             let uu____17980 =
               let uu____17983 =
                 let uu____17986 = list_elements tl1 in
                 FStar_Util.must uu____17986 in
               hd1 :: uu____17983 in
             FStar_Pervasives_Native.Some uu____17980
         | uu____17995 -> FStar_Pervasives_Native.None)
let (unthunk_lemma_post :
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun t ->
    let uu____18024 =
      let uu____18025 = FStar_Syntax_Subst.compress t in
      uu____18025.FStar_Syntax_Syntax.n in
    match uu____18024 with
    | FStar_Syntax_Syntax.Tm_abs (b::[], e, uu____18032) ->
        let uu____18067 = FStar_Syntax_Subst.open_term [b] e in
        (match uu____18067 with
         | (bs, e1) ->
             let b1 = FStar_List.hd bs in
             let uu____18101 = is_free_in (FStar_Pervasives_Native.fst b1) e1 in
             if uu____18101
             then
               let uu____18108 =
                 let uu____18119 = FStar_Syntax_Syntax.as_arg exp_unit in
                 [uu____18119] in
               mk_app t uu____18108
             else e1)
    | uu____18146 ->
        let uu____18147 =
          let uu____18158 = FStar_Syntax_Syntax.as_arg exp_unit in
          [uu____18158] in
        mk_app t uu____18147
let (smt_lemma_as_forall :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.universe Prims.list)
      -> FStar_Syntax_Syntax.term)
  =
  fun t ->
    fun universe_of_binders ->
      let list_elements1 e =
        let uu____18213 = list_elements e in
        match uu____18213 with
        | FStar_Pervasives_Native.Some l -> l
        | FStar_Pervasives_Native.None ->
            (FStar_Errors.log_issue e.FStar_Syntax_Syntax.pos
               (FStar_Errors.Warning_NonListLiteralSMTPattern,
                 "SMT pattern is not a list literal; ignoring the pattern");
             []) in
      let one_pat p =
        let uu____18244 =
          let uu____18261 = unmeta p in
          FStar_All.pipe_right uu____18261 head_and_args in
        match uu____18244 with
        | (head1, args) ->
            let uu____18312 =
              let uu____18327 =
                let uu____18328 = un_uinst head1 in
                uu____18328.FStar_Syntax_Syntax.n in
              (uu____18327, args) in
            (match uu____18312 with
             | (FStar_Syntax_Syntax.Tm_fvar fv,
                (uu____18350, uu____18351)::arg::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.smtpat_lid
                 -> arg
             | uu____18403 -> failwith "Unexpected pattern term") in
      let lemma_pats p =
        let elts = list_elements1 p in
        let smt_pat_or1 t1 =
          let uu____18458 =
            let uu____18475 = unmeta t1 in
            FStar_All.pipe_right uu____18475 head_and_args in
          match uu____18458 with
          | (head1, args) ->
              let uu____18522 =
                let uu____18537 =
                  let uu____18538 = un_uinst head1 in
                  uu____18538.FStar_Syntax_Syntax.n in
                (uu____18537, args) in
              (match uu____18522 with
               | (FStar_Syntax_Syntax.Tm_fvar fv, (e, uu____18557)::[]) when
                   FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.smtpatOr_lid
                   -> FStar_Pervasives_Native.Some e
               | uu____18594 -> FStar_Pervasives_Native.None) in
        match elts with
        | t1::[] ->
            let uu____18624 = smt_pat_or1 t1 in
            (match uu____18624 with
             | FStar_Pervasives_Native.Some e ->
                 let uu____18646 = list_elements1 e in
                 FStar_All.pipe_right uu____18646
                   (FStar_List.map
                      (fun branch1 ->
                         let uu____18676 = list_elements1 branch1 in
                         FStar_All.pipe_right uu____18676
                           (FStar_List.map one_pat)))
             | uu____18699 ->
                 let uu____18704 =
                   FStar_All.pipe_right elts (FStar_List.map one_pat) in
                 [uu____18704])
        | uu____18755 ->
            let uu____18758 =
              FStar_All.pipe_right elts (FStar_List.map one_pat) in
            [uu____18758] in
      let uu____18809 =
        let uu____18842 =
          let uu____18843 = FStar_Syntax_Subst.compress t in
          uu____18843.FStar_Syntax_Syntax.n in
        match uu____18842 with
        | FStar_Syntax_Syntax.Tm_arrow (binders, c) ->
            let uu____18900 = FStar_Syntax_Subst.open_comp binders c in
            (match uu____18900 with
             | (binders1, c1) ->
                 (match c1.FStar_Syntax_Syntax.n with
                  | FStar_Syntax_Syntax.Comp
                      { FStar_Syntax_Syntax.comp_univs = uu____18971;
                        FStar_Syntax_Syntax.effect_name = uu____18972;
                        FStar_Syntax_Syntax.result_typ = uu____18973;
                        FStar_Syntax_Syntax.effect_args =
                          (pre, uu____18975)::(post, uu____18977)::(pats,
                                                                    uu____18979)::[];
                        FStar_Syntax_Syntax.flags = uu____18980;_}
                      ->
                      let uu____19041 = lemma_pats pats in
                      (binders1, pre, post, uu____19041)
                  | uu____19078 -> failwith "impos"))
        | uu____19112 -> failwith "Impos" in
      match uu____18809 with
      | (binders, pre, post, patterns) ->
          let post1 = unthunk_lemma_post post in
          let body =
            let uu____19204 =
              let uu____19211 =
                let uu____19212 =
                  let uu____19219 = mk_imp pre post1 in
                  (uu____19219, (FStar_Syntax_Syntax.Meta_pattern patterns)) in
                FStar_Syntax_Syntax.Tm_meta uu____19212 in
              FStar_Syntax_Syntax.mk uu____19211 in
            uu____19204 FStar_Pervasives_Native.None
              t.FStar_Syntax_Syntax.pos in
          let quant =
            let uu____19225 = universe_of_binders binders in
            FStar_List.fold_right2
              (fun b ->
                 fun u ->
                   fun out -> mk_forall u (FStar_Pervasives_Native.fst b) out)
              binders uu____19225 body in
          quant