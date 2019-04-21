" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-14
" @Revision:    2

if exists('g:vimtags#defs#haxe#done')
    finish
endif
let g:vimtags#defs#haxe#done = 1

Vimtagsctags --langdef=haxe
Vimtagsctags --langmap=haxe:.hx
Vimtagsctags --regex-haxe=/^package[ \t]+([A-Za-z0-9_.]+)/\1/p,package/
Vimtagsctags --regex-haxe=/^[ \t]*[(@:macro|private|public|static|override|inline|dynamic)( \t)]*function[ \t]+([A-Za-z0-9_]+)/\1/f,function/
Vimtagsctags --regex-haxe=/^[ \t]*([private|public|static|protected|inline][ \t]*)+var[ \t]+([A-Za-z0-9_]+)/\2/v,variable/
Vimtagsctags --regex-haxe=/^[ \t]*package[ \t]*([A-Za-z0-9_]+)/\1/p,package/
Vimtagsctags --regex-haxe=/^[ \t]*(extern[ \t]*|@:native\([^)]*\)[ \t]*)*class[ \t]+([A-Za-z0-9_]+)[ \t]*[^\{]*/\2/c,class/
Vimtagsctags --regex-haxe=/^[ \t]*(extern[ \t]+)?interface[ \t]+([A-Za-z0-9_]+)/\2/i,interface/
Vimtagsctags --regex-haxe=/^[ \t]*typedef[ \t]+([A-Za-z0-9_]+)/\1/t,typedef/
Vimtagsctags --regex-haxe=/^[ \t]*enum[ \t]+([A-Za-z0-9_]+)/\1/t,typedef/
Vimtagsctags --regex-haxe=/^[ \t]*+([A-Za-z0-9_]+)(;|\([^)]*:[^)]*\))/\1/t,enum_field/

