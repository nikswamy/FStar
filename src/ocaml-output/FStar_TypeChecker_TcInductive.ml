open Prims
let (unfold_whnf :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  FStar_TypeChecker_Normalize.unfold_whnf'
    [FStar_TypeChecker_Env.AllowUnboundUniverses]
let (tc_tycon :
  FStar_TypeChecker_Env.env_t ->
    FStar_Syntax_Syntax.sigelt ->
      (FStar_TypeChecker_Env.env_t * FStar_Syntax_Syntax.sigelt *
        FStar_Syntax_Syntax.universe * FStar_TypeChecker_Env.guard_t))
  =
  fun env ->
    fun s ->
      match s.FStar_Syntax_Syntax.sigel with
      | FStar_Syntax_Syntax.Sig_inductive_typ
          (tc, uvs, tps, k, mutuals, data) ->
          let env0 = env in
          let uu____50 = FStar_Syntax_Subst.univ_var_opening uvs in
          (match uu____50 with
           | (usubst, uvs1) ->
               let uu____77 =
                 let uu____84 = FStar_TypeChecker_Env.push_univ_vars env uvs1 in
                 let uu____85 = FStar_Syntax_Subst.subst_binders usubst tps in
                 let uu____86 =
                   let uu____87 =
                     FStar_Syntax_Subst.shift_subst (FStar_List.length tps)
                       usubst in
                   FStar_Syntax_Subst.subst uu____87 k in
                 (uu____84, uu____85, uu____86) in
               (match uu____77 with
                | (env1, tps1, k1) ->
                    let uu____107 = FStar_Syntax_Subst.open_term tps1 k1 in
                    (match uu____107 with
                     | (tps2, k2) ->
                         let uu____122 =
                           FStar_TypeChecker_TcTerm.tc_binders env1 tps2 in
                         (match uu____122 with
                          | (tps3, env_tps, guard_params, us) ->
                              let uu____143 =
                                let uu____162 =
                                  FStar_TypeChecker_TcTerm.tc_tot_or_gtot_term
                                    env_tps k2 in
                                match uu____162 with
                                | (k3, uu____188, g) ->
                                    let k4 =
                                      FStar_TypeChecker_Normalize.normalize
                                        [FStar_TypeChecker_Env.Exclude
                                           FStar_TypeChecker_Env.Iota;
                                        FStar_TypeChecker_Env.Exclude
                                          FStar_TypeChecker_Env.Zeta;
                                        FStar_TypeChecker_Env.Eager_unfolding;
                                        FStar_TypeChecker_Env.NoFullNorm;
                                        FStar_TypeChecker_Env.Exclude
                                          FStar_TypeChecker_Env.Beta] env_tps
                                        k3 in
                                    let uu____191 =
                                      FStar_Syntax_Util.arrow_formals k4 in
                                    let uu____206 =
                                      let uu____207 =
                                        FStar_TypeChecker_Env.conj_guard
                                          guard_params g in
                                      FStar_TypeChecker_Rel.discharge_guard
                                        env_tps uu____207 in
                                    (uu____191, uu____206) in
                              (match uu____143 with
                               | ((indices, t), guard) ->
                                   let k3 =
                                     let uu____270 =
                                       FStar_Syntax_Syntax.mk_Total t in
                                     FStar_Syntax_Util.arrow indices
                                       uu____270 in
                                   let uu____273 =
                                     FStar_Syntax_Util.type_u () in
                                   (match uu____273 with
                                    | (t_type, u) ->
                                        let valid_type =
                                          ((FStar_Syntax_Util.is_eqtype_no_unrefine
                                              t)
                                             &&
                                             (let uu____291 =
                                                FStar_All.pipe_right
                                                  s.FStar_Syntax_Syntax.sigquals
                                                  (FStar_List.contains
                                                     FStar_Syntax_Syntax.Unopteq) in
                                              Prims.op_Negation uu____291))
                                            ||
                                            (FStar_TypeChecker_Rel.teq_nosmt_force
                                               env1 t t_type) in
                                        (if Prims.op_Negation valid_type
                                         then
                                           (let uu____298 =
                                              let uu____304 =
                                                let uu____306 =
                                                  FStar_Syntax_Print.term_to_string
                                                    t in
                                                let uu____308 =
                                                  FStar_Ident.string_of_lid
                                                    tc in
                                                FStar_Util.format2
                                                  "Type annotation %s for inductive %s is not Type or eqtype, or it is eqtype but contains unopteq qualifier"
                                                  uu____306 uu____308 in
                                              (FStar_Errors.Error_InductiveAnnotNotAType,
                                                uu____304) in
                                            FStar_Errors.raise_error
                                              uu____298
                                              s.FStar_Syntax_Syntax.sigrng)
                                         else ();
                                         (let usubst1 =
                                            FStar_Syntax_Subst.univ_var_closing
                                              uvs1 in
                                          let guard1 =
                                            FStar_TypeChecker_Util.close_guard_implicits
                                              env1 tps3 guard in
                                          let t_tc =
                                            let uu____321 =
                                              let uu____330 =
                                                FStar_All.pipe_right tps3
                                                  (FStar_Syntax_Subst.subst_binders
                                                     usubst1) in
                                              let uu____347 =
                                                let uu____356 =
                                                  let uu____369 =
                                                    FStar_Syntax_Subst.shift_subst
                                                      (FStar_List.length tps3)
                                                      usubst1 in
                                                  FStar_Syntax_Subst.subst_binders
                                                    uu____369 in
                                                FStar_All.pipe_right indices
                                                  uu____356 in
                                              FStar_List.append uu____330
                                                uu____347 in
                                            let uu____392 =
                                              let uu____395 =
                                                let uu____396 =
                                                  let uu____401 =
                                                    FStar_Syntax_Subst.shift_subst
                                                      ((FStar_List.length
                                                          tps3)
                                                         +
                                                         (FStar_List.length
                                                            indices)) usubst1 in
                                                  FStar_Syntax_Subst.subst
                                                    uu____401 in
                                                FStar_All.pipe_right t
                                                  uu____396 in
                                              FStar_Syntax_Syntax.mk_Total
                                                uu____395 in
                                            FStar_Syntax_Util.arrow uu____321
                                              uu____392 in
                                          let tps4 =
                                            FStar_Syntax_Subst.close_binders
                                              tps3 in
                                          let k4 =
                                            FStar_Syntax_Subst.close tps4 k3 in
                                          let uu____418 =
                                            let uu____423 =
                                              FStar_Syntax_Subst.subst_binders
                                                usubst1 tps4 in
                                            let uu____424 =
                                              let uu____425 =
                                                FStar_Syntax_Subst.shift_subst
                                                  (FStar_List.length tps4)
                                                  usubst1 in
                                              FStar_Syntax_Subst.subst
                                                uu____425 k4 in
                                            (uu____423, uu____424) in
                                          match uu____418 with
                                          | (tps5, k5) ->
                                              let fv_tc =
                                                FStar_Syntax_Syntax.lid_as_fv
                                                  tc
                                                  FStar_Syntax_Syntax.delta_constant
                                                  FStar_Pervasives_Native.None in
                                              let uu____445 =
                                                FStar_TypeChecker_Env.push_let_binding
                                                  env0 (FStar_Util.Inr fv_tc)
                                                  (uvs1, t_tc) in
                                              (uu____445,
                                                (let uu___61_451 = s in
                                                 {
                                                   FStar_Syntax_Syntax.sigel
                                                     =
                                                     (FStar_Syntax_Syntax.Sig_inductive_typ
                                                        (tc, uvs1, tps5, k5,
                                                          mutuals, data));
                                                   FStar_Syntax_Syntax.sigrng
                                                     =
                                                     (uu___61_451.FStar_Syntax_Syntax.sigrng);
                                                   FStar_Syntax_Syntax.sigquals
                                                     =
                                                     (uu___61_451.FStar_Syntax_Syntax.sigquals);
                                                   FStar_Syntax_Syntax.sigmeta
                                                     =
                                                     (uu___61_451.FStar_Syntax_Syntax.sigmeta);
                                                   FStar_Syntax_Syntax.sigattrs
                                                     =
                                                     (uu___61_451.FStar_Syntax_Syntax.sigattrs)
                                                 }), u, guard1)))))))))
      | uu____456 -> failwith "impossible"
let (tc_data :
  FStar_TypeChecker_Env.env_t ->
    (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universe) Prims.list ->
      FStar_Syntax_Syntax.sigelt ->
        (FStar_Syntax_Syntax.sigelt * FStar_TypeChecker_Env.guard_t))
  =
  fun env ->
    fun tcs ->
      fun se ->
        match se.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_datacon
            (c, _uvs, t, tc_lid, ntps, _mutual_tcs) ->
            let uu____520 = FStar_Syntax_Subst.univ_var_opening _uvs in
            (match uu____520 with
             | (usubst, _uvs1) ->
                 let uu____543 =
                   let uu____548 =
                     FStar_TypeChecker_Env.push_univ_vars env _uvs1 in
                   let uu____549 = FStar_Syntax_Subst.subst usubst t in
                   (uu____548, uu____549) in
                 (match uu____543 with
                  | (env1, t1) ->
                      let uu____556 =
                        let tps_u_opt =
                          FStar_Util.find_map tcs
                            (fun uu____595 ->
                               match uu____595 with
                               | (se1, u_tc) ->
                                   let uu____610 =
                                     let uu____612 =
                                       let uu____613 =
                                         FStar_Syntax_Util.lid_of_sigelt se1 in
                                       FStar_Util.must uu____613 in
                                     FStar_Ident.lid_equals tc_lid uu____612 in
                                   if uu____610
                                   then
                                     (match se1.FStar_Syntax_Syntax.sigel
                                      with
                                      | FStar_Syntax_Syntax.Sig_inductive_typ
                                          (uu____633, uu____634, tps,
                                           uu____636, uu____637, uu____638)
                                          ->
                                          let tps1 =
                                            let uu____648 =
                                              FStar_All.pipe_right tps
                                                (FStar_Syntax_Subst.subst_binders
                                                   usubst) in
                                            FStar_All.pipe_right uu____648
                                              (FStar_List.map
                                                 (fun uu____688 ->
                                                    match uu____688 with
                                                    | (x, uu____702) ->
                                                        (x,
                                                          (FStar_Pervasives_Native.Some
                                                             FStar_Syntax_Syntax.imp_tag)))) in
                                          let tps2 =
                                            FStar_Syntax_Subst.open_binders
                                              tps1 in
                                          let uu____710 =
                                            let uu____717 =
                                              FStar_TypeChecker_Env.push_binders
                                                env1 tps2 in
                                            (uu____717, tps2, u_tc) in
                                          FStar_Pervasives_Native.Some
                                            uu____710
                                      | uu____724 -> failwith "Impossible")
                                   else FStar_Pervasives_Native.None) in
                        match tps_u_opt with
                        | FStar_Pervasives_Native.Some x -> x
                        | FStar_Pervasives_Native.None ->
                            let uu____767 =
                              FStar_Ident.lid_equals tc_lid
                                FStar_Parser_Const.exn_lid in
                            if uu____767
                            then (env1, [], FStar_Syntax_Syntax.U_zero)
                            else
                              FStar_Errors.raise_error
                                (FStar_Errors.Fatal_UnexpectedDataConstructor,
                                  "Unexpected data constructor")
                                se.FStar_Syntax_Syntax.sigrng in
                      (match uu____556 with
                       | (env2, tps, u_tc) ->
                           let uu____799 =
                             let t2 =
                               FStar_TypeChecker_Normalize.normalize
                                 (FStar_List.append
                                    FStar_TypeChecker_Normalize.whnf_steps
                                    [FStar_TypeChecker_Env.AllowUnboundUniverses])
                                 env2 t1 in
                             let uu____815 =
                               let uu____816 = FStar_Syntax_Subst.compress t2 in
                               uu____816.FStar_Syntax_Syntax.n in
                             match uu____815 with
                             | FStar_Syntax_Syntax.Tm_arrow (bs, res) ->
                                 let uu____855 = FStar_Util.first_N ntps bs in
                                 (match uu____855 with
                                  | (uu____896, bs') ->
                                      let t3 =
                                        FStar_Syntax_Syntax.mk
                                          (FStar_Syntax_Syntax.Tm_arrow
                                             (bs', res))
                                          FStar_Pervasives_Native.None
                                          t2.FStar_Syntax_Syntax.pos in
                                      let subst1 =
                                        FStar_All.pipe_right tps
                                          (FStar_List.mapi
                                             (fun i ->
                                                fun uu____967 ->
                                                  match uu____967 with
                                                  | (x, uu____976) ->
                                                      FStar_Syntax_Syntax.DB
                                                        ((ntps -
                                                            ((Prims.parse_int "1")
                                                               + i)), x))) in
                                      let uu____983 =
                                        FStar_Syntax_Subst.subst subst1 t3 in
                                      FStar_Syntax_Util.arrow_formals
                                        uu____983)
                             | uu____984 -> ([], t2) in
                           (match uu____799 with
                            | (arguments, result) ->
                                ((let uu____1028 =
                                    FStar_TypeChecker_Env.debug env2
                                      FStar_Options.Low in
                                  if uu____1028
                                  then
                                    let uu____1031 =
                                      FStar_Syntax_Print.lid_to_string c in
                                    let uu____1033 =
                                      FStar_Syntax_Print.binders_to_string
                                        "->" arguments in
                                    let uu____1036 =
                                      FStar_Syntax_Print.term_to_string
                                        result in
                                    FStar_Util.print3
                                      "Checking datacon  %s : %s -> %s \n"
                                      uu____1031 uu____1033 uu____1036
                                  else ());
                                 (let uu____1041 =
                                    FStar_TypeChecker_TcTerm.tc_tparams env2
                                      arguments in
                                  match uu____1041 with
                                  | (arguments1, env', us) ->
                                      let type_u_tc =
                                        FStar_Syntax_Syntax.mk
                                          (FStar_Syntax_Syntax.Tm_type u_tc)
                                          FStar_Pervasives_Native.None
                                          result.FStar_Syntax_Syntax.pos in
                                      let env'1 =
                                        FStar_TypeChecker_Env.set_expected_typ
                                          env' type_u_tc in
                                      let uu____1059 =
                                        FStar_TypeChecker_TcTerm.tc_trivial_guard
                                          env'1 result in
                                      (match uu____1059 with
                                       | (result1, res_lcomp) ->
                                           let uu____1070 =
                                             FStar_Syntax_Util.head_and_args
                                               result1 in
                                           (match uu____1070 with
                                            | (head1, args) ->
                                                let p_args =
                                                  let uu____1128 =
                                                    FStar_Util.first_N
                                                      (FStar_List.length tps)
                                                      args in
                                                  FStar_Pervasives_Native.fst
                                                    uu____1128 in
                                                (FStar_List.iter2
                                                   (fun uu____1210 ->
                                                      fun uu____1211 ->
                                                        match (uu____1210,
                                                                uu____1211)
                                                        with
                                                        | ((bv, uu____1241),
                                                           (t2, uu____1243))
                                                            ->
                                                            let uu____1270 =
                                                              let uu____1271
                                                                =
                                                                FStar_Syntax_Subst.compress
                                                                  t2 in
                                                              uu____1271.FStar_Syntax_Syntax.n in
                                                            (match uu____1270
                                                             with
                                                             | FStar_Syntax_Syntax.Tm_name
                                                                 bv' when
                                                                 FStar_Syntax_Syntax.bv_eq
                                                                   bv bv'
                                                                 -> ()
                                                             | uu____1275 ->
                                                                 let uu____1276
                                                                   =
                                                                   let uu____1282
                                                                    =
                                                                    let uu____1284
                                                                    =
                                                                    FStar_Syntax_Print.bv_to_string
                                                                    bv in
                                                                    let uu____1286
                                                                    =
                                                                    FStar_Syntax_Print.term_to_string
                                                                    t2 in
                                                                    FStar_Util.format2
                                                                    "This parameter is not constant: expected %s, got %s"
                                                                    uu____1284
                                                                    uu____1286 in
                                                                   (FStar_Errors.Error_BadInductiveParam,
                                                                    uu____1282) in
                                                                 FStar_Errors.raise_error
                                                                   uu____1276
                                                                   t2.FStar_Syntax_Syntax.pos))
                                                   tps p_args;
                                                 (let ty =
                                                    let uu____1291 =
                                                      unfold_whnf env2
                                                        res_lcomp.FStar_Syntax_Syntax.res_typ in
                                                    FStar_All.pipe_right
                                                      uu____1291
                                                      FStar_Syntax_Util.unrefine in
                                                  (let uu____1293 =
                                                     let uu____1294 =
                                                       FStar_Syntax_Subst.compress
                                                         ty in
                                                     uu____1294.FStar_Syntax_Syntax.n in
                                                   match uu____1293 with
                                                   | FStar_Syntax_Syntax.Tm_type
                                                       uu____1297 -> ()
                                                   | uu____1298 ->
                                                       let uu____1299 =
                                                         let uu____1305 =
                                                           let uu____1307 =
                                                             FStar_Syntax_Print.term_to_string
                                                               result1 in
                                                           let uu____1309 =
                                                             FStar_Syntax_Print.term_to_string
                                                               ty in
                                                           FStar_Util.format2
                                                             "The type of %s is %s, but since this is the result type of a constructor its type should be Type"
                                                             uu____1307
                                                             uu____1309 in
                                                         (FStar_Errors.Fatal_WrongResultTypeAfterConstrutor,
                                                           uu____1305) in
                                                       FStar_Errors.raise_error
                                                         uu____1299
                                                         se.FStar_Syntax_Syntax.sigrng);
                                                  (let g_uvs =
                                                     let uu____1314 =
                                                       let uu____1315 =
                                                         FStar_Syntax_Subst.compress
                                                           head1 in
                                                       uu____1315.FStar_Syntax_Syntax.n in
                                                     match uu____1314 with
                                                     | FStar_Syntax_Syntax.Tm_uinst
                                                         ({
                                                            FStar_Syntax_Syntax.n
                                                              =
                                                              FStar_Syntax_Syntax.Tm_fvar
                                                              fv;
                                                            FStar_Syntax_Syntax.pos
                                                              = uu____1319;
                                                            FStar_Syntax_Syntax.vars
                                                              = uu____1320;_},
                                                          tuvs)
                                                         when
                                                         FStar_Syntax_Syntax.fv_eq_lid
                                                           fv tc_lid
                                                         ->
                                                         if
                                                           (FStar_List.length
                                                              _uvs1)
                                                             =
                                                             (FStar_List.length
                                                                tuvs)
                                                         then
                                                           FStar_List.fold_left2
                                                             (fun g ->
                                                                fun u1 ->
                                                                  fun u2 ->
                                                                    let uu____1334
                                                                    =
                                                                    let uu____1335
                                                                    =
                                                                    FStar_Syntax_Syntax.mk
                                                                    (FStar_Syntax_Syntax.Tm_type
                                                                    u1)
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Range.dummyRange in
                                                                    let uu____1336
                                                                    =
                                                                    FStar_Syntax_Syntax.mk
                                                                    (FStar_Syntax_Syntax.Tm_type
                                                                    (FStar_Syntax_Syntax.U_name
                                                                    u2))
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Range.dummyRange in
                                                                    FStar_TypeChecker_Rel.teq
                                                                    env'1
                                                                    uu____1335
                                                                    uu____1336 in
                                                                    FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____1334)
                                                             FStar_TypeChecker_Env.trivial_guard
                                                             tuvs _uvs1
                                                         else
                                                           FStar_Errors.raise_error
                                                             (FStar_Errors.Fatal_UnexpectedConstructorType,
                                                               "Length of annotated universes does not match inferred universes")
                                                             se.FStar_Syntax_Syntax.sigrng
                                                     | FStar_Syntax_Syntax.Tm_fvar
                                                         fv when
                                                         FStar_Syntax_Syntax.fv_eq_lid
                                                           fv tc_lid
                                                         ->
                                                         FStar_TypeChecker_Env.trivial_guard
                                                     | uu____1342 ->
                                                         let uu____1343 =
                                                           let uu____1349 =
                                                             let uu____1351 =
                                                               FStar_Syntax_Print.lid_to_string
                                                                 tc_lid in
                                                             let uu____1353 =
                                                               FStar_Syntax_Print.term_to_string
                                                                 head1 in
                                                             FStar_Util.format2
                                                               "Expected a constructor of type %s; got %s"
                                                               uu____1351
                                                               uu____1353 in
                                                           (FStar_Errors.Fatal_UnexpectedConstructorType,
                                                             uu____1349) in
                                                         FStar_Errors.raise_error
                                                           uu____1343
                                                           se.FStar_Syntax_Syntax.sigrng in
                                                   let g =
                                                     FStar_List.fold_left2
                                                       (fun g ->
                                                          fun uu____1371 ->
                                                            fun u_x ->
                                                              match uu____1371
                                                              with
                                                              | (x,
                                                                 uu____1380)
                                                                  ->
                                                                  let uu____1385
                                                                    =
                                                                    FStar_TypeChecker_Rel.universe_inequality
                                                                    u_x u_tc in
                                                                  FStar_TypeChecker_Env.conj_guard
                                                                    g
                                                                    uu____1385)
                                                       g_uvs arguments1 us in
                                                   let t2 =
                                                     let uu____1389 =
                                                       let uu____1398 =
                                                         FStar_All.pipe_right
                                                           tps
                                                           (FStar_List.map
                                                              (fun uu____1438
                                                                 ->
                                                                 match uu____1438
                                                                 with
                                                                 | (x,
                                                                    uu____1452)
                                                                    ->
                                                                    (x,
                                                                    (FStar_Pervasives_Native.Some
                                                                    (FStar_Syntax_Syntax.Implicit
                                                                    true))))) in
                                                       FStar_List.append
                                                         uu____1398
                                                         arguments1 in
                                                     let uu____1466 =
                                                       FStar_Syntax_Syntax.mk_Total
                                                         result1 in
                                                     FStar_Syntax_Util.arrow
                                                       uu____1389 uu____1466 in
                                                   let t3 =
                                                     FStar_Syntax_Subst.close_univ_vars
                                                       _uvs1 t2 in
                                                   ((let uu___183_1471 = se in
                                                     {
                                                       FStar_Syntax_Syntax.sigel
                                                         =
                                                         (FStar_Syntax_Syntax.Sig_datacon
                                                            (c, _uvs1, t3,
                                                              tc_lid, ntps,
                                                              []));
                                                       FStar_Syntax_Syntax.sigrng
                                                         =
                                                         (uu___183_1471.FStar_Syntax_Syntax.sigrng);
                                                       FStar_Syntax_Syntax.sigquals
                                                         =
                                                         (uu___183_1471.FStar_Syntax_Syntax.sigquals);
                                                       FStar_Syntax_Syntax.sigmeta
                                                         =
                                                         (uu___183_1471.FStar_Syntax_Syntax.sigmeta);
                                                       FStar_Syntax_Syntax.sigattrs
                                                         =
                                                         (uu___183_1471.FStar_Syntax_Syntax.sigattrs)
                                                     }), g))))))))))))
        | uu____1475 -> failwith "impossible"
let (generalize_and_inst_within :
  FStar_TypeChecker_Env.env_t ->
    FStar_TypeChecker_Env.guard_t ->
      (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.universe) Prims.list
        ->
        FStar_Syntax_Syntax.sigelt Prims.list ->
          (FStar_Syntax_Syntax.sigelt Prims.list * FStar_Syntax_Syntax.sigelt
            Prims.list))
  =
  fun env ->
    fun g ->
      fun tcs ->
        fun datas ->
          let tc_universe_vars =
            FStar_List.map FStar_Pervasives_Native.snd tcs in
          let g1 =
            let uu___191_1542 = g in
            {
              FStar_TypeChecker_Env.guard_f =
                (uu___191_1542.FStar_TypeChecker_Env.guard_f);
              FStar_TypeChecker_Env.deferred =
                (uu___191_1542.FStar_TypeChecker_Env.deferred);
              FStar_TypeChecker_Env.univ_ineqs =
                (tc_universe_vars,
                  (FStar_Pervasives_Native.snd
                     g.FStar_TypeChecker_Env.univ_ineqs));
              FStar_TypeChecker_Env.implicits =
                (uu___191_1542.FStar_TypeChecker_Env.implicits)
            } in
          (let uu____1552 =
             FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
               (FStar_Options.Other "GenUniverses") in
           if uu____1552
           then
             let uu____1557 = FStar_TypeChecker_Rel.guard_to_string env g1 in
             FStar_Util.print1 "@@@@@@Guard before generalization: %s\n"
               uu____1557
           else ());
          FStar_TypeChecker_Rel.force_trivial_guard env g1;
          (let binders =
             FStar_All.pipe_right tcs
               (FStar_List.map
                  (fun uu____1600 ->
                     match uu____1600 with
                     | (se, uu____1606) ->
                         (match se.FStar_Syntax_Syntax.sigel with
                          | FStar_Syntax_Syntax.Sig_inductive_typ
                              (uu____1607, uu____1608, tps, k, uu____1611,
                               uu____1612)
                              ->
                              let uu____1621 =
                                let uu____1622 =
                                  FStar_Syntax_Syntax.mk_Total k in
                                FStar_All.pipe_left
                                  (FStar_Syntax_Util.arrow tps) uu____1622 in
                              FStar_Syntax_Syntax.null_binder uu____1621
                          | uu____1627 -> failwith "Impossible"))) in
           let binders' =
             FStar_All.pipe_right datas
               (FStar_List.map
                  (fun se ->
                     match se.FStar_Syntax_Syntax.sigel with
                     | FStar_Syntax_Syntax.Sig_datacon
                         (uu____1656, uu____1657, t, uu____1659, uu____1660,
                          uu____1661)
                         -> FStar_Syntax_Syntax.null_binder t
                     | uu____1668 -> failwith "Impossible")) in
           let t =
             let uu____1673 =
               FStar_Syntax_Syntax.mk_Total FStar_Syntax_Syntax.t_unit in
             FStar_Syntax_Util.arrow (FStar_List.append binders binders')
               uu____1673 in
           (let uu____1683 =
              FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                (FStar_Options.Other "GenUniverses") in
            if uu____1683
            then
              let uu____1688 =
                FStar_TypeChecker_Normalize.term_to_string env t in
              FStar_Util.print1
                "@@@@@@Trying to generalize universes in %s\n" uu____1688
            else ());
           (let uu____1693 =
              FStar_TypeChecker_Util.generalize_universes env t in
            match uu____1693 with
            | (uvs, t1) ->
                ((let uu____1713 =
                    FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
                      (FStar_Options.Other "GenUniverses") in
                  if uu____1713
                  then
                    let uu____1718 =
                      let uu____1720 =
                        FStar_All.pipe_right uvs
                          (FStar_List.map (fun u -> u.FStar_Ident.idText)) in
                      FStar_All.pipe_right uu____1720
                        (FStar_String.concat ", ") in
                    let uu____1737 = FStar_Syntax_Print.term_to_string t1 in
                    FStar_Util.print2 "@@@@@@Generalized to (%s, %s)\n"
                      uu____1718 uu____1737
                  else ());
                 (let uu____1742 = FStar_Syntax_Subst.open_univ_vars uvs t1 in
                  match uu____1742 with
                  | (uvs1, t2) ->
                      let uu____1757 = FStar_Syntax_Util.arrow_formals t2 in
                      (match uu____1757 with
                       | (args, uu____1781) ->
                           let uu____1802 =
                             FStar_Util.first_N (FStar_List.length binders)
                               args in
                           (match uu____1802 with
                            | (tc_types, data_types) ->
                                let tcs1 =
                                  FStar_List.map2
                                    (fun uu____1907 ->
                                       fun uu____1908 ->
                                         match (uu____1907, uu____1908) with
                                         | ((x, uu____1930),
                                            (se, uu____1932)) ->
                                             (match se.FStar_Syntax_Syntax.sigel
                                              with
                                              | FStar_Syntax_Syntax.Sig_inductive_typ
                                                  (tc, uu____1948, tps,
                                                   uu____1950, mutuals,
                                                   datas1)
                                                  ->
                                                  let ty =
                                                    FStar_Syntax_Subst.close_univ_vars
                                                      uvs1
                                                      x.FStar_Syntax_Syntax.sort in
                                                  let uu____1962 =
                                                    let uu____1967 =
                                                      let uu____1968 =
                                                        FStar_Syntax_Subst.compress
                                                          ty in
                                                      uu____1968.FStar_Syntax_Syntax.n in
                                                    match uu____1967 with
                                                    | FStar_Syntax_Syntax.Tm_arrow
                                                        (binders1, c) ->
                                                        let uu____1997 =
                                                          FStar_Util.first_N
                                                            (FStar_List.length
                                                               tps) binders1 in
                                                        (match uu____1997
                                                         with
                                                         | (tps1, rest) ->
                                                             let t3 =
                                                               match rest
                                                               with
                                                               | [] ->
                                                                   FStar_Syntax_Util.comp_result
                                                                    c
                                                               | uu____2075
                                                                   ->
                                                                   FStar_Syntax_Syntax.mk
                                                                    (FStar_Syntax_Syntax.Tm_arrow
                                                                    (rest, c))
                                                                    FStar_Pervasives_Native.None
                                                                    (x.FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.pos in
                                                             (tps1, t3))
                                                    | uu____2094 -> ([], ty) in
                                                  (match uu____1962 with
                                                   | (tps1, t3) ->
                                                       let uu___268_2103 = se in
                                                       {
                                                         FStar_Syntax_Syntax.sigel
                                                           =
                                                           (FStar_Syntax_Syntax.Sig_inductive_typ
                                                              (tc, uvs1,
                                                                tps1, t3,
                                                                mutuals,
                                                                datas1));
                                                         FStar_Syntax_Syntax.sigrng
                                                           =
                                                           (uu___268_2103.FStar_Syntax_Syntax.sigrng);
                                                         FStar_Syntax_Syntax.sigquals
                                                           =
                                                           (uu___268_2103.FStar_Syntax_Syntax.sigquals);
                                                         FStar_Syntax_Syntax.sigmeta
                                                           =
                                                           (uu___268_2103.FStar_Syntax_Syntax.sigmeta);
                                                         FStar_Syntax_Syntax.sigattrs
                                                           =
                                                           (uu___268_2103.FStar_Syntax_Syntax.sigattrs)
                                                       })
                                              | uu____2108 ->
                                                  failwith "Impossible"))
                                    tc_types tcs in
                                let datas1 =
                                  match uvs1 with
                                  | [] -> datas
                                  | uu____2115 ->
                                      let uvs_universes =
                                        FStar_All.pipe_right uvs1
                                          (FStar_List.map
                                             (fun _2119 ->
                                                FStar_Syntax_Syntax.U_name
                                                  _2119)) in
                                      let tc_insts =
                                        FStar_All.pipe_right tcs1
                                          (FStar_List.map
                                             (fun uu___0_2138 ->
                                                match uu___0_2138 with
                                                | {
                                                    FStar_Syntax_Syntax.sigel
                                                      =
                                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                                      (tc, uu____2144,
                                                       uu____2145,
                                                       uu____2146,
                                                       uu____2147,
                                                       uu____2148);
                                                    FStar_Syntax_Syntax.sigrng
                                                      = uu____2149;
                                                    FStar_Syntax_Syntax.sigquals
                                                      = uu____2150;
                                                    FStar_Syntax_Syntax.sigmeta
                                                      = uu____2151;
                                                    FStar_Syntax_Syntax.sigattrs
                                                      = uu____2152;_}
                                                    -> (tc, uvs_universes)
                                                | uu____2165 ->
                                                    failwith "Impossible")) in
                                      FStar_List.map2
                                        (fun uu____2189 ->
                                           fun d ->
                                             match uu____2189 with
                                             | (t3, uu____2198) ->
                                                 (match d.FStar_Syntax_Syntax.sigel
                                                  with
                                                  | FStar_Syntax_Syntax.Sig_datacon
                                                      (l, uu____2204,
                                                       uu____2205, tc, ntps,
                                                       mutuals)
                                                      ->
                                                      let ty =
                                                        let uu____2216 =
                                                          FStar_Syntax_InstFV.instantiate
                                                            tc_insts
                                                            t3.FStar_Syntax_Syntax.sort in
                                                        FStar_All.pipe_right
                                                          uu____2216
                                                          (FStar_Syntax_Subst.close_univ_vars
                                                             uvs1) in
                                                      let uu___304_2217 = d in
                                                      {
                                                        FStar_Syntax_Syntax.sigel
                                                          =
                                                          (FStar_Syntax_Syntax.Sig_datacon
                                                             (l, uvs1, ty,
                                                               tc, ntps,
                                                               mutuals));
                                                        FStar_Syntax_Syntax.sigrng
                                                          =
                                                          (uu___304_2217.FStar_Syntax_Syntax.sigrng);
                                                        FStar_Syntax_Syntax.sigquals
                                                          =
                                                          (uu___304_2217.FStar_Syntax_Syntax.sigquals);
                                                        FStar_Syntax_Syntax.sigmeta
                                                          =
                                                          (uu___304_2217.FStar_Syntax_Syntax.sigmeta);
                                                        FStar_Syntax_Syntax.sigattrs
                                                          =
                                                          (uu___304_2217.FStar_Syntax_Syntax.sigattrs)
                                                      }
                                                  | uu____2221 ->
                                                      failwith "Impossible"))
                                        data_types datas in
                                (tcs1, datas1)))))))
let (debug_log : FStar_TypeChecker_Env.env_t -> Prims.string -> unit) =
  fun env ->
    fun s ->
      let uu____2240 =
        FStar_All.pipe_left (FStar_TypeChecker_Env.debug env)
          (FStar_Options.Other "Positivity") in
      if uu____2240
      then
        FStar_Util.print_string
          (Prims.op_Hat "Positivity::" (Prims.op_Hat s "\n"))
      else ()
let (ty_occurs_in :
  FStar_Ident.lident -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun ty_lid ->
    fun t ->
      let uu____2262 = FStar_Syntax_Free.fvars t in
      FStar_Util.set_mem ty_lid uu____2262
let (try_get_fv :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.fv * FStar_Syntax_Syntax.universes))
  =
  fun t ->
    let uu____2279 =
      let uu____2280 = FStar_Syntax_Subst.compress t in
      uu____2280.FStar_Syntax_Syntax.n in
    match uu____2279 with
    | FStar_Syntax_Syntax.Tm_fvar fv -> (fv, [])
    | FStar_Syntax_Syntax.Tm_uinst (t1, us) ->
        (match t1.FStar_Syntax_Syntax.n with
         | FStar_Syntax_Syntax.Tm_fvar fv -> (fv, us)
         | uu____2299 ->
             failwith "Node is a Tm_uinst, but Tm_uinst is not an fvar")
    | uu____2305 -> failwith "Node is not an fvar or a Tm_uinst"
type unfolded_memo_elt =
  (FStar_Ident.lident * FStar_Syntax_Syntax.args) Prims.list
type unfolded_memo_t = unfolded_memo_elt FStar_ST.ref
let (already_unfolded :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.args ->
      unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ilid ->
    fun arrghs ->
      fun unfolded ->
        fun env ->
          let uu____2342 = FStar_ST.op_Bang unfolded in
          FStar_List.existsML
            (fun uu____2391 ->
               match uu____2391 with
               | (lid, l) ->
                   (FStar_Ident.lid_equals lid ilid) &&
                     (let args =
                        let uu____2435 =
                          FStar_List.splitAt (FStar_List.length l) arrghs in
                        FStar_Pervasives_Native.fst uu____2435 in
                      FStar_List.fold_left2
                        (fun b ->
                           fun a ->
                             fun a' ->
                               b &&
                                 (FStar_TypeChecker_Rel.teq_nosmt_force env
                                    (FStar_Pervasives_Native.fst a)
                                    (FStar_Pervasives_Native.fst a'))) true
                        args l)) uu____2342
let rec (ty_strictly_positive_in_type :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term ->
      unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid ->
    fun btype ->
      fun unfolded ->
        fun env ->
          (let uu____2640 =
             let uu____2642 = FStar_Syntax_Print.term_to_string btype in
             Prims.op_Hat "Checking strict positivity in type: " uu____2642 in
           debug_log env uu____2640);
          (let btype1 =
             FStar_TypeChecker_Normalize.normalize
               [FStar_TypeChecker_Env.Beta;
               FStar_TypeChecker_Env.Eager_unfolding;
               FStar_TypeChecker_Env.UnfoldUntil
                 FStar_Syntax_Syntax.delta_constant;
               FStar_TypeChecker_Env.Iota;
               FStar_TypeChecker_Env.Zeta;
               FStar_TypeChecker_Env.AllowUnboundUniverses] env btype in
           (let uu____2647 =
              let uu____2649 = FStar_Syntax_Print.term_to_string btype1 in
              Prims.op_Hat
                "Checking strict positivity in type, after normalization: "
                uu____2649 in
            debug_log env uu____2647);
           (let uu____2654 = ty_occurs_in ty_lid btype1 in
            Prims.op_Negation uu____2654) ||
             ((debug_log env "ty does occur in this type, pressing ahead";
               (let uu____2667 =
                  let uu____2668 = FStar_Syntax_Subst.compress btype1 in
                  uu____2668.FStar_Syntax_Syntax.n in
                match uu____2667 with
                | FStar_Syntax_Syntax.Tm_app (t, args) ->
                    let uu____2698 = try_get_fv t in
                    (match uu____2698 with
                     | (fv, us) ->
                         let uu____2706 =
                           FStar_Ident.lid_equals
                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                             ty_lid in
                         if uu____2706
                         then
                           (debug_log env
                              "Checking strict positivity in the Tm_app node where head lid is ty itself, checking that ty does not occur in the arguments";
                            FStar_List.for_all
                              (fun uu____2722 ->
                                 match uu____2722 with
                                 | (t1, uu____2731) ->
                                     let uu____2736 = ty_occurs_in ty_lid t1 in
                                     Prims.op_Negation uu____2736) args)
                         else
                           (debug_log env
                              "Checking strict positivity in the Tm_app node, head lid is not ty, so checking nested positivity";
                            ty_nested_positive_in_inductive ty_lid
                              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                              us args unfolded env))
                | FStar_Syntax_Syntax.Tm_arrow (sbs, c) ->
                    (debug_log env "Checking strict positivity in Tm_arrow";
                     (let check_comp1 =
                        let c1 =
                          let uu____2771 =
                            FStar_TypeChecker_Env.unfold_effect_abbrev env c in
                          FStar_All.pipe_right uu____2771
                            FStar_Syntax_Syntax.mk_Comp in
                        (FStar_Syntax_Util.is_pure_or_ghost_comp c1) ||
                          (let uu____2775 =
                             FStar_TypeChecker_Env.lookup_effect_quals env
                               (FStar_Syntax_Util.comp_effect_name c1) in
                           FStar_All.pipe_right uu____2775
                             (FStar_List.existsb
                                (fun q -> q = FStar_Syntax_Syntax.TotalEffect))) in
                      if Prims.op_Negation check_comp1
                      then
                        (debug_log env
                           "Checking strict positivity , the arrow is impure, so return true";
                         true)
                      else
                        (debug_log env
                           "Checking struict positivity, Pure arrow, checking that ty does not occur in the binders, and that it is strictly positive in the return type";
                         (FStar_List.for_all
                            (fun uu____2802 ->
                               match uu____2802 with
                               | (b, uu____2811) ->
                                   let uu____2816 =
                                     ty_occurs_in ty_lid
                                       b.FStar_Syntax_Syntax.sort in
                                   Prims.op_Negation uu____2816) sbs)
                           &&
                           ((let uu____2822 =
                               FStar_Syntax_Subst.open_term sbs
                                 (FStar_Syntax_Util.comp_result c) in
                             match uu____2822 with
                             | (uu____2828, return_type) ->
                                 let uu____2830 =
                                   FStar_TypeChecker_Env.push_binders env sbs in
                                 ty_strictly_positive_in_type ty_lid
                                   return_type unfolded uu____2830)))))
                | FStar_Syntax_Syntax.Tm_fvar uu____2831 ->
                    (debug_log env
                       "Checking strict positivity in an fvar, return true";
                     true)
                | FStar_Syntax_Syntax.Tm_type uu____2835 ->
                    (debug_log env
                       "Checking strict positivity in an Tm_type, return true";
                     true)
                | FStar_Syntax_Syntax.Tm_uinst (t, uu____2840) ->
                    (debug_log env
                       "Checking strict positivity in an Tm_uinst, recur on the term inside (mostly it should be the same inductive)";
                     ty_strictly_positive_in_type ty_lid t unfolded env)
                | FStar_Syntax_Syntax.Tm_refine (bv, uu____2848) ->
                    (debug_log env
                       "Checking strict positivity in an Tm_refine, recur in the bv sort)";
                     ty_strictly_positive_in_type ty_lid
                       bv.FStar_Syntax_Syntax.sort unfolded env)
                | FStar_Syntax_Syntax.Tm_match (uu____2855, branches) ->
                    (debug_log env
                       "Checking strict positivity in an Tm_match, recur in the branches)";
                     FStar_List.for_all
                       (fun uu____2914 ->
                          match uu____2914 with
                          | (p, uu____2927, t) ->
                              let bs =
                                let uu____2946 =
                                  FStar_Syntax_Syntax.pat_bvs p in
                                FStar_List.map FStar_Syntax_Syntax.mk_binder
                                  uu____2946 in
                              let uu____2955 =
                                FStar_Syntax_Subst.open_term bs t in
                              (match uu____2955 with
                               | (bs1, t1) ->
                                   let uu____2963 =
                                     FStar_TypeChecker_Env.push_binders env
                                       bs1 in
                                   ty_strictly_positive_in_type ty_lid t1
                                     unfolded uu____2963)) branches)
                | FStar_Syntax_Syntax.Tm_ascribed (t, uu____2965, uu____2966)
                    ->
                    (debug_log env
                       "Checking strict positivity in an Tm_ascribed, recur)";
                     ty_strictly_positive_in_type ty_lid t unfolded env)
                | uu____3009 ->
                    ((let uu____3011 =
                        let uu____3013 =
                          let uu____3015 =
                            FStar_Syntax_Print.tag_of_term btype1 in
                          let uu____3017 =
                            let uu____3019 =
                              FStar_Syntax_Print.term_to_string btype1 in
                            Prims.op_Hat " and term: " uu____3019 in
                          Prims.op_Hat uu____3015 uu____3017 in
                        Prims.op_Hat
                          "Checking strict positivity, unexpected tag: "
                          uu____3013 in
                      debug_log env uu____3011);
                     false)))))
and (ty_nested_positive_in_inductive :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.universes ->
        FStar_Syntax_Syntax.args ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid ->
    fun ilid ->
      fun us ->
        fun args ->
          fun unfolded ->
            fun env ->
              (let uu____3032 =
                 let uu____3034 =
                   let uu____3036 =
                     let uu____3038 = FStar_Syntax_Print.args_to_string args in
                     Prims.op_Hat " applied to arguments: " uu____3038 in
                   Prims.op_Hat ilid.FStar_Ident.str uu____3036 in
                 Prims.op_Hat "Checking nested positivity in the inductive "
                   uu____3034 in
               debug_log env uu____3032);
              (let uu____3042 =
                 FStar_TypeChecker_Env.datacons_of_typ env ilid in
               match uu____3042 with
               | (b, idatas) ->
                   if Prims.op_Negation b
                   then
                     let uu____3061 =
                       let uu____3063 =
                         FStar_Syntax_Syntax.lid_as_fv ilid
                           FStar_Syntax_Syntax.delta_constant
                           FStar_Pervasives_Native.None in
                       FStar_TypeChecker_Env.fv_has_attr env uu____3063
                         FStar_Parser_Const.assume_strictly_positive_attr_lid in
                     (if uu____3061
                      then
                        ((let uu____3067 =
                            let uu____3069 = FStar_Ident.string_of_lid ilid in
                            FStar_Util.format1
                              "Checking nested positivity, special case decorated with `assume_strictly_positive` %s; return true"
                              uu____3069 in
                          debug_log env uu____3067);
                         true)
                      else
                        (debug_log env
                           "Checking nested positivity, not an inductive, return false";
                         false))
                   else
                     (let uu____3080 =
                        already_unfolded ilid args unfolded env in
                      if uu____3080
                      then
                        (debug_log env
                           "Checking nested positivity, we have already unfolded this inductive with these args";
                         true)
                      else
                        (let num_ibs =
                           let uu____3091 =
                             FStar_TypeChecker_Env.num_inductive_ty_params
                               env ilid in
                           FStar_Option.get uu____3091 in
                         (let uu____3097 =
                            let uu____3099 =
                              let uu____3101 =
                                FStar_Util.string_of_int num_ibs in
                              Prims.op_Hat uu____3101
                                ", also adding to the memo table" in
                            Prims.op_Hat
                              "Checking nested positivity, number of type parameters is "
                              uu____3099 in
                          debug_log env uu____3097);
                         (let uu____3106 =
                            let uu____3107 = FStar_ST.op_Bang unfolded in
                            let uu____3133 =
                              let uu____3140 =
                                let uu____3145 =
                                  let uu____3146 =
                                    FStar_List.splitAt num_ibs args in
                                  FStar_Pervasives_Native.fst uu____3146 in
                                (ilid, uu____3145) in
                              [uu____3140] in
                            FStar_List.append uu____3107 uu____3133 in
                          FStar_ST.op_Colon_Equals unfolded uu____3106);
                         FStar_List.for_all
                           (fun d ->
                              ty_nested_positive_in_dlid ty_lid d ilid us
                                args num_ibs unfolded env) idatas)))
and (ty_nested_positive_in_dlid :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Ident.lident ->
        FStar_Syntax_Syntax.universes ->
          FStar_Syntax_Syntax.args ->
            Prims.int ->
              unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid ->
    fun dlid ->
      fun ilid ->
        fun us ->
          fun args ->
            fun num_ibs ->
              fun unfolded ->
                fun env ->
                  debug_log env
                    (Prims.op_Hat
                       "Checking nested positivity in data constructor "
                       (Prims.op_Hat dlid.FStar_Ident.str
                          (Prims.op_Hat " of the inductive "
                             ilid.FStar_Ident.str)));
                  (let uu____3245 =
                     FStar_TypeChecker_Env.lookup_datacon env dlid in
                   match uu____3245 with
                   | (univ_unif_vars, dt) ->
                       (FStar_List.iter2
                          (fun u' ->
                             fun u ->
                               match u' with
                               | FStar_Syntax_Syntax.U_unif u'' ->
                                   FStar_Syntax_Unionfind.univ_change u'' u
                               | uu____3268 ->
                                   failwith
                                     "Impossible! Expected universe unification variables")
                          univ_unif_vars us;
                        (let dt1 =
                           FStar_TypeChecker_Normalize.normalize
                             [FStar_TypeChecker_Env.Beta;
                             FStar_TypeChecker_Env.Eager_unfolding;
                             FStar_TypeChecker_Env.UnfoldUntil
                               FStar_Syntax_Syntax.delta_constant;
                             FStar_TypeChecker_Env.Iota;
                             FStar_TypeChecker_Env.Zeta;
                             FStar_TypeChecker_Env.AllowUnboundUniverses] env
                             dt in
                         (let uu____3272 =
                            let uu____3274 =
                              FStar_Syntax_Print.term_to_string dt1 in
                            Prims.op_Hat
                              "Checking nested positivity in the data constructor type: "
                              uu____3274 in
                          debug_log env uu____3272);
                         (let uu____3277 =
                            let uu____3278 = FStar_Syntax_Subst.compress dt1 in
                            uu____3278.FStar_Syntax_Syntax.n in
                          match uu____3277 with
                          | FStar_Syntax_Syntax.Tm_arrow (dbs, c) ->
                              (debug_log env
                                 "Checked nested positivity in Tm_arrow data constructor type";
                               (let uu____3306 =
                                  FStar_List.splitAt num_ibs dbs in
                                match uu____3306 with
                                | (ibs, dbs1) ->
                                    let ibs1 =
                                      FStar_Syntax_Subst.open_binders ibs in
                                    let dbs2 =
                                      let uu____3370 =
                                        FStar_Syntax_Subst.opening_of_binders
                                          ibs1 in
                                      FStar_Syntax_Subst.subst_binders
                                        uu____3370 dbs1 in
                                    let c1 =
                                      let uu____3374 =
                                        FStar_Syntax_Subst.opening_of_binders
                                          ibs1 in
                                      FStar_Syntax_Subst.subst_comp
                                        uu____3374 c in
                                    let uu____3377 =
                                      FStar_List.splitAt num_ibs args in
                                    (match uu____3377 with
                                     | (args1, uu____3412) ->
                                         let subst1 =
                                           FStar_List.fold_left2
                                             (fun subst1 ->
                                                fun ib ->
                                                  fun arg ->
                                                    FStar_List.append subst1
                                                      [FStar_Syntax_Syntax.NT
                                                         ((FStar_Pervasives_Native.fst
                                                             ib),
                                                           (FStar_Pervasives_Native.fst
                                                              arg))]) [] ibs1
                                             args1 in
                                         let dbs3 =
                                           FStar_Syntax_Subst.subst_binders
                                             subst1 dbs2 in
                                         let c2 =
                                           let uu____3504 =
                                             FStar_Syntax_Subst.shift_subst
                                               (FStar_List.length dbs3)
                                               subst1 in
                                           FStar_Syntax_Subst.subst_comp
                                             uu____3504 c1 in
                                         ((let uu____3514 =
                                             let uu____3516 =
                                               let uu____3518 =
                                                 FStar_Syntax_Print.binders_to_string
                                                   "; " dbs3 in
                                               let uu____3521 =
                                                 let uu____3523 =
                                                   FStar_Syntax_Print.comp_to_string
                                                     c2 in
                                                 Prims.op_Hat ", and c: "
                                                   uu____3523 in
                                               Prims.op_Hat uu____3518
                                                 uu____3521 in
                                             Prims.op_Hat
                                               "Checking nested positivity in the unfolded data constructor binders as: "
                                               uu____3516 in
                                           debug_log env uu____3514);
                                          ty_nested_positive_in_type ty_lid
                                            (FStar_Syntax_Syntax.Tm_arrow
                                               (dbs3, c2)) ilid num_ibs
                                            unfolded env))))
                          | uu____3537 ->
                              (debug_log env
                                 "Checking nested positivity in the data constructor type that is not an arrow";
                               (let uu____3540 =
                                  let uu____3541 =
                                    FStar_Syntax_Subst.compress dt1 in
                                  uu____3541.FStar_Syntax_Syntax.n in
                                ty_nested_positive_in_type ty_lid uu____3540
                                  ilid num_ibs unfolded env))))))
and (ty_nested_positive_in_type :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.term' ->
      FStar_Ident.lident ->
        Prims.int ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env_t -> Prims.bool)
  =
  fun ty_lid ->
    fun t ->
      fun ilid ->
        fun num_ibs ->
          fun unfolded ->
            fun env ->
              match t with
              | FStar_Syntax_Syntax.Tm_app (t1, args) ->
                  (debug_log env
                     "Checking nested positivity in an Tm_app node, which is expected to be the ilid itself";
                   (let uu____3580 = try_get_fv t1 in
                    match uu____3580 with
                    | (fv, uu____3587) ->
                        let uu____3588 =
                          FStar_Ident.lid_equals
                            (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                            ilid in
                        if uu____3588
                        then true
                        else
                          failwith "Impossible, expected the type to be ilid"))
              | FStar_Syntax_Syntax.Tm_arrow (sbs, c) ->
                  ((let uu____3620 =
                      let uu____3622 =
                        FStar_Syntax_Print.binders_to_string "; " sbs in
                      Prims.op_Hat
                        "Checking nested positivity in an Tm_arrow node, with binders as: "
                        uu____3622 in
                    debug_log env uu____3620);
                   (let sbs1 = FStar_Syntax_Subst.open_binders sbs in
                    let uu____3627 =
                      FStar_List.fold_left
                        (fun uu____3648 ->
                           fun b ->
                             match uu____3648 with
                             | (r, env1) ->
                                 if Prims.op_Negation r
                                 then (r, env1)
                                 else
                                   (let uu____3679 =
                                      ty_strictly_positive_in_type ty_lid
                                        (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                        unfolded env1 in
                                    let uu____3683 =
                                      FStar_TypeChecker_Env.push_binders env1
                                        [b] in
                                    (uu____3679, uu____3683))) (true, env)
                        sbs1 in
                    match uu____3627 with | (b, uu____3701) -> b))
              | uu____3704 ->
                  failwith "Nested positive check, unhandled case"
let (ty_positive_in_datacon :
  FStar_Ident.lident ->
    FStar_Ident.lident ->
      FStar_Syntax_Syntax.binders ->
        FStar_Syntax_Syntax.universes ->
          unfolded_memo_t -> FStar_TypeChecker_Env.env -> Prims.bool)
  =
  fun ty_lid ->
    fun dlid ->
      fun ty_bs ->
        fun us ->
          fun unfolded ->
            fun env ->
              let uu____3740 = FStar_TypeChecker_Env.lookup_datacon env dlid in
              match uu____3740 with
              | (univ_unif_vars, dt) ->
                  (FStar_List.iter2
                     (fun u' ->
                        fun u ->
                          match u' with
                          | FStar_Syntax_Syntax.U_unif u'' ->
                              FStar_Syntax_Unionfind.univ_change u'' u
                          | uu____3763 ->
                              failwith
                                "Impossible! Expected universe unification variables")
                     univ_unif_vars us;
                   (let uu____3766 =
                      let uu____3768 = FStar_Syntax_Print.term_to_string dt in
                      Prims.op_Hat "Checking data constructor type: "
                        uu____3768 in
                    debug_log env uu____3766);
                   (let uu____3771 =
                      let uu____3772 = FStar_Syntax_Subst.compress dt in
                      uu____3772.FStar_Syntax_Syntax.n in
                    match uu____3771 with
                    | FStar_Syntax_Syntax.Tm_fvar uu____3776 ->
                        (debug_log env
                           "Data constructor type is simply an fvar, returning true";
                         true)
                    | FStar_Syntax_Syntax.Tm_arrow (dbs, uu____3781) ->
                        let dbs1 =
                          let uu____3811 =
                            FStar_List.splitAt (FStar_List.length ty_bs) dbs in
                          FStar_Pervasives_Native.snd uu____3811 in
                        let dbs2 =
                          let uu____3861 =
                            FStar_Syntax_Subst.opening_of_binders ty_bs in
                          FStar_Syntax_Subst.subst_binders uu____3861 dbs1 in
                        let dbs3 = FStar_Syntax_Subst.open_binders dbs2 in
                        ((let uu____3866 =
                            let uu____3868 =
                              let uu____3870 =
                                FStar_Util.string_of_int
                                  (FStar_List.length dbs3) in
                              Prims.op_Hat uu____3870 " binders" in
                            Prims.op_Hat
                              "Data constructor type is an arrow type, so checking strict positivity in "
                              uu____3868 in
                          debug_log env uu____3866);
                         (let uu____3880 =
                            FStar_List.fold_left
                              (fun uu____3901 ->
                                 fun b ->
                                   match uu____3901 with
                                   | (r, env1) ->
                                       if Prims.op_Negation r
                                       then (r, env1)
                                       else
                                         (let uu____3932 =
                                            ty_strictly_positive_in_type
                                              ty_lid
                                              (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                                              unfolded env1 in
                                          let uu____3936 =
                                            FStar_TypeChecker_Env.push_binders
                                              env1 [b] in
                                          (uu____3932, uu____3936)))
                              (true, env) dbs3 in
                          match uu____3880 with | (b, uu____3954) -> b))
                    | FStar_Syntax_Syntax.Tm_app (uu____3957, uu____3958) ->
                        (debug_log env
                           "Data constructor type is a Tm_app, so returning true";
                         true)
                    | FStar_Syntax_Syntax.Tm_uinst (t, univs1) ->
                        (debug_log env
                           "Data constructor type is a Tm_uinst, so recursing in the base type";
                         ty_strictly_positive_in_type ty_lid t unfolded env)
                    | uu____3994 ->
                        failwith
                          "Unexpected data constructor type when checking positivity"))
let (check_positivity :
  FStar_Syntax_Syntax.sigelt -> FStar_TypeChecker_Env.env -> Prims.bool) =
  fun ty ->
    fun env ->
      let unfolded_inductives = FStar_Util.mk_ref [] in
      let uu____4017 =
        match ty.FStar_Syntax_Syntax.sigel with
        | FStar_Syntax_Syntax.Sig_inductive_typ
            (lid, us, bs, uu____4033, uu____4034, uu____4035) ->
            (lid, us, bs)
        | uu____4044 -> failwith "Impossible!" in
      match uu____4017 with
      | (ty_lid, ty_us, ty_bs) ->
          let uu____4056 = FStar_Syntax_Subst.univ_var_opening ty_us in
          (match uu____4056 with
           | (ty_usubst, ty_us1) ->
               let env1 = FStar_TypeChecker_Env.push_univ_vars env ty_us1 in
               let env2 = FStar_TypeChecker_Env.push_binders env1 ty_bs in
               let ty_bs1 = FStar_Syntax_Subst.subst_binders ty_usubst ty_bs in
               let ty_bs2 = FStar_Syntax_Subst.open_binders ty_bs1 in
               let uu____4080 =
                 let uu____4083 =
                   FStar_TypeChecker_Env.datacons_of_typ env2 ty_lid in
                 FStar_Pervasives_Native.snd uu____4083 in
               FStar_List.for_all
                 (fun d ->
                    let uu____4097 =
                      FStar_List.map (fun s -> FStar_Syntax_Syntax.U_name s)
                        ty_us1 in
                    ty_positive_in_datacon ty_lid d ty_bs2 uu____4097
                      unfolded_inductives env2) uu____4080)
let (check_exn_positivity :
  FStar_Ident.lid -> FStar_TypeChecker_Env.env -> Prims.bool) =
  fun data_ctor_lid ->
    fun env ->
      let unfolded_inductives = FStar_Util.mk_ref [] in
      ty_positive_in_datacon FStar_Parser_Const.exn_lid data_ctor_lid [] []
        unfolded_inductives env
let (datacon_typ : FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.term) =
  fun data ->
    match data.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_datacon
        (uu____4132, uu____4133, t, uu____4135, uu____4136, uu____4137) -> t
    | uu____4144 -> failwith "Impossible!"
let (haseq_suffix : Prims.string) = "__uu___haseq"
let (is_haseq_lid : FStar_Ident.lid -> Prims.bool) =
  fun lid ->
    let str = lid.FStar_Ident.str in
    let len = FStar_String.length str in
    let haseq_suffix_len = FStar_String.length haseq_suffix in
    (len > haseq_suffix_len) &&
      (let uu____4161 =
         let uu____4163 =
           FStar_String.substring str (len - haseq_suffix_len)
             haseq_suffix_len in
         FStar_String.compare uu____4163 haseq_suffix in
       uu____4161 = (Prims.parse_int "0"))
let (get_haseq_axiom_lid : FStar_Ident.lid -> FStar_Ident.lid) =
  fun lid ->
    let uu____4173 =
      let uu____4176 =
        let uu____4179 =
          FStar_Ident.id_of_text
            (Prims.op_Hat (lid.FStar_Ident.ident).FStar_Ident.idText
               haseq_suffix) in
        [uu____4179] in
      FStar_List.append lid.FStar_Ident.ns uu____4176 in
    FStar_Ident.lid_of_ids uu____4173
let (get_optimized_haseq_axiom :
  FStar_TypeChecker_Env.env ->
    FStar_Syntax_Syntax.sigelt ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.univ_names ->
          (FStar_Ident.lident * FStar_Syntax_Syntax.term *
            FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.binders *
            FStar_Syntax_Syntax.term))
  =
  fun en ->
    fun ty ->
      fun usubst ->
        fun us ->
          let uu____4225 =
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (lid, uu____4239, bs, t, uu____4242, uu____4243) ->
                (lid, bs, t)
            | uu____4252 -> failwith "Impossible!" in
          match uu____4225 with
          | (lid, bs, t) ->
              let bs1 = FStar_Syntax_Subst.subst_binders usubst bs in
              let t1 =
                let uu____4275 =
                  FStar_Syntax_Subst.shift_subst (FStar_List.length bs1)
                    usubst in
                FStar_Syntax_Subst.subst uu____4275 t in
              let uu____4284 = FStar_Syntax_Subst.open_term bs1 t1 in
              (match uu____4284 with
               | (bs2, t2) ->
                   let ibs =
                     let uu____4302 =
                       let uu____4303 = FStar_Syntax_Subst.compress t2 in
                       uu____4303.FStar_Syntax_Syntax.n in
                     match uu____4302 with
                     | FStar_Syntax_Syntax.Tm_arrow (ibs, uu____4307) -> ibs
                     | uu____4328 -> [] in
                   let ibs1 = FStar_Syntax_Subst.open_binders ibs in
                   let ind =
                     let uu____4337 =
                       FStar_Syntax_Syntax.fvar lid
                         FStar_Syntax_Syntax.delta_constant
                         FStar_Pervasives_Native.None in
                     let uu____4338 =
                       FStar_List.map (fun u -> FStar_Syntax_Syntax.U_name u)
                         us in
                     FStar_Syntax_Syntax.mk_Tm_uinst uu____4337 uu____4338 in
                   let ind1 =
                     let uu____4344 =
                       let uu____4349 =
                         FStar_List.map
                           (fun uu____4366 ->
                              match uu____4366 with
                              | (bv, aq) ->
                                  let uu____4385 =
                                    FStar_Syntax_Syntax.bv_to_name bv in
                                  (uu____4385, aq)) bs2 in
                       FStar_Syntax_Syntax.mk_Tm_app ind uu____4349 in
                     uu____4344 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange in
                   let ind2 =
                     let uu____4391 =
                       let uu____4396 =
                         FStar_List.map
                           (fun uu____4413 ->
                              match uu____4413 with
                              | (bv, aq) ->
                                  let uu____4432 =
                                    FStar_Syntax_Syntax.bv_to_name bv in
                                  (uu____4432, aq)) ibs1 in
                       FStar_Syntax_Syntax.mk_Tm_app ind1 uu____4396 in
                     uu____4391 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange in
                   let haseq_ind =
                     let uu____4438 =
                       let uu____4443 =
                         let uu____4444 = FStar_Syntax_Syntax.as_arg ind2 in
                         [uu____4444] in
                       FStar_Syntax_Syntax.mk_Tm_app
                         FStar_Syntax_Util.t_haseq uu____4443 in
                     uu____4438 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange in
                   let bs' =
                     FStar_List.filter
                       (fun b ->
                          let uu____4493 =
                            let uu____4494 = FStar_Syntax_Util.type_u () in
                            FStar_Pervasives_Native.fst uu____4494 in
                          FStar_TypeChecker_Rel.subtype_nosmt_force en
                            (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort
                            uu____4493) bs2 in
                   let haseq_bs =
                     FStar_List.fold_left
                       (fun t3 ->
                          fun b ->
                            let uu____4507 =
                              let uu____4510 =
                                let uu____4515 =
                                  let uu____4516 =
                                    let uu____4525 =
                                      FStar_Syntax_Syntax.bv_to_name
                                        (FStar_Pervasives_Native.fst b) in
                                    FStar_Syntax_Syntax.as_arg uu____4525 in
                                  [uu____4516] in
                                FStar_Syntax_Syntax.mk_Tm_app
                                  FStar_Syntax_Util.t_haseq uu____4515 in
                              uu____4510 FStar_Pervasives_Native.None
                                FStar_Range.dummyRange in
                            FStar_Syntax_Util.mk_conj t3 uu____4507)
                       FStar_Syntax_Util.t_true bs' in
                   let fml = FStar_Syntax_Util.mk_imp haseq_bs haseq_ind in
                   let fml1 =
                     let uu___638_4548 = fml in
                     let uu____4549 =
                       let uu____4550 =
                         let uu____4557 =
                           let uu____4558 =
                             let uu____4571 =
                               let uu____4582 =
                                 FStar_Syntax_Syntax.as_arg haseq_ind in
                               [uu____4582] in
                             [uu____4571] in
                           FStar_Syntax_Syntax.Meta_pattern uu____4558 in
                         (fml, uu____4557) in
                       FStar_Syntax_Syntax.Tm_meta uu____4550 in
                     {
                       FStar_Syntax_Syntax.n = uu____4549;
                       FStar_Syntax_Syntax.pos =
                         (uu___638_4548.FStar_Syntax_Syntax.pos);
                       FStar_Syntax_Syntax.vars =
                         (uu___638_4548.FStar_Syntax_Syntax.vars)
                     } in
                   let fml2 =
                     FStar_List.fold_right
                       (fun b ->
                          fun t3 ->
                            let uu____4635 =
                              let uu____4640 =
                                let uu____4641 =
                                  let uu____4650 =
                                    let uu____4651 =
                                      FStar_Syntax_Subst.close [b] t3 in
                                    FStar_Syntax_Util.abs
                                      [((FStar_Pervasives_Native.fst b),
                                         FStar_Pervasives_Native.None)]
                                      uu____4651 FStar_Pervasives_Native.None in
                                  FStar_Syntax_Syntax.as_arg uu____4650 in
                                [uu____4641] in
                              FStar_Syntax_Syntax.mk_Tm_app
                                FStar_Syntax_Util.tforall uu____4640 in
                            uu____4635 FStar_Pervasives_Native.None
                              FStar_Range.dummyRange) ibs1 fml1 in
                   let fml3 =
                     FStar_List.fold_right
                       (fun b ->
                          fun t3 ->
                            let uu____4704 =
                              let uu____4709 =
                                let uu____4710 =
                                  let uu____4719 =
                                    let uu____4720 =
                                      FStar_Syntax_Subst.close [b] t3 in
                                    FStar_Syntax_Util.abs
                                      [((FStar_Pervasives_Native.fst b),
                                         FStar_Pervasives_Native.None)]
                                      uu____4720 FStar_Pervasives_Native.None in
                                  FStar_Syntax_Syntax.as_arg uu____4719 in
                                [uu____4710] in
                              FStar_Syntax_Syntax.mk_Tm_app
                                FStar_Syntax_Util.tforall uu____4709 in
                            uu____4704 FStar_Pervasives_Native.None
                              FStar_Range.dummyRange) bs2 fml2 in
                   let axiom_lid = get_haseq_axiom_lid lid in
                   (axiom_lid, fml3, bs2, ibs1, haseq_bs))
let (optimized_haseq_soundness_for_data :
  FStar_Ident.lident ->
    FStar_Syntax_Syntax.sigelt ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.term)
  =
  fun ty_lid ->
    fun data ->
      fun usubst ->
        fun bs ->
          let dt = datacon_typ data in
          let dt1 = FStar_Syntax_Subst.subst usubst dt in
          let uu____4795 =
            let uu____4796 = FStar_Syntax_Subst.compress dt1 in
            uu____4796.FStar_Syntax_Syntax.n in
          match uu____4795 with
          | FStar_Syntax_Syntax.Tm_arrow (dbs, uu____4800) ->
              let dbs1 =
                let uu____4830 =
                  FStar_List.splitAt (FStar_List.length bs) dbs in
                FStar_Pervasives_Native.snd uu____4830 in
              let dbs2 =
                let uu____4880 = FStar_Syntax_Subst.opening_of_binders bs in
                FStar_Syntax_Subst.subst_binders uu____4880 dbs1 in
              let dbs3 = FStar_Syntax_Subst.open_binders dbs2 in
              let cond =
                FStar_List.fold_left
                  (fun t ->
                     fun b ->
                       let haseq_b =
                         let uu____4895 =
                           let uu____4900 =
                             let uu____4901 =
                               FStar_Syntax_Syntax.as_arg
                                 (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                             [uu____4901] in
                           FStar_Syntax_Syntax.mk_Tm_app
                             FStar_Syntax_Util.t_haseq uu____4900 in
                         uu____4895 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange in
                       let sort_range =
                         ((FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort).FStar_Syntax_Syntax.pos in
                       let haseq_b1 =
                         let uu____4932 =
                           FStar_Util.format1
                             "Failed to prove that the type '%s' supports decidable equality because of this argument; add either the 'noeq' or 'unopteq' qualifier"
                             ty_lid.FStar_Ident.str in
                         FStar_TypeChecker_Util.label uu____4932 sort_range
                           haseq_b in
                       FStar_Syntax_Util.mk_conj t haseq_b1)
                  FStar_Syntax_Util.t_true dbs3 in
              FStar_List.fold_right
                (fun b ->
                   fun t ->
                     let uu____4940 =
                       let uu____4945 =
                         let uu____4946 =
                           let uu____4955 =
                             let uu____4956 = FStar_Syntax_Subst.close [b] t in
                             FStar_Syntax_Util.abs
                               [((FStar_Pervasives_Native.fst b),
                                  FStar_Pervasives_Native.None)] uu____4956
                               FStar_Pervasives_Native.None in
                           FStar_Syntax_Syntax.as_arg uu____4955 in
                         [uu____4946] in
                       FStar_Syntax_Syntax.mk_Tm_app
                         FStar_Syntax_Util.tforall uu____4945 in
                     uu____4940 FStar_Pervasives_Native.None
                       FStar_Range.dummyRange) dbs3 cond
          | uu____5003 -> FStar_Syntax_Util.t_true
let (optimized_haseq_ty :
  FStar_Syntax_Syntax.sigelts ->
    FStar_Syntax_Syntax.subst_elt Prims.list ->
      FStar_Syntax_Syntax.univ_name Prims.list ->
        ((FStar_Ident.lident * FStar_Syntax_Syntax.term) Prims.list *
          FStar_TypeChecker_Env.env * FStar_Syntax_Syntax.term'
          FStar_Syntax_Syntax.syntax * FStar_Syntax_Syntax.term'
          FStar_Syntax_Syntax.syntax) ->
          FStar_Syntax_Syntax.sigelt ->
            ((FStar_Ident.lident * FStar_Syntax_Syntax.term) Prims.list *
              FStar_TypeChecker_Env.env * FStar_Syntax_Syntax.term'
              FStar_Syntax_Syntax.syntax * FStar_Syntax_Syntax.term'
              FStar_Syntax_Syntax.syntax))
  =
  fun all_datas_in_the_bundle ->
    fun usubst ->
      fun us ->
        fun acc ->
          fun ty ->
            let lid =
              match ty.FStar_Syntax_Syntax.sigel with
              | FStar_Syntax_Syntax.Sig_inductive_typ
                  (lid, uu____5094, uu____5095, uu____5096, uu____5097,
                   uu____5098)
                  -> lid
              | uu____5107 -> failwith "Impossible!" in
            let uu____5109 = acc in
            match uu____5109 with
            | (uu____5146, en, uu____5148, uu____5149) ->
                let uu____5170 = get_optimized_haseq_axiom en ty usubst us in
                (match uu____5170 with
                 | (axiom_lid, fml, bs, ibs, haseq_bs) ->
                     let guard = FStar_Syntax_Util.mk_conj haseq_bs fml in
                     let uu____5207 = acc in
                     (match uu____5207 with
                      | (l_axioms, env, guard', cond') ->
                          let env1 =
                            FStar_TypeChecker_Env.push_binders env bs in
                          let env2 =
                            FStar_TypeChecker_Env.push_binders env1 ibs in
                          let t_datas =
                            FStar_List.filter
                              (fun s ->
                                 match s.FStar_Syntax_Syntax.sigel with
                                 | FStar_Syntax_Syntax.Sig_datacon
                                     (uu____5282, uu____5283, uu____5284,
                                      t_lid, uu____5286, uu____5287)
                                     -> t_lid = lid
                                 | uu____5294 -> failwith "Impossible")
                              all_datas_in_the_bundle in
                          let cond =
                            FStar_List.fold_left
                              (fun acc1 ->
                                 fun d ->
                                   let uu____5309 =
                                     optimized_haseq_soundness_for_data lid d
                                       usubst bs in
                                   FStar_Syntax_Util.mk_conj acc1 uu____5309)
                              FStar_Syntax_Util.t_true t_datas in
                          let uu____5312 =
                            FStar_Syntax_Util.mk_conj guard' guard in
                          let uu____5315 =
                            FStar_Syntax_Util.mk_conj cond' cond in
                          ((FStar_List.append l_axioms [(axiom_lid, fml)]),
                            env2, uu____5312, uu____5315)))
let (optimized_haseq_scheme :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_TypeChecker_Env.env_t -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun sig_bndle ->
    fun tcs ->
      fun datas ->
        fun env0 ->
          let uu____5373 =
            let ty = FStar_List.hd tcs in
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (uu____5383, us, uu____5385, t, uu____5387, uu____5388) ->
                (us, t)
            | uu____5397 -> failwith "Impossible!" in
          match uu____5373 with
          | (us, t) ->
              let uu____5407 = FStar_Syntax_Subst.univ_var_opening us in
              (match uu____5407 with
               | (usubst, us1) ->
                   let env = FStar_TypeChecker_Env.push_sigelt env0 sig_bndle in
                   ((env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.push
                      "haseq";
                    (env.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.encode_sig
                      env sig_bndle;
                    (let env1 = FStar_TypeChecker_Env.push_univ_vars env us1 in
                     let uu____5433 =
                       FStar_List.fold_left
                         (optimized_haseq_ty datas usubst us1)
                         ([], env1, FStar_Syntax_Util.t_true,
                           FStar_Syntax_Util.t_true) tcs in
                     match uu____5433 with
                     | (axioms, env2, guard, cond) ->
                         let phi =
                           let uu____5511 = FStar_Syntax_Util.arrow_formals t in
                           match uu____5511 with
                           | (uu____5526, t1) ->
                               let uu____5548 =
                                 FStar_Syntax_Util.is_eqtype_no_unrefine t1 in
                               if uu____5548
                               then cond
                               else FStar_Syntax_Util.mk_imp guard cond in
                         let uu____5553 =
                           FStar_TypeChecker_TcTerm.tc_trivial_guard env2 phi in
                         (match uu____5553 with
                          | (phi1, uu____5561) ->
                              ((let uu____5563 =
                                  FStar_TypeChecker_Env.should_verify env2 in
                                if uu____5563
                                then
                                  let uu____5566 =
                                    FStar_TypeChecker_Env.guard_of_guard_formula
                                      (FStar_TypeChecker_Common.NonTrivial
                                         phi1) in
                                  FStar_TypeChecker_Rel.force_trivial_guard
                                    env2 uu____5566
                                else ());
                               (let ses =
                                  FStar_List.fold_left
                                    (fun l ->
                                       fun uu____5584 ->
                                         match uu____5584 with
                                         | (lid, fml) ->
                                             let fml1 =
                                               FStar_Syntax_Subst.close_univ_vars
                                                 us1 fml in
                                             FStar_List.append l
                                               [{
                                                  FStar_Syntax_Syntax.sigel =
                                                    (FStar_Syntax_Syntax.Sig_assume
                                                       (lid, us1, fml1));
                                                  FStar_Syntax_Syntax.sigrng
                                                    = FStar_Range.dummyRange;
                                                  FStar_Syntax_Syntax.sigquals
                                                    = [];
                                                  FStar_Syntax_Syntax.sigmeta
                                                    =
                                                    FStar_Syntax_Syntax.default_sigmeta;
                                                  FStar_Syntax_Syntax.sigattrs
                                                    = []
                                                }]) [] axioms in
                                (env2.FStar_TypeChecker_Env.solver).FStar_TypeChecker_Env.pop
                                  "haseq";
                                ses))))))
let (unoptimized_haseq_data :
  FStar_Syntax_Syntax.subst_elt Prims.list ->
    FStar_Syntax_Syntax.binders ->
      FStar_Syntax_Syntax.term ->
        FStar_Ident.lident Prims.list ->
          FStar_Syntax_Syntax.term ->
            FStar_Syntax_Syntax.sigelt ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun usubst ->
    fun bs ->
      fun haseq_ind ->
        fun mutuals ->
          fun acc ->
            fun data ->
              let rec is_mutual t =
                let uu____5656 =
                  let uu____5657 = FStar_Syntax_Subst.compress t in
                  uu____5657.FStar_Syntax_Syntax.n in
                match uu____5656 with
                | FStar_Syntax_Syntax.Tm_fvar fv ->
                    FStar_List.existsb
                      (fun lid ->
                         FStar_Ident.lid_equals lid
                           (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                      mutuals
                | FStar_Syntax_Syntax.Tm_uinst (t', uu____5665) ->
                    is_mutual t'
                | FStar_Syntax_Syntax.Tm_refine (bv, t') ->
                    is_mutual bv.FStar_Syntax_Syntax.sort
                | FStar_Syntax_Syntax.Tm_app (t', args) ->
                    let uu____5702 = is_mutual t' in
                    if uu____5702
                    then true
                    else
                      (let uu____5709 =
                         FStar_List.map FStar_Pervasives_Native.fst args in
                       exists_mutual uu____5709)
                | FStar_Syntax_Syntax.Tm_meta (t', uu____5729) ->
                    is_mutual t'
                | uu____5734 -> false
              and exists_mutual uu___1_5736 =
                match uu___1_5736 with
                | [] -> false
                | hd1::tl1 -> (is_mutual hd1) || (exists_mutual tl1) in
              let dt = datacon_typ data in
              let dt1 = FStar_Syntax_Subst.subst usubst dt in
              let uu____5757 =
                let uu____5758 = FStar_Syntax_Subst.compress dt1 in
                uu____5758.FStar_Syntax_Syntax.n in
              match uu____5757 with
              | FStar_Syntax_Syntax.Tm_arrow (dbs, uu____5764) ->
                  let dbs1 =
                    let uu____5794 =
                      FStar_List.splitAt (FStar_List.length bs) dbs in
                    FStar_Pervasives_Native.snd uu____5794 in
                  let dbs2 =
                    let uu____5844 = FStar_Syntax_Subst.opening_of_binders bs in
                    FStar_Syntax_Subst.subst_binders uu____5844 dbs1 in
                  let dbs3 = FStar_Syntax_Subst.open_binders dbs2 in
                  let cond =
                    FStar_List.fold_left
                      (fun t ->
                         fun b ->
                           let sort =
                             (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                           let haseq_sort =
                             let uu____5864 =
                               let uu____5869 =
                                 let uu____5870 =
                                   FStar_Syntax_Syntax.as_arg
                                     (FStar_Pervasives_Native.fst b).FStar_Syntax_Syntax.sort in
                                 [uu____5870] in
                               FStar_Syntax_Syntax.mk_Tm_app
                                 FStar_Syntax_Util.t_haseq uu____5869 in
                             uu____5864 FStar_Pervasives_Native.None
                               FStar_Range.dummyRange in
                           let haseq_sort1 =
                             let uu____5900 = is_mutual sort in
                             if uu____5900
                             then
                               FStar_Syntax_Util.mk_imp haseq_ind haseq_sort
                             else haseq_sort in
                           FStar_Syntax_Util.mk_conj t haseq_sort1)
                      FStar_Syntax_Util.t_true dbs3 in
                  let cond1 =
                    FStar_List.fold_right
                      (fun b ->
                         fun t ->
                           let uu____5913 =
                             let uu____5918 =
                               let uu____5919 =
                                 let uu____5928 =
                                   let uu____5929 =
                                     FStar_Syntax_Subst.close [b] t in
                                   FStar_Syntax_Util.abs
                                     [((FStar_Pervasives_Native.fst b),
                                        FStar_Pervasives_Native.None)]
                                     uu____5929 FStar_Pervasives_Native.None in
                                 FStar_Syntax_Syntax.as_arg uu____5928 in
                               [uu____5919] in
                             FStar_Syntax_Syntax.mk_Tm_app
                               FStar_Syntax_Util.tforall uu____5918 in
                           uu____5913 FStar_Pervasives_Native.None
                             FStar_Range.dummyRange) dbs3 cond in
                  FStar_Syntax_Util.mk_conj acc cond1
              | uu____5976 -> acc
let (unoptimized_haseq_ty :
  FStar_Syntax_Syntax.sigelt Prims.list ->
    FStar_Ident.lident Prims.list ->
      FStar_Syntax_Syntax.subst_elt Prims.list ->
        FStar_Syntax_Syntax.univ_name Prims.list ->
          FStar_Syntax_Syntax.term ->
            FStar_Syntax_Syntax.sigelt ->
              FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax)
  =
  fun all_datas_in_the_bundle ->
    fun mutuals ->
      fun usubst ->
        fun us ->
          fun acc ->
            fun ty ->
              let uu____6026 =
                match ty.FStar_Syntax_Syntax.sigel with
                | FStar_Syntax_Syntax.Sig_inductive_typ
                    (lid, uu____6048, bs, t, uu____6051, d_lids) ->
                    (lid, bs, t, d_lids)
                | uu____6063 -> failwith "Impossible!" in
              match uu____6026 with
              | (lid, bs, t, d_lids) ->
                  let bs1 = FStar_Syntax_Subst.subst_binders usubst bs in
                  let t1 =
                    let uu____6087 =
                      FStar_Syntax_Subst.shift_subst (FStar_List.length bs1)
                        usubst in
                    FStar_Syntax_Subst.subst uu____6087 t in
                  let uu____6096 = FStar_Syntax_Subst.open_term bs1 t1 in
                  (match uu____6096 with
                   | (bs2, t2) ->
                       let ibs =
                         let uu____6106 =
                           let uu____6107 = FStar_Syntax_Subst.compress t2 in
                           uu____6107.FStar_Syntax_Syntax.n in
                         match uu____6106 with
                         | FStar_Syntax_Syntax.Tm_arrow (ibs, uu____6111) ->
                             ibs
                         | uu____6132 -> [] in
                       let ibs1 = FStar_Syntax_Subst.open_binders ibs in
                       let ind =
                         let uu____6141 =
                           FStar_Syntax_Syntax.fvar lid
                             FStar_Syntax_Syntax.delta_constant
                             FStar_Pervasives_Native.None in
                         let uu____6142 =
                           FStar_List.map
                             (fun u -> FStar_Syntax_Syntax.U_name u) us in
                         FStar_Syntax_Syntax.mk_Tm_uinst uu____6141
                           uu____6142 in
                       let ind1 =
                         let uu____6148 =
                           let uu____6153 =
                             FStar_List.map
                               (fun uu____6170 ->
                                  match uu____6170 with
                                  | (bv, aq) ->
                                      let uu____6189 =
                                        FStar_Syntax_Syntax.bv_to_name bv in
                                      (uu____6189, aq)) bs2 in
                           FStar_Syntax_Syntax.mk_Tm_app ind uu____6153 in
                         uu____6148 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange in
                       let ind2 =
                         let uu____6195 =
                           let uu____6200 =
                             FStar_List.map
                               (fun uu____6217 ->
                                  match uu____6217 with
                                  | (bv, aq) ->
                                      let uu____6236 =
                                        FStar_Syntax_Syntax.bv_to_name bv in
                                      (uu____6236, aq)) ibs1 in
                           FStar_Syntax_Syntax.mk_Tm_app ind1 uu____6200 in
                         uu____6195 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange in
                       let haseq_ind =
                         let uu____6242 =
                           let uu____6247 =
                             let uu____6248 = FStar_Syntax_Syntax.as_arg ind2 in
                             [uu____6248] in
                           FStar_Syntax_Syntax.mk_Tm_app
                             FStar_Syntax_Util.t_haseq uu____6247 in
                         uu____6242 FStar_Pervasives_Native.None
                           FStar_Range.dummyRange in
                       let t_datas =
                         FStar_List.filter
                           (fun s ->
                              match s.FStar_Syntax_Syntax.sigel with
                              | FStar_Syntax_Syntax.Sig_datacon
                                  (uu____6285, uu____6286, uu____6287, t_lid,
                                   uu____6289, uu____6290)
                                  -> t_lid = lid
                              | uu____6297 -> failwith "Impossible")
                           all_datas_in_the_bundle in
                       let data_cond =
                         FStar_List.fold_left
                           (unoptimized_haseq_data usubst bs2 haseq_ind
                              mutuals) FStar_Syntax_Util.t_true t_datas in
                       let fml = FStar_Syntax_Util.mk_imp data_cond haseq_ind in
                       let fml1 =
                         let uu___875_6309 = fml in
                         let uu____6310 =
                           let uu____6311 =
                             let uu____6318 =
                               let uu____6319 =
                                 let uu____6332 =
                                   let uu____6343 =
                                     FStar_Syntax_Syntax.as_arg haseq_ind in
                                   [uu____6343] in
                                 [uu____6332] in
                               FStar_Syntax_Syntax.Meta_pattern uu____6319 in
                             (fml, uu____6318) in
                           FStar_Syntax_Syntax.Tm_meta uu____6311 in
                         {
                           FStar_Syntax_Syntax.n = uu____6310;
                           FStar_Syntax_Syntax.pos =
                             (uu___875_6309.FStar_Syntax_Syntax.pos);
                           FStar_Syntax_Syntax.vars =
                             (uu___875_6309.FStar_Syntax_Syntax.vars)
                         } in
                       let fml2 =
                         FStar_List.fold_right
                           (fun b ->
                              fun t3 ->
                                let uu____6396 =
                                  let uu____6401 =
                                    let uu____6402 =
                                      let uu____6411 =
                                        let uu____6412 =
                                          FStar_Syntax_Subst.close [b] t3 in
                                        FStar_Syntax_Util.abs
                                          [((FStar_Pervasives_Native.fst b),
                                             FStar_Pervasives_Native.None)]
                                          uu____6412
                                          FStar_Pervasives_Native.None in
                                      FStar_Syntax_Syntax.as_arg uu____6411 in
                                    [uu____6402] in
                                  FStar_Syntax_Syntax.mk_Tm_app
                                    FStar_Syntax_Util.tforall uu____6401 in
                                uu____6396 FStar_Pervasives_Native.None
                                  FStar_Range.dummyRange) ibs1 fml1 in
                       let fml3 =
                         FStar_List.fold_right
                           (fun b ->
                              fun t3 ->
                                let uu____6465 =
                                  let uu____6470 =
                                    let uu____6471 =
                                      let uu____6480 =
                                        let uu____6481 =
                                          FStar_Syntax_Subst.close [b] t3 in
                                        FStar_Syntax_Util.abs
                                          [((FStar_Pervasives_Native.fst b),
                                             FStar_Pervasives_Native.None)]
                                          uu____6481
                                          FStar_Pervasives_Native.None in
                                      FStar_Syntax_Syntax.as_arg uu____6480 in
                                    [uu____6471] in
                                  FStar_Syntax_Syntax.mk_Tm_app
                                    FStar_Syntax_Util.tforall uu____6470 in
                                uu____6465 FStar_Pervasives_Native.None
                                  FStar_Range.dummyRange) bs2 fml2 in
                       FStar_Syntax_Util.mk_conj acc fml3)
let (unoptimized_haseq_scheme :
  FStar_Syntax_Syntax.sigelt ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_TypeChecker_Env.env_t -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun sig_bndle ->
    fun tcs ->
      fun datas ->
        fun env0 ->
          let mutuals =
            FStar_List.map
              (fun ty ->
                 match ty.FStar_Syntax_Syntax.sigel with
                 | FStar_Syntax_Syntax.Sig_inductive_typ
                     (lid, uu____6573, uu____6574, uu____6575, uu____6576,
                      uu____6577)
                     -> lid
                 | uu____6586 -> failwith "Impossible!") tcs in
          let uu____6588 =
            let ty = FStar_List.hd tcs in
            match ty.FStar_Syntax_Syntax.sigel with
            | FStar_Syntax_Syntax.Sig_inductive_typ
                (lid, us, uu____6600, uu____6601, uu____6602, uu____6603) ->
                (lid, us)
            | uu____6612 -> failwith "Impossible!" in
          match uu____6588 with
          | (lid, us) ->
              let uu____6622 = FStar_Syntax_Subst.univ_var_opening us in
              (match uu____6622 with
               | (usubst, us1) ->
                   let fml =
                     FStar_List.fold_left
                       (unoptimized_haseq_ty datas mutuals usubst us1)
                       FStar_Syntax_Util.t_true tcs in
                   let se =
                     let uu____6649 =
                       let uu____6650 =
                         let uu____6657 = get_haseq_axiom_lid lid in
                         (uu____6657, us1, fml) in
                       FStar_Syntax_Syntax.Sig_assume uu____6650 in
                     {
                       FStar_Syntax_Syntax.sigel = uu____6649;
                       FStar_Syntax_Syntax.sigrng = FStar_Range.dummyRange;
                       FStar_Syntax_Syntax.sigquals = [];
                       FStar_Syntax_Syntax.sigmeta =
                         FStar_Syntax_Syntax.default_sigmeta;
                       FStar_Syntax_Syntax.sigattrs = []
                     } in
                   [se])
let (check_inductive_well_typedness :
  FStar_TypeChecker_Env.env_t ->
    FStar_Syntax_Syntax.sigelt Prims.list ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        FStar_Ident.lident Prims.list ->
          (FStar_Syntax_Syntax.sigelt * FStar_Syntax_Syntax.sigelt Prims.list
            * FStar_Syntax_Syntax.sigelt Prims.list))
  =
  fun env ->
    fun ses ->
      fun quals ->
        fun lids ->
          let uu____6711 =
            FStar_All.pipe_right ses
              (FStar_List.partition
                 (fun uu___2_6736 ->
                    match uu___2_6736 with
                    | {
                        FStar_Syntax_Syntax.sigel =
                          FStar_Syntax_Syntax.Sig_inductive_typ uu____6738;
                        FStar_Syntax_Syntax.sigrng = uu____6739;
                        FStar_Syntax_Syntax.sigquals = uu____6740;
                        FStar_Syntax_Syntax.sigmeta = uu____6741;
                        FStar_Syntax_Syntax.sigattrs = uu____6742;_} -> true
                    | uu____6764 -> false)) in
          match uu____6711 with
          | (tys, datas) ->
              ((let uu____6787 =
                  FStar_All.pipe_right datas
                    (FStar_Util.for_some
                       (fun uu___3_6798 ->
                          match uu___3_6798 with
                          | {
                              FStar_Syntax_Syntax.sigel =
                                FStar_Syntax_Syntax.Sig_datacon uu____6800;
                              FStar_Syntax_Syntax.sigrng = uu____6801;
                              FStar_Syntax_Syntax.sigquals = uu____6802;
                              FStar_Syntax_Syntax.sigmeta = uu____6803;
                              FStar_Syntax_Syntax.sigattrs = uu____6804;_} ->
                              false
                          | uu____6825 -> true)) in
                if uu____6787
                then
                  let uu____6828 = FStar_TypeChecker_Env.get_range env in
                  FStar_Errors.raise_error
                    (FStar_Errors.Fatal_NonInductiveInMutuallyDefinedType,
                      "Mutually defined type contains a non-inductive element")
                    uu____6828
                else ());
               (let univs1 =
                  if (FStar_List.length tys) = (Prims.parse_int "0")
                  then []
                  else
                    (let uu____6843 =
                       let uu____6844 = FStar_List.hd tys in
                       uu____6844.FStar_Syntax_Syntax.sigel in
                     match uu____6843 with
                     | FStar_Syntax_Syntax.Sig_inductive_typ
                         (uu____6847, uvs, uu____6849, uu____6850,
                          uu____6851, uu____6852)
                         -> uvs
                     | uu____6861 -> failwith "Impossible, can't happen!") in
                let env0 = env in
                let uu____6866 =
                  if (FStar_List.length univs1) = (Prims.parse_int "0")
                  then (env, tys, datas)
                  else
                    (let uu____6896 =
                       FStar_Syntax_Subst.univ_var_opening univs1 in
                     match uu____6896 with
                     | (subst1, univs2) ->
                         let tys1 =
                           FStar_List.map
                             (fun se ->
                                let sigel =
                                  match se.FStar_Syntax_Syntax.sigel with
                                  | FStar_Syntax_Syntax.Sig_inductive_typ
                                      (lid, uu____6934, bs, t, l1, l2) ->
                                      let uu____6947 =
                                        let uu____6964 =
                                          FStar_Syntax_Subst.subst_binders
                                            subst1 bs in
                                        let uu____6965 =
                                          let uu____6966 =
                                            FStar_Syntax_Subst.shift_subst
                                              (FStar_List.length bs) subst1 in
                                          FStar_Syntax_Subst.subst uu____6966
                                            t in
                                        (lid, univs2, uu____6964, uu____6965,
                                          l1, l2) in
                                      FStar_Syntax_Syntax.Sig_inductive_typ
                                        uu____6947
                                  | uu____6979 ->
                                      failwith "Impossible, can't happen" in
                                let uu___971_6981 = se in
                                {
                                  FStar_Syntax_Syntax.sigel = sigel;
                                  FStar_Syntax_Syntax.sigrng =
                                    (uu___971_6981.FStar_Syntax_Syntax.sigrng);
                                  FStar_Syntax_Syntax.sigquals =
                                    (uu___971_6981.FStar_Syntax_Syntax.sigquals);
                                  FStar_Syntax_Syntax.sigmeta =
                                    (uu___971_6981.FStar_Syntax_Syntax.sigmeta);
                                  FStar_Syntax_Syntax.sigattrs =
                                    (uu___971_6981.FStar_Syntax_Syntax.sigattrs)
                                }) tys in
                         let datas1 =
                           FStar_List.map
                             (fun se ->
                                let sigel =
                                  match se.FStar_Syntax_Syntax.sigel with
                                  | FStar_Syntax_Syntax.Sig_datacon
                                      (lid, uu____6991, t, lid_t, x, l) ->
                                      let uu____7002 =
                                        let uu____7018 =
                                          FStar_Syntax_Subst.subst subst1 t in
                                        (lid, univs2, uu____7018, lid_t, x,
                                          l) in
                                      FStar_Syntax_Syntax.Sig_datacon
                                        uu____7002
                                  | uu____7022 ->
                                      failwith "Impossible, can't happen" in
                                let uu___985_7024 = se in
                                {
                                  FStar_Syntax_Syntax.sigel = sigel;
                                  FStar_Syntax_Syntax.sigrng =
                                    (uu___985_7024.FStar_Syntax_Syntax.sigrng);
                                  FStar_Syntax_Syntax.sigquals =
                                    (uu___985_7024.FStar_Syntax_Syntax.sigquals);
                                  FStar_Syntax_Syntax.sigmeta =
                                    (uu___985_7024.FStar_Syntax_Syntax.sigmeta);
                                  FStar_Syntax_Syntax.sigattrs =
                                    (uu___985_7024.FStar_Syntax_Syntax.sigattrs)
                                }) datas in
                         let uu____7025 =
                           FStar_TypeChecker_Env.push_univ_vars env univs2 in
                         (uu____7025, tys1, datas1)) in
                match uu____6866 with
                | (env1, tys1, datas1) ->
                    let uu____7051 =
                      FStar_List.fold_right
                        (fun tc ->
                           fun uu____7090 ->
                             match uu____7090 with
                             | (env2, all_tcs, g) ->
                                 let uu____7130 = tc_tycon env2 tc in
                                 (match uu____7130 with
                                  | (env3, tc1, tc_u, guard) ->
                                      let g' =
                                        FStar_TypeChecker_Rel.universe_inequality
                                          FStar_Syntax_Syntax.U_zero tc_u in
                                      ((let uu____7157 =
                                          FStar_TypeChecker_Env.debug env3
                                            FStar_Options.Low in
                                        if uu____7157
                                        then
                                          let uu____7160 =
                                            FStar_Syntax_Print.sigelt_to_string
                                              tc1 in
                                          FStar_Util.print1
                                            "Checked inductive: %s\n"
                                            uu____7160
                                        else ());
                                       (let uu____7165 =
                                          let uu____7166 =
                                            FStar_TypeChecker_Env.conj_guard
                                              guard g' in
                                          FStar_TypeChecker_Env.conj_guard g
                                            uu____7166 in
                                        (env3, ((tc1, tc_u) :: all_tcs),
                                          uu____7165))))) tys1
                        (env1, [], FStar_TypeChecker_Env.trivial_guard) in
                    (match uu____7051 with
                     | (env2, tcs, g) ->
                         let uu____7212 =
                           FStar_List.fold_right
                             (fun se ->
                                fun uu____7234 ->
                                  match uu____7234 with
                                  | (datas2, g1) ->
                                      let uu____7253 =
                                        let uu____7258 = tc_data env2 tcs in
                                        uu____7258 se in
                                      (match uu____7253 with
                                       | (data, g') ->
                                           let uu____7275 =
                                             FStar_TypeChecker_Env.conj_guard
                                               g1 g' in
                                           ((data :: datas2), uu____7275)))
                             datas1 ([], g) in
                         (match uu____7212 with
                          | (datas2, g1) ->
                              let uu____7296 =
                                if
                                  (FStar_List.length univs1) =
                                    (Prims.parse_int "0")
                                then
                                  generalize_and_inst_within env1 g1 tcs
                                    datas2
                                else
                                  (let uu____7318 =
                                     FStar_List.map
                                       FStar_Pervasives_Native.fst tcs in
                                   (uu____7318, datas2)) in
                              (match uu____7296 with
                               | (tcs1, datas3) ->
                                   let sig_bndle =
                                     let uu____7350 =
                                       FStar_TypeChecker_Env.get_range env0 in
                                     let uu____7351 =
                                       FStar_List.collect
                                         (fun s ->
                                            s.FStar_Syntax_Syntax.sigattrs)
                                         ses in
                                     {
                                       FStar_Syntax_Syntax.sigel =
                                         (FStar_Syntax_Syntax.Sig_bundle
                                            ((FStar_List.append tcs1 datas3),
                                              lids));
                                       FStar_Syntax_Syntax.sigrng =
                                         uu____7350;
                                       FStar_Syntax_Syntax.sigquals = quals;
                                       FStar_Syntax_Syntax.sigmeta =
                                         FStar_Syntax_Syntax.default_sigmeta;
                                       FStar_Syntax_Syntax.sigattrs =
                                         uu____7351
                                     } in
                                   (FStar_All.pipe_right tcs1
                                      (FStar_List.iter
                                         (fun se ->
                                            match se.FStar_Syntax_Syntax.sigel
                                            with
                                            | FStar_Syntax_Syntax.Sig_inductive_typ
                                                (l, univs2, binders, typ,
                                                 uu____7377, uu____7378)
                                                ->
                                                let fail1 expected inferred =
                                                  let uu____7398 =
                                                    let uu____7404 =
                                                      let uu____7406 =
                                                        FStar_Syntax_Print.tscheme_to_string
                                                          expected in
                                                      let uu____7408 =
                                                        FStar_Syntax_Print.tscheme_to_string
                                                          inferred in
                                                      FStar_Util.format2
                                                        "Expected an inductive with type %s; got %s"
                                                        uu____7406 uu____7408 in
                                                    (FStar_Errors.Fatal_UnexpectedInductivetype,
                                                      uu____7404) in
                                                  FStar_Errors.raise_error
                                                    uu____7398
                                                    se.FStar_Syntax_Syntax.sigrng in
                                                let uu____7412 =
                                                  FStar_TypeChecker_Env.try_lookup_val_decl
                                                    env0 l in
                                                (match uu____7412 with
                                                 | FStar_Pervasives_Native.None
                                                     -> ()
                                                 | FStar_Pervasives_Native.Some
                                                     (expected_typ1,
                                                      uu____7428)
                                                     ->
                                                     let inferred_typ =
                                                       let body =
                                                         match binders with
                                                         | [] -> typ
                                                         | uu____7459 ->
                                                             let uu____7460 =
                                                               let uu____7467
                                                                 =
                                                                 let uu____7468
                                                                   =
                                                                   let uu____7483
                                                                    =
                                                                    FStar_Syntax_Syntax.mk_Total
                                                                    typ in
                                                                   (binders,
                                                                    uu____7483) in
                                                                 FStar_Syntax_Syntax.Tm_arrow
                                                                   uu____7468 in
                                                               FStar_Syntax_Syntax.mk
                                                                 uu____7467 in
                                                             uu____7460
                                                               FStar_Pervasives_Native.None
                                                               se.FStar_Syntax_Syntax.sigrng in
                                                       (univs2, body) in
                                                     if
                                                       (FStar_List.length
                                                          univs2)
                                                         =
                                                         (FStar_List.length
                                                            (FStar_Pervasives_Native.fst
                                                               expected_typ1))
                                                     then
                                                       let uu____7505 =
                                                         FStar_TypeChecker_Env.inst_tscheme
                                                           inferred_typ in
                                                       (match uu____7505 with
                                                        | (uu____7510,
                                                           inferred) ->
                                                            let uu____7512 =
                                                              FStar_TypeChecker_Env.inst_tscheme
                                                                expected_typ1 in
                                                            (match uu____7512
                                                             with
                                                             | (uu____7517,
                                                                expected) ->
                                                                 let uu____7519
                                                                   =
                                                                   FStar_TypeChecker_Rel.teq_nosmt_force
                                                                    env0
                                                                    inferred
                                                                    expected in
                                                                 if
                                                                   uu____7519
                                                                 then ()
                                                                 else
                                                                   fail1
                                                                    expected_typ1
                                                                    inferred_typ))
                                                     else
                                                       fail1 expected_typ1
                                                         inferred_typ)
                                            | uu____7526 -> ()));
                                    (sig_bndle, tcs1, datas3)))))))
let (early_prims_inductives : Prims.string Prims.list) =
  ["c_False"; "c_True"; "equals"; "h_equals"; "c_and"; "c_or"]
let (mk_discriminator_and_indexed_projectors :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_Syntax_Syntax.fv_qual ->
      Prims.bool ->
        FStar_TypeChecker_Env.env ->
          FStar_Ident.lident ->
            FStar_Ident.lident ->
              FStar_Syntax_Syntax.univ_names ->
                FStar_Syntax_Syntax.binders ->
                  FStar_Syntax_Syntax.binders ->
                    FStar_Syntax_Syntax.binders ->
                      FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals ->
    fun fvq ->
      fun refine_domain ->
        fun env ->
          fun tc ->
            fun lid ->
              fun uvs ->
                fun inductive_tps ->
                  fun indices ->
                    fun fields ->
                      let p = FStar_Ident.range_of_lid lid in
                      let pos q = FStar_Syntax_Syntax.withinfo q p in
                      let projectee ptyp =
                        FStar_Syntax_Syntax.gen_bv "projectee"
                          (FStar_Pervasives_Native.Some p) ptyp in
                      let inst_univs =
                        FStar_List.map
                          (fun u -> FStar_Syntax_Syntax.U_name u) uvs in
                      let tps = inductive_tps in
                      let arg_typ =
                        let inst_tc =
                          let uu____7637 =
                            let uu____7644 =
                              let uu____7645 =
                                let uu____7652 =
                                  let uu____7655 =
                                    FStar_Syntax_Syntax.lid_as_fv tc
                                      FStar_Syntax_Syntax.delta_constant
                                      FStar_Pervasives_Native.None in
                                  FStar_Syntax_Syntax.fv_to_tm uu____7655 in
                                (uu____7652, inst_univs) in
                              FStar_Syntax_Syntax.Tm_uinst uu____7645 in
                            FStar_Syntax_Syntax.mk uu____7644 in
                          uu____7637 FStar_Pervasives_Native.None p in
                        let args =
                          FStar_All.pipe_right
                            (FStar_List.append tps indices)
                            (FStar_List.map
                               (fun uu____7689 ->
                                  match uu____7689 with
                                  | (x, imp) ->
                                      let uu____7708 =
                                        FStar_Syntax_Syntax.bv_to_name x in
                                      (uu____7708, imp))) in
                        FStar_Syntax_Syntax.mk_Tm_app inst_tc args
                          FStar_Pervasives_Native.None p in
                      let unrefined_arg_binder =
                        let uu____7712 = projectee arg_typ in
                        FStar_Syntax_Syntax.mk_binder uu____7712 in
                      let arg_binder =
                        if Prims.op_Negation refine_domain
                        then unrefined_arg_binder
                        else
                          (let disc_name =
                             FStar_Syntax_Util.mk_discriminator lid in
                           let x =
                             FStar_Syntax_Syntax.new_bv
                               (FStar_Pervasives_Native.Some p) arg_typ in
                           let sort =
                             let disc_fvar =
                               let uu____7735 =
                                 FStar_Ident.set_lid_range disc_name p in
                               FStar_Syntax_Syntax.fvar uu____7735
                                 (FStar_Syntax_Syntax.Delta_equational_at_level
                                    (Prims.parse_int "1"))
                                 FStar_Pervasives_Native.None in
                             let uu____7737 =
                               let uu____7740 =
                                 let uu____7743 =
                                   let uu____7748 =
                                     FStar_Syntax_Syntax.mk_Tm_uinst
                                       disc_fvar inst_univs in
                                   let uu____7749 =
                                     let uu____7750 =
                                       let uu____7759 =
                                         FStar_Syntax_Syntax.bv_to_name x in
                                       FStar_All.pipe_left
                                         FStar_Syntax_Syntax.as_arg
                                         uu____7759 in
                                     [uu____7750] in
                                   FStar_Syntax_Syntax.mk_Tm_app uu____7748
                                     uu____7749 in
                                 uu____7743 FStar_Pervasives_Native.None p in
                               FStar_Syntax_Util.b2t uu____7740 in
                             FStar_Syntax_Util.refine x uu____7737 in
                           let uu____7784 =
                             let uu___1086_7785 = projectee arg_typ in
                             {
                               FStar_Syntax_Syntax.ppname =
                                 (uu___1086_7785.FStar_Syntax_Syntax.ppname);
                               FStar_Syntax_Syntax.index =
                                 (uu___1086_7785.FStar_Syntax_Syntax.index);
                               FStar_Syntax_Syntax.sort = sort
                             } in
                           FStar_Syntax_Syntax.mk_binder uu____7784) in
                      let ntps = FStar_List.length tps in
                      let all_params =
                        let uu____7802 =
                          FStar_List.map
                            (fun uu____7826 ->
                               match uu____7826 with
                               | (x, uu____7840) ->
                                   (x,
                                     (FStar_Pervasives_Native.Some
                                        FStar_Syntax_Syntax.imp_tag))) tps in
                        FStar_List.append uu____7802 fields in
                      let imp_binders =
                        FStar_All.pipe_right (FStar_List.append tps indices)
                          (FStar_List.map
                             (fun uu____7899 ->
                                match uu____7899 with
                                | (x, uu____7913) ->
                                    (x,
                                      (FStar_Pervasives_Native.Some
                                         FStar_Syntax_Syntax.imp_tag)))) in
                      let early_prims_inductive =
                        (let uu____7924 =
                           FStar_TypeChecker_Env.current_module env in
                         FStar_Ident.lid_equals FStar_Parser_Const.prims_lid
                           uu____7924)
                          &&
                          (FStar_List.existsb
                             (fun s ->
                                s = (tc.FStar_Ident.ident).FStar_Ident.idText)
                             early_prims_inductives) in
                      let discriminator_ses =
                        if fvq <> FStar_Syntax_Syntax.Data_ctor
                        then []
                        else
                          (let discriminator_name =
                             FStar_Syntax_Util.mk_discriminator lid in
                           let no_decl = false in
                           let only_decl =
                             early_prims_inductive ||
                               (let uu____7945 =
                                  let uu____7947 =
                                    FStar_TypeChecker_Env.current_module env in
                                  uu____7947.FStar_Ident.str in
                                FStar_Options.dont_gen_projectors uu____7945) in
                           let quals =
                             let uu____7951 =
                               FStar_List.filter
                                 (fun uu___4_7955 ->
                                    match uu___4_7955 with
                                    | FStar_Syntax_Syntax.Abstract ->
                                        Prims.op_Negation only_decl
                                    | FStar_Syntax_Syntax.Inline_for_extraction
                                        -> true
                                    | FStar_Syntax_Syntax.NoExtract -> true
                                    | FStar_Syntax_Syntax.Private -> true
                                    | uu____7960 -> false) iquals in
                             FStar_List.append
                               ((FStar_Syntax_Syntax.Discriminator lid) ::
                               (if only_decl
                                then
                                  [FStar_Syntax_Syntax.Logic;
                                  FStar_Syntax_Syntax.Assumption]
                                else [])) uu____7951 in
                           let binders =
                             FStar_List.append imp_binders
                               [unrefined_arg_binder] in
                           let t =
                             let bool_typ =
                               let uu____7998 =
                                 let uu____7999 =
                                   FStar_Syntax_Syntax.lid_as_fv
                                     FStar_Parser_Const.bool_lid
                                     FStar_Syntax_Syntax.delta_constant
                                     FStar_Pervasives_Native.None in
                                 FStar_Syntax_Syntax.fv_to_tm uu____7999 in
                               FStar_Syntax_Syntax.mk_Total uu____7998 in
                             let uu____8000 =
                               FStar_Syntax_Util.arrow binders bool_typ in
                             FStar_All.pipe_left
                               (FStar_Syntax_Subst.close_univ_vars uvs)
                               uu____8000 in
                           let decl =
                             let uu____8004 =
                               FStar_Ident.range_of_lid discriminator_name in
                             {
                               FStar_Syntax_Syntax.sigel =
                                 (FStar_Syntax_Syntax.Sig_declare_typ
                                    (discriminator_name, uvs, t));
                               FStar_Syntax_Syntax.sigrng = uu____8004;
                               FStar_Syntax_Syntax.sigquals = quals;
                               FStar_Syntax_Syntax.sigmeta =
                                 FStar_Syntax_Syntax.default_sigmeta;
                               FStar_Syntax_Syntax.sigattrs = []
                             } in
                           (let uu____8006 =
                              FStar_TypeChecker_Env.debug env
                                (FStar_Options.Other "LogTypes") in
                            if uu____8006
                            then
                              let uu____8010 =
                                FStar_Syntax_Print.sigelt_to_string decl in
                              FStar_Util.print1
                                "Declaration of a discriminator %s\n"
                                uu____8010
                            else ());
                           if only_decl
                           then [decl]
                           else
                             (let body =
                                if Prims.op_Negation refine_domain
                                then FStar_Syntax_Util.exp_true_bool
                                else
                                  (let arg_pats =
                                     FStar_All.pipe_right all_params
                                       (FStar_List.mapi
                                          (fun j ->
                                             fun uu____8071 ->
                                               match uu____8071 with
                                               | (x, imp) ->
                                                   let b =
                                                     FStar_Syntax_Syntax.is_implicit
                                                       imp in
                                                   if b && (j < ntps)
                                                   then
                                                     let uu____8096 =
                                                       let uu____8099 =
                                                         let uu____8100 =
                                                           let uu____8107 =
                                                             FStar_Syntax_Syntax.gen_bv
                                                               (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                               FStar_Pervasives_Native.None
                                                               FStar_Syntax_Syntax.tun in
                                                           (uu____8107,
                                                             FStar_Syntax_Syntax.tun) in
                                                         FStar_Syntax_Syntax.Pat_dot_term
                                                           uu____8100 in
                                                       pos uu____8099 in
                                                     (uu____8096, b)
                                                   else
                                                     (let uu____8115 =
                                                        let uu____8118 =
                                                          let uu____8119 =
                                                            FStar_Syntax_Syntax.gen_bv
                                                              (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                              FStar_Pervasives_Native.None
                                                              FStar_Syntax_Syntax.tun in
                                                          FStar_Syntax_Syntax.Pat_wild
                                                            uu____8119 in
                                                        pos uu____8118 in
                                                      (uu____8115, b)))) in
                                   let pat_true =
                                     let uu____8138 =
                                       let uu____8141 =
                                         let uu____8142 =
                                           let uu____8156 =
                                             FStar_Syntax_Syntax.lid_as_fv
                                               lid
                                               FStar_Syntax_Syntax.delta_constant
                                               (FStar_Pervasives_Native.Some
                                                  fvq) in
                                           (uu____8156, arg_pats) in
                                         FStar_Syntax_Syntax.Pat_cons
                                           uu____8142 in
                                       pos uu____8141 in
                                     (uu____8138,
                                       FStar_Pervasives_Native.None,
                                       FStar_Syntax_Util.exp_true_bool) in
                                   let pat_false =
                                     let uu____8191 =
                                       let uu____8194 =
                                         let uu____8195 =
                                           FStar_Syntax_Syntax.new_bv
                                             FStar_Pervasives_Native.None
                                             FStar_Syntax_Syntax.tun in
                                         FStar_Syntax_Syntax.Pat_wild
                                           uu____8195 in
                                       pos uu____8194 in
                                     (uu____8191,
                                       FStar_Pervasives_Native.None,
                                       FStar_Syntax_Util.exp_false_bool) in
                                   let arg_exp =
                                     FStar_Syntax_Syntax.bv_to_name
                                       (FStar_Pervasives_Native.fst
                                          unrefined_arg_binder) in
                                   let uu____8209 =
                                     let uu____8216 =
                                       let uu____8217 =
                                         let uu____8240 =
                                           let uu____8257 =
                                             FStar_Syntax_Util.branch
                                               pat_true in
                                           let uu____8272 =
                                             let uu____8289 =
                                               FStar_Syntax_Util.branch
                                                 pat_false in
                                             [uu____8289] in
                                           uu____8257 :: uu____8272 in
                                         (arg_exp, uu____8240) in
                                       FStar_Syntax_Syntax.Tm_match
                                         uu____8217 in
                                     FStar_Syntax_Syntax.mk uu____8216 in
                                   uu____8209 FStar_Pervasives_Native.None p) in
                              let dd =
                                let uu____8365 =
                                  FStar_All.pipe_right quals
                                    (FStar_List.contains
                                       FStar_Syntax_Syntax.Abstract) in
                                if uu____8365
                                then
                                  FStar_Syntax_Syntax.Delta_abstract
                                    (FStar_Syntax_Syntax.Delta_equational_at_level
                                       (Prims.parse_int "1"))
                                else
                                  FStar_Syntax_Syntax.Delta_equational_at_level
                                    (Prims.parse_int "1") in
                              let imp =
                                FStar_Syntax_Util.abs binders body
                                  FStar_Pervasives_Native.None in
                              let lbtyp =
                                if no_decl
                                then t
                                else FStar_Syntax_Syntax.tun in
                              let lb =
                                let uu____8387 =
                                  let uu____8392 =
                                    FStar_Syntax_Syntax.lid_as_fv
                                      discriminator_name dd
                                      FStar_Pervasives_Native.None in
                                  FStar_Util.Inr uu____8392 in
                                let uu____8393 =
                                  FStar_Syntax_Subst.close_univ_vars uvs imp in
                                FStar_Syntax_Util.mk_letbinding uu____8387
                                  uvs lbtyp FStar_Parser_Const.effect_Tot_lid
                                  uu____8393 [] FStar_Range.dummyRange in
                              let impl =
                                let uu____8399 =
                                  let uu____8400 =
                                    let uu____8407 =
                                      let uu____8410 =
                                        let uu____8411 =
                                          FStar_All.pipe_right
                                            lb.FStar_Syntax_Syntax.lbname
                                            FStar_Util.right in
                                        FStar_All.pipe_right uu____8411
                                          (fun fv ->
                                             (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                      [uu____8410] in
                                    ((false, [lb]), uu____8407) in
                                  FStar_Syntax_Syntax.Sig_let uu____8400 in
                                {
                                  FStar_Syntax_Syntax.sigel = uu____8399;
                                  FStar_Syntax_Syntax.sigrng = p;
                                  FStar_Syntax_Syntax.sigquals = quals;
                                  FStar_Syntax_Syntax.sigmeta =
                                    FStar_Syntax_Syntax.default_sigmeta;
                                  FStar_Syntax_Syntax.sigattrs = []
                                } in
                              (let uu____8425 =
                                 FStar_TypeChecker_Env.debug env
                                   (FStar_Options.Other "LogTypes") in
                               if uu____8425
                               then
                                 let uu____8429 =
                                   FStar_Syntax_Print.sigelt_to_string impl in
                                 FStar_Util.print1
                                   "Implementation of a discriminator %s\n"
                                   uu____8429
                               else ());
                              [decl; impl])) in
                      let arg_exp =
                        FStar_Syntax_Syntax.bv_to_name
                          (FStar_Pervasives_Native.fst arg_binder) in
                      let binders =
                        FStar_List.append imp_binders [arg_binder] in
                      let arg =
                        FStar_Syntax_Util.arg_of_non_null_binder arg_binder in
                      let subst1 =
                        FStar_All.pipe_right fields
                          (FStar_List.mapi
                             (fun i ->
                                fun uu____8502 ->
                                  match uu____8502 with
                                  | (a, uu____8511) ->
                                      let uu____8516 =
                                        FStar_Syntax_Util.mk_field_projector_name
                                          lid a i in
                                      (match uu____8516 with
                                       | (field_name, uu____8522) ->
                                           let field_proj_tm =
                                             let uu____8524 =
                                               let uu____8525 =
                                                 FStar_Syntax_Syntax.lid_as_fv
                                                   field_name
                                                   (FStar_Syntax_Syntax.Delta_equational_at_level
                                                      (Prims.parse_int "1"))
                                                   FStar_Pervasives_Native.None in
                                               FStar_Syntax_Syntax.fv_to_tm
                                                 uu____8525 in
                                             FStar_Syntax_Syntax.mk_Tm_uinst
                                               uu____8524 inst_univs in
                                           let proj =
                                             FStar_Syntax_Syntax.mk_Tm_app
                                               field_proj_tm [arg]
                                               FStar_Pervasives_Native.None p in
                                           FStar_Syntax_Syntax.NT (a, proj)))) in
                      let projectors_ses =
                        let uu____8551 =
                          FStar_All.pipe_right fields
                            (FStar_List.mapi
                               (fun i ->
                                  fun uu____8593 ->
                                    match uu____8593 with
                                    | (x, uu____8604) ->
                                        let p1 =
                                          FStar_Syntax_Syntax.range_of_bv x in
                                        let uu____8610 =
                                          FStar_Syntax_Util.mk_field_projector_name
                                            lid x i in
                                        (match uu____8610 with
                                         | (field_name, uu____8618) ->
                                             let t =
                                               let uu____8622 =
                                                 let uu____8623 =
                                                   let uu____8626 =
                                                     FStar_Syntax_Subst.subst
                                                       subst1
                                                       x.FStar_Syntax_Syntax.sort in
                                                   FStar_Syntax_Syntax.mk_Total
                                                     uu____8626 in
                                                 FStar_Syntax_Util.arrow
                                                   binders uu____8623 in
                                               FStar_All.pipe_left
                                                 (FStar_Syntax_Subst.close_univ_vars
                                                    uvs) uu____8622 in
                                             let only_decl =
                                               early_prims_inductive ||
                                                 (let uu____8632 =
                                                    let uu____8634 =
                                                      FStar_TypeChecker_Env.current_module
                                                        env in
                                                    uu____8634.FStar_Ident.str in
                                                  FStar_Options.dont_gen_projectors
                                                    uu____8632) in
                                             let no_decl = false in
                                             let quals q =
                                               if only_decl
                                               then
                                                 let uu____8653 =
                                                   FStar_List.filter
                                                     (fun uu___5_8657 ->
                                                        match uu___5_8657
                                                        with
                                                        | FStar_Syntax_Syntax.Abstract
                                                            -> false
                                                        | uu____8660 -> true)
                                                     q in
                                                 FStar_Syntax_Syntax.Assumption
                                                   :: uu____8653
                                               else q in
                                             let quals1 =
                                               let iquals1 =
                                                 FStar_All.pipe_right iquals
                                                   (FStar_List.filter
                                                      (fun uu___6_8675 ->
                                                         match uu___6_8675
                                                         with
                                                         | FStar_Syntax_Syntax.Inline_for_extraction
                                                             -> true
                                                         | FStar_Syntax_Syntax.NoExtract
                                                             -> true
                                                         | FStar_Syntax_Syntax.Abstract
                                                             -> true
                                                         | FStar_Syntax_Syntax.Private
                                                             -> true
                                                         | uu____8681 ->
                                                             false)) in
                                               quals
                                                 ((FStar_Syntax_Syntax.Projector
                                                     (lid,
                                                       (x.FStar_Syntax_Syntax.ppname)))
                                                 :: iquals1) in
                                             let attrs =
                                               if only_decl
                                               then []
                                               else
                                                 [FStar_Syntax_Util.attr_substitute] in
                                             let decl =
                                               let uu____8692 =
                                                 FStar_Ident.range_of_lid
                                                   field_name in
                                               {
                                                 FStar_Syntax_Syntax.sigel =
                                                   (FStar_Syntax_Syntax.Sig_declare_typ
                                                      (field_name, uvs, t));
                                                 FStar_Syntax_Syntax.sigrng =
                                                   uu____8692;
                                                 FStar_Syntax_Syntax.sigquals
                                                   = quals1;
                                                 FStar_Syntax_Syntax.sigmeta
                                                   =
                                                   FStar_Syntax_Syntax.default_sigmeta;
                                                 FStar_Syntax_Syntax.sigattrs
                                                   = attrs
                                               } in
                                             ((let uu____8694 =
                                                 FStar_TypeChecker_Env.debug
                                                   env
                                                   (FStar_Options.Other
                                                      "LogTypes") in
                                               if uu____8694
                                               then
                                                 let uu____8698 =
                                                   FStar_Syntax_Print.sigelt_to_string
                                                     decl in
                                                 FStar_Util.print1
                                                   "Declaration of a projector %s\n"
                                                   uu____8698
                                               else ());
                                              if only_decl
                                              then [decl]
                                              else
                                                (let projection =
                                                   FStar_Syntax_Syntax.gen_bv
                                                     (x.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                     FStar_Pervasives_Native.None
                                                     FStar_Syntax_Syntax.tun in
                                                 let arg_pats =
                                                   FStar_All.pipe_right
                                                     all_params
                                                     (FStar_List.mapi
                                                        (fun j ->
                                                           fun uu____8752 ->
                                                             match uu____8752
                                                             with
                                                             | (x1, imp) ->
                                                                 let b =
                                                                   FStar_Syntax_Syntax.is_implicit
                                                                    imp in
                                                                 if
                                                                   (i + ntps)
                                                                    = j
                                                                 then
                                                                   let uu____8778
                                                                    =
                                                                    pos
                                                                    (FStar_Syntax_Syntax.Pat_var
                                                                    projection) in
                                                                   (uu____8778,
                                                                    b)
                                                                 else
                                                                   if
                                                                    b &&
                                                                    (j < ntps)
                                                                   then
                                                                    (let uu____8794
                                                                    =
                                                                    let uu____8797
                                                                    =
                                                                    let uu____8798
                                                                    =
                                                                    let uu____8805
                                                                    =
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    (x1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun in
                                                                    (uu____8805,
                                                                    FStar_Syntax_Syntax.tun) in
                                                                    FStar_Syntax_Syntax.Pat_dot_term
                                                                    uu____8798 in
                                                                    pos
                                                                    uu____8797 in
                                                                    (uu____8794,
                                                                    b))
                                                                   else
                                                                    (let uu____8813
                                                                    =
                                                                    let uu____8816
                                                                    =
                                                                    let uu____8817
                                                                    =
                                                                    FStar_Syntax_Syntax.gen_bv
                                                                    (x1.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
                                                                    FStar_Pervasives_Native.None
                                                                    FStar_Syntax_Syntax.tun in
                                                                    FStar_Syntax_Syntax.Pat_wild
                                                                    uu____8817 in
                                                                    pos
                                                                    uu____8816 in
                                                                    (uu____8813,
                                                                    b)))) in
                                                 let pat =
                                                   let uu____8836 =
                                                     let uu____8839 =
                                                       let uu____8840 =
                                                         let uu____8854 =
                                                           FStar_Syntax_Syntax.lid_as_fv
                                                             lid
                                                             FStar_Syntax_Syntax.delta_constant
                                                             (FStar_Pervasives_Native.Some
                                                                fvq) in
                                                         (uu____8854,
                                                           arg_pats) in
                                                       FStar_Syntax_Syntax.Pat_cons
                                                         uu____8840 in
                                                     pos uu____8839 in
                                                   let uu____8864 =
                                                     FStar_Syntax_Syntax.bv_to_name
                                                       projection in
                                                   (uu____8836,
                                                     FStar_Pervasives_Native.None,
                                                     uu____8864) in
                                                 let body =
                                                   let uu____8880 =
                                                     let uu____8887 =
                                                       let uu____8888 =
                                                         let uu____8911 =
                                                           let uu____8928 =
                                                             FStar_Syntax_Util.branch
                                                               pat in
                                                           [uu____8928] in
                                                         (arg_exp,
                                                           uu____8911) in
                                                       FStar_Syntax_Syntax.Tm_match
                                                         uu____8888 in
                                                     FStar_Syntax_Syntax.mk
                                                       uu____8887 in
                                                   uu____8880
                                                     FStar_Pervasives_Native.None
                                                     p1 in
                                                 let imp =
                                                   FStar_Syntax_Util.abs
                                                     binders body
                                                     FStar_Pervasives_Native.None in
                                                 let dd =
                                                   let uu____8993 =
                                                     FStar_All.pipe_right
                                                       quals1
                                                       (FStar_List.contains
                                                          FStar_Syntax_Syntax.Abstract) in
                                                   if uu____8993
                                                   then
                                                     FStar_Syntax_Syntax.Delta_abstract
                                                       (FStar_Syntax_Syntax.Delta_equational_at_level
                                                          (Prims.parse_int "1"))
                                                   else
                                                     FStar_Syntax_Syntax.Delta_equational_at_level
                                                       (Prims.parse_int "1") in
                                                 let lbtyp =
                                                   if no_decl
                                                   then t
                                                   else
                                                     FStar_Syntax_Syntax.tun in
                                                 let lb =
                                                   let uu____9012 =
                                                     let uu____9017 =
                                                       FStar_Syntax_Syntax.lid_as_fv
                                                         field_name dd
                                                         FStar_Pervasives_Native.None in
                                                     FStar_Util.Inr
                                                       uu____9017 in
                                                   let uu____9018 =
                                                     FStar_Syntax_Subst.close_univ_vars
                                                       uvs imp in
                                                   {
                                                     FStar_Syntax_Syntax.lbname
                                                       = uu____9012;
                                                     FStar_Syntax_Syntax.lbunivs
                                                       = uvs;
                                                     FStar_Syntax_Syntax.lbtyp
                                                       = lbtyp;
                                                     FStar_Syntax_Syntax.lbeff
                                                       =
                                                       FStar_Parser_Const.effect_Tot_lid;
                                                     FStar_Syntax_Syntax.lbdef
                                                       = uu____9018;
                                                     FStar_Syntax_Syntax.lbattrs
                                                       = [];
                                                     FStar_Syntax_Syntax.lbpos
                                                       =
                                                       FStar_Range.dummyRange
                                                   } in
                                                 let impl =
                                                   let uu____9024 =
                                                     let uu____9025 =
                                                       let uu____9032 =
                                                         let uu____9035 =
                                                           let uu____9036 =
                                                             FStar_All.pipe_right
                                                               lb.FStar_Syntax_Syntax.lbname
                                                               FStar_Util.right in
                                                           FStar_All.pipe_right
                                                             uu____9036
                                                             (fun fv ->
                                                                (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v) in
                                                         [uu____9035] in
                                                       ((false, [lb]),
                                                         uu____9032) in
                                                     FStar_Syntax_Syntax.Sig_let
                                                       uu____9025 in
                                                   {
                                                     FStar_Syntax_Syntax.sigel
                                                       = uu____9024;
                                                     FStar_Syntax_Syntax.sigrng
                                                       = p1;
                                                     FStar_Syntax_Syntax.sigquals
                                                       = quals1;
                                                     FStar_Syntax_Syntax.sigmeta
                                                       =
                                                       FStar_Syntax_Syntax.default_sigmeta;
                                                     FStar_Syntax_Syntax.sigattrs
                                                       = attrs
                                                   } in
                                                 (let uu____9050 =
                                                    FStar_TypeChecker_Env.debug
                                                      env
                                                      (FStar_Options.Other
                                                         "LogTypes") in
                                                  if uu____9050
                                                  then
                                                    let uu____9054 =
                                                      FStar_Syntax_Print.sigelt_to_string
                                                        impl in
                                                    FStar_Util.print1
                                                      "Implementation of a projector %s\n"
                                                      uu____9054
                                                  else ());
                                                 if no_decl
                                                 then [impl]
                                                 else [decl; impl]))))) in
                        FStar_All.pipe_right uu____8551 FStar_List.flatten in
                      FStar_List.append discriminator_ses projectors_ses
let (mk_data_operations :
  FStar_Syntax_Syntax.qualifier Prims.list ->
    FStar_TypeChecker_Env.env ->
      FStar_Syntax_Syntax.sigelt Prims.list ->
        FStar_Syntax_Syntax.sigelt -> FStar_Syntax_Syntax.sigelt Prims.list)
  =
  fun iquals ->
    fun env ->
      fun tcs ->
        fun se ->
          match se.FStar_Syntax_Syntax.sigel with
          | FStar_Syntax_Syntax.Sig_datacon
              (constr_lid, uvs, t, typ_lid, n_typars, uu____9108) when
              let uu____9115 =
                FStar_Ident.lid_equals constr_lid
                  FStar_Parser_Const.lexcons_lid in
              Prims.op_Negation uu____9115 ->
              let uu____9117 = FStar_Syntax_Subst.univ_var_opening uvs in
              (match uu____9117 with
               | (univ_opening, uvs1) ->
                   let t1 = FStar_Syntax_Subst.subst univ_opening t in
                   let uu____9139 = FStar_Syntax_Util.arrow_formals t1 in
                   (match uu____9139 with
                    | (formals, uu____9157) ->
                        let uu____9178 =
                          let tps_opt =
                            FStar_Util.find_map tcs
                              (fun se1 ->
                                 let uu____9213 =
                                   let uu____9215 =
                                     let uu____9216 =
                                       FStar_Syntax_Util.lid_of_sigelt se1 in
                                     FStar_Util.must uu____9216 in
                                   FStar_Ident.lid_equals typ_lid uu____9215 in
                                 if uu____9213
                                 then
                                   match se1.FStar_Syntax_Syntax.sigel with
                                   | FStar_Syntax_Syntax.Sig_inductive_typ
                                       (uu____9238, uvs', tps, typ0,
                                        uu____9242, constrs)
                                       ->
                                       FStar_Pervasives_Native.Some
                                         (tps, typ0,
                                           ((FStar_List.length constrs) >
                                              (Prims.parse_int "1")))
                                   | uu____9262 -> failwith "Impossible"
                                 else FStar_Pervasives_Native.None) in
                          match tps_opt with
                          | FStar_Pervasives_Native.Some x -> x
                          | FStar_Pervasives_Native.None ->
                              let uu____9311 =
                                FStar_Ident.lid_equals typ_lid
                                  FStar_Parser_Const.exn_lid in
                              if uu____9311
                              then ([], FStar_Syntax_Util.ktype0, true)
                              else
                                FStar_Errors.raise_error
                                  (FStar_Errors.Fatal_UnexpectedDataConstructor,
                                    "Unexpected data constructor")
                                  se.FStar_Syntax_Syntax.sigrng in
                        (match uu____9178 with
                         | (inductive_tps, typ0, should_refine) ->
                             let inductive_tps1 =
                               FStar_Syntax_Subst.subst_binders univ_opening
                                 inductive_tps in
                             let typ01 =
                               FStar_Syntax_Subst.subst univ_opening typ0 in
                             let uu____9349 =
                               FStar_Syntax_Util.arrow_formals typ01 in
                             (match uu____9349 with
                              | (indices, uu____9367) ->
                                  let refine_domain =
                                    let uu____9390 =
                                      FStar_All.pipe_right
                                        se.FStar_Syntax_Syntax.sigquals
                                        (FStar_Util.for_some
                                           (fun uu___7_9397 ->
                                              match uu___7_9397 with
                                              | FStar_Syntax_Syntax.RecordConstructor
                                                  uu____9399 -> true
                                              | uu____9409 -> false)) in
                                    if uu____9390
                                    then false
                                    else should_refine in
                                  let fv_qual =
                                    let filter_records uu___8_9424 =
                                      match uu___8_9424 with
                                      | FStar_Syntax_Syntax.RecordConstructor
                                          (uu____9427, fns) ->
                                          FStar_Pervasives_Native.Some
                                            (FStar_Syntax_Syntax.Record_ctor
                                               (constr_lid, fns))
                                      | uu____9439 ->
                                          FStar_Pervasives_Native.None in
                                    let uu____9440 =
                                      FStar_Util.find_map
                                        se.FStar_Syntax_Syntax.sigquals
                                        filter_records in
                                    match uu____9440 with
                                    | FStar_Pervasives_Native.None ->
                                        FStar_Syntax_Syntax.Data_ctor
                                    | FStar_Pervasives_Native.Some q -> q in
                                  let iquals1 =
                                    if
                                      (FStar_List.contains
                                         FStar_Syntax_Syntax.Abstract iquals)
                                        &&
                                        (Prims.op_Negation
                                           (FStar_List.contains
                                              FStar_Syntax_Syntax.Private
                                              iquals))
                                    then FStar_Syntax_Syntax.Private ::
                                      iquals
                                    else iquals in
                                  let fields =
                                    let uu____9453 =
                                      FStar_Util.first_N n_typars formals in
                                    match uu____9453 with
                                    | (imp_tps, fields) ->
                                        let rename =
                                          FStar_List.map2
                                            (fun uu____9536 ->
                                               fun uu____9537 ->
                                                 match (uu____9536,
                                                         uu____9537)
                                                 with
                                                 | ((x, uu____9563),
                                                    (x', uu____9565)) ->
                                                     let uu____9586 =
                                                       let uu____9593 =
                                                         FStar_Syntax_Syntax.bv_to_name
                                                           x' in
                                                       (x, uu____9593) in
                                                     FStar_Syntax_Syntax.NT
                                                       uu____9586) imp_tps
                                            inductive_tps1 in
                                        FStar_Syntax_Subst.subst_binders
                                          rename fields in
                                  mk_discriminator_and_indexed_projectors
                                    iquals1 fv_qual refine_domain env typ_lid
                                    constr_lid uvs1 inductive_tps1 indices
                                    fields))))
          | uu____9598 -> []