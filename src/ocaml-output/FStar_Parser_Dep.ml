
open Prims
open FStar_Pervasives
type verify_mode =
| VerifyAll
| VerifyUserList
| VerifyFigureItOut


let uu___is_VerifyAll : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyAll -> begin
true
end
| uu____20 -> begin
false
end))


let uu___is_VerifyUserList : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyUserList -> begin
true
end
| uu____31 -> begin
false
end))


let uu___is_VerifyFigureItOut : verify_mode  ->  Prims.bool = (fun projectee -> (match (projectee) with
| VerifyFigureItOut -> begin
true
end
| uu____42 -> begin
false
end))


type files_for_module_name =
(Prims.string FStar_Pervasives_Native.option * Prims.string FStar_Pervasives_Native.option) FStar_Util.smap

type color =
| White
| Gray
| Black


let uu___is_White : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| White -> begin
true
end
| uu____65 -> begin
false
end))


let uu___is_Gray : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Gray -> begin
true
end
| uu____76 -> begin
false
end))


let uu___is_Black : color  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Black -> begin
true
end
| uu____87 -> begin
false
end))

type open_kind =
| Open_module
| Open_namespace


let uu___is_Open_module : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_module -> begin
true
end
| uu____98 -> begin
false
end))


let uu___is_Open_namespace : open_kind  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Open_namespace -> begin
true
end
| uu____109 -> begin
false
end))


let check_and_strip_suffix : Prims.string  ->  Prims.string FStar_Pervasives_Native.option = (fun f -> (

let suffixes = (".fsti")::(".fst")::(".fsi")::(".fs")::[]
in (

let matches = (FStar_List.map (fun ext -> (

let lext = (FStar_String.length ext)
in (

let l = (FStar_String.length f)
in (

let uu____157 = ((l > lext) && (

let uu____160 = (FStar_String.substring f (l - lext) lext)
in (Prims.op_Equality uu____160 ext)))
in (match (uu____157) with
| true -> begin
(

let uu____167 = (FStar_String.substring f (Prims.parse_int "0") (l - lext))
in FStar_Pervasives_Native.Some (uu____167))
end
| uu____171 -> begin
FStar_Pervasives_Native.None
end))))) suffixes)
in (

let uu____174 = (FStar_List.filter FStar_Util.is_some matches)
in (match (uu____174) with
| (FStar_Pervasives_Native.Some (m))::uu____188 -> begin
FStar_Pervasives_Native.Some (m)
end
| uu____200 -> begin
FStar_Pervasives_Native.None
end)))))


let is_interface : Prims.string  ->  Prims.bool = (fun f -> (

let uu____217 = (FStar_String.get f ((FStar_String.length f) - (Prims.parse_int "1")))
in (Prims.op_Equality uu____217 105 (*i*))))


let is_implementation : Prims.string  ->  Prims.bool = (fun f -> (

let uu____231 = (is_interface f)
in (not (uu____231))))


let list_of_option : 'Auu____238 . 'Auu____238 FStar_Pervasives_Native.option  ->  'Auu____238 Prims.list = (fun uu___0_247 -> (match (uu___0_247) with
| FStar_Pervasives_Native.Some (x) -> begin
(x)::[]
end
| FStar_Pervasives_Native.None -> begin
[]
end))


let list_of_pair : 'Auu____256 . ('Auu____256 FStar_Pervasives_Native.option * 'Auu____256 FStar_Pervasives_Native.option)  ->  'Auu____256 Prims.list = (fun uu____271 -> (match (uu____271) with
| (intf, impl) -> begin
(FStar_List.append (list_of_option intf) (list_of_option impl))
end))


let module_name_of_file : Prims.string  ->  Prims.string = (fun f -> (

let uu____299 = (

let uu____303 = (FStar_Util.basename f)
in (check_and_strip_suffix uu____303))
in (match (uu____299) with
| FStar_Pervasives_Native.Some (longname) -> begin
longname
end
| FStar_Pervasives_Native.None -> begin
(

let uu____310 = (

let uu____316 = (FStar_Util.format1 "not a valid FStar file: %s" f)
in ((FStar_Errors.Fatal_NotValidFStarFile), (uu____316)))
in (FStar_Errors.raise_err uu____310))
end)))


let lowercase_module_name : Prims.string  ->  Prims.string = (fun f -> (

let uu____330 = (module_name_of_file f)
in (FStar_String.lowercase uu____330)))


let namespace_of_module : Prims.string  ->  FStar_Ident.lident FStar_Pervasives_Native.option = (fun f -> (

let lid = (

let uu____343 = (FStar_Ident.path_of_text f)
in (FStar_Ident.lid_of_path uu____343 FStar_Range.dummyRange))
in (match (lid.FStar_Ident.ns) with
| [] -> begin
FStar_Pervasives_Native.None
end
| uu____346 -> begin
(

let uu____349 = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns)
in FStar_Pervasives_Native.Some (uu____349))
end)))


type file_name =
Prims.string


type module_name =
Prims.string

type dependence =
| UseInterface of module_name
| PreferInterface of module_name
| UseImplementation of module_name
| FriendImplementation of module_name


let uu___is_UseInterface : dependence  ->  Prims.bool = (fun projectee -> (match (projectee) with
| UseInterface (_0) -> begin
true
end
| uu____389 -> begin
false
end))


let __proj__UseInterface__item___0 : dependence  ->  module_name = (fun projectee -> (match (projectee) with
| UseInterface (_0) -> begin
_0
end))


let uu___is_PreferInterface : dependence  ->  Prims.bool = (fun projectee -> (match (projectee) with
| PreferInterface (_0) -> begin
true
end
| uu____412 -> begin
false
end))


let __proj__PreferInterface__item___0 : dependence  ->  module_name = (fun projectee -> (match (projectee) with
| PreferInterface (_0) -> begin
_0
end))


let uu___is_UseImplementation : dependence  ->  Prims.bool = (fun projectee -> (match (projectee) with
| UseImplementation (_0) -> begin
true
end
| uu____435 -> begin
false
end))


let __proj__UseImplementation__item___0 : dependence  ->  module_name = (fun projectee -> (match (projectee) with
| UseImplementation (_0) -> begin
_0
end))


let uu___is_FriendImplementation : dependence  ->  Prims.bool = (fun projectee -> (match (projectee) with
| FriendImplementation (_0) -> begin
true
end
| uu____458 -> begin
false
end))


let __proj__FriendImplementation__item___0 : dependence  ->  module_name = (fun projectee -> (match (projectee) with
| FriendImplementation (_0) -> begin
_0
end))


let dep_to_string : dependence  ->  Prims.string = (fun uu___1_476 -> (match (uu___1_476) with
| UseInterface (f) -> begin
(FStar_String.op_Hat "UseInterface " f)
end
| PreferInterface (f) -> begin
(FStar_String.op_Hat "PreferInterface " f)
end
| UseImplementation (f) -> begin
(FStar_String.op_Hat "UseImplementation " f)
end
| FriendImplementation (f) -> begin
(FStar_String.op_Hat "FriendImplementation " f)
end))


type dependences =
dependence Prims.list


let empty_dependences : 'Auu____495 . unit  ->  'Auu____495 Prims.list = (fun uu____498 -> [])

type dep_node =
{edges : dependences; color : color}


let __proj__Mkdep_node__item__edges : dep_node  ->  dependences = (fun projectee -> (match (projectee) with
| {edges = edges; color = color} -> begin
edges
end))


let __proj__Mkdep_node__item__color : dep_node  ->  color = (fun projectee -> (match (projectee) with
| {edges = edges; color = color} -> begin
color
end))

type dependence_graph =
| Deps of dep_node FStar_Util.smap


let uu___is_Deps : dependence_graph  ->  Prims.bool = (fun projectee -> true)


let __proj__Deps__item___0 : dependence_graph  ->  dep_node FStar_Util.smap = (fun projectee -> (match (projectee) with
| Deps (_0) -> begin
_0
end))

type parsing_data =
{direct_deps : dependence Prims.list; additional_roots : dependence Prims.list; has_inline_for_extraction : Prims.bool}


let __proj__Mkparsing_data__item__direct_deps : parsing_data  ->  dependence Prims.list = (fun projectee -> (match (projectee) with
| {direct_deps = direct_deps; additional_roots = additional_roots; has_inline_for_extraction = has_inline_for_extraction} -> begin
direct_deps
end))


let __proj__Mkparsing_data__item__additional_roots : parsing_data  ->  dependence Prims.list = (fun projectee -> (match (projectee) with
| {direct_deps = direct_deps; additional_roots = additional_roots; has_inline_for_extraction = has_inline_for_extraction} -> begin
additional_roots
end))


let __proj__Mkparsing_data__item__has_inline_for_extraction : parsing_data  ->  Prims.bool = (fun projectee -> (match (projectee) with
| {direct_deps = direct_deps; additional_roots = additional_roots; has_inline_for_extraction = has_inline_for_extraction} -> begin
has_inline_for_extraction
end))


let empty_parsing_data : parsing_data = {direct_deps = []; additional_roots = []; has_inline_for_extraction = false}

type deps =
{dep_graph : dependence_graph; file_system_map : files_for_module_name; cmd_line_files : file_name Prims.list; all_files : file_name Prims.list; interfaces_with_inlining : module_name Prims.list; parse_results : parsing_data FStar_Util.smap}


let __proj__Mkdeps__item__dep_graph : deps  ->  dependence_graph = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
dep_graph
end))


let __proj__Mkdeps__item__file_system_map : deps  ->  files_for_module_name = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
file_system_map
end))


let __proj__Mkdeps__item__cmd_line_files : deps  ->  file_name Prims.list = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
cmd_line_files
end))


let __proj__Mkdeps__item__all_files : deps  ->  file_name Prims.list = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
all_files
end))


let __proj__Mkdeps__item__interfaces_with_inlining : deps  ->  module_name Prims.list = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
interfaces_with_inlining
end))


let __proj__Mkdeps__item__parse_results : deps  ->  parsing_data FStar_Util.smap = (fun projectee -> (match (projectee) with
| {dep_graph = dep_graph; file_system_map = file_system_map; cmd_line_files = cmd_line_files; all_files = all_files; interfaces_with_inlining = interfaces_with_inlining; parse_results = parse_results} -> begin
parse_results
end))


let deps_try_find : dependence_graph  ->  Prims.string  ->  dep_node FStar_Pervasives_Native.option = (fun uu____840 k -> (match (uu____840) with
| Deps (m) -> begin
(FStar_Util.smap_try_find m k)
end))


let deps_add_dep : dependence_graph  ->  Prims.string  ->  dep_node  ->  unit = (fun uu____862 k v1 -> (match (uu____862) with
| Deps (m) -> begin
(FStar_Util.smap_add m k v1)
end))


let deps_keys : dependence_graph  ->  Prims.string Prims.list = (fun uu____877 -> (match (uu____877) with
| Deps (m) -> begin
(FStar_Util.smap_keys m)
end))


let deps_empty : unit  ->  dependence_graph = (fun uu____889 -> (

let uu____890 = (FStar_Util.smap_create (Prims.parse_int "41"))
in Deps (uu____890)))


let mk_deps : dependence_graph  ->  files_for_module_name  ->  file_name Prims.list  ->  file_name Prims.list  ->  module_name Prims.list  ->  parsing_data FStar_Util.smap  ->  deps = (fun dg fs c a i pr -> {dep_graph = dg; file_system_map = fs; cmd_line_files = c; all_files = a; interfaces_with_inlining = i; parse_results = pr})


let empty_deps : deps = (

let uu____948 = (deps_empty ())
in (

let uu____949 = (FStar_Util.smap_create (Prims.parse_int "0"))
in (

let uu____961 = (FStar_Util.smap_create (Prims.parse_int "0"))
in (mk_deps uu____948 uu____949 [] [] [] uu____961))))


let module_name_of_dep : dependence  ->  module_name = (fun uu___2_974 -> (match (uu___2_974) with
| UseInterface (m) -> begin
m
end
| PreferInterface (m) -> begin
m
end
| UseImplementation (m) -> begin
m
end
| FriendImplementation (m) -> begin
m
end))


let resolve_module_name : files_for_module_name  ->  module_name  ->  module_name FStar_Pervasives_Native.option = (fun file_system_map key -> (

let uu____1003 = (FStar_Util.smap_try_find file_system_map key)
in (match (uu____1003) with
| FStar_Pervasives_Native.Some (FStar_Pervasives_Native.Some (fn), uu____1030) -> begin
(

let uu____1052 = (lowercase_module_name fn)
in FStar_Pervasives_Native.Some (uu____1052))
end
| FStar_Pervasives_Native.Some (uu____1055, FStar_Pervasives_Native.Some (fn)) -> begin
(

let uu____1078 = (lowercase_module_name fn)
in FStar_Pervasives_Native.Some (uu____1078))
end
| uu____1081 -> begin
FStar_Pervasives_Native.None
end)))


let interface_of_internal : files_for_module_name  ->  module_name  ->  file_name FStar_Pervasives_Native.option = (fun file_system_map key -> (

let uu____1114 = (FStar_Util.smap_try_find file_system_map key)
in (match (uu____1114) with
| FStar_Pervasives_Native.Some (FStar_Pervasives_Native.Some (iface), uu____1141) -> begin
FStar_Pervasives_Native.Some (iface)
end
| uu____1164 -> begin
FStar_Pervasives_Native.None
end)))


let implementation_of_internal : files_for_module_name  ->  module_name  ->  file_name FStar_Pervasives_Native.option = (fun file_system_map key -> (

let uu____1197 = (FStar_Util.smap_try_find file_system_map key)
in (match (uu____1197) with
| FStar_Pervasives_Native.Some (uu____1223, FStar_Pervasives_Native.Some (impl)) -> begin
FStar_Pervasives_Native.Some (impl)
end
| uu____1247 -> begin
FStar_Pervasives_Native.None
end)))


let interface_of : deps  ->  Prims.string  ->  Prims.string FStar_Pervasives_Native.option = (fun deps key -> (interface_of_internal deps.file_system_map key))


let implementation_of : deps  ->  Prims.string  ->  Prims.string FStar_Pervasives_Native.option = (fun deps key -> (implementation_of_internal deps.file_system_map key))


let has_interface : files_for_module_name  ->  module_name  ->  Prims.bool = (fun file_system_map key -> (

let uu____1308 = (interface_of_internal file_system_map key)
in (FStar_Option.isSome uu____1308)))


let has_implementation : files_for_module_name  ->  module_name  ->  Prims.bool = (fun file_system_map key -> (

let uu____1328 = (implementation_of_internal file_system_map key)
in (FStar_Option.isSome uu____1328)))


let cache_file_name : Prims.string  ->  Prims.string = (

let checked_file_and_exists_flag = (fun fn -> (

let lax1 = (FStar_Options.lax ())
in (

let cache_fn = (match (lax1) with
| true -> begin
(FStar_String.op_Hat fn ".checked.lax")
end
| uu____1356 -> begin
(FStar_String.op_Hat fn ".checked")
end)
in (

let mname = (FStar_All.pipe_right fn module_name_of_file)
in (

let uu____1363 = (

let uu____1367 = (FStar_All.pipe_right cache_fn FStar_Util.basename)
in (FStar_Options.find_file uu____1367))
in (match (uu____1363) with
| FStar_Pervasives_Native.Some (path) -> begin
(

let expected_cache_file = (FStar_Options.prepend_cache_dir cache_fn)
in ((

let uu____1378 = (((

let uu____1382 = (FStar_Options.dep ())
in (FStar_Option.isSome uu____1382)) && (

let uu____1388 = (FStar_Options.should_be_already_cached mname)
in (not (uu____1388)))) && ((not ((FStar_Util.file_exists expected_cache_file))) || (

let uu____1391 = (FStar_Util.paths_to_same_file path expected_cache_file)
in (not (uu____1391)))))
in (match (uu____1378) with
| true -> begin
(

let uu____1394 = (

let uu____1400 = (

let uu____1402 = (FStar_Options.prepend_cache_dir cache_fn)
in (FStar_Util.format3 "Did not expected %s to be already checked, but found it in an unexpected location %s instead of %s" mname path uu____1402))
in ((FStar_Errors.Warning_UnexpectedCheckedFile), (uu____1400)))
in (FStar_Errors.log_issue FStar_Range.dummyRange uu____1394))
end
| uu____1406 -> begin
()
end));
path;
))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____1409 = (FStar_All.pipe_right mname FStar_Options.should_be_already_cached)
in (match (uu____1409) with
| true -> begin
(

let uu____1415 = (

let uu____1421 = (FStar_Util.format1 "Expected %s to be already checked but could not find it" mname)
in ((FStar_Errors.Error_AlreadyCachedAssertionFailure), (uu____1421)))
in (FStar_Errors.raise_err uu____1415))
end
| uu____1426 -> begin
(FStar_Options.prepend_cache_dir cache_fn)
end))
end))))))
in (

let memo = (FStar_Util.smap_create (Prims.parse_int "100"))
in (

let memo1 = (fun f x -> (

let uu____1457 = (FStar_Util.smap_try_find memo x)
in (match (uu____1457) with
| FStar_Pervasives_Native.Some (res) -> begin
res
end
| FStar_Pervasives_Native.None -> begin
(

let res = (f x)
in ((FStar_Util.smap_add memo x res);
res;
))
end)))
in (memo1 checked_file_and_exists_flag))))


let parsing_data_of : deps  ->  Prims.string  ->  parsing_data = (fun deps fn -> (

let uu____1484 = (FStar_Util.smap_try_find deps.parse_results fn)
in (FStar_All.pipe_right uu____1484 FStar_Util.must)))


let file_of_dep_aux : Prims.bool  ->  files_for_module_name  ->  file_name Prims.list  ->  dependence  ->  file_name = (fun use_checked_file file_system_map all_cmd_line_files d -> (

let cmd_line_has_impl = (fun key -> (FStar_All.pipe_right all_cmd_line_files (FStar_Util.for_some (fun fn -> ((is_implementation fn) && (

let uu____1538 = (lowercase_module_name fn)
in (Prims.op_Equality key uu____1538)))))))
in (

let maybe_use_cache_of = (fun f -> (match (use_checked_file) with
| true -> begin
(cache_file_name f)
end
| uu____1552 -> begin
f
end))
in (match (d) with
| UseInterface (key) -> begin
(

let uu____1557 = (interface_of_internal file_system_map key)
in (match (uu____1557) with
| FStar_Pervasives_Native.None -> begin
(

let uu____1564 = (

let uu____1570 = (FStar_Util.format1 "Expected an interface for module %s, but couldn\'t find one" key)
in ((FStar_Errors.Fatal_MissingInterface), (uu____1570)))
in (FStar_Errors.raise_err uu____1564))
end
| FStar_Pervasives_Native.Some (f) -> begin
f
end))
end
| PreferInterface (key) when (has_interface file_system_map key) -> begin
(

let uu____1580 = ((cmd_line_has_impl key) && (

let uu____1583 = (FStar_Options.dep ())
in (FStar_Option.isNone uu____1583)))
in (match (uu____1580) with
| true -> begin
(

let uu____1590 = (FStar_Options.expose_interfaces ())
in (match (uu____1590) with
| true -> begin
(

let uu____1594 = (

let uu____1596 = (implementation_of_internal file_system_map key)
in (FStar_Option.get uu____1596))
in (maybe_use_cache_of uu____1594))
end
| uu____1601 -> begin
(

let uu____1603 = (

let uu____1609 = (

let uu____1611 = (

let uu____1613 = (implementation_of_internal file_system_map key)
in (FStar_Option.get uu____1613))
in (

let uu____1618 = (

let uu____1620 = (interface_of_internal file_system_map key)
in (FStar_Option.get uu____1620))
in (FStar_Util.format3 "You may have a cyclic dependence on module %s: use --dep full to confirm. Alternatively, invoking fstar with %s on the command line breaks the abstraction imposed by its interface %s; if you really want this behavior add the option \'--expose_interfaces\'" key uu____1611 uu____1618)))
in ((FStar_Errors.Fatal_MissingExposeInterfacesOption), (uu____1609)))
in (FStar_Errors.raise_err uu____1603))
end))
end
| uu____1628 -> begin
(

let uu____1630 = (

let uu____1632 = (interface_of_internal file_system_map key)
in (FStar_Option.get uu____1632))
in (maybe_use_cache_of uu____1630))
end))
end
| PreferInterface (key) -> begin
(

let uu____1639 = (implementation_of_internal file_system_map key)
in (match (uu____1639) with
| FStar_Pervasives_Native.None -> begin
(

let uu____1645 = (

let uu____1651 = (FStar_Util.format1 "Expected an implementation of module %s, but couldn\'t find one" key)
in ((FStar_Errors.Fatal_MissingImplementation), (uu____1651)))
in (FStar_Errors.raise_err uu____1645))
end
| FStar_Pervasives_Native.Some (f) -> begin
(maybe_use_cache_of f)
end))
end
| UseImplementation (key) -> begin
(

let uu____1661 = (implementation_of_internal file_system_map key)
in (match (uu____1661) with
| FStar_Pervasives_Native.None -> begin
(

let uu____1667 = (

let uu____1673 = (FStar_Util.format1 "Expected an implementation of module %s, but couldn\'t find one" key)
in ((FStar_Errors.Fatal_MissingImplementation), (uu____1673)))
in (FStar_Errors.raise_err uu____1667))
end
| FStar_Pervasives_Native.Some (f) -> begin
(maybe_use_cache_of f)
end))
end
| FriendImplementation (key) -> begin
(

let uu____1683 = (implementation_of_internal file_system_map key)
in (match (uu____1683) with
| FStar_Pervasives_Native.None -> begin
(

let uu____1689 = (

let uu____1695 = (FStar_Util.format1 "Expected an implementation of module %s, but couldn\'t find one" key)
in ((FStar_Errors.Fatal_MissingImplementation), (uu____1695)))
in (FStar_Errors.raise_err uu____1689))
end
| FStar_Pervasives_Native.Some (f) -> begin
(maybe_use_cache_of f)
end))
end))))


let file_of_dep : files_for_module_name  ->  file_name Prims.list  ->  dependence  ->  file_name = (file_of_dep_aux false)


let dependences_of : files_for_module_name  ->  dependence_graph  ->  file_name Prims.list  ->  file_name  ->  file_name Prims.list = (fun file_system_map deps all_cmd_line_files fn -> (

let uu____1756 = (deps_try_find deps fn)
in (match (uu____1756) with
| FStar_Pervasives_Native.None -> begin
(empty_dependences ())
end
| FStar_Pervasives_Native.Some ({edges = deps1; color = uu____1764}) -> begin
(FStar_List.map (file_of_dep file_system_map all_cmd_line_files) deps1)
end)))


let print_graph : dependence_graph  ->  unit = (fun graph -> ((FStar_Util.print_endline "A DOT-format graph has been dumped in the current directory as dep.graph");
(FStar_Util.print_endline "With GraphViz installed, try: fdp -Tpng -odep.png dep.graph");
(FStar_Util.print_endline "Hint: cat dep.graph | grep -v _ | grep -v prims");
(

let uu____1778 = (

let uu____1780 = (

let uu____1782 = (

let uu____1784 = (

let uu____1788 = (

let uu____1792 = (deps_keys graph)
in (FStar_List.unique uu____1792))
in (FStar_List.collect (fun k -> (

let deps = (

let uu____1806 = (

let uu____1807 = (deps_try_find graph k)
in (FStar_Util.must uu____1807))
in uu____1806.edges)
in (

let r = (fun s -> (FStar_Util.replace_char s 46 (*.*) 95 (*_*)))
in (

let print7 = (fun dep1 -> (

let uu____1828 = (

let uu____1830 = (lowercase_module_name k)
in (r uu____1830))
in (FStar_Util.format2 "  \"%s\" -> \"%s\"" uu____1828 (r (module_name_of_dep dep1)))))
in (FStar_List.map print7 deps))))) uu____1788))
in (FStar_String.concat "\n" uu____1784))
in (FStar_String.op_Hat uu____1782 "\n}\n"))
in (FStar_String.op_Hat "digraph {\n" uu____1780))
in (FStar_Util.write_file "dep.graph" uu____1778));
))


let build_inclusion_candidates_list : unit  ->  (Prims.string * Prims.string) Prims.list = (fun uu____1851 -> (

let include_directories = (FStar_Options.include_path ())
in (

let include_directories1 = (FStar_List.map FStar_Util.normalize_file_path include_directories)
in (

let include_directories2 = (FStar_List.unique include_directories1)
in (

let cwd = (

let uu____1877 = (FStar_Util.getcwd ())
in (FStar_Util.normalize_file_path uu____1877))
in (FStar_List.concatMap (fun d -> (match ((FStar_Util.is_directory d)) with
| true -> begin
(

let files = (FStar_Util.readdir d)
in (FStar_List.filter_map (fun f -> (

let f1 = (FStar_Util.basename f)
in (

let uu____1917 = (check_and_strip_suffix f1)
in (FStar_All.pipe_right uu____1917 (FStar_Util.map_option (fun longname -> (

let full_path = (match ((Prims.op_Equality d cwd)) with
| true -> begin
f1
end
| uu____1948 -> begin
(FStar_Util.join_paths d f1)
end)
in ((longname), (full_path))))))))) files))
end
| uu____1952 -> begin
(

let uu____1954 = (

let uu____1960 = (FStar_Util.format1 "not a valid include directory: %s\n" d)
in ((FStar_Errors.Fatal_NotValidIncludeDirectory), (uu____1960)))
in (FStar_Errors.raise_err uu____1954))
end)) include_directories2))))))


let build_map : Prims.string Prims.list  ->  files_for_module_name = (fun filenames -> (

let map1 = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let add_entry = (fun key full_path -> (

let uu____2023 = (FStar_Util.smap_try_find map1 key)
in (match (uu____2023) with
| FStar_Pervasives_Native.Some (intf, impl) -> begin
(

let uu____2070 = (is_interface full_path)
in (match (uu____2070) with
| true -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.Some (full_path)), (impl)))
end
| uu____2090 -> begin
(FStar_Util.smap_add map1 key ((intf), (FStar_Pervasives_Native.Some (full_path))))
end))
end
| FStar_Pervasives_Native.None -> begin
(

let uu____2119 = (is_interface full_path)
in (match (uu____2119) with
| true -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.Some (full_path)), (FStar_Pervasives_Native.None)))
end
| uu____2140 -> begin
(FStar_Util.smap_add map1 key ((FStar_Pervasives_Native.None), (FStar_Pervasives_Native.Some (full_path))))
end))
end)))
in ((

let uu____2161 = (build_inclusion_candidates_list ())
in (FStar_List.iter (fun uu____2179 -> (match (uu____2179) with
| (longname, full_path) -> begin
(add_entry (FStar_String.lowercase longname) full_path)
end)) uu____2161));
(FStar_List.iter (fun f -> (

let uu____2198 = (lowercase_module_name f)
in (add_entry uu____2198 f))) filenames);
map1;
))))


let enter_namespace : files_for_module_name  ->  files_for_module_name  ->  Prims.string  ->  Prims.bool = (fun original_map working_map prefix1 -> (

let found = (FStar_Util.mk_ref false)
in (

let prefix2 = (FStar_String.op_Hat prefix1 ".")
in ((

let uu____2230 = (

let uu____2234 = (FStar_Util.smap_keys original_map)
in (FStar_List.unique uu____2234))
in (FStar_List.iter (fun k -> (match ((FStar_Util.starts_with k prefix2)) with
| true -> begin
(

let suffix = (FStar_String.substring k (FStar_String.length prefix2) ((FStar_String.length k) - (FStar_String.length prefix2)))
in (

let filename = (

let uu____2270 = (FStar_Util.smap_try_find original_map k)
in (FStar_Util.must uu____2270))
in ((FStar_Util.smap_add working_map suffix filename);
(FStar_ST.op_Colon_Equals found true);
)))
end
| uu____2336 -> begin
()
end)) uu____2230));
(FStar_ST.op_Bang found);
))))


let string_of_lid : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last1 -> (

let suffix = (match (last1) with
| true -> begin
(l.FStar_Ident.ident.FStar_Ident.idText)::[]
end
| uu____2383 -> begin
[]
end)
in (

let names = (

let uu____2390 = (FStar_List.map (fun x -> x.FStar_Ident.idText) l.FStar_Ident.ns)
in (FStar_List.append uu____2390 suffix))
in (FStar_String.concat "." names))))


let lowercase_join_longident : FStar_Ident.lident  ->  Prims.bool  ->  Prims.string = (fun l last1 -> (

let uu____2413 = (string_of_lid l last1)
in (FStar_String.lowercase uu____2413)))


let namespace_of_lid : FStar_Ident.lident  ->  Prims.string = (fun l -> (

let uu____2422 = (FStar_List.map FStar_Ident.text_of_id l.FStar_Ident.ns)
in (FStar_String.concat "_" uu____2422)))


let check_module_declaration_against_filename : FStar_Ident.lident  ->  Prims.string  ->  unit = (fun lid filename -> (

let k' = (lowercase_join_longident lid true)
in (

let uu____2444 = (

let uu____2446 = (

let uu____2448 = (

let uu____2450 = (

let uu____2454 = (FStar_Util.basename filename)
in (check_and_strip_suffix uu____2454))
in (FStar_Util.must uu____2450))
in (FStar_String.lowercase uu____2448))
in (Prims.op_disEquality uu____2446 k'))
in (match (uu____2444) with
| true -> begin
(

let uu____2459 = (FStar_Ident.range_of_lid lid)
in (

let uu____2460 = (

let uu____2466 = (

let uu____2468 = (string_of_lid lid true)
in (FStar_Util.format2 "The module declaration \"module %s\" found in file %s does not match its filename. Dependencies will be incorrect and the module will not be verified.\n" uu____2468 filename))
in ((FStar_Errors.Error_ModuleFileNameMismatch), (uu____2466)))
in (FStar_Errors.log_issue uu____2459 uu____2460)))
end
| uu____2473 -> begin
()
end))))

exception Exit


let uu___is_Exit : Prims.exn  ->  Prims.bool = (fun projectee -> (match (projectee) with
| Exit -> begin
true
end
| uu____2484 -> begin
false
end))


let hard_coded_dependencies : Prims.string  ->  (FStar_Ident.lident * open_kind) Prims.list = (fun full_filename -> (

let filename = (FStar_Util.basename full_filename)
in (

let corelibs = (

let uu____2506 = (FStar_Options.prims_basename ())
in (

let uu____2508 = (

let uu____2512 = (FStar_Options.pervasives_basename ())
in (

let uu____2514 = (

let uu____2518 = (FStar_Options.pervasives_native_basename ())
in (uu____2518)::[])
in (uu____2512)::uu____2514))
in (uu____2506)::uu____2508))
in (match ((FStar_List.mem filename corelibs)) with
| true -> begin
[]
end
| uu____2536 -> begin
(

let implicit_deps = (((FStar_Parser_Const.fstar_ns_lid), (Open_namespace)))::(((FStar_Parser_Const.prims_lid), (Open_module)))::(((FStar_Parser_Const.pervasives_lid), (Open_module)))::[]
in (

let uu____2561 = (

let uu____2564 = (lowercase_module_name full_filename)
in (namespace_of_module uu____2564))
in (match (uu____2561) with
| FStar_Pervasives_Native.None -> begin
implicit_deps
end
| FStar_Pervasives_Native.Some (ns) -> begin
(FStar_List.append implicit_deps ((((ns), (Open_namespace)))::[]))
end)))
end))))


let dep_subsumed_by : dependence  ->  dependence  ->  Prims.bool = (fun d d' -> (match (((d), (d'))) with
| (PreferInterface (l'), FriendImplementation (l)) -> begin
(Prims.op_Equality l l')
end
| uu____2603 -> begin
(Prims.op_Equality d d')
end))


let collect_one : files_for_module_name  ->  Prims.string  ->  (Prims.string  ->  parsing_data FStar_Pervasives_Native.option)  ->  parsing_data = (fun original_map filename get_parsing_data_from_cache -> (

let data_from_cache = (FStar_All.pipe_right filename get_parsing_data_from_cache)
in (

let uu____2643 = (FStar_All.pipe_right data_from_cache FStar_Util.is_some)
in (match (uu____2643) with
| true -> begin
((

let uu____2650 = (FStar_Options.debug_any ())
in (match (uu____2650) with
| true -> begin
(FStar_Util.print1 "Reading parsing data for %s from its checked file\n" filename)
end
| uu____2654 -> begin
()
end));
(FStar_All.pipe_right data_from_cache FStar_Util.must);
)
end
| uu____2658 -> begin
(

let deps = (FStar_Util.mk_ref [])
in (

let mo_roots = (FStar_Util.mk_ref [])
in (

let has_inline_for_extraction = (FStar_Util.mk_ref false)
in (

let set_interface_inlining = (fun uu____2685 -> (

let uu____2686 = (is_interface filename)
in (match (uu____2686) with
| true -> begin
(FStar_ST.op_Colon_Equals has_inline_for_extraction true)
end
| uu____2711 -> begin
()
end)))
in (

let add_dep = (fun deps1 d -> (

let uu____2808 = (

let uu____2810 = (

let uu____2812 = (FStar_ST.op_Bang deps1)
in (FStar_List.existsML (dep_subsumed_by d) uu____2812))
in (not (uu____2810)))
in (match (uu____2808) with
| true -> begin
(

let uu____2839 = (

let uu____2842 = (FStar_ST.op_Bang deps1)
in (d)::uu____2842)
in (FStar_ST.op_Colon_Equals deps1 uu____2839))
end
| uu____2891 -> begin
()
end)))
in (

let working_map = (FStar_Util.smap_copy original_map)
in (

let dep_edge = (fun module_name -> PreferInterface (module_name))
in (

let add_dependence_edge = (fun original_or_working_map lid -> (

let key = (lowercase_join_longident lid true)
in (

let uu____2939 = (resolve_module_name original_or_working_map key)
in (match (uu____2939) with
| FStar_Pervasives_Native.Some (module_name) -> begin
((add_dep deps (dep_edge module_name));
(

let uu____2949 = ((has_interface original_or_working_map module_name) && (has_implementation original_or_working_map module_name))
in (match (uu____2949) with
| true -> begin
(add_dep mo_roots (UseImplementation (module_name)))
end
| uu____2952 -> begin
()
end));
true;
)
end
| uu____2955 -> begin
false
end))))
in (

let record_open_module = (fun let_open lid -> (

let uu____2974 = ((let_open && (add_dependence_edge working_map lid)) || ((not (let_open)) && (add_dependence_edge original_map lid)))
in (match (uu____2974) with
| true -> begin
true
end
| uu____2979 -> begin
((match (let_open) with
| true -> begin
(

let uu____2983 = (FStar_Ident.range_of_lid lid)
in (

let uu____2984 = (

let uu____2990 = (

let uu____2992 = (string_of_lid lid true)
in (FStar_Util.format1 "Module not found: %s" uu____2992))
in ((FStar_Errors.Warning_ModuleOrFileNotFoundWarning), (uu____2990)))
in (FStar_Errors.log_issue uu____2983 uu____2984)))
end
| uu____2997 -> begin
()
end);
false;
)
end)))
in (

let record_open_namespace = (fun lid -> (

let key = (lowercase_join_longident lid true)
in (

let r = (enter_namespace original_map working_map key)
in (match ((not (r))) with
| true -> begin
(

let uu____3012 = (FStar_Ident.range_of_lid lid)
in (

let uu____3013 = (

let uu____3019 = (

let uu____3021 = (string_of_lid lid true)
in (FStar_Util.format1 "No modules in namespace %s and no file with that name either" uu____3021))
in ((FStar_Errors.Warning_ModuleOrFileNotFoundWarning), (uu____3019)))
in (FStar_Errors.log_issue uu____3012 uu____3013)))
end
| uu____3026 -> begin
()
end))))
in (

let record_open = (fun let_open lid -> (

let uu____3041 = (record_open_module let_open lid)
in (match (uu____3041) with
| true -> begin
()
end
| uu____3044 -> begin
(match ((not (let_open))) with
| true -> begin
(record_open_namespace lid)
end
| uu____3047 -> begin
()
end)
end)))
in (

let record_open_module_or_namespace = (fun uu____3058 -> (match (uu____3058) with
| (lid, kind) -> begin
(match (kind) with
| Open_namespace -> begin
(record_open_namespace lid)
end
| Open_module -> begin
(

let uu____3065 = (record_open_module false lid)
in ())
end)
end))
in (

let record_module_alias = (fun ident lid -> (

let key = (

let uu____3082 = (FStar_Ident.text_of_id ident)
in (FStar_String.lowercase uu____3082))
in (

let alias = (lowercase_join_longident lid true)
in (

let uu____3087 = (FStar_Util.smap_try_find original_map alias)
in (match (uu____3087) with
| FStar_Pervasives_Native.Some (deps_of_aliased_module) -> begin
((FStar_Util.smap_add working_map key deps_of_aliased_module);
true;
)
end
| FStar_Pervasives_Native.None -> begin
((

let uu____3155 = (FStar_Ident.range_of_lid lid)
in (

let uu____3156 = (

let uu____3162 = (FStar_Util.format1 "module not found in search path: %s\n" alias)
in ((FStar_Errors.Warning_ModuleOrFileNotFoundWarning), (uu____3162)))
in (FStar_Errors.log_issue uu____3155 uu____3156)));
false;
)
end)))))
in (

let add_dep_on_module = (fun module_name -> (

let uu____3173 = (add_dependence_edge working_map module_name)
in (match (uu____3173) with
| true -> begin
()
end
| uu____3176 -> begin
(

let uu____3178 = (FStar_Options.debug_any ())
in (match (uu____3178) with
| true -> begin
(

let uu____3181 = (FStar_Ident.range_of_lid module_name)
in (

let uu____3182 = (

let uu____3188 = (

let uu____3190 = (FStar_Ident.string_of_lid module_name)
in (FStar_Util.format1 "Unbound module reference %s" uu____3190))
in ((FStar_Errors.Warning_UnboundModuleReference), (uu____3188)))
in (FStar_Errors.log_issue uu____3181 uu____3182)))
end
| uu____3194 -> begin
()
end))
end)))
in (

let record_lid = (fun lid -> (match (lid.FStar_Ident.ns) with
| [] -> begin
()
end
| uu____3202 -> begin
(

let module_name = (FStar_Ident.lid_of_ids lid.FStar_Ident.ns)
in (add_dep_on_module module_name))
end))
in (

let auto_open = (hard_coded_dependencies filename)
in ((FStar_List.iter record_open_module_or_namespace auto_open);
(

let num_of_toplevelmods = (FStar_Util.mk_ref (Prims.parse_int "0"))
in (

let rec collect_module = (fun uu___3_3330 -> (match (uu___3_3330) with
| FStar_Parser_AST.Module (lid, decls) -> begin
((check_module_declaration_against_filename lid filename);
(match (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0"))) with
| true -> begin
(

let uu____3341 = (

let uu____3343 = (namespace_of_lid lid)
in (enter_namespace original_map working_map uu____3343))
in ())
end
| uu____3345 -> begin
()
end);
(collect_decls decls);
)
end
| FStar_Parser_AST.Interface (lid, decls, uu____3349) -> begin
((check_module_declaration_against_filename lid filename);
(match (((FStar_List.length lid.FStar_Ident.ns) > (Prims.parse_int "0"))) with
| true -> begin
(

let uu____3360 = (

let uu____3362 = (namespace_of_lid lid)
in (enter_namespace original_map working_map uu____3362))
in ())
end
| uu____3364 -> begin
()
end);
(collect_decls decls);
)
end))
and collect_decls = (fun decls -> (FStar_List.iter (fun x -> ((collect_decl x.FStar_Parser_AST.d);
(FStar_List.iter collect_term x.FStar_Parser_AST.attrs);
(match ((FStar_List.contains FStar_Parser_AST.Inline_for_extraction x.FStar_Parser_AST.quals)) with
| true -> begin
(set_interface_inlining ())
end
| uu____3376 -> begin
()
end);
)) decls))
and collect_decl = (fun d -> (match (d) with
| FStar_Parser_AST.Include (lid) -> begin
(record_open false lid)
end
| FStar_Parser_AST.Open (lid) -> begin
(record_open false lid)
end
| FStar_Parser_AST.Friend (lid) -> begin
(

let uu____3384 = (

let uu____3385 = (lowercase_join_longident lid true)
in FriendImplementation (uu____3385))
in (add_dep deps uu____3384))
end
| FStar_Parser_AST.ModuleAbbrev (ident, lid) -> begin
(

let uu____3390 = (record_module_alias ident lid)
in (match (uu____3390) with
| true -> begin
(

let uu____3393 = (

let uu____3394 = (lowercase_join_longident lid true)
in (dep_edge uu____3394))
in (add_dep deps uu____3393))
end
| uu____3397 -> begin
()
end))
end
| FStar_Parser_AST.TopLevelLet (uu____3399, patterms) -> begin
(FStar_List.iter (fun uu____3421 -> (match (uu____3421) with
| (pat, t) -> begin
((collect_pattern pat);
(collect_term t);
)
end)) patterms)
end
| FStar_Parser_AST.Main (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Splice (uu____3430, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Assume (uu____3436, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____3438; FStar_Parser_AST.mdest = uu____3439; FStar_Parser_AST.lift_op = FStar_Parser_AST.NonReifiableLift (t)}) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____3441; FStar_Parser_AST.mdest = uu____3442; FStar_Parser_AST.lift_op = FStar_Parser_AST.LiftForFree (t)}) -> begin
(collect_term t)
end
| FStar_Parser_AST.Val (uu____3444, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.SubEffect ({FStar_Parser_AST.msource = uu____3446; FStar_Parser_AST.mdest = uu____3447; FStar_Parser_AST.lift_op = FStar_Parser_AST.ReifiableLift (t0, t1)}) -> begin
((collect_term t0);
(collect_term t1);
)
end
| FStar_Parser_AST.Tycon (uu____3451, tc, ts) -> begin
((match (tc) with
| true -> begin
(record_lid FStar_Parser_Const.mk_class_lid)
end
| uu____3476 -> begin
()
end);
(

let ts1 = (FStar_List.map (fun uu____3490 -> (match (uu____3490) with
| (x, docnik) -> begin
x
end)) ts)
in (FStar_List.iter collect_tycon ts1));
)
end
| FStar_Parser_AST.Exception (uu____3503, t) -> begin
(FStar_Util.iter_opt t collect_term)
end
| FStar_Parser_AST.NewEffect (ed) -> begin
(collect_effect_decl ed)
end
| FStar_Parser_AST.Fsdoc (uu____3510) -> begin
()
end
| FStar_Parser_AST.Pragma (uu____3511) -> begin
()
end
| FStar_Parser_AST.TopLevelModule (lid) -> begin
((FStar_Util.incr num_of_toplevelmods);
(

let uu____3514 = (

let uu____3516 = (FStar_ST.op_Bang num_of_toplevelmods)
in (uu____3516 > (Prims.parse_int "1")))
in (match (uu____3514) with
| true -> begin
(

let uu____3541 = (

let uu____3547 = (

let uu____3549 = (string_of_lid lid true)
in (FStar_Util.format1 "Automatic dependency analysis demands one module per file (module %s not supported)" uu____3549))
in ((FStar_Errors.Fatal_OneModulePerFile), (uu____3547)))
in (

let uu____3554 = (FStar_Ident.range_of_lid lid)
in (FStar_Errors.raise_error uu____3541 uu____3554)))
end
| uu____3555 -> begin
()
end));
)
end))
and collect_tycon = (fun uu___4_3557 -> (match (uu___4_3557) with
| FStar_Parser_AST.TyconAbstract (uu____3558, binders, k) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
)
end
| FStar_Parser_AST.TyconAbbrev (uu____3570, binders, k, t) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(collect_term t);
)
end
| FStar_Parser_AST.TyconRecord (uu____3584, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____3630 -> (match (uu____3630) with
| (uu____3639, t, uu____3641) -> begin
(collect_term t)
end)) identterms);
)
end
| FStar_Parser_AST.TyconVariant (uu____3646, binders, k, identterms) -> begin
((collect_binders binders);
(FStar_Util.iter_opt k collect_term);
(FStar_List.iter (fun uu____3708 -> (match (uu____3708) with
| (uu____3722, t, uu____3724, uu____3725) -> begin
(FStar_Util.iter_opt t collect_term)
end)) identterms);
)
end))
and collect_effect_decl = (fun uu___5_3736 -> (match (uu___5_3736) with
| FStar_Parser_AST.DefineEffect (uu____3737, binders, t, decls) -> begin
((collect_binders binders);
(collect_term t);
(collect_decls decls);
)
end
| FStar_Parser_AST.RedefineEffect (uu____3751, binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end))
and collect_binders = (fun binders -> (FStar_List.iter collect_binder binders))
and collect_binder = (fun b -> ((collect_aqual b.FStar_Parser_AST.aqual);
(match (b) with
| {FStar_Parser_AST.b = FStar_Parser_AST.Annotated (uu____3764, t); FStar_Parser_AST.brange = uu____3766; FStar_Parser_AST.blevel = uu____3767; FStar_Parser_AST.aqual = uu____3768} -> begin
(collect_term t)
end
| {FStar_Parser_AST.b = FStar_Parser_AST.TAnnotated (uu____3771, t); FStar_Parser_AST.brange = uu____3773; FStar_Parser_AST.blevel = uu____3774; FStar_Parser_AST.aqual = uu____3775} -> begin
(collect_term t)
end
| {FStar_Parser_AST.b = FStar_Parser_AST.NoName (t); FStar_Parser_AST.brange = uu____3779; FStar_Parser_AST.blevel = uu____3780; FStar_Parser_AST.aqual = uu____3781} -> begin
(collect_term t)
end
| uu____3784 -> begin
()
end);
))
and collect_aqual = (fun uu___6_3785 -> (match (uu___6_3785) with
| FStar_Pervasives_Native.Some (FStar_Parser_AST.Meta (t)) -> begin
(collect_term t)
end
| uu____3789 -> begin
()
end))
and collect_term = (fun t -> (collect_term' t.FStar_Parser_AST.tm))
and collect_constant = (fun uu___7_3793 -> (match (uu___7_3793) with
| FStar_Const.Const_int (uu____3794, FStar_Pervasives_Native.Some (signedness, width)) -> begin
(

let u = (match (signedness) with
| FStar_Const.Unsigned -> begin
"u"
end
| FStar_Const.Signed -> begin
""
end)
in (

let w = (match (width) with
| FStar_Const.Int8 -> begin
"8"
end
| FStar_Const.Int16 -> begin
"16"
end
| FStar_Const.Int32 -> begin
"32"
end
| FStar_Const.Int64 -> begin
"64"
end)
in (

let uu____3821 = (

let uu____3822 = (FStar_Util.format2 "fstar.%sint%s" u w)
in (dep_edge uu____3822))
in (add_dep deps uu____3821))))
end
| FStar_Const.Const_char (uu____3825) -> begin
(add_dep deps (dep_edge "fstar.char"))
end
| FStar_Const.Const_float (uu____3828) -> begin
(add_dep deps (dep_edge "fstar.float"))
end
| uu____3830 -> begin
()
end))
and collect_term' = (fun uu___10_3831 -> (match (uu___10_3831) with
| FStar_Parser_AST.Wild -> begin
()
end
| FStar_Parser_AST.Const (c) -> begin
(collect_constant c)
end
| FStar_Parser_AST.Op (s, ts) -> begin
((

let uu____3840 = (

let uu____3842 = (FStar_Ident.text_of_id s)
in (Prims.op_Equality uu____3842 "@"))
in (match (uu____3840) with
| true -> begin
(

let uu____3847 = (

let uu____3848 = (

let uu____3849 = (FStar_Ident.path_of_text "FStar.List.Tot.Base.append")
in (FStar_Ident.lid_of_path uu____3849 FStar_Range.dummyRange))
in FStar_Parser_AST.Name (uu____3848))
in (collect_term' uu____3847))
end
| uu____3851 -> begin
()
end));
(FStar_List.iter collect_term ts);
)
end
| FStar_Parser_AST.Tvar (uu____3853) -> begin
()
end
| FStar_Parser_AST.Uvar (uu____3854) -> begin
()
end
| FStar_Parser_AST.Var (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Projector (lid, uu____3857) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Discrim (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Name (lid) -> begin
(record_lid lid)
end
| FStar_Parser_AST.Construct (lid, termimps) -> begin
((record_lid lid);
(FStar_List.iter (fun uu____3882 -> (match (uu____3882) with
| (t, uu____3888) -> begin
(collect_term t)
end)) termimps);
)
end
| FStar_Parser_AST.Abs (pats, t) -> begin
((collect_patterns pats);
(collect_term t);
)
end
| FStar_Parser_AST.App (t1, t2, uu____3898) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Let (uu____3900, patterms, t) -> begin
((FStar_List.iter (fun uu____3950 -> (match (uu____3950) with
| (attrs_opt, (pat, t1)) -> begin
((

let uu____3979 = (FStar_Util.map_opt attrs_opt (FStar_List.iter collect_term))
in ());
(collect_pattern pat);
(collect_term t1);
)
end)) patterms);
(collect_term t);
)
end
| FStar_Parser_AST.LetOpen (lid, t) -> begin
((record_open true lid);
(collect_term t);
)
end
| FStar_Parser_AST.Bind (uu____3989, t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Seq (t1, t2) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.If (t1, t2, t3) -> begin
((collect_term t1);
(collect_term t2);
(collect_term t3);
)
end
| FStar_Parser_AST.Match (t, bs) -> begin
((collect_term t);
(collect_branches bs);
)
end
| FStar_Parser_AST.TryWith (t, bs) -> begin
((collect_term t);
(collect_branches bs);
)
end
| FStar_Parser_AST.Ascribed (t1, t2, FStar_Pervasives_Native.None) -> begin
((collect_term t1);
(collect_term t2);
)
end
| FStar_Parser_AST.Ascribed (t1, t2, FStar_Pervasives_Native.Some (tac)) -> begin
((collect_term t1);
(collect_term t2);
(collect_term tac);
)
end
| FStar_Parser_AST.Record (t, idterms) -> begin
((FStar_Util.iter_opt t collect_term);
(FStar_List.iter (fun uu____4085 -> (match (uu____4085) with
| (uu____4090, t1) -> begin
(collect_term t1)
end)) idterms);
)
end
| FStar_Parser_AST.Project (t, uu____4093) -> begin
(collect_term t)
end
| FStar_Parser_AST.Product (binders, t) -> begin
((collect_binders binders);
(collect_term t);
)
end
| FStar_Parser_AST.Sum (binders, t) -> begin
((FStar_List.iter (fun uu___8_4122 -> (match (uu___8_4122) with
| FStar_Util.Inl (b) -> begin
(collect_binder b)
end
| FStar_Util.Inr (t1) -> begin
(collect_term t1)
end)) binders);
(collect_term t);
)
end
| FStar_Parser_AST.QForall (binders, (uu____4130, ts), t) -> begin
((collect_binders binders);
(FStar_List.iter (FStar_List.iter collect_term) ts);
(collect_term t);
)
end
| FStar_Parser_AST.QExists (binders, (uu____4164, ts), t) -> begin
((collect_binders binders);
(FStar_List.iter (FStar_List.iter collect_term) ts);
(collect_term t);
)
end
| FStar_Parser_AST.Refine (binder, t) -> begin
((collect_binder binder);
(collect_term t);
)
end
| FStar_Parser_AST.NamedTyp (uu____4200, t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Paren (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Requires (t, uu____4204) -> begin
(collect_term t)
end
| FStar_Parser_AST.Ensures (t, uu____4212) -> begin
(collect_term t)
end
| FStar_Parser_AST.Labeled (t, uu____4220, uu____4221) -> begin
(collect_term t)
end
| FStar_Parser_AST.Quote (t, uu____4227) -> begin
(collect_term t)
end
| FStar_Parser_AST.Antiquote (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.VQuote (t) -> begin
(collect_term t)
end
| FStar_Parser_AST.Attributes (cattributes) -> begin
(FStar_List.iter collect_term cattributes)
end
| FStar_Parser_AST.CalcProof (rel, init1, steps) -> begin
((

let uu____4241 = (FStar_Ident.lid_of_str "FStar.Calc")
in (add_dep_on_module uu____4241));
(collect_term rel);
(collect_term init1);
(FStar_List.iter (fun uu___9_4251 -> (match (uu___9_4251) with
| FStar_Parser_AST.CalcStep (rel1, just, next) -> begin
((collect_term rel1);
(collect_term just);
(collect_term next);
)
end)) steps);
)
end))
and collect_patterns = (fun ps -> (FStar_List.iter collect_pattern ps))
and collect_pattern = (fun p -> (collect_pattern' p.FStar_Parser_AST.pat))
and collect_pattern' = (fun uu___11_4261 -> (match (uu___11_4261) with
| FStar_Parser_AST.PatVar (uu____4262, aqual) -> begin
(collect_aqual aqual)
end
| FStar_Parser_AST.PatTvar (uu____4268, aqual) -> begin
(collect_aqual aqual)
end
| FStar_Parser_AST.PatWild (aqual) -> begin
(collect_aqual aqual)
end
| FStar_Parser_AST.PatOp (uu____4277) -> begin
()
end
| FStar_Parser_AST.PatConst (uu____4278) -> begin
()
end
| FStar_Parser_AST.PatApp (p, ps) -> begin
((collect_pattern p);
(collect_patterns ps);
)
end
| FStar_Parser_AST.PatName (uu____4286) -> begin
()
end
| FStar_Parser_AST.PatList (ps) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatOr (ps) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatTuple (ps, uu____4294) -> begin
(collect_patterns ps)
end
| FStar_Parser_AST.PatRecord (lidpats) -> begin
(FStar_List.iter (fun uu____4315 -> (match (uu____4315) with
| (uu____4320, p) -> begin
(collect_pattern p)
end)) lidpats)
end
| FStar_Parser_AST.PatAscribed (p, (t, FStar_Pervasives_Native.None)) -> begin
((collect_pattern p);
(collect_term t);
)
end
| FStar_Parser_AST.PatAscribed (p, (t, FStar_Pervasives_Native.Some (tac))) -> begin
((collect_pattern p);
(collect_term t);
(collect_term tac);
)
end))
and collect_branches = (fun bs -> (FStar_List.iter collect_branch bs))
and collect_branch = (fun uu____4365 -> (match (uu____4365) with
| (pat, t1, t2) -> begin
((collect_pattern pat);
(FStar_Util.iter_opt t1 collect_term);
(collect_term t2);
)
end))
in (

let uu____4383 = (FStar_Parser_Driver.parse_file filename)
in (match (uu____4383) with
| (ast, uu____4396) -> begin
(

let mname = (lowercase_module_name filename)
in ((

let uu____4414 = ((is_interface filename) && (has_implementation original_map mname))
in (match (uu____4414) with
| true -> begin
(add_dep mo_roots (UseImplementation (mname)))
end
| uu____4417 -> begin
()
end));
(collect_module ast);
(

let uu____4420 = (FStar_ST.op_Bang deps)
in (

let uu____4446 = (FStar_ST.op_Bang mo_roots)
in (

let uu____4472 = (FStar_ST.op_Bang has_inline_for_extraction)
in {direct_deps = uu____4420; additional_roots = uu____4446; has_inline_for_extraction = uu____4472})));
))
end))));
)))))))))))))))))
end))))


let collect_one_cache : (dependence Prims.list * dependence Prims.list * Prims.bool) FStar_Util.smap FStar_ST.ref = (

let uu____4511 = (FStar_Util.smap_create (Prims.parse_int "0"))
in (FStar_Util.mk_ref uu____4511))


let set_collect_one_cache : (dependence Prims.list * dependence Prims.list * Prims.bool) FStar_Util.smap  ->  unit = (fun cache -> (FStar_ST.op_Colon_Equals collect_one_cache cache))


let dep_graph_copy : dependence_graph  ->  dependence_graph = (fun dep_graph -> (

let uu____4633 = dep_graph
in (match (uu____4633) with
| Deps (g) -> begin
(

let uu____4637 = (FStar_Util.smap_copy g)
in Deps (uu____4637))
end)))


let topological_dependences_of : files_for_module_name  ->  dependence_graph  ->  Prims.string Prims.list  ->  file_name Prims.list  ->  Prims.bool  ->  (file_name Prims.list * Prims.bool) = (fun file_system_map dep_graph interfaces_needing_inlining root_files for_extraction -> (

let rec all_friend_deps_1 = (fun dep_graph1 cycle uu____4782 filename -> (match (uu____4782) with
| (all_friends, all_files) -> begin
(

let dep_node = (

let uu____4823 = (deps_try_find dep_graph1 filename)
in (FStar_Util.must uu____4823))
in (match (dep_node.color) with
| Gray -> begin
(failwith "Impossible: cycle detected after cycle detection has passed")
end
| Black -> begin
((all_friends), (all_files))
end
| White -> begin
((

let uu____4854 = (FStar_Options.debug_any ())
in (match (uu____4854) with
| true -> begin
(

let uu____4857 = (

let uu____4859 = (FStar_List.map dep_to_string dep_node.edges)
in (FStar_String.concat ", " uu____4859))
in (FStar_Util.print2 "Visiting %s: direct deps are %s\n" filename uu____4857))
end
| uu____4866 -> begin
()
end));
(deps_add_dep dep_graph1 filename (

let uu___846_4870 = dep_node
in {edges = uu___846_4870.edges; color = Gray}));
(

let uu____4871 = (

let uu____4882 = (dependences_of file_system_map dep_graph1 root_files filename)
in (all_friend_deps dep_graph1 cycle ((all_friends), (all_files)) uu____4882))
in (match (uu____4871) with
| (all_friends1, all_files1) -> begin
((deps_add_dep dep_graph1 filename (

let uu___852_4918 = dep_node
in {edges = uu___852_4918.edges; color = Black}));
(

let uu____4920 = (FStar_Options.debug_any ())
in (match (uu____4920) with
| true -> begin
(FStar_Util.print1 "Adding %s\n" filename)
end
| uu____4924 -> begin
()
end));
(

let uu____4926 = (

let uu____4930 = (FStar_List.collect (fun uu___12_4937 -> (match (uu___12_4937) with
| FriendImplementation (m) -> begin
(m)::[]
end
| d -> begin
[]
end)) dep_node.edges)
in (FStar_List.append uu____4930 all_friends1))
in ((uu____4926), ((filename)::all_files1)));
)
end));
)
end))
end))
and all_friend_deps = (fun dep_graph1 cycle all_friends filenames -> (FStar_List.fold_left (fun all_friends1 k -> (all_friend_deps_1 dep_graph1 ((k)::cycle) all_friends1 k)) all_friends filenames))
in ((

let uu____5003 = (FStar_Options.debug_any ())
in (match (uu____5003) with
| true -> begin
(FStar_Util.print_string "==============Phase1==================\n")
end
| uu____5007 -> begin
()
end));
(

let widened = (FStar_Util.mk_ref false)
in (

let widen_deps = (fun friends deps -> (

let uu____5032 = deps
in (match (uu____5032) with
| Deps (dg) -> begin
(

let uu____5036 = (deps_empty ())
in (match (uu____5036) with
| Deps (dg') -> begin
(

let widen_one = (fun deps1 -> (FStar_All.pipe_right deps1 (FStar_List.map (fun d -> (match (d) with
| PreferInterface (m) when ((FStar_List.contains m friends) && (has_implementation file_system_map m)) -> begin
((FStar_ST.op_Colon_Equals widened true);
FriendImplementation (m);
)
end
| uu____5086 -> begin
d
end)))))
in ((FStar_Util.smap_fold dg (fun filename dep_node uu____5094 -> (

let uu____5096 = (

let uu___887_5097 = dep_node
in (

let uu____5098 = (widen_one dep_node.edges)
in {edges = uu____5098; color = White}))
in (FStar_Util.smap_add dg' filename uu____5096))) ());
Deps (dg');
))
end))
end)))
in (

let dep_graph1 = (

let uu____5100 = ((FStar_Options.cmi ()) && for_extraction)
in (match (uu____5100) with
| true -> begin
(widen_deps interfaces_needing_inlining dep_graph)
end
| uu____5103 -> begin
dep_graph
end))
in (

let uu____5105 = (all_friend_deps dep_graph1 [] (([]), ([])) root_files)
in (match (uu____5105) with
| (friends, all_files_0) -> begin
((

let uu____5148 = (FStar_Options.debug_any ())
in (match (uu____5148) with
| true -> begin
(

let uu____5151 = (

let uu____5153 = (FStar_Util.remove_dups (fun x y -> (Prims.op_Equality x y)) friends)
in (FStar_String.concat ", " uu____5153))
in (FStar_Util.print3 "Phase1 complete:\n\tall_files = %s\n\tall_friends=%s\n\tinterfaces_with_inlining=%s\n" (FStar_String.concat ", " all_files_0) uu____5151 (FStar_String.concat ", " interfaces_needing_inlining)))
end
| uu____5169 -> begin
()
end));
(

let dep_graph2 = (widen_deps friends dep_graph1)
in (

let uu____5172 = ((

let uu____5184 = (FStar_Options.debug_any ())
in (match (uu____5184) with
| true -> begin
(FStar_Util.print_string "==============Phase2==================\n")
end
| uu____5188 -> begin
()
end));
(all_friend_deps dep_graph2 [] (([]), ([])) root_files);
)
in (match (uu____5172) with
| (uu____5207, all_files) -> begin
((

let uu____5222 = (FStar_Options.debug_any ())
in (match (uu____5222) with
| true -> begin
(FStar_Util.print1 "Phase2 complete: all_files = %s\n" (FStar_String.concat ", " all_files))
end
| uu____5227 -> begin
()
end));
(

let uu____5229 = (FStar_ST.op_Bang widened)
in ((all_files), (uu____5229)));
)
end)));
)
end)))));
)))


let collect : Prims.string Prims.list  ->  (Prims.string  ->  parsing_data FStar_Pervasives_Native.option)  ->  (Prims.string Prims.list * deps) = (fun all_cmd_line_files get_parsing_data_from_cache -> (

let all_cmd_line_files1 = (FStar_All.pipe_right all_cmd_line_files (FStar_List.map (fun fn -> (

let uu____5315 = (FStar_Options.find_file fn)
in (match (uu____5315) with
| FStar_Pervasives_Native.None -> begin
(

let uu____5321 = (

let uu____5327 = (FStar_Util.format1 "File %s could not be found\n" fn)
in ((FStar_Errors.Fatal_ModuleOrFileNotFound), (uu____5327)))
in (FStar_Errors.raise_err uu____5321))
end
| FStar_Pervasives_Native.Some (fn1) -> begin
fn1
end)))))
in (

let dep_graph = (deps_empty ())
in (

let file_system_map = (build_map all_cmd_line_files1)
in (

let interfaces_needing_inlining = (FStar_Util.mk_ref [])
in (

let add_interface_for_inlining = (fun l -> (

let l1 = (lowercase_module_name l)
in (

let uu____5357 = (

let uu____5361 = (FStar_ST.op_Bang interfaces_needing_inlining)
in (l1)::uu____5361)
in (FStar_ST.op_Colon_Equals interfaces_needing_inlining uu____5357))))
in (

let parse_results = (FStar_Util.smap_create (Prims.parse_int "40"))
in (

let rec discover_one = (fun file_name -> (

let uu____5428 = (

let uu____5430 = (deps_try_find dep_graph file_name)
in (Prims.op_Equality uu____5430 FStar_Pervasives_Native.None))
in (match (uu____5428) with
| true -> begin
(

let uu____5436 = (

let uu____5448 = (

let uu____5462 = (FStar_ST.op_Bang collect_one_cache)
in (FStar_Util.smap_try_find uu____5462 file_name))
in (match (uu____5448) with
| FStar_Pervasives_Native.Some (cached) -> begin
cached
end
| FStar_Pervasives_Native.None -> begin
(

let r = (collect_one file_system_map file_name get_parsing_data_from_cache)
in ((r.direct_deps), (r.additional_roots), (r.has_inline_for_extraction)))
end))
in (match (uu____5436) with
| (deps, mo_roots, needs_interface_inlining) -> begin
((match (needs_interface_inlining) with
| true -> begin
(add_interface_for_inlining file_name)
end
| uu____5598 -> begin
()
end);
(FStar_Util.smap_add parse_results file_name {direct_deps = deps; additional_roots = mo_roots; has_inline_for_extraction = needs_interface_inlining});
(

let deps1 = (

let module_name = (lowercase_module_name file_name)
in (

let uu____5606 = ((is_implementation file_name) && (has_interface file_system_map module_name))
in (match (uu____5606) with
| true -> begin
(FStar_List.append deps ((UseInterface (module_name))::[]))
end
| uu____5611 -> begin
deps
end)))
in (

let dep_node = (

let uu____5614 = (FStar_List.unique deps1)
in {edges = uu____5614; color = White})
in ((deps_add_dep dep_graph file_name dep_node);
(

let uu____5616 = (FStar_List.map (file_of_dep file_system_map all_cmd_line_files1) (FStar_List.append deps1 mo_roots))
in (FStar_List.iter discover_one uu____5616));
)));
)
end))
end
| uu____5622 -> begin
()
end)))
in ((FStar_Options.profile (fun uu____5626 -> (FStar_List.iter discover_one all_cmd_line_files1)) (fun uu____5629 -> "Dependence analysis: Initial scan"));
(

let cycle_detected = (fun dep_graph1 cycle filename -> ((FStar_Util.print1 "The cycle contains a subset of the modules in:\n%s \n" (FStar_String.concat "\n`used by` " cycle));
(print_graph dep_graph1);
(FStar_Util.print_string "\n");
(

let uu____5661 = (

let uu____5667 = (FStar_Util.format1 "Recursive dependency on module %s\n" filename)
in ((FStar_Errors.Fatal_CyclicDependence), (uu____5667)))
in (FStar_Errors.raise_err uu____5661));
))
in (

let full_cycle_detection = (fun all_command_line_files -> (

let dep_graph1 = (dep_graph_copy dep_graph)
in (

let rec aux = (fun cycle filename -> (

let node = (

let uu____5704 = (deps_try_find dep_graph1 filename)
in (match (uu____5704) with
| FStar_Pervasives_Native.Some (node) -> begin
node
end
| FStar_Pervasives_Native.None -> begin
(

let uu____5708 = (FStar_Util.format1 "Failed to find dependences of %s" filename)
in (failwith uu____5708))
end))
in (

let direct_deps = (FStar_All.pipe_right node.edges (FStar_List.collect (fun x -> (match (x) with
| UseInterface (f) -> begin
(

let uu____5722 = (implementation_of_internal file_system_map f)
in (match (uu____5722) with
| FStar_Pervasives_Native.None -> begin
(x)::[]
end
| FStar_Pervasives_Native.Some (fn) when (Prims.op_Equality fn filename) -> begin
(x)::[]
end
| uu____5733 -> begin
(x)::(UseImplementation (f))::[]
end))
end
| PreferInterface (f) -> begin
(

let uu____5739 = (implementation_of_internal file_system_map f)
in (match (uu____5739) with
| FStar_Pervasives_Native.None -> begin
(x)::[]
end
| FStar_Pervasives_Native.Some (fn) when (Prims.op_Equality fn filename) -> begin
(x)::[]
end
| uu____5750 -> begin
(x)::(UseImplementation (f))::[]
end))
end
| uu____5754 -> begin
(x)::[]
end))))
in (match (node.color) with
| Gray -> begin
(cycle_detected dep_graph1 cycle filename)
end
| Black -> begin
()
end
| White -> begin
((deps_add_dep dep_graph1 filename (

let uu___973_5757 = node
in {edges = direct_deps; color = Gray}));
(

let uu____5759 = (dependences_of file_system_map dep_graph1 all_command_line_files filename)
in (FStar_List.iter (fun k -> (aux ((k)::cycle) k)) uu____5759));
(deps_add_dep dep_graph1 filename (

let uu___978_5769 = node
in {edges = direct_deps; color = Black}));
)
end))))
in (FStar_List.iter (aux []) all_command_line_files))))
in ((full_cycle_detection all_cmd_line_files1);
(FStar_All.pipe_right all_cmd_line_files1 (FStar_List.iter (fun f -> (

let m = (lowercase_module_name f)
in (FStar_Options.add_verify_module m)))));
(

let inlining_ifaces = (FStar_ST.op_Bang interfaces_needing_inlining)
in (

let uu____5813 = (FStar_Options.profile (fun uu____5832 -> (

let uu____5833 = (

let uu____5835 = (FStar_Options.codegen ())
in (Prims.op_disEquality uu____5835 FStar_Pervasives_Native.None))
in (topological_dependences_of file_system_map dep_graph inlining_ifaces all_cmd_line_files1 uu____5833))) (fun uu____5841 -> "Dependence analysis: topological sort for full file list"))
in (match (uu____5813) with
| (all_files, uu____5859) -> begin
((

let uu____5869 = (FStar_Options.debug_any ())
in (match (uu____5869) with
| true -> begin
(FStar_Util.print1 "Interfaces needing inlining: %s\n" (FStar_String.concat ", " inlining_ifaces))
end
| uu____5874 -> begin
()
end));
((all_files), ((mk_deps dep_graph file_system_map all_cmd_line_files1 all_files inlining_ifaces parse_results)));
)
end)));
)));
)))))))))


let deps_of : deps  ->  Prims.string  ->  Prims.string Prims.list = (fun deps f -> (dependences_of deps.file_system_map deps.dep_graph deps.cmd_line_files f))


let print_digest : (Prims.string * Prims.string) Prims.list  ->  Prims.string = (fun dig -> (

let uu____5922 = (FStar_All.pipe_right dig (FStar_List.map (fun uu____5948 -> (match (uu____5948) with
| (m, d) -> begin
(

let uu____5962 = (FStar_Util.base64_encode d)
in (FStar_Util.format2 "%s:%s" m uu____5962))
end))))
in (FStar_All.pipe_right uu____5922 (FStar_String.concat "\n"))))


let print_make : deps  ->  unit = (fun deps -> (

let file_system_map = deps.file_system_map
in (

let all_cmd_line_files = deps.cmd_line_files
in (

let deps1 = deps.dep_graph
in (

let keys = (deps_keys deps1)
in (FStar_All.pipe_right keys (FStar_List.iter (fun f -> (

let dep_node = (

let uu____5997 = (deps_try_find deps1 f)
in (FStar_All.pipe_right uu____5997 FStar_Option.get))
in (

let files = (FStar_List.map (file_of_dep file_system_map all_cmd_line_files) dep_node.edges)
in (

let files1 = (FStar_List.map (fun s -> (FStar_Util.replace_chars s 32 (* *) "\\ ")) files)
in (FStar_Util.print2 "%s: %s\n\n" f (FStar_String.concat " " files1)))))))))))))


let print_raw : deps  ->  unit = (fun deps -> (

let uu____6026 = deps.dep_graph
in (match (uu____6026) with
| Deps (deps1) -> begin
(

let uu____6030 = (

let uu____6032 = (FStar_Util.smap_fold deps1 (fun k dep_node out -> (

let uu____6050 = (

let uu____6052 = (

let uu____6054 = (FStar_List.map dep_to_string dep_node.edges)
in (FStar_All.pipe_right uu____6054 (FStar_String.concat ";\n\t")))
in (FStar_Util.format2 "%s -> [\n\t%s\n] " k uu____6052))
in (uu____6050)::out)) [])
in (FStar_All.pipe_right uu____6032 (FStar_String.concat ";;\n")))
in (FStar_All.pipe_right uu____6030 FStar_Util.print_endline))
end)))


let print_full : deps  ->  unit = (fun deps -> (

let sort_output_files = (fun orig_output_file_map -> (

let order = (FStar_Util.mk_ref [])
in (

let remaining_output_files = (FStar_Util.smap_copy orig_output_file_map)
in (

let visited_other_modules = (FStar_Util.smap_create (Prims.parse_int "41"))
in (

let should_visit = (fun lc_module_name -> ((

let uu____6126 = (FStar_Util.smap_try_find remaining_output_files lc_module_name)
in (FStar_Option.isSome uu____6126)) || (

let uu____6133 = (FStar_Util.smap_try_find visited_other_modules lc_module_name)
in (FStar_Option.isNone uu____6133))))
in (

let mark_visiting = (fun lc_module_name -> (

let ml_file_opt = (FStar_Util.smap_try_find remaining_output_files lc_module_name)
in ((FStar_Util.smap_remove remaining_output_files lc_module_name);
(FStar_Util.smap_add visited_other_modules lc_module_name true);
ml_file_opt;
)))
in (

let emit_output_file_opt = (fun ml_file_opt -> (match (ml_file_opt) with
| FStar_Pervasives_Native.None -> begin
()
end
| FStar_Pervasives_Native.Some (ml_file) -> begin
(

let uu____6176 = (

let uu____6180 = (FStar_ST.op_Bang order)
in (ml_file)::uu____6180)
in (FStar_ST.op_Colon_Equals order uu____6176))
end))
in (

let rec aux = (fun uu___13_6243 -> (match (uu___13_6243) with
| [] -> begin
()
end
| (lc_module_name)::modules_to_extract -> begin
(

let visit_file = (fun file_opt -> (match (file_opt) with
| FStar_Pervasives_Native.None -> begin
()
end
| FStar_Pervasives_Native.Some (file_name) -> begin
(

let uu____6271 = (deps_try_find deps.dep_graph file_name)
in (match (uu____6271) with
| FStar_Pervasives_Native.None -> begin
(

let uu____6274 = (FStar_Util.format2 "Impossible: module %s: %s not found" lc_module_name file_name)
in (failwith uu____6274))
end
| FStar_Pervasives_Native.Some ({edges = immediate_deps; color = uu____6278}) -> begin
(

let immediate_deps1 = (FStar_List.map (fun x -> (FStar_String.lowercase (module_name_of_dep x))) immediate_deps)
in (aux immediate_deps1))
end))
end))
in ((

let uu____6287 = (should_visit lc_module_name)
in (match (uu____6287) with
| true -> begin
(

let ml_file_opt = (mark_visiting lc_module_name)
in ((

let uu____6295 = (implementation_of deps lc_module_name)
in (visit_file uu____6295));
(

let uu____6300 = (interface_of deps lc_module_name)
in (visit_file uu____6300));
(emit_output_file_opt ml_file_opt);
))
end
| uu____6304 -> begin
()
end));
(aux modules_to_extract);
))
end))
in (

let all_extracted_modules = (FStar_Util.smap_keys orig_output_file_map)
in ((aux all_extracted_modules);
(

let uu____6312 = (FStar_ST.op_Bang order)
in (FStar_List.rev uu____6312));
))))))))))
in (

let sb = (

let uu____6343 = (FStar_BigInt.of_int_fs (Prims.parse_int "10000"))
in (FStar_StringBuffer.create uu____6343))
in (

let pr = (fun str -> (

let uu____6353 = (FStar_StringBuffer.add str sb)
in (FStar_All.pipe_left (fun a1 -> ()) uu____6353)))
in (

let print_entry = (fun target first_dep all_deps -> ((pr target);
(pr ": ");
(pr first_dep);
(pr "\\\n\t");
(pr all_deps);
(pr "\n\n");
))
in (

let keys = (deps_keys deps.dep_graph)
in (

let output_file = (fun ext fst_file -> (

let ml_base_name = (

let uu____6406 = (

let uu____6408 = (

let uu____6412 = (FStar_Util.basename fst_file)
in (check_and_strip_suffix uu____6412))
in (FStar_Option.get uu____6408))
in (FStar_Util.replace_chars uu____6406 46 (*.*) "_"))
in (

let uu____6417 = (FStar_String.op_Hat ml_base_name ext)
in (FStar_Options.prepend_output_dir uu____6417))))
in (

let norm_path = (fun s -> (FStar_Util.replace_chars s 92 (*\*) "/"))
in (

let output_ml_file = (fun f -> (

let uu____6439 = (output_file ".ml" f)
in (norm_path uu____6439)))
in (

let output_krml_file = (fun f -> (

let uu____6451 = (output_file ".krml" f)
in (norm_path uu____6451)))
in (

let output_cmx_file = (fun f -> (

let uu____6463 = (output_file ".cmx" f)
in (norm_path uu____6463)))
in (

let cache_file = (fun f -> (

let uu____6475 = (cache_file_name f)
in (norm_path uu____6475)))
in (

let all_checked_files = (FStar_All.pipe_right keys (FStar_List.fold_left (fun all_checked_files file_name -> (

let process_one_key = (fun uu____6508 -> (

let dep_node = (

let uu____6510 = (deps_try_find deps.dep_graph file_name)
in (FStar_All.pipe_right uu____6510 FStar_Option.get))
in (

let iface_deps = (

let uu____6520 = (is_interface file_name)
in (match (uu____6520) with
| true -> begin
FStar_Pervasives_Native.None
end
| uu____6529 -> begin
(

let uu____6531 = (

let uu____6535 = (lowercase_module_name file_name)
in (interface_of deps uu____6535))
in (match (uu____6531) with
| FStar_Pervasives_Native.None -> begin
FStar_Pervasives_Native.None
end
| FStar_Pervasives_Native.Some (iface) -> begin
(

let uu____6547 = (

let uu____6550 = (

let uu____6551 = (deps_try_find deps.dep_graph iface)
in (FStar_Option.get uu____6551))
in uu____6550.edges)
in FStar_Pervasives_Native.Some (uu____6547))
end))
end))
in (

let iface_deps1 = (FStar_Util.map_opt iface_deps (FStar_List.filter (fun iface_dep -> (

let uu____6568 = (FStar_Util.for_some (dep_subsumed_by iface_dep) dep_node.edges)
in (not (uu____6568))))))
in (

let norm_f = (norm_path file_name)
in (

let files = (FStar_List.map (file_of_dep_aux true deps.file_system_map deps.cmd_line_files) dep_node.edges)
in (

let files1 = (match (iface_deps1) with
| FStar_Pervasives_Native.None -> begin
files
end
| FStar_Pervasives_Native.Some (iface_deps2) -> begin
(

let iface_files = (FStar_List.map (file_of_dep_aux true deps.file_system_map deps.cmd_line_files) iface_deps2)
in (FStar_Util.remove_dups (fun x y -> (Prims.op_Equality x y)) (FStar_List.append files iface_files)))
end)
in (

let files2 = (FStar_List.map norm_path files1)
in (

let files3 = (FStar_List.map (fun s -> (FStar_Util.replace_chars s 32 (* *) "\\ ")) files2)
in (

let files4 = (FStar_Options.profile (fun uu____6628 -> (FStar_String.concat "\\\n\t" files3)) (fun uu____6631 -> "Dependence analysis: concat files"))
in (

let cache_file_name1 = (cache_file file_name)
in (

let all_checked_files1 = (

let uu____6640 = (

let uu____6642 = (

let uu____6644 = (module_name_of_file file_name)
in (FStar_Options.should_be_already_cached uu____6644))
in (not (uu____6642)))
in (match (uu____6640) with
| true -> begin
((print_entry cache_file_name1 norm_f files4);
(cache_file_name1)::all_checked_files;
)
end
| uu____6652 -> begin
all_checked_files
end))
in (

let uu____6654 = (

let uu____6663 = (FStar_Options.cmi ())
in (match (uu____6663) with
| true -> begin
(FStar_Options.profile (fun uu____6683 -> (topological_dependences_of deps.file_system_map deps.dep_graph deps.interfaces_with_inlining ((file_name)::[]) true)) (fun uu____6688 -> "Dependence analysis: cmi, second topological sort"))
end
| uu____6698 -> begin
(

let maybe_widen_deps = (fun f_deps -> (FStar_List.map (fun dep1 -> (file_of_dep_aux false deps.file_system_map deps.cmd_line_files dep1)) f_deps))
in (

let fst_files = (maybe_widen_deps dep_node.edges)
in (

let fst_files_from_iface = (match (iface_deps1) with
| FStar_Pervasives_Native.None -> begin
[]
end
| FStar_Pervasives_Native.Some (iface_deps2) -> begin
(maybe_widen_deps iface_deps2)
end)
in (

let uu____6732 = (FStar_Util.remove_dups (fun x y -> (Prims.op_Equality x y)) (FStar_List.append fst_files fst_files_from_iface))
in ((uu____6732), (false))))))
end))
in (match (uu____6654) with
| (all_fst_files_dep, widened) -> begin
(

let all_checked_fst_dep_files = (FStar_All.pipe_right all_fst_files_dep (FStar_List.map cache_file))
in (

let all_checked_fst_dep_files_string = (FStar_String.concat " \\\n\t" all_checked_fst_dep_files)
in ((

let uu____6779 = (is_implementation file_name)
in (match (uu____6779) with
| true -> begin
((

let uu____6783 = ((FStar_Options.cmi ()) && widened)
in (match (uu____6783) with
| true -> begin
((

let uu____6787 = (output_ml_file file_name)
in (print_entry uu____6787 cache_file_name1 all_checked_fst_dep_files_string));
(

let uu____6789 = (output_krml_file file_name)
in (print_entry uu____6789 cache_file_name1 all_checked_fst_dep_files_string));
)
end
| uu____6791 -> begin
((

let uu____6794 = (output_ml_file file_name)
in (print_entry uu____6794 cache_file_name1 ""));
(

let uu____6797 = (output_krml_file file_name)
in (print_entry uu____6797 cache_file_name1 ""));
)
end));
(

let cmx_files = (

let extracted_fst_files = (FStar_All.pipe_right all_fst_files_dep (FStar_List.filter (fun df -> ((

let uu____6822 = (lowercase_module_name df)
in (

let uu____6824 = (lowercase_module_name file_name)
in (Prims.op_disEquality uu____6822 uu____6824))) && (

let uu____6828 = (lowercase_module_name df)
in (FStar_Options.should_extract uu____6828))))))
in (FStar_All.pipe_right extracted_fst_files (FStar_List.map output_cmx_file)))
in (

let uu____6838 = (

let uu____6840 = (lowercase_module_name file_name)
in (FStar_Options.should_extract uu____6840))
in (match (uu____6838) with
| true -> begin
(

let cmx_files1 = (FStar_String.concat "\\\n\t" cmx_files)
in (

let uu____6846 = (output_cmx_file file_name)
in (

let uu____6848 = (output_ml_file file_name)
in (print_entry uu____6846 uu____6848 cmx_files1))))
end
| uu____6850 -> begin
()
end)));
)
end
| uu____6852 -> begin
(

let uu____6854 = ((

let uu____6858 = (

let uu____6860 = (lowercase_module_name file_name)
in (has_implementation deps.file_system_map uu____6860))
in (not (uu____6858))) && (is_interface file_name))
in (match (uu____6854) with
| true -> begin
(

let uu____6863 = ((FStar_Options.cmi ()) && (widened || true))
in (match (uu____6863) with
| true -> begin
(

let uu____6867 = (output_krml_file file_name)
in (print_entry uu____6867 cache_file_name1 all_checked_fst_dep_files_string))
end
| uu____6869 -> begin
(

let uu____6871 = (output_krml_file file_name)
in (print_entry uu____6871 cache_file_name1 ""))
end))
end
| uu____6874 -> begin
()
end))
end));
all_checked_files1;
)))
end))))))))))))))
in (FStar_Options.profile process_one_key (fun uu____6880 -> (FStar_Util.format1 "Dependence analysis: output key %s" file_name))))) []))
in (

let all_fst_files = (

let uu____6890 = (FStar_All.pipe_right keys (FStar_List.filter is_implementation))
in (FStar_All.pipe_right uu____6890 (FStar_Util.sort_with FStar_String.compare)))
in (

let all_ml_files = (

let ml_file_map = (FStar_Util.smap_create (Prims.parse_int "41"))
in ((FStar_All.pipe_right all_fst_files (FStar_List.iter (fun fst_file -> (

let mname = (lowercase_module_name fst_file)
in (

let uu____6931 = (FStar_Options.should_extract mname)
in (match (uu____6931) with
| true -> begin
(

let uu____6934 = (output_ml_file fst_file)
in (FStar_Util.smap_add ml_file_map mname uu____6934))
end
| uu____6937 -> begin
()
end))))));
(sort_output_files ml_file_map);
))
in (

let all_krml_files = (

let krml_file_map = (FStar_Util.smap_create (Prims.parse_int "41"))
in ((FStar_All.pipe_right keys (FStar_List.iter (fun fst_file -> (

let mname = (lowercase_module_name fst_file)
in (

let uu____6961 = (output_krml_file fst_file)
in (FStar_Util.smap_add krml_file_map mname uu____6961))))));
(sort_output_files krml_file_map);
))
in (

let print_all = (fun tag files -> ((pr tag);
(pr "=\\\n\t");
(FStar_List.iter (fun f -> ((pr (norm_path f));
(pr " \\\n\t");
)) files);
(pr "\n");
))
in ((print_all "ALL_FST_FILES" all_fst_files);
(print_all "ALL_CHECKED_FILES" all_checked_files);
(print_all "ALL_ML_FILES" all_ml_files);
(print_all "ALL_KRML_FILES" all_krml_files);
(FStar_StringBuffer.output_channel FStar_Util.stdout sb);
))))))))))))))))))


let print : deps  ->  unit = (fun deps -> (

let uu____7009 = (FStar_Options.dep ())
in (match (uu____7009) with
| FStar_Pervasives_Native.Some ("make") -> begin
(print_make deps)
end
| FStar_Pervasives_Native.Some ("full") -> begin
(FStar_Options.profile (fun uu____7018 -> (print_full deps)) (fun uu____7020 -> "Dependence analysis: printing"))
end
| FStar_Pervasives_Native.Some ("graph") -> begin
(print_graph deps.dep_graph)
end
| FStar_Pervasives_Native.Some ("raw") -> begin
(print_raw deps)
end
| FStar_Pervasives_Native.Some (uu____7026) -> begin
(FStar_Errors.raise_err ((FStar_Errors.Fatal_UnknownToolForDep), ("unknown tool for --dep\n")))
end
| FStar_Pervasives_Native.None -> begin
()
end)))


let print_fsmap : (Prims.string FStar_Pervasives_Native.option * Prims.string FStar_Pervasives_Native.option) FStar_Util.smap  ->  Prims.string = (fun fsmap -> (FStar_Util.smap_fold fsmap (fun k uu____7081 s -> (match (uu____7081) with
| (v0, v1) -> begin
(

let uu____7110 = (

let uu____7112 = (FStar_Util.format3 "%s -> (%s, %s)" k (FStar_Util.dflt "_" v0) (FStar_Util.dflt "_" v1))
in (FStar_String.op_Hat "; " uu____7112))
in (FStar_String.op_Hat s uu____7110))
end)) ""))


let module_has_interface : deps  ->  FStar_Ident.lident  ->  Prims.bool = (fun deps module_name -> (

let uu____7133 = (

let uu____7135 = (FStar_Ident.string_of_lid module_name)
in (FStar_String.lowercase uu____7135))
in (has_interface deps.file_system_map uu____7133)))


let deps_has_implementation : deps  ->  FStar_Ident.lident  ->  Prims.bool = (fun deps module_name -> (

let m = (

let uu____7151 = (FStar_Ident.string_of_lid module_name)
in (FStar_String.lowercase uu____7151))
in (FStar_All.pipe_right deps.all_files (FStar_Util.for_some (fun f -> ((is_implementation f) && (

let uu____7162 = (

let uu____7164 = (module_name_of_file f)
in (FStar_String.lowercase uu____7164))
in (Prims.op_Equality uu____7162 m))))))))




