open Prims
let rec delta_depth_to_string:
  FStar_Syntax_Syntax.delta_depth -> Prims.string =
  fun uu___112_3  ->
    match uu___112_3 with
    | FStar_Syntax_Syntax.Delta_constant  -> "Delta_constant"
    | FStar_Syntax_Syntax.Delta_defined_at_level i ->
        let uu____5 = FStar_Util.string_of_int i in
        Prims.strcat "Delta_defined_at_level " uu____5
    | FStar_Syntax_Syntax.Delta_equational  -> "Delta_equational"
    | FStar_Syntax_Syntax.Delta_abstract d ->
        let uu____7 =
          let uu____8 = delta_depth_to_string d in Prims.strcat uu____8 ")" in
        Prims.strcat "Delta_abstract (" uu____7
let sli: FStar_Ident.lident -> Prims.string =
  fun l  ->
    let uu____12 = FStar_Options.print_real_names () in
    if uu____12
    then l.FStar_Ident.str
    else (l.FStar_Ident.ident).FStar_Ident.idText
let lid_to_string: FStar_Ident.lid -> Prims.string = fun l  -> sli l
let fv_to_string: FStar_Syntax_Syntax.fv -> Prims.string =
  fun fv  ->
    lid_to_string (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
let bv_to_string: FStar_Syntax_Syntax.bv -> Prims.string =
  fun bv  ->
    let uu____23 =
      let uu____24 = FStar_Util.string_of_int bv.FStar_Syntax_Syntax.index in
      Prims.strcat "#" uu____24 in
    Prims.strcat (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText uu____23
let nm_to_string: FStar_Syntax_Syntax.bv -> Prims.string =
  fun bv  ->
    let uu____28 = FStar_Options.print_real_names () in
    if uu____28
    then bv_to_string bv
    else (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText
let db_to_string: FStar_Syntax_Syntax.bv -> Prims.string =
  fun bv  ->
    let uu____33 =
      let uu____34 = FStar_Util.string_of_int bv.FStar_Syntax_Syntax.index in
      Prims.strcat "@" uu____34 in
    Prims.strcat (bv.FStar_Syntax_Syntax.ppname).FStar_Ident.idText uu____33
let infix_prim_ops:
  (FStar_Ident.lident,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list
  =
  [(FStar_Parser_Const.op_Addition, "+");
  (FStar_Parser_Const.op_Subtraction, "-");
  (FStar_Parser_Const.op_Multiply, "*");
  (FStar_Parser_Const.op_Division, "/");
  (FStar_Parser_Const.op_Eq, "=");
  (FStar_Parser_Const.op_ColonEq, ":=");
  (FStar_Parser_Const.op_notEq, "<>");
  (FStar_Parser_Const.op_And, "&&");
  (FStar_Parser_Const.op_Or, "||");
  (FStar_Parser_Const.op_LTE, "<=");
  (FStar_Parser_Const.op_GTE, ">=");
  (FStar_Parser_Const.op_LT, "<");
  (FStar_Parser_Const.op_GT, ">");
  (FStar_Parser_Const.op_Modulus, "mod");
  (FStar_Parser_Const.and_lid, "/\\");
  (FStar_Parser_Const.or_lid, "\\/");
  (FStar_Parser_Const.imp_lid, "==>");
  (FStar_Parser_Const.iff_lid, "<==>");
  (FStar_Parser_Const.precedes_lid, "<<");
  (FStar_Parser_Const.eq2_lid, "==");
  (FStar_Parser_Const.eq3_lid, "===")]
let unary_prim_ops:
  (FStar_Ident.lident,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list
  =
  [(FStar_Parser_Const.op_Negation, "not");
  (FStar_Parser_Const.op_Minus, "-");
  (FStar_Parser_Const.not_lid, "~")]
let is_prim_op:
  FStar_Ident.lident Prims.list ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.bool
  =
  fun ps  ->
    fun f  ->
      match f.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          FStar_All.pipe_right ps
            (FStar_Util.for_some (FStar_Syntax_Syntax.fv_eq_lid fv))
      | uu____168 -> false
let get_lid:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> FStar_Ident.lident
  =
  fun f  ->
    match f.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_fvar fv ->
        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
    | uu____177 -> failwith "get_lid"
let is_infix_prim_op: FStar_Syntax_Syntax.term -> Prims.bool =
  fun e  ->
    is_prim_op
      (FStar_Pervasives_Native.fst (FStar_List.split infix_prim_ops)) e
let is_unary_prim_op: FStar_Syntax_Syntax.term -> Prims.bool =
  fun e  ->
    is_prim_op
      (FStar_Pervasives_Native.fst (FStar_List.split unary_prim_ops)) e
let quants:
  (FStar_Ident.lident,Prims.string) FStar_Pervasives_Native.tuple2 Prims.list
  =
  [(FStar_Parser_Const.forall_lid, "forall");
  (FStar_Parser_Const.exists_lid, "exists")]
type exp = FStar_Syntax_Syntax.term[@@deriving show]
let is_b2t: FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  -> is_prim_op [FStar_Parser_Const.b2t_lid] t
let is_quant: FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  ->
    is_prim_op (FStar_Pervasives_Native.fst (FStar_List.split quants)) t
let is_ite: FStar_Syntax_Syntax.typ -> Prims.bool =
  fun t  -> is_prim_op [FStar_Parser_Const.ite_lid] t
let is_lex_cons: exp -> Prims.bool =
  fun f  -> is_prim_op [FStar_Parser_Const.lexcons_lid] f
let is_lex_top: exp -> Prims.bool =
  fun f  -> is_prim_op [FStar_Parser_Const.lextop_lid] f
let is_inr:
  'Auu____232 'Auu____233 .
    ('Auu____233,'Auu____232) FStar_Util.either -> Prims.bool
  =
  fun uu___113_241  ->
    match uu___113_241 with
    | FStar_Util.Inl uu____246 -> false
    | FStar_Util.Inr uu____247 -> true
let filter_imp:
  'Auu____250 .
    ('Auu____250,FStar_Syntax_Syntax.arg_qualifier
                   FStar_Pervasives_Native.option)
      FStar_Pervasives_Native.tuple2 Prims.list ->
      ('Auu____250,FStar_Syntax_Syntax.arg_qualifier
                     FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2 Prims.list
  =
  fun a  ->
    FStar_All.pipe_right a
      (FStar_List.filter
         (fun uu___114_304  ->
            match uu___114_304 with
            | (uu____311,FStar_Pervasives_Native.Some
               (FStar_Syntax_Syntax.Implicit uu____312)) -> false
            | uu____315 -> true))
let rec reconstruct_lex:
  exp ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax Prims.list
      FStar_Pervasives_Native.option
  =
  fun e  ->
    let uu____331 =
      let uu____332 = FStar_Syntax_Subst.compress e in
      uu____332.FStar_Syntax_Syntax.n in
    match uu____331 with
    | FStar_Syntax_Syntax.Tm_app (f,args) ->
        let args1 = filter_imp args in
        let exps = FStar_List.map FStar_Pervasives_Native.fst args1 in
        let uu____395 =
          (is_lex_cons f) &&
            ((FStar_List.length exps) = (Prims.parse_int "2")) in
        if uu____395
        then
          let uu____404 =
            let uu____411 = FStar_List.nth exps (Prims.parse_int "1") in
            reconstruct_lex uu____411 in
          (match uu____404 with
           | FStar_Pervasives_Native.Some xs ->
               let uu____429 =
                 let uu____434 = FStar_List.nth exps (Prims.parse_int "0") in
                 uu____434 :: xs in
               FStar_Pervasives_Native.Some uu____429
           | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None)
        else FStar_Pervasives_Native.None
    | uu____458 ->
        let uu____459 = is_lex_top e in
        if uu____459
        then FStar_Pervasives_Native.Some []
        else FStar_Pervasives_Native.None
let rec find: 'a . ('a -> Prims.bool) -> 'a Prims.list -> 'a =
  fun f  ->
    fun l  ->
      match l with
      | [] -> failwith "blah"
      | hd1::tl1 ->
          let uu____503 = f hd1 in if uu____503 then hd1 else find f tl1
let find_lid:
  FStar_Ident.lident ->
    (FStar_Ident.lident,Prims.string) FStar_Pervasives_Native.tuple2
      Prims.list -> Prims.string
  =
  fun x  ->
    fun xs  ->
      let uu____523 =
        find
          (fun p  -> FStar_Ident.lid_equals x (FStar_Pervasives_Native.fst p))
          xs in
      FStar_Pervasives_Native.snd uu____523
let infix_prim_op_to_string:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.string =
  fun e  -> let uu____545 = get_lid e in find_lid uu____545 infix_prim_ops
let unary_prim_op_to_string:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.string =
  fun e  -> let uu____553 = get_lid e in find_lid uu____553 unary_prim_ops
let quant_to_string:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.string =
  fun t  -> let uu____561 = get_lid t in find_lid uu____561 quants
let const_to_string: FStar_Const.sconst -> Prims.string =
  fun x  -> FStar_Parser_Const.const_to_string x
let lbname_to_string: FStar_Syntax_Syntax.lbname -> Prims.string =
  fun uu___115_567  ->
    match uu___115_567 with
    | FStar_Util.Inl l -> bv_to_string l
    | FStar_Util.Inr l ->
        lid_to_string (l.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
let uvar_to_string: FStar_Syntax_Syntax.uvar -> Prims.string =
  fun u  ->
    let uu____573 = FStar_Options.hide_uvar_nums () in
    if uu____573
    then "?"
    else
      (let uu____575 =
         let uu____576 = FStar_Syntax_Unionfind.uvar_id u in
         FStar_All.pipe_right uu____576 FStar_Util.string_of_int in
       Prims.strcat "?" uu____575)
let version_to_string: FStar_Syntax_Syntax.version -> Prims.string =
  fun v1  ->
    let uu____580 = FStar_Util.string_of_int v1.FStar_Syntax_Syntax.major in
    let uu____581 = FStar_Util.string_of_int v1.FStar_Syntax_Syntax.minor in
    FStar_Util.format2 "%s.%s" uu____580 uu____581
let univ_uvar_to_string: FStar_Syntax_Syntax.universe_uvar -> Prims.string =
  fun u  ->
    let uu____585 = FStar_Options.hide_uvar_nums () in
    if uu____585
    then "?"
    else
      (let uu____587 =
         let uu____588 =
           let uu____589 = FStar_Syntax_Unionfind.univ_uvar_id u in
           FStar_All.pipe_right uu____589 FStar_Util.string_of_int in
         let uu____590 =
           let uu____591 = version_to_string (FStar_Pervasives_Native.snd u) in
           Prims.strcat ":" uu____591 in
         Prims.strcat uu____588 uu____590 in
       Prims.strcat "?" uu____587)
let rec int_of_univ:
  Prims.int ->
    FStar_Syntax_Syntax.universe ->
      (Prims.int,FStar_Syntax_Syntax.universe FStar_Pervasives_Native.option)
        FStar_Pervasives_Native.tuple2
  =
  fun n1  ->
    fun u  ->
      let uu____608 = FStar_Syntax_Subst.compress_univ u in
      match uu____608 with
      | FStar_Syntax_Syntax.U_zero  -> (n1, FStar_Pervasives_Native.None)
      | FStar_Syntax_Syntax.U_succ u1 ->
          int_of_univ (n1 + (Prims.parse_int "1")) u1
      | uu____618 -> (n1, (FStar_Pervasives_Native.Some u))
let rec univ_to_string: FStar_Syntax_Syntax.universe -> Prims.string =
  fun u  ->
    let uu____624 =
      let uu____625 = FStar_Options.ugly () in Prims.op_Negation uu____625 in
    if uu____624
    then
      let e = FStar_Syntax_Resugar.resugar_universe u FStar_Range.dummyRange in
      let d = FStar_Parser_ToDocument.term_to_document e in
      FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
        (Prims.parse_int "100") d
    else
      (let uu____629 = FStar_Syntax_Subst.compress_univ u in
       match uu____629 with
       | FStar_Syntax_Syntax.U_unif u1 -> univ_uvar_to_string u1
       | FStar_Syntax_Syntax.U_name x -> x.FStar_Ident.idText
       | FStar_Syntax_Syntax.U_bvar x ->
           let uu____641 = FStar_Util.string_of_int x in
           Prims.strcat "@" uu____641
       | FStar_Syntax_Syntax.U_zero  -> "0"
       | FStar_Syntax_Syntax.U_succ u1 ->
           let uu____643 = int_of_univ (Prims.parse_int "1") u1 in
           (match uu____643 with
            | (n1,FStar_Pervasives_Native.None ) ->
                FStar_Util.string_of_int n1
            | (n1,FStar_Pervasives_Native.Some u2) ->
                let uu____657 = univ_to_string u2 in
                let uu____658 = FStar_Util.string_of_int n1 in
                FStar_Util.format2 "(%s + %s)" uu____657 uu____658)
       | FStar_Syntax_Syntax.U_max us ->
           let uu____662 =
             let uu____663 = FStar_List.map univ_to_string us in
             FStar_All.pipe_right uu____663 (FStar_String.concat ", ") in
           FStar_Util.format1 "(max %s)" uu____662
       | FStar_Syntax_Syntax.U_unknown  -> "unknown")
let univs_to_string: FStar_Syntax_Syntax.universe Prims.list -> Prims.string
  =
  fun us  ->
    let uu____675 = FStar_List.map univ_to_string us in
    FStar_All.pipe_right uu____675 (FStar_String.concat ", ")
let univ_names_to_string: FStar_Ident.ident Prims.list -> Prims.string =
  fun us  ->
    let uu____687 = FStar_List.map (fun x  -> x.FStar_Ident.idText) us in
    FStar_All.pipe_right uu____687 (FStar_String.concat ", ")
let qual_to_string: FStar_Syntax_Syntax.qualifier -> Prims.string =
  fun uu___116_696  ->
    match uu___116_696 with
    | FStar_Syntax_Syntax.Assumption  -> "assume"
    | FStar_Syntax_Syntax.New  -> "new"
    | FStar_Syntax_Syntax.Private  -> "private"
    | FStar_Syntax_Syntax.Unfold_for_unification_and_vcgen  -> "unfold"
    | FStar_Syntax_Syntax.Inline_for_extraction  -> "inline"
    | FStar_Syntax_Syntax.NoExtract  -> "noextract"
    | FStar_Syntax_Syntax.Visible_default  -> "visible"
    | FStar_Syntax_Syntax.Irreducible  -> "irreducible"
    | FStar_Syntax_Syntax.Abstract  -> "abstract"
    | FStar_Syntax_Syntax.Noeq  -> "noeq"
    | FStar_Syntax_Syntax.Unopteq  -> "unopteq"
    | FStar_Syntax_Syntax.Logic  -> "logic"
    | FStar_Syntax_Syntax.TotalEffect  -> "total"
    | FStar_Syntax_Syntax.Discriminator l ->
        let uu____698 = lid_to_string l in
        FStar_Util.format1 "(Discriminator %s)" uu____698
    | FStar_Syntax_Syntax.Projector (l,x) ->
        let uu____701 = lid_to_string l in
        FStar_Util.format2 "(Projector %s %s)" uu____701 x.FStar_Ident.idText
    | FStar_Syntax_Syntax.RecordType (ns,fns) ->
        let uu____712 =
          let uu____713 = FStar_Ident.path_of_ns ns in
          FStar_Ident.text_of_path uu____713 in
        let uu____716 =
          let uu____717 =
            FStar_All.pipe_right fns (FStar_List.map FStar_Ident.text_of_id) in
          FStar_All.pipe_right uu____717 (FStar_String.concat ", ") in
        FStar_Util.format2 "(RecordType %s %s)" uu____712 uu____716
    | FStar_Syntax_Syntax.RecordConstructor (ns,fns) ->
        let uu____736 =
          let uu____737 = FStar_Ident.path_of_ns ns in
          FStar_Ident.text_of_path uu____737 in
        let uu____740 =
          let uu____741 =
            FStar_All.pipe_right fns (FStar_List.map FStar_Ident.text_of_id) in
          FStar_All.pipe_right uu____741 (FStar_String.concat ", ") in
        FStar_Util.format2 "(RecordConstructor %s %s)" uu____736 uu____740
    | FStar_Syntax_Syntax.Action eff_lid ->
        let uu____751 = lid_to_string eff_lid in
        FStar_Util.format1 "(Action %s)" uu____751
    | FStar_Syntax_Syntax.ExceptionConstructor  -> "ExceptionConstructor"
    | FStar_Syntax_Syntax.HasMaskedEffect  -> "HasMaskedEffect"
    | FStar_Syntax_Syntax.Effect  -> "Effect"
    | FStar_Syntax_Syntax.Reifiable  -> "reify"
    | FStar_Syntax_Syntax.Reflectable l ->
        FStar_Util.format1 "(reflect %s)" l.FStar_Ident.str
    | FStar_Syntax_Syntax.OnlyName  -> "OnlyName"
let quals_to_string: FStar_Syntax_Syntax.qualifier Prims.list -> Prims.string
  =
  fun quals  ->
    match quals with
    | [] -> ""
    | uu____760 ->
        let uu____763 =
          FStar_All.pipe_right quals (FStar_List.map qual_to_string) in
        FStar_All.pipe_right uu____763 (FStar_String.concat " ")
let quals_to_string':
  FStar_Syntax_Syntax.qualifier Prims.list -> Prims.string =
  fun quals  ->
    match quals with
    | [] -> ""
    | uu____779 ->
        let uu____782 = quals_to_string quals in Prims.strcat uu____782 " "
let rec tag_of_term: FStar_Syntax_Syntax.term -> Prims.string =
  fun t  ->
    match t.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_bvar x ->
        let uu____841 = db_to_string x in Prims.strcat "Tm_bvar: " uu____841
    | FStar_Syntax_Syntax.Tm_name x ->
        let uu____843 = nm_to_string x in Prims.strcat "Tm_name: " uu____843
    | FStar_Syntax_Syntax.Tm_fvar x ->
        let uu____845 =
          lid_to_string (x.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v in
        Prims.strcat "Tm_fvar: " uu____845
    | FStar_Syntax_Syntax.Tm_uinst uu____846 -> "Tm_uinst"
    | FStar_Syntax_Syntax.Tm_constant uu____853 -> "Tm_constant"
    | FStar_Syntax_Syntax.Tm_type uu____854 -> "Tm_type"
    | FStar_Syntax_Syntax.Tm_abs uu____855 -> "Tm_abs"
    | FStar_Syntax_Syntax.Tm_arrow uu____872 -> "Tm_arrow"
    | FStar_Syntax_Syntax.Tm_refine uu____885 -> "Tm_refine"
    | FStar_Syntax_Syntax.Tm_app uu____892 -> "Tm_app"
    | FStar_Syntax_Syntax.Tm_match uu____907 -> "Tm_match"
    | FStar_Syntax_Syntax.Tm_ascribed uu____930 -> "Tm_ascribed"
    | FStar_Syntax_Syntax.Tm_let uu____957 -> "Tm_let"
    | FStar_Syntax_Syntax.Tm_uvar uu____970 -> "Tm_uvar"
    | FStar_Syntax_Syntax.Tm_delayed (uu____987,m) ->
        let uu____1029 = FStar_ST.op_Bang m in
        (match uu____1029 with
         | FStar_Pervasives_Native.None  -> "Tm_delayed"
         | FStar_Pervasives_Native.Some uu____1104 -> "Tm_delayed-resolved")
    | FStar_Syntax_Syntax.Tm_meta (uu____1109,m) ->
        let uu____1115 = metadata_to_string m in
        Prims.strcat "Tm_meta:" uu____1115
    | FStar_Syntax_Syntax.Tm_unknown  -> "Tm_unknown"
and term_to_string: FStar_Syntax_Syntax.term -> Prims.string =
  fun x  ->
    let uu____1117 =
      let uu____1118 = FStar_Options.ugly () in Prims.op_Negation uu____1118 in
    if uu____1117
    then
      let e = FStar_Syntax_Resugar.resugar_term x in
      let d = FStar_Parser_ToDocument.term_to_document e in
      FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
        (Prims.parse_int "100") d
    else
      (let x1 = FStar_Syntax_Subst.compress x in
       let x2 =
         let uu____1124 = FStar_Options.print_implicits () in
         if uu____1124 then x1 else FStar_Syntax_Util.unmeta x1 in
       match x2.FStar_Syntax_Syntax.n with
       | FStar_Syntax_Syntax.Tm_delayed uu____1126 -> failwith "impossible"
       | FStar_Syntax_Syntax.Tm_app (uu____1151,[]) -> failwith "Empty args!"
       | FStar_Syntax_Syntax.Tm_meta (t,FStar_Syntax_Syntax.Meta_pattern ps)
           ->
           let pats =
             let uu____1187 =
               FStar_All.pipe_right ps
                 (FStar_List.map
                    (fun args  ->
                       let uu____1217 =
                         FStar_All.pipe_right args
                           (FStar_List.map
                              (fun uu____1235  ->
                                 match uu____1235 with
                                 | (t1,uu____1241) -> term_to_string t1)) in
                       FStar_All.pipe_right uu____1217
                         (FStar_String.concat "; "))) in
             FStar_All.pipe_right uu____1187 (FStar_String.concat "\\/") in
           let uu____1246 = term_to_string t in
           FStar_Util.format2 "{:pattern %s} %s" pats uu____1246
       | FStar_Syntax_Syntax.Tm_meta
           (t,FStar_Syntax_Syntax.Meta_monadic (m,t')) ->
           let uu____1258 = tag_of_term t in
           let uu____1259 = sli m in
           let uu____1260 = term_to_string t' in
           let uu____1261 = term_to_string t in
           FStar_Util.format4 "(Monadic-%s{%s %s} %s)" uu____1258 uu____1259
             uu____1260 uu____1261
       | FStar_Syntax_Syntax.Tm_meta
           (t,FStar_Syntax_Syntax.Meta_monadic_lift (m0,m1,t')) ->
           let uu____1274 = tag_of_term t in
           let uu____1275 = term_to_string t' in
           let uu____1276 = sli m0 in
           let uu____1277 = sli m1 in
           let uu____1278 = term_to_string t in
           FStar_Util.format5 "(MonadicLift-%s{%s : %s -> %s} %s)" uu____1274
             uu____1275 uu____1276 uu____1277 uu____1278
       | FStar_Syntax_Syntax.Tm_meta
           (t,FStar_Syntax_Syntax.Meta_alien (uu____1280,s,uu____1282)) ->
           FStar_Util.format1 "(Meta_alien \"%s\")" s
       | FStar_Syntax_Syntax.Tm_meta
           (t,FStar_Syntax_Syntax.Meta_labeled (l,r,b)) ->
           let uu____1299 = FStar_Range.string_of_range r in
           let uu____1300 = term_to_string t in
           FStar_Util.format3 "Meta_labeled(%s, %s){%s}" l uu____1299
             uu____1300
       | FStar_Syntax_Syntax.Tm_meta (t,FStar_Syntax_Syntax.Meta_named l) ->
           let uu____1307 = lid_to_string l in
           let uu____1308 =
             FStar_Range.string_of_range t.FStar_Syntax_Syntax.pos in
           let uu____1309 = term_to_string t in
           FStar_Util.format3 "Meta_named(%s, %s){%s}" uu____1307 uu____1308
             uu____1309
       | FStar_Syntax_Syntax.Tm_meta
           (t,FStar_Syntax_Syntax.Meta_desugared uu____1311) ->
           let uu____1316 = term_to_string t in
           FStar_Util.format1 "Meta_desugared{%s}" uu____1316
       | FStar_Syntax_Syntax.Tm_bvar x3 ->
           let uu____1318 = db_to_string x3 in
           let uu____1319 =
             let uu____1320 = tag_of_term x3.FStar_Syntax_Syntax.sort in
             Prims.strcat ":" uu____1320 in
           Prims.strcat uu____1318 uu____1319
       | FStar_Syntax_Syntax.Tm_name x3 -> nm_to_string x3
       | FStar_Syntax_Syntax.Tm_fvar f -> fv_to_string f
       | FStar_Syntax_Syntax.Tm_uvar (u,uu____1324) -> uvar_to_string u
       | FStar_Syntax_Syntax.Tm_constant c -> const_to_string c
       | FStar_Syntax_Syntax.Tm_type u ->
           let uu____1351 = FStar_Options.print_universes () in
           if uu____1351
           then
             let uu____1352 = univ_to_string u in
             FStar_Util.format1 "Type u#(%s)" uu____1352
           else "Type"
       | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
           let uu____1372 = binders_to_string " -> " bs in
           let uu____1373 = comp_to_string c in
           FStar_Util.format2 "(%s -> %s)" uu____1372 uu____1373
       | FStar_Syntax_Syntax.Tm_abs (bs,t2,lc) ->
           (match lc with
            | FStar_Pervasives_Native.Some rc when
                FStar_Options.print_implicits () ->
                let uu____1398 = binders_to_string " " bs in
                let uu____1399 = term_to_string t2 in
                let uu____1400 =
                  if FStar_Option.isNone rc.FStar_Syntax_Syntax.residual_typ
                  then "None"
                  else
                    (let uu____1404 =
                       FStar_Option.get rc.FStar_Syntax_Syntax.residual_typ in
                     term_to_string uu____1404) in
                FStar_Util.format4 "(fun %s -> (%s $$ (residual) %s %s))"
                  uu____1398 uu____1399
                  (rc.FStar_Syntax_Syntax.residual_effect).FStar_Ident.str
                  uu____1400
            | uu____1407 ->
                let uu____1410 = binders_to_string " " bs in
                let uu____1411 = term_to_string t2 in
                FStar_Util.format2 "(fun %s -> %s)" uu____1410 uu____1411)
       | FStar_Syntax_Syntax.Tm_refine (xt,f) ->
           let uu____1418 = bv_to_string xt in
           let uu____1419 =
             FStar_All.pipe_right xt.FStar_Syntax_Syntax.sort term_to_string in
           let uu____1422 = FStar_All.pipe_right f formula_to_string in
           FStar_Util.format3 "(%s:%s{%s})" uu____1418 uu____1419 uu____1422
       | FStar_Syntax_Syntax.Tm_app (t,args) ->
           let uu____1447 = term_to_string t in
           let uu____1448 = args_to_string args in
           FStar_Util.format2 "(%s %s)" uu____1447 uu____1448
       | FStar_Syntax_Syntax.Tm_let (lbs,e) ->
           let uu____1467 = lbs_to_string [] lbs in
           let uu____1468 = term_to_string e in
           FStar_Util.format2 "%s\nin\n%s" uu____1467 uu____1468
       | FStar_Syntax_Syntax.Tm_ascribed (e,(annot,topt),eff_name) ->
           let annot1 =
             match annot with
             | FStar_Util.Inl t ->
                 let uu____1529 =
                   let uu____1530 =
                     FStar_Util.map_opt eff_name FStar_Ident.text_of_lid in
                   FStar_All.pipe_right uu____1530
                     (FStar_Util.dflt "default") in
                 let uu____1535 = term_to_string t in
                 FStar_Util.format2 "[%s] %s" uu____1529 uu____1535
             | FStar_Util.Inr c -> comp_to_string c in
           let topt1 =
             match topt with
             | FStar_Pervasives_Native.None  -> ""
             | FStar_Pervasives_Native.Some t ->
                 let uu____1551 = term_to_string t in
                 FStar_Util.format1 "by %s" uu____1551 in
           let uu____1552 = term_to_string e in
           FStar_Util.format3 "(%s <ascribed: %s %s)" uu____1552 annot1 topt1
       | FStar_Syntax_Syntax.Tm_match (head1,branches) ->
           let uu____1591 = term_to_string head1 in
           let uu____1592 =
             let uu____1593 =
               FStar_All.pipe_right branches
                 (FStar_List.map
                    (fun uu____1629  ->
                       match uu____1629 with
                       | (p,wopt,e) ->
                           let uu____1645 =
                             FStar_All.pipe_right p pat_to_string in
                           let uu____1646 =
                             match wopt with
                             | FStar_Pervasives_Native.None  -> ""
                             | FStar_Pervasives_Native.Some w ->
                                 let uu____1648 =
                                   FStar_All.pipe_right w term_to_string in
                                 FStar_Util.format1 "when %s" uu____1648 in
                           let uu____1649 =
                             FStar_All.pipe_right e term_to_string in
                           FStar_Util.format3 "%s %s -> %s" uu____1645
                             uu____1646 uu____1649)) in
             FStar_Util.concat_l "\n\t|" uu____1593 in
           FStar_Util.format2 "(match %s with\n\t| %s)" uu____1591 uu____1592
       | FStar_Syntax_Syntax.Tm_uinst (t,us) ->
           let uu____1656 = FStar_Options.print_universes () in
           if uu____1656
           then
             let uu____1657 = term_to_string t in
             let uu____1658 = univs_to_string us in
             FStar_Util.format2 "%s<%s>" uu____1657 uu____1658
           else term_to_string t
       | uu____1660 -> tag_of_term x2)
and pat_to_string: FStar_Syntax_Syntax.pat -> Prims.string =
  fun x  ->
    let uu____1662 =
      let uu____1663 = FStar_Options.ugly () in Prims.op_Negation uu____1663 in
    if uu____1662
    then
      let e = FStar_Syntax_Resugar.resugar_pat x in
      let d = FStar_Parser_ToDocument.pat_to_document e in
      FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
        (Prims.parse_int "100") d
    else
      (match x.FStar_Syntax_Syntax.v with
       | FStar_Syntax_Syntax.Pat_cons (l,pats) ->
           let uu____1685 = fv_to_string l in
           let uu____1686 =
             let uu____1687 =
               FStar_List.map
                 (fun uu____1698  ->
                    match uu____1698 with
                    | (x1,b) ->
                        let p = pat_to_string x1 in
                        if b then Prims.strcat "#" p else p) pats in
             FStar_All.pipe_right uu____1687 (FStar_String.concat " ") in
           FStar_Util.format2 "(%s %s)" uu____1685 uu____1686
       | FStar_Syntax_Syntax.Pat_dot_term (x1,uu____1710) ->
           let uu____1715 = FStar_Options.print_bound_var_types () in
           if uu____1715
           then
             let uu____1716 = bv_to_string x1 in
             let uu____1717 = term_to_string x1.FStar_Syntax_Syntax.sort in
             FStar_Util.format2 ".%s:%s" uu____1716 uu____1717
           else
             (let uu____1719 = bv_to_string x1 in
              FStar_Util.format1 ".%s" uu____1719)
       | FStar_Syntax_Syntax.Pat_var x1 ->
           let uu____1721 = FStar_Options.print_bound_var_types () in
           if uu____1721
           then
             let uu____1722 = bv_to_string x1 in
             let uu____1723 = term_to_string x1.FStar_Syntax_Syntax.sort in
             FStar_Util.format2 "%s:%s" uu____1722 uu____1723
           else bv_to_string x1
       | FStar_Syntax_Syntax.Pat_constant c -> const_to_string c
       | FStar_Syntax_Syntax.Pat_wild x1 ->
           let uu____1727 = FStar_Options.print_real_names () in
           if uu____1727
           then
             let uu____1728 = bv_to_string x1 in
             Prims.strcat "Pat_wild " uu____1728
           else "_")
and lbs_to_string:
  FStar_Syntax_Syntax.qualifier Prims.list ->
    (Prims.bool,FStar_Syntax_Syntax.letbinding Prims.list)
      FStar_Pervasives_Native.tuple2 -> Prims.string
  =
  fun quals  ->
    fun lbs  ->
      let uu____1740 = quals_to_string' quals in
      let uu____1741 =
        let uu____1742 =
          FStar_All.pipe_right (FStar_Pervasives_Native.snd lbs)
            (FStar_List.map
               (fun lb  ->
                  let uu____1757 =
                    lbname_to_string lb.FStar_Syntax_Syntax.lbname in
                  let uu____1758 =
                    let uu____1759 = FStar_Options.print_universes () in
                    if uu____1759
                    then
                      let uu____1760 =
                        let uu____1761 =
                          univ_names_to_string lb.FStar_Syntax_Syntax.lbunivs in
                        Prims.strcat uu____1761 ">" in
                      Prims.strcat "<" uu____1760
                    else "" in
                  let uu____1763 =
                    term_to_string lb.FStar_Syntax_Syntax.lbtyp in
                  let uu____1764 =
                    FStar_All.pipe_right lb.FStar_Syntax_Syntax.lbdef
                      term_to_string in
                  FStar_Util.format4 "%s %s : %s = %s" uu____1757 uu____1758
                    uu____1763 uu____1764)) in
        FStar_Util.concat_l "\n and " uu____1742 in
      FStar_Util.format3 "%slet %s %s" uu____1740
        (if FStar_Pervasives_Native.fst lbs then "rec" else "") uu____1741
and lcomp_to_string: FStar_Syntax_Syntax.lcomp -> Prims.string =
  fun lc  ->
    let uu____1771 = FStar_Options.print_effect_args () in
    if uu____1771
    then
      let uu____1772 = lc.FStar_Syntax_Syntax.comp () in
      comp_to_string uu____1772
    else
      (let uu____1774 = sli lc.FStar_Syntax_Syntax.eff_name in
       let uu____1775 = term_to_string lc.FStar_Syntax_Syntax.res_typ in
       FStar_Util.format2 "%s %s" uu____1774 uu____1775)
and aqual_to_string: FStar_Syntax_Syntax.aqual -> Prims.string =
  fun uu___117_1776  ->
    match uu___117_1776 with
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit (false )) ->
        "#"
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Implicit (true )) ->
        "#."
    | FStar_Pervasives_Native.Some (FStar_Syntax_Syntax.Equality ) -> "$"
    | uu____1777 -> ""
and imp_to_string: Prims.string -> FStar_Syntax_Syntax.aqual -> Prims.string
  =
  fun s  ->
    fun aq  ->
      let uu____1780 = aqual_to_string aq in Prims.strcat uu____1780 s
and binder_to_string':
  Prims.bool -> FStar_Syntax_Syntax.binder -> Prims.string =
  fun is_arrow  ->
    fun b  ->
      let uu____1783 =
        let uu____1784 = FStar_Options.ugly () in
        Prims.op_Negation uu____1784 in
      if uu____1783
      then
        let uu____1785 =
          FStar_Syntax_Resugar.resugar_binder b FStar_Range.dummyRange in
        match uu____1785 with
        | FStar_Pervasives_Native.None  -> ""
        | FStar_Pervasives_Native.Some e ->
            let d = FStar_Parser_ToDocument.binder_to_document e in
            FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
              (Prims.parse_int "100") d
      else
        (let uu____1791 = b in
         match uu____1791 with
         | (a,imp) ->
             let uu____1794 = FStar_Syntax_Syntax.is_null_binder b in
             if uu____1794
             then
               let uu____1795 = term_to_string a.FStar_Syntax_Syntax.sort in
               Prims.strcat "_:" uu____1795
             else
               (let uu____1797 =
                  (Prims.op_Negation is_arrow) &&
                    (let uu____1799 = FStar_Options.print_bound_var_types () in
                     Prims.op_Negation uu____1799) in
                if uu____1797
                then
                  let uu____1800 = nm_to_string a in
                  imp_to_string uu____1800 imp
                else
                  (let uu____1802 =
                     let uu____1803 = nm_to_string a in
                     let uu____1804 =
                       let uu____1805 =
                         term_to_string a.FStar_Syntax_Syntax.sort in
                       Prims.strcat ":" uu____1805 in
                     Prims.strcat uu____1803 uu____1804 in
                   imp_to_string uu____1802 imp)))
and binder_to_string: FStar_Syntax_Syntax.binder -> Prims.string =
  fun b  -> binder_to_string' false b
and arrow_binder_to_string: FStar_Syntax_Syntax.binder -> Prims.string =
  fun b  -> binder_to_string' true b
and binders_to_string:
  Prims.string -> FStar_Syntax_Syntax.binders -> Prims.string =
  fun sep  ->
    fun bs  ->
      let bs1 =
        let uu____1811 = FStar_Options.print_implicits () in
        if uu____1811 then bs else filter_imp bs in
      if sep = " -> "
      then
        let uu____1813 =
          FStar_All.pipe_right bs1 (FStar_List.map arrow_binder_to_string) in
        FStar_All.pipe_right uu____1813 (FStar_String.concat sep)
      else
        (let uu____1821 =
           FStar_All.pipe_right bs1 (FStar_List.map binder_to_string) in
         FStar_All.pipe_right uu____1821 (FStar_String.concat sep))
and arg_to_string:
  (FStar_Syntax_Syntax.term,FStar_Syntax_Syntax.aqual)
    FStar_Pervasives_Native.tuple2 -> Prims.string
  =
  fun uu___118_1828  ->
    match uu___118_1828 with
    | (a,imp) ->
        let uu____1835 = term_to_string a in imp_to_string uu____1835 imp
and args_to_string: FStar_Syntax_Syntax.args -> Prims.string =
  fun args  ->
    let args1 =
      let uu____1838 = FStar_Options.print_implicits () in
      if uu____1838 then args else filter_imp args in
    let uu____1842 =
      FStar_All.pipe_right args1 (FStar_List.map arg_to_string) in
    FStar_All.pipe_right uu____1842 (FStar_String.concat " ")
and comp_to_string: FStar_Syntax_Syntax.comp -> Prims.string =
  fun c  ->
    let uu____1854 =
      let uu____1855 = FStar_Options.ugly () in Prims.op_Negation uu____1855 in
    if uu____1854
    then
      let e = FStar_Syntax_Resugar.resugar_comp c in
      let d = FStar_Parser_ToDocument.term_to_document e in
      FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
        (Prims.parse_int "100") d
    else
      (match c.FStar_Syntax_Syntax.n with
       | FStar_Syntax_Syntax.Total (t,uopt) ->
           let uu____1869 =
             let uu____1870 = FStar_Syntax_Subst.compress t in
             uu____1870.FStar_Syntax_Syntax.n in
           (match uu____1869 with
            | FStar_Syntax_Syntax.Tm_type uu____1873 when
                let uu____1874 =
                  (FStar_Options.print_implicits ()) ||
                    (FStar_Options.print_universes ()) in
                Prims.op_Negation uu____1874 -> term_to_string t
            | uu____1875 ->
                (match uopt with
                 | FStar_Pervasives_Native.Some u when
                     FStar_Options.print_universes () ->
                     let uu____1877 = univ_to_string u in
                     let uu____1878 = term_to_string t in
                     FStar_Util.format2 "Tot<%s> %s" uu____1877 uu____1878
                 | uu____1879 ->
                     let uu____1882 = term_to_string t in
                     FStar_Util.format1 "Tot %s" uu____1882))
       | FStar_Syntax_Syntax.GTotal (t,uopt) ->
           let uu____1893 =
             let uu____1894 = FStar_Syntax_Subst.compress t in
             uu____1894.FStar_Syntax_Syntax.n in
           (match uu____1893 with
            | FStar_Syntax_Syntax.Tm_type uu____1897 when
                let uu____1898 =
                  (FStar_Options.print_implicits ()) ||
                    (FStar_Options.print_universes ()) in
                Prims.op_Negation uu____1898 -> term_to_string t
            | uu____1899 ->
                (match uopt with
                 | FStar_Pervasives_Native.Some u when
                     FStar_Options.print_universes () ->
                     let uu____1901 = univ_to_string u in
                     let uu____1902 = term_to_string t in
                     FStar_Util.format2 "GTot<%s> %s" uu____1901 uu____1902
                 | uu____1903 ->
                     let uu____1906 = term_to_string t in
                     FStar_Util.format1 "GTot %s" uu____1906))
       | FStar_Syntax_Syntax.Comp c1 ->
           let basic =
             let uu____1909 = FStar_Options.print_effect_args () in
             if uu____1909
             then
               let uu____1910 = sli c1.FStar_Syntax_Syntax.effect_name in
               let uu____1911 =
                 let uu____1912 =
                   FStar_All.pipe_right c1.FStar_Syntax_Syntax.comp_univs
                     (FStar_List.map univ_to_string) in
                 FStar_All.pipe_right uu____1912 (FStar_String.concat ", ") in
               let uu____1919 =
                 term_to_string c1.FStar_Syntax_Syntax.result_typ in
               let uu____1920 =
                 let uu____1921 =
                   FStar_All.pipe_right c1.FStar_Syntax_Syntax.effect_args
                     (FStar_List.map arg_to_string) in
                 FStar_All.pipe_right uu____1921 (FStar_String.concat ", ") in
               let uu____1940 =
                 let uu____1941 =
                   FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
                     (FStar_List.map cflags_to_string) in
                 FStar_All.pipe_right uu____1941 (FStar_String.concat " ") in
               FStar_Util.format5 "%s<%s> (%s) %s (attributes %s)" uu____1910
                 uu____1911 uu____1919 uu____1920 uu____1940
             else
               (let uu____1951 =
                  (FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
                     (FStar_Util.for_some
                        (fun uu___119_1955  ->
                           match uu___119_1955 with
                           | FStar_Syntax_Syntax.TOTAL  -> true
                           | uu____1956 -> false)))
                    &&
                    (let uu____1958 = FStar_Options.print_effect_args () in
                     Prims.op_Negation uu____1958) in
                if uu____1951
                then
                  let uu____1959 =
                    term_to_string c1.FStar_Syntax_Syntax.result_typ in
                  FStar_Util.format1 "Tot %s" uu____1959
                else
                  (let uu____1961 =
                     ((let uu____1964 = FStar_Options.print_effect_args () in
                       Prims.op_Negation uu____1964) &&
                        (let uu____1966 = FStar_Options.print_implicits () in
                         Prims.op_Negation uu____1966))
                       &&
                       (FStar_Ident.lid_equals
                          c1.FStar_Syntax_Syntax.effect_name
                          FStar_Parser_Const.effect_ML_lid) in
                   if uu____1961
                   then term_to_string c1.FStar_Syntax_Syntax.result_typ
                   else
                     (let uu____1968 =
                        (let uu____1971 = FStar_Options.print_effect_args () in
                         Prims.op_Negation uu____1971) &&
                          (FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
                             (FStar_Util.for_some
                                (fun uu___120_1975  ->
                                   match uu___120_1975 with
                                   | FStar_Syntax_Syntax.MLEFFECT  -> true
                                   | uu____1976 -> false))) in
                      if uu____1968
                      then
                        let uu____1977 =
                          term_to_string c1.FStar_Syntax_Syntax.result_typ in
                        FStar_Util.format1 "ALL %s" uu____1977
                      else
                        (let uu____1979 =
                           sli c1.FStar_Syntax_Syntax.effect_name in
                         let uu____1980 =
                           term_to_string c1.FStar_Syntax_Syntax.result_typ in
                         FStar_Util.format2 "%s (%s)" uu____1979 uu____1980)))) in
           let dec =
             let uu____1982 =
               FStar_All.pipe_right c1.FStar_Syntax_Syntax.flags
                 (FStar_List.collect
                    (fun uu___121_1992  ->
                       match uu___121_1992 with
                       | FStar_Syntax_Syntax.DECREASES e ->
                           let uu____1998 =
                             let uu____1999 = term_to_string e in
                             FStar_Util.format1 " (decreases %s)" uu____1999 in
                           [uu____1998]
                       | uu____2000 -> [])) in
             FStar_All.pipe_right uu____1982 (FStar_String.concat " ") in
           FStar_Util.format2 "%s%s" basic dec)
and cflags_to_string: FStar_Syntax_Syntax.cflags -> Prims.string =
  fun c  ->
    match c with
    | FStar_Syntax_Syntax.TOTAL  -> "total"
    | FStar_Syntax_Syntax.MLEFFECT  -> "ml"
    | FStar_Syntax_Syntax.RETURN  -> "return"
    | FStar_Syntax_Syntax.PARTIAL_RETURN  -> "partial_return"
    | FStar_Syntax_Syntax.SOMETRIVIAL  -> "sometrivial"
    | FStar_Syntax_Syntax.LEMMA  -> "lemma"
    | FStar_Syntax_Syntax.CPS  -> "cps"
    | FStar_Syntax_Syntax.DECREASES uu____2004 -> ""
and formula_to_string:
  FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax -> Prims.string =
  fun phi  -> term_to_string phi
and metadata_to_string: FStar_Syntax_Syntax.metadata -> Prims.string =
  fun uu___122_2010  ->
    match uu___122_2010 with
    | FStar_Syntax_Syntax.Meta_pattern ps ->
        let pats =
          let uu____2023 =
            FStar_All.pipe_right ps
              (FStar_List.map
                 (fun args  ->
                    let uu____2053 =
                      FStar_All.pipe_right args
                        (FStar_List.map
                           (fun uu____2071  ->
                              match uu____2071 with
                              | (t,uu____2077) -> term_to_string t)) in
                    FStar_All.pipe_right uu____2053
                      (FStar_String.concat "; "))) in
          FStar_All.pipe_right uu____2023 (FStar_String.concat "\\/") in
        FStar_Util.format1 "{Meta_pattern %s}" pats
    | FStar_Syntax_Syntax.Meta_named lid ->
        let uu____2083 = sli lid in
        FStar_Util.format1 "{Meta_named %s}" uu____2083
    | FStar_Syntax_Syntax.Meta_labeled (l,r,uu____2086) ->
        let uu____2087 = FStar_Range.string_of_range r in
        FStar_Util.format2 "{Meta_labeled (%s, %s)}" l uu____2087
    | FStar_Syntax_Syntax.Meta_desugared msi -> "{Meta_desugared}"
    | FStar_Syntax_Syntax.Meta_monadic (m,t) ->
        let uu____2095 = sli m in
        let uu____2096 = term_to_string t in
        FStar_Util.format2 "{Meta_monadic(%s @ %s)}" uu____2095 uu____2096
    | FStar_Syntax_Syntax.Meta_monadic_lift (m,m',t) ->
        let uu____2104 = sli m in
        let uu____2105 = sli m' in
        let uu____2106 = term_to_string t in
        FStar_Util.format3 "{Meta_monadic_lift(%s -> %s @ %s)}" uu____2104
          uu____2105 uu____2106
    | FStar_Syntax_Syntax.Meta_alien (uu____2107,s,t) ->
        let uu____2114 = term_to_string t in
        FStar_Util.format2 "{Meta_alien (%s, %s)}" s uu____2114
let binder_to_json: FStar_Syntax_Syntax.binder -> FStar_Util.json =
  fun b  ->
    let uu____2118 = b in
    match uu____2118 with
    | (a,imp) ->
        let n1 =
          let uu____2122 = FStar_Syntax_Syntax.is_null_binder b in
          if uu____2122
          then FStar_Util.JsonNull
          else
            (let uu____2124 =
               let uu____2125 = nm_to_string a in
               imp_to_string uu____2125 imp in
             FStar_Util.JsonStr uu____2124) in
        let t =
          let uu____2127 = term_to_string a.FStar_Syntax_Syntax.sort in
          FStar_Util.JsonStr uu____2127 in
        FStar_Util.JsonAssoc [("name", n1); ("type", t)]
let binders_to_json: FStar_Syntax_Syntax.binders -> FStar_Util.json =
  fun bs  ->
    let uu____2143 = FStar_List.map binder_to_json bs in
    FStar_Util.JsonList uu____2143
let enclose_universes: Prims.string -> Prims.string =
  fun s  ->
    let uu____2149 = FStar_Options.print_universes () in
    if uu____2149 then Prims.strcat "<" (Prims.strcat s ">") else ""
let tscheme_to_string: FStar_Syntax_Syntax.tscheme -> Prims.string =
  fun s  ->
    let uu____2154 =
      let uu____2155 = FStar_Options.ugly () in Prims.op_Negation uu____2155 in
    if uu____2154
    then
      let d = FStar_Syntax_Resugar.resugar_tscheme s in
      let d1 = FStar_Parser_ToDocument.decl_to_document d in
      FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
        (Prims.parse_int "100") d1
    else
      (let uu____2159 = s in
       match uu____2159 with
       | (us,t) ->
           let uu____2166 =
             let uu____2167 = univ_names_to_string us in
             FStar_All.pipe_left enclose_universes uu____2167 in
           let uu____2168 = term_to_string t in
           FStar_Util.format2 "%s%s" uu____2166 uu____2168)
let action_to_string: FStar_Syntax_Syntax.action -> Prims.string =
  fun a  ->
    let uu____2172 = sli a.FStar_Syntax_Syntax.action_name in
    let uu____2173 =
      binders_to_string " " a.FStar_Syntax_Syntax.action_params in
    let uu____2174 =
      let uu____2175 =
        univ_names_to_string a.FStar_Syntax_Syntax.action_univs in
      FStar_All.pipe_left enclose_universes uu____2175 in
    let uu____2176 = term_to_string a.FStar_Syntax_Syntax.action_typ in
    let uu____2177 = term_to_string a.FStar_Syntax_Syntax.action_defn in
    FStar_Util.format5 "%s%s %s : %s = %s" uu____2172 uu____2173 uu____2174
      uu____2176 uu____2177
let eff_decl_to_string':
  Prims.bool ->
    FStar_Range.range ->
      FStar_Syntax_Syntax.qualifier Prims.list ->
        FStar_Syntax_Syntax.eff_decl -> Prims.string
  =
  fun for_free  ->
    fun r  ->
      fun q  ->
        fun ed  ->
          let uu____2194 =
            let uu____2195 = FStar_Options.ugly () in
            Prims.op_Negation uu____2195 in
          if uu____2194
          then
            let d = FStar_Syntax_Resugar.resugar_eff_decl for_free r q ed in
            let d1 = FStar_Parser_ToDocument.decl_to_document d in
            FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
              (Prims.parse_int "100") d1
          else
            (let actions_to_string actions =
               let uu____2207 =
                 FStar_All.pipe_right actions
                   (FStar_List.map action_to_string) in
               FStar_All.pipe_right uu____2207 (FStar_String.concat ",\n\t") in
             let uu____2216 =
               let uu____2219 =
                 let uu____2222 = lid_to_string ed.FStar_Syntax_Syntax.mname in
                 let uu____2223 =
                   let uu____2226 =
                     let uu____2227 =
                       univ_names_to_string ed.FStar_Syntax_Syntax.univs in
                     FStar_All.pipe_left enclose_universes uu____2227 in
                   let uu____2228 =
                     let uu____2231 =
                       binders_to_string " " ed.FStar_Syntax_Syntax.binders in
                     let uu____2232 =
                       let uu____2235 =
                         term_to_string ed.FStar_Syntax_Syntax.signature in
                       let uu____2236 =
                         let uu____2239 =
                           tscheme_to_string ed.FStar_Syntax_Syntax.ret_wp in
                         let uu____2240 =
                           let uu____2243 =
                             tscheme_to_string ed.FStar_Syntax_Syntax.bind_wp in
                           let uu____2244 =
                             let uu____2247 =
                               tscheme_to_string
                                 ed.FStar_Syntax_Syntax.if_then_else in
                             let uu____2248 =
                               let uu____2251 =
                                 tscheme_to_string
                                   ed.FStar_Syntax_Syntax.ite_wp in
                               let uu____2252 =
                                 let uu____2255 =
                                   tscheme_to_string
                                     ed.FStar_Syntax_Syntax.stronger in
                                 let uu____2256 =
                                   let uu____2259 =
                                     tscheme_to_string
                                       ed.FStar_Syntax_Syntax.close_wp in
                                   let uu____2260 =
                                     let uu____2263 =
                                       tscheme_to_string
                                         ed.FStar_Syntax_Syntax.assert_p in
                                     let uu____2264 =
                                       let uu____2267 =
                                         tscheme_to_string
                                           ed.FStar_Syntax_Syntax.assume_p in
                                       let uu____2268 =
                                         let uu____2271 =
                                           tscheme_to_string
                                             ed.FStar_Syntax_Syntax.null_wp in
                                         let uu____2272 =
                                           let uu____2275 =
                                             tscheme_to_string
                                               ed.FStar_Syntax_Syntax.trivial in
                                           let uu____2276 =
                                             let uu____2279 =
                                               term_to_string
                                                 ed.FStar_Syntax_Syntax.repr in
                                             let uu____2280 =
                                               let uu____2283 =
                                                 tscheme_to_string
                                                   ed.FStar_Syntax_Syntax.bind_repr in
                                               let uu____2284 =
                                                 let uu____2287 =
                                                   tscheme_to_string
                                                     ed.FStar_Syntax_Syntax.return_repr in
                                                 let uu____2288 =
                                                   let uu____2291 =
                                                     actions_to_string
                                                       ed.FStar_Syntax_Syntax.actions in
                                                   [uu____2291] in
                                                 uu____2287 :: uu____2288 in
                                               uu____2283 :: uu____2284 in
                                             uu____2279 :: uu____2280 in
                                           uu____2275 :: uu____2276 in
                                         uu____2271 :: uu____2272 in
                                       uu____2267 :: uu____2268 in
                                     uu____2263 :: uu____2264 in
                                   uu____2259 :: uu____2260 in
                                 uu____2255 :: uu____2256 in
                               uu____2251 :: uu____2252 in
                             uu____2247 :: uu____2248 in
                           uu____2243 :: uu____2244 in
                         uu____2239 :: uu____2240 in
                       uu____2235 :: uu____2236 in
                     uu____2231 :: uu____2232 in
                   uu____2226 :: uu____2228 in
                 uu____2222 :: uu____2223 in
               (if for_free then "_for_free " else "") :: uu____2219 in
             FStar_Util.format
               "new_effect%s { %s%s %s : %s \n  return_wp   = %s\n; bind_wp     = %s\n; if_then_else= %s\n; ite_wp      = %s\n; stronger    = %s\n; close_wp    = %s\n; assert_p    = %s\n; assume_p    = %s\n; null_wp     = %s\n; trivial     = %s\n; repr        = %s\n; bind_repr   = %s\n; return_repr = %s\nand effect_actions\n\t%s\n}\n"
               uu____2216)
let eff_decl_to_string:
  Prims.bool -> FStar_Syntax_Syntax.eff_decl -> Prims.string =
  fun for_free  ->
    fun ed  -> eff_decl_to_string' for_free FStar_Range.dummyRange [] ed
let rec sigelt_to_string: FStar_Syntax_Syntax.sigelt -> Prims.string =
  fun x  ->
    let uu____2302 =
      let uu____2303 = FStar_Options.ugly () in Prims.op_Negation uu____2303 in
    if uu____2302
    then
      let e = FStar_Syntax_Resugar.resugar_sigelt x in
      match e with
      | FStar_Pervasives_Native.Some d ->
          let d1 = FStar_Parser_ToDocument.decl_to_document d in
          FStar_Pprint.pretty_string (FStar_Util.float_of_string "1.0")
            (Prims.parse_int "100") d1
      | uu____2309 -> ""
    else
      (match x.FStar_Syntax_Syntax.sigel with
       | FStar_Syntax_Syntax.Sig_pragma (FStar_Syntax_Syntax.LightOff ) ->
           "#light \"off\""
       | FStar_Syntax_Syntax.Sig_pragma (FStar_Syntax_Syntax.ResetOptions
           (FStar_Pervasives_Native.None )) -> "#reset-options"
       | FStar_Syntax_Syntax.Sig_pragma (FStar_Syntax_Syntax.ResetOptions
           (FStar_Pervasives_Native.Some s)) ->
           FStar_Util.format1 "#reset-options \"%s\"" s
       | FStar_Syntax_Syntax.Sig_pragma (FStar_Syntax_Syntax.SetOptions s) ->
           FStar_Util.format1 "#set-options \"%s\"" s
       | FStar_Syntax_Syntax.Sig_inductive_typ
           (lid,univs1,tps,k,uu____2319,uu____2320) ->
           let uu____2329 = quals_to_string' x.FStar_Syntax_Syntax.sigquals in
           let uu____2330 = binders_to_string " " tps in
           let uu____2331 = term_to_string k in
           FStar_Util.format4 "%stype %s %s : %s" uu____2329
             lid.FStar_Ident.str uu____2330 uu____2331
       | FStar_Syntax_Syntax.Sig_datacon
           (lid,univs1,t,uu____2335,uu____2336,uu____2337) ->
           let uu____2342 = FStar_Options.print_universes () in
           if uu____2342
           then
             let uu____2343 = FStar_Syntax_Subst.open_univ_vars univs1 t in
             (match uu____2343 with
              | (univs2,t1) ->
                  let uu____2350 = univ_names_to_string univs2 in
                  let uu____2351 = term_to_string t1 in
                  FStar_Util.format3 "datacon<%s> %s : %s" uu____2350
                    lid.FStar_Ident.str uu____2351)
           else
             (let uu____2353 = term_to_string t in
              FStar_Util.format2 "datacon %s : %s" lid.FStar_Ident.str
                uu____2353)
       | FStar_Syntax_Syntax.Sig_declare_typ (lid,univs1,t) ->
           let uu____2357 = FStar_Syntax_Subst.open_univ_vars univs1 t in
           (match uu____2357 with
            | (univs2,t1) ->
                let uu____2364 =
                  quals_to_string' x.FStar_Syntax_Syntax.sigquals in
                let uu____2365 =
                  let uu____2366 = FStar_Options.print_universes () in
                  if uu____2366
                  then
                    let uu____2367 = univ_names_to_string univs2 in
                    FStar_Util.format1 "<%s>" uu____2367
                  else "" in
                let uu____2369 = term_to_string t1 in
                FStar_Util.format4 "%sval %s %s : %s" uu____2364
                  lid.FStar_Ident.str uu____2365 uu____2369)
       | FStar_Syntax_Syntax.Sig_assume (lid,uu____2371,f) ->
           let uu____2373 = term_to_string f in
           FStar_Util.format2 "val %s : %s" lid.FStar_Ident.str uu____2373
       | FStar_Syntax_Syntax.Sig_let (lbs,uu____2375) ->
           lbs_to_string x.FStar_Syntax_Syntax.sigquals lbs
       | FStar_Syntax_Syntax.Sig_main e ->
           let uu____2381 = term_to_string e in
           FStar_Util.format1 "let _ = %s" uu____2381
       | FStar_Syntax_Syntax.Sig_bundle (ses,uu____2383) ->
           let uu____2392 = FStar_List.map sigelt_to_string ses in
           FStar_All.pipe_right uu____2392 (FStar_String.concat "\n")
       | FStar_Syntax_Syntax.Sig_new_effect ed ->
           eff_decl_to_string' false x.FStar_Syntax_Syntax.sigrng
             x.FStar_Syntax_Syntax.sigquals ed
       | FStar_Syntax_Syntax.Sig_new_effect_for_free ed ->
           eff_decl_to_string' true x.FStar_Syntax_Syntax.sigrng
             x.FStar_Syntax_Syntax.sigquals ed
       | FStar_Syntax_Syntax.Sig_sub_effect se ->
           let lift_wp =
             match ((se.FStar_Syntax_Syntax.lift_wp),
                     (se.FStar_Syntax_Syntax.lift))
             with
             | (FStar_Pervasives_Native.None ,FStar_Pervasives_Native.None )
                 -> failwith "impossible"
             | (FStar_Pervasives_Native.Some lift_wp,uu____2410) -> lift_wp
             | (uu____2417,FStar_Pervasives_Native.Some lift) -> lift in
           let uu____2425 =
             FStar_Syntax_Subst.open_univ_vars
               (FStar_Pervasives_Native.fst lift_wp)
               (FStar_Pervasives_Native.snd lift_wp) in
           (match uu____2425 with
            | (us,t) ->
                let uu____2436 = lid_to_string se.FStar_Syntax_Syntax.source in
                let uu____2437 = lid_to_string se.FStar_Syntax_Syntax.target in
                let uu____2438 = univ_names_to_string us in
                let uu____2439 = term_to_string t in
                FStar_Util.format4 "sub_effect %s ~> %s : <%s> %s" uu____2436
                  uu____2437 uu____2438 uu____2439)
       | FStar_Syntax_Syntax.Sig_effect_abbrev (l,univs1,tps,c,flags) ->
           let uu____2449 = FStar_Options.print_universes () in
           if uu____2449
           then
             let uu____2450 =
               let uu____2455 =
                 FStar_Syntax_Syntax.mk
                   (FStar_Syntax_Syntax.Tm_arrow (tps, c))
                   FStar_Pervasives_Native.None FStar_Range.dummyRange in
               FStar_Syntax_Subst.open_univ_vars univs1 uu____2455 in
             (match uu____2450 with
              | (univs2,t) ->
                  let uu____2458 =
                    let uu____2471 =
                      let uu____2472 = FStar_Syntax_Subst.compress t in
                      uu____2472.FStar_Syntax_Syntax.n in
                    match uu____2471 with
                    | FStar_Syntax_Syntax.Tm_arrow (bs,c1) -> (bs, c1)
                    | uu____2513 -> failwith "impossible" in
                  (match uu____2458 with
                   | (tps1,c1) ->
                       let uu____2544 = sli l in
                       let uu____2545 = univ_names_to_string univs2 in
                       let uu____2546 = binders_to_string " " tps1 in
                       let uu____2547 = comp_to_string c1 in
                       FStar_Util.format4 "effect %s<%s> %s = %s" uu____2544
                         uu____2545 uu____2546 uu____2547))
           else
             (let uu____2549 = sli l in
              let uu____2550 = binders_to_string " " tps in
              let uu____2551 = comp_to_string c in
              FStar_Util.format3 "effect %s %s = %s" uu____2549 uu____2550
                uu____2551))
let format_error: FStar_Range.range -> Prims.string -> Prims.string =
  fun r  ->
    fun msg  ->
      let uu____2558 = FStar_Range.string_of_range r in
      FStar_Util.format2 "%s: %s\n" uu____2558 msg
let rec sigelt_to_string_short: FStar_Syntax_Syntax.sigelt -> Prims.string =
  fun x  ->
    match x.FStar_Syntax_Syntax.sigel with
    | FStar_Syntax_Syntax.Sig_let
        ((uu____2562,{ FStar_Syntax_Syntax.lbname = lb;
                       FStar_Syntax_Syntax.lbunivs = uu____2564;
                       FStar_Syntax_Syntax.lbtyp = t;
                       FStar_Syntax_Syntax.lbeff = uu____2566;
                       FStar_Syntax_Syntax.lbdef = uu____2567;_}::[]),uu____2568)
        ->
        let uu____2591 = lbname_to_string lb in
        let uu____2592 = term_to_string t in
        FStar_Util.format2 "let %s : %s" uu____2591 uu____2592
    | uu____2593 ->
        let uu____2594 =
          FStar_All.pipe_right (FStar_Syntax_Util.lids_of_sigelt x)
            (FStar_List.map (fun l  -> l.FStar_Ident.str)) in
        FStar_All.pipe_right uu____2594 (FStar_String.concat ", ")
let rec modul_to_string: FStar_Syntax_Syntax.modul -> Prims.string =
  fun m  ->
    let uu____2608 = sli m.FStar_Syntax_Syntax.name in
    let uu____2609 =
      let uu____2610 =
        FStar_List.map sigelt_to_string m.FStar_Syntax_Syntax.declarations in
      FStar_All.pipe_right uu____2610 (FStar_String.concat "\n") in
    FStar_Util.format2 "module %s\n%s" uu____2608 uu____2609
let subst_elt_to_string: FStar_Syntax_Syntax.subst_elt -> Prims.string =
  fun uu___123_2617  ->
    match uu___123_2617 with
    | FStar_Syntax_Syntax.DB (i,x) ->
        let uu____2620 = FStar_Util.string_of_int i in
        let uu____2621 = bv_to_string x in
        FStar_Util.format2 "DB (%s, %s)" uu____2620 uu____2621
    | FStar_Syntax_Syntax.NM (x,i) ->
        let uu____2624 = bv_to_string x in
        let uu____2625 = FStar_Util.string_of_int i in
        FStar_Util.format2 "NM (%s, %s)" uu____2624 uu____2625
    | FStar_Syntax_Syntax.NT (x,t) ->
        let uu____2632 = bv_to_string x in
        let uu____2633 = term_to_string t in
        FStar_Util.format2 "DB (%s, %s)" uu____2632 uu____2633
    | FStar_Syntax_Syntax.UN (i,u) ->
        let uu____2636 = FStar_Util.string_of_int i in
        let uu____2637 = univ_to_string u in
        FStar_Util.format2 "UN (%s, %s)" uu____2636 uu____2637
    | FStar_Syntax_Syntax.UD (u,i) ->
        let uu____2640 = FStar_Util.string_of_int i in
        FStar_Util.format2 "UD (%s, %s)" u.FStar_Ident.idText uu____2640
let subst_to_string: FStar_Syntax_Syntax.subst_t -> Prims.string =
  fun s  ->
    let uu____2644 =
      FStar_All.pipe_right s (FStar_List.map subst_elt_to_string) in
    FStar_All.pipe_right uu____2644 (FStar_String.concat "; ")
let abs_ascription_to_string:
  (FStar_Syntax_Syntax.lcomp,FStar_Ident.lident) FStar_Util.either
    FStar_Pervasives_Native.option -> Prims.string
  =
  fun ascription  ->
    let strb = FStar_Util.new_string_builder () in
    (match ascription with
     | FStar_Pervasives_Native.None  ->
         FStar_Util.string_builder_append strb "None"
     | FStar_Pervasives_Native.Some (FStar_Util.Inl lc) ->
         (FStar_Util.string_builder_append strb "Some Inr ";
          FStar_Util.string_builder_append strb
            (FStar_Ident.text_of_lid lc.FStar_Syntax_Syntax.eff_name))
     | FStar_Pervasives_Native.Some (FStar_Util.Inr lid) ->
         (FStar_Util.string_builder_append strb "Some Inr ";
          FStar_Util.string_builder_append strb (FStar_Ident.text_of_lid lid)));
    FStar_Util.string_of_string_builder strb
let list_to_string:
  'a . ('a -> Prims.string) -> 'a Prims.list -> Prims.string =
  fun f  ->
    fun elts  ->
      match elts with
      | [] -> "[]"
      | x::xs ->
          let strb = FStar_Util.new_string_builder () in
          (FStar_Util.string_builder_append strb "[";
           (let uu____2712 = f x in
            FStar_Util.string_builder_append strb uu____2712);
           FStar_List.iter
             (fun x1  ->
                FStar_Util.string_builder_append strb "; ";
                (let uu____2719 = f x1 in
                 FStar_Util.string_builder_append strb uu____2719)) xs;
           FStar_Util.string_builder_append strb "]";
           FStar_Util.string_of_string_builder strb)
let set_to_string:
  'a . ('a -> Prims.string) -> 'a FStar_Util.set -> Prims.string =
  fun f  ->
    fun s  ->
      let elts = FStar_Util.set_elements s in
      match elts with
      | [] -> "{}"
      | x::xs ->
          let strb = FStar_Util.new_string_builder () in
          (FStar_Util.string_builder_append strb "{";
           (let uu____2752 = f x in
            FStar_Util.string_builder_append strb uu____2752);
           FStar_List.iter
             (fun x1  ->
                FStar_Util.string_builder_append strb ", ";
                (let uu____2759 = f x1 in
                 FStar_Util.string_builder_append strb uu____2759)) xs;
           FStar_Util.string_builder_append strb "}";
           FStar_Util.string_of_string_builder strb)