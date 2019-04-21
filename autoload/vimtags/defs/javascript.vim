" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-12
" @Revision:    1

if exists('g:vimtags#defs#javascript#done')
    finish
endif
let g:vimtags#defs#javascript#done = 1

Vimtagsctags --langdef=js
Vimtagsctags --langmap=js:.js
Vimtagsctags --regex-js=/([A-Za-z0-9._$]+)[ \t]*[:=][ \t]*\{/\1/,object/
Vimtagsctags --regex-js=/([A-Za-z0-9._$()]+)[ \t]*[:=][ \t]*function[ \t]*\(/\1/,function/
Vimtagsctags --regex-js=/function[ \t]+([A-Za-z0-9._$]+)[ \t]*\(([^)])\)/\1/,function/
Vimtagsctags --regex-js=/([A-Za-z0-9._$]+)[ \t]*[:=][ \t]*\[/\1/,array/
Vimtagsctags --regex-js=/([^= ]+)[ \t]*=[ \t]*[^"]'[^']*/\1/,string/
Vimtagsctags --regex-js=/([^= ]+)[ \t]*=[ \t]*[^']"[^"]*/\1/,string/

