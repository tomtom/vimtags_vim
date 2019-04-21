" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-21
" @Revision:    4

if exists('g:vimtags#defs#vim#done')
    finish
endif
let g:vimtags#defs#vim#done = 1


if !exists('g:vimtags#defs#default#vim_include_prefix')
    " Some VIM commands don't work properly if prefixes like `s:` are 
    " included in the tag name, which is why it is excluded by default.
    let g:vimtags#defs#default#vim_include_prefix = 0   "{{{2
endif


Vimtagsfiletype vim *.vim
if g:vimtags#defs#default#vim_include_prefix
    Vimtagskind vim /^\s*fu\%[nction]!\?\s\+\(\%(s:\|<SID>\)\?[^[:space:](]\+\)/ f
else
    Vimtagskind vim /^\s*fu\%[nction]!\?\s\+\%(s:\|<SID>\)\?\([^[:space:](]\+\)/ f
endif
Vimtagskind vim /^\s*com\%[mand]!\?\%(\s\+-\S\+\)\+\s\+\(\u\S*\)/ c
Vimtagskind vim /^\s*let\s\+[sgwbt]:\([^[:space:]=]\+\)/ g
" Vimtagskind vim /^\s*let\s\+l:\([^[:space:]=]\+\)/ v
Vimtagskind vim /^\s*[nvxsoilct]\?\%(nore\)\?map\%(\s\+<buffer>\|\s\+<silent>\)\+\s\+\(<[-[:alnum:]]>\)/ m


