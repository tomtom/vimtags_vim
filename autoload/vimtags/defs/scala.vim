" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-12
" @Revision:    1


if exists('g:vimtags#defs#scala#done')
    finish
endif
let g:vimtags#defs#scala#done = 1


Vimtagsctags --langdef=scala
Vimtagsctags --langmap=scala:.scala

" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*class[ \t]+([a-zA-Z0-9_]+)/\4/c,classes/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*object[ \t]+([a-zA-Z0-9_]+)/\4/c,objects/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*case class[ \t]+([a-zA-Z0-9_]+)/\6/c,case classes/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*case object[ \t]+([a-zA-Z0-9_]+)/\4/c,case objects/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private[^ ]*|protected)?[ \t]*trait[ \t]+([a-zA-Z0-9_]+)/\4/t,traits/
" Vimtagsctags --regex-scala=/^[ \t]*type[ \t]+([a-zA-Z0-9_]+)/\1/T,types/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*(\[[a-z]*\])*|protected)[ \t]*)*def[ \t]+([a-zA-Z0-9_]+)/\4/m,methods/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*|protected)[ \t]*)*val[ \t]+([a-zA-Z0-9_]+)/\3/l,constants/
" Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy|private[^ ]*|protected)[ \t]*)*var[ \t]+([a-zA-Z0-9_]+)/\3/l,variables/
" Vimtagsctags --regex-scala=/^[ \t]*package[ \t]+([a-zA-Z0-9_.]+)/\1/p,packages/

Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private|protected)?[ \t]*class[ \t]+([a-zA-Z0-9_]+)/\4/c,classes/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private|protected)?[ \t]*object[ \t]+([a-zA-Z0-9_]+)/\4/c,objects/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private|protected)?[ \t]*case class[ \t]+([a-zA-Z0-9_]+)/\4/c,case classes/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private|protected)?[ \t]*case object[ \t]+([a-zA-Z0-9_]+)/\4/c,case objects/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*(private|protected)?[ \t]*trait[ \t]+([a-zA-Z0-9_]+)/\4/t,traits/
Vimtagsctags --regex-scala=/^[ \t]*type[ \t]+([a-zA-Z0-9_]+)/\1/T,types/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*def[ \t]+([a-zA-Z0-9_]+)/\3/m,methods/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*val[ \t]+([a-zA-Z0-9_]+)/\3/l,constants/
Vimtagsctags --regex-scala=/^[ \t]*((abstract|final|sealed|implicit|lazy)[ \t]*)*var[ \t]+([a-zA-Z0-9_]+)/\3/l,variables/
Vimtagsctags --regex-scala=/^[ \t]*package[ \t]+([a-zA-Z0-9_.]+)/\1/p,packages/

