" @Author:      Tom Link (micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-24
" @Revision:    171
" GetLatestVimScripts: 0 0 vimtags.vim

if &cp || exists('g:loaded_vimtags')
    finish
endif
let g:loaded_vimtags = 1

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:vimtags_defs')
    let g:vimtags_defs = {}   "{{{2
endif
if exists('g:vimtags_defs_user')
    for [s:key, s:val] in items(g:vimtags_defs_user)
        let g:vimtags_defs[s:key] = extend(get(g:vimtags_defs, s:key, []), s:val)
    endfor
    unlet! s:key s:val
endif


if !exists('g:vimtags_filetypes')
    " :read: let g:vimtags_filetypes = {...}   "{{{2
    let g:vimtags_filetypes = {}
endif
if exists('g:vimtags_filetypes_user')
    for [s:key, s:val] in items(g:vimtags_filetypes_user)
        let g:vimtags_filetypes[s:key] = extend(get(g:vimtags_filetypes, s:key, []), s:val)
    endfor
    unlet! s:key s:val
endif


function! s:AddTagDef(bang, filetype, def) abort "{{{3
    if a:bang || !has_key(g:vimtags_defs, a:filetype)
        let g:vimtags_defs[a:filetype] = []
    endif
    let g:vimtags_defs[a:filetype] = add(g:vimtags_defs[a:filetype], a:def)
endf


" :nodoc:
function! Vimtagskind(bang, filetype, rx, ...) abort "{{{3
    let l:def = {}
    let rx = matchstr(a:rx, '^/\zs\%([^\\]\+\|\\.\)\+\ze/$')
    if !empty(rx)
        let l:def.rx = rx
    else
        throw 'Vimtagskind: Malformed rx: '. a:rx
    endif
    let l:extra = []
    for arg in a:000
        if arg =~# '^ignore_rx=/\%([^\\]\+\|\\.\)\+/$'
            let l:def.ignore_rx = matchstr(arg, '^ignore_rx=/\zs\%([^\\]\+\|\\.\)\+\ze/')
        elseif arg =~# '^submatch=\d\+$'
            let l:def.submatch = matchstr(arg, '^submatch=\zs.*$')
        elseif arg =~# '^lnum=\d\+\%(,\d\+\)\?$'
            let l:lnumrange = split(matchstr(arg, '^lnum=\zs.*$'), ',')
            let l:def.lnum = [l:lnumrange[0], get(l:lnumrange, 1, l:lnumrange[0])]
        elseif arg =~# '^hide=\d\+$'
            let l:def.hide = matchstr(arg, '^hide=\zs.*$')
        elseif arg =~# '^prevline_rx=/.\{-}/$'
            let l:def.prevline_rx = matchstr(arg, '^prevline_rx=\zs\%([^\\]\+\|\\.\)\+\ze/$')
        elseif arg =~# '^if:\w\+='
            let l:ml = matchlist(arg, '^let:\(\w\+\)=\(.*\)$')
            if !has_key(l:def, 'if')
                let l:def.if = {}
            endif
            let l:def.if[l:ml[0]] = l:ml[1]
        elseif arg =~# '^let:\w\+='
            let l:ml = matchlist(arg, '^let:\(\w\+\)=\(.*\)$')
            if !has_key(l:def, 'let')
                let l:def.let = {}
            endif
            let l:def.let[l:ml[0]] = l:ml[1]
        else
            call add(l:extra, arg)
        endif
    endfor
    if !empty(l:extra)
        let l:def.extra = l:extra
    endif
    call s:AddTagDef(a:bang, a:filetype, l:def)
endf


" :nodoc:
function! Vimtagsfiletype(bang, filetype, ...) abort "{{{3
    if a:bang || !has_key(g:vimtags_filetypes, a:filetype)
        let g:vimtags_filetypes[a:filetype] = {'glob': [], 'rx': ''}
    endif
    let g:vimtags_filetypes[a:filetype].glob = extend(g:vimtags_filetypes[a:filetype].glob, a:000)
    let g:vimtags_filetypes[a:filetype].rx = '\%('. join(map(copy(g:vimtags_filetypes[a:filetype].glob), 'glob2regpat(v:val)'), '\|') .'\)'
endf


let s:langdefs = {}

" :nodoc:
function! VimtagsCTags(arg, ...) abort "{{{3
    let l:quiet = a:0 >= 1 ? a:1 : 0
    if a:arg =~# '^--langdef='
        let l:filetype = matchstr(a:arg, '^--langdef=\zs.*')
        let s:langdefs[tolower(l:filetype)] = {'lang': l:filetype}
    elseif a:arg =~# '^--langmap='
        let l:ml = matchlist(a:arg, '^--langmap=\(\w\+\):\(+\)\?\(.*\)$')
        if empty(l:ml)
            throw 'Vimtags: Malformed ctags langdef argument: '. a:arg
        endif
        let l:filetype = l:ml[1]
        let l:add = l:ml[2]
        let l:pattern = l:ml[3]
        call Vimtagsfiletype(l:add !=# '+', l:filetype, l:pattern)
    elseif a:arg =~# '^--regex-\w\+=/.\{-}/$'
        let l:ml = matchlist(a:arg, '^--regex-\(\w\+\)=/\(.\{-}\)/\\\(\d\)/\(\w*\)\%(,\([^/,]\+\)\)\?\%(,\([^/,]\+\)\)\?/\s*$')
        if empty(l:ml)
            throw 'Vimtags: Malformed ctags regex argument: '. a:arg
        endif
        let l:filetype = l:ml[1]
        let l:rx = '\v'. l:ml[2]
        let l:submatch = l:ml[3]
        let l:kind = l:ml[4]
        if empty(l:kind)
            let l:kind = l:ml[5]
        endif
        if empty(l:kind)
            let l:kind = l:ml[6]
        endif
        let def = {'rx': l:rx, 'submatch': l:submatch, 'extra': [l:kind]}
        if has_key(s:langdefs[l:filetype], 'init')
            let l:bang = 0
        else
            let l:bang = 1
            let s:langdefs[l:filetype].init = 1
        endif
        call s:AddTagDef(l:bang, l:filetype, def)
    elseif !l:quiet
        echohl WarningMsg
        echom 'Vimtags: Unsupported ctags argument:' a:arg
        echohl NONE
    endif
endf


" :nodoc:
function! VimtagsCTagsConfig(filename) abort "{{{3
    for line in readfile(a:filename)
        if line =~# '^-'
            call VimtagsCTags(line, 1)
        endif
    endfor
endf


" :display: :Vimtags[!] TAGSFILE [PATTERN...]
" Create a tags file by scanning all files below the |current-directory| 
" (that match a given |glob()| pattern if any).
"
" With the optional <bang> '!', the tags file will be replaced. Without 
" the bang, the tags file will be updated.
command! -nargs=* -bang -bar -complete=file Vimtags call vimtags#Update(!empty("<bang>"), <f-args>)


" :display: :Vimtagsfiletype[!] FILETYPE FILENAME_PATTERN...
" Define a new filetype for files matching a certain filename pattern 
" (given as |glob()| pattern).
"
" Usually, the definition of a filetype should be followed by several 
" |:Vimtagskind| commands that define kinds of tags.
command! -bang -nargs=+ Vimtagsfiletype call Vimtagsfiletype(!empty("<bang>"), <f-args>)


" :display: :Vimtagskind[!] FILETYPE /REGEXP/ [FIELDS...]
" Define a new kind for a certain filetype (previously defined via 
" |:Vimtagsfiletype|) for lines matching a certain |regexp|.
"
" FILETYPE ... A filetype
" REGEXP   ... A valid |regexp| Use backslashes to escape any character. 
"              I.e. ''\\'' is one backslash.
"
" FIELDS can be one or more of:
"
"   hide=N
"   if=EXPR
"   ignore_rx=/REGEX/
"   let:NAME=VALUE
"   lnum=N[,N]
"   submatch=N
"
" Any other extra information is added as extra field to the tag.
" EXTRA...
command! -nargs=+ -bang Vimtagskind call Vimtagskind(!empty("<bang>"), <f-args>)

" :display: :Vimtagsctags [CTAGS COMMAND LINE OPTION]
" Use ctags command line options to define filetypes and kinds. The 
" following options are supported:
"
" --langdef=LANG
" --langmap=LANG:SUFFIX
" --regex-LANG=REGEXP
command! -nargs=1 Vimtagsctags call VimtagsCTags(<q-args>)

" :display| :Vimtagsctagsconfig FILENAME
" Read a ctags configuration file and parse its command-line options.
command! -nargs=1 -complete=file Vimtagsctagsconfig call VimtagsCTagsConfig(<q-args>)


runtime! autoload/vimtags/defs/*.vim

augroup Vimtags
    autocmd!
    for [s:filetype, s:def] in items(g:vimtags_filetypes)
        exec 'autocmd BufEnter' escape(join(s:def.glob, ','), ' ') 'call vimtags#MaybeSetupBuffer(expand(''<abuf>''), '. string(s:filetype) .')'
    endfor
    unlet! s:key s:def
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

