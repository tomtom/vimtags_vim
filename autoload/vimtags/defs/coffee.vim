" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-12
" @Revision:    1

if exists('g:vimtags#defs#coffee#done')
    finish
endif
let g:vimtags#defs#coffee#done = 1


Vimtagsctags --langdef=coffee
Vimtagsctags --langmap=coffee:.coffee
Vimtagsctags --regex-coffee=/(^|=[ \t])*class ([A-Za-z.]+)( extends [A-Za-z.]+)?$/\2/c,class/
Vimtagsctags --regex-coffee=/^[ \t]*(module\.)?(exports\.)?@?([A-Za-z.]+):.*[-=]>.*$/\3/f,function/
Vimtagsctags --regex-coffee=/^[ \t]*(module\.)?(exports\.)?([A-Za-z.]+)[ \t]+=.*[-=]>.*$/\3/f,function/
Vimtagsctags --regex-coffee=/^[ \t]*([A-Za-z.]+)[ \t]+=[^->\n]*$/\1/v,variable/

