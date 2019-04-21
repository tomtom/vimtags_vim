" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-12
" @Revision:    2

if exists('g:vimtags#defs#kotlin#done')
    finish
endif
let g:vimtags#defs#kotlin#done = 1


Vimtagsctags --langdef=Kotlin
Vimtagsctags --langmap=kotlin:.kt
Vimtagsctags --langmap=kotlin:+.kts
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*class[ \t]+([a-zA-Z0-9_]+)/\4/c,classes/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*object[ \t]+([a-zA-Z0-9_]+)/\4/o,objects/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*data class[ \t]+([a-zA-Z0-9_]+)/\6/c,data classes/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*interface[ \t]+([a-zA-Z0-9_]+)/\4/i,interfaces/
Vimtagsctags --regex-kotlin=/^[ \t]*type[ \t]+([a-zA-Z0-9_]+)/\1/T,types/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*(\[[a-z]*\])*|protected)[ \t]*)*fun[ \t]+([a-zA-Z0-9_]+)/\4/m,methods/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*|protected)[ \t]*)*val[ \t]+([a-zA-Z0-9_]+)/\3/co,constants/
Vimtagsctags --regex-kotlin=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*|protected)[ \t]*)*var[ \t]+([a-zA-Z0-9_]+)/\3/va,variables/
Vimtagsctags --regex-kotlin=/^[ \t]*package[ \t]+([a-zA-Z0-9_.]+)/\1/p,packages/
Vimtagsctags --regex-kotlin=/^[ \t]*import[ \t]+([a-zA-Z0-9_.]+)/\1/p,imports/


