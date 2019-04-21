" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-21
" @Revision:    2

if exists('g:vimtags#defs#latex#done')
    finish
endif
let g:vimtags#defs#latex#done = 1


" LaTeX
Vimtagsfiletype latex *.tex
Vimtagskind latex /^\s*\\\\\(\%(sub\)*heading\s*\*\?\s*{.\{-}}\)\s*$/ s

