" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-24
" @Revision:    7

if exists('g:vimtags#defs#r#done')
    finish
endif
let g:vimtags#defs#r#done = 1


" Credits: Derived from http://tinyheero.github.io/2017/05/13/r-vim-ctags.html
Vimtagsfiletype R *.R *.r
Vimtagskind R /^\s*\(['"`]\?\)\([.A-Za-z][.A-Za-z0-9_]*\)\1\s*<-\s*function\>/ submatch=2 f
Vimtagskind R /^\(['"`]\?\)\([.A-Za-z][.A-Za-z0-9_]*\)\1\s*<-\s*\%(function\>\)\@!/ submatch=2 g
Vimtagskind R /^\(['"`]\?\)\([.A-Za-z][.A-Za-z0-9_]*\)\1\s*<-\s*\%(function\>\)\@!/ submatch=2 v

