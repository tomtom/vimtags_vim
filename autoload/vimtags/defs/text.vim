" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-21
" @Revision:    60


if !exists('g:vimtags#defs#default#text_filetype')
    let g:vimtags#defs#default#text_filetype = 'viki'   "{{{2
endif


" Markdown
Vimtagsfiletype markdown *.md
if g:vimtags#defs#default#text_filetype == 'markdown'
    Vimtagsfiletype markdown *.txt
endif
Vimtagskind markdown /^#\+\s\(.*\)$/ s
Vimtagskind markdown /^\s*:\ \ \ \ / s prevline_rx=/.*/
" Vimtagskind markdown /@(\S\+)/ k


" Viki
Vimtagsfiletype viki *.viki
if g:vimtags#defs#default#text_filetype ==# 'viki'
    Vimtagsfiletype viki *.txt
endif
Vimtagskind viki /^\*\+\s\(.*\)$/ s
Vimtagskind viki /^#\(\l\S\+\)/ k
Vimtagskind viki /^\s\+\(.\{-}\)\s\+::/ d

