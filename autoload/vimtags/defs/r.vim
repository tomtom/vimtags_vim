" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-21
" @Revision:    3

if exists('g:vimtags#defs#r#done')
    finish
endif
let g:vimtags#defs#r#done = 1


" Credits: http://tinyheero.github.io/2017/05/13/r-vim-ctags.html
Vimtagsfiletype R *.R *.r
Vimtagskind R /^\s*"?\([.A-Za-z][.A-Za-z0-9_]*\)"?\s*<-\s*function/ f
Vimtagskind R /^"?\([.A-Za-z][.A-Za-z0-9_]*\)"?\s*<-\s*\%(function\)\@!/ g
Vimtagskind R /^"?\([.A-Za-z][.A-Za-z0-9_]*\)"?\s*<-\s*\%(function\)\@!/ v

