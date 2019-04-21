" @Author:      Tom Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     https://github.com/tomtom
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Last Change: 2019-04-16
" @Revision:    267


if exists(':Tlibtrace') != 2
    command! -nargs=+ -bang Tlibtrace :
endif


if !exists('g:loaded_tlib') || g:loaded_tlib < 127
    runtime plugin/tlib.vim
    if !exists('g:loaded_tlib') || g:loaded_tlib < 127
        echoerr 'tlib >= 1.27 is required'
        finish
    endif
endif


if !exists('g:vimtags#debug')
    let g:vimtags#debug = 0   "{{{2
endif


function! s:GetFiletype(filename, bufnr) abort "{{{3
    if a:bufnr != -1
        let l:filetype = getbufvar(a:bufnr, 'vimtags_name', '')
        if !empty(l:filetype)
            return l:filetype
        endif
    endif
    for [l:filetype, l:def] in items(g:vimtags_filetypes)
        if a:filename =~# l:def.rx
            if a:bufnr != -1
                call setbufvar(a:bufnr, 'vimtags_name', l:filetype)
            endif
            return l:filetype
        endif
    endfor
    return ''
endf


function! vimtags#Test_GetFiletype() abort "{{{3
    call assert_equal('', s:GetFiletype('', -1))
    call assert_equal('', s:GetFiletype('foo/bar.unknown', -1))
    call assert_equal('latex', s:GetFiletype('foo/bar.tex', -1))
    call assert_equal('latex', s:GetFiletype('foo/bar.tpl.tex', -1))
endf


function! s:GetPatterns(filetype, filename) abort "{{{3
    Tlibtrace 'vimtags', a:filetype, a:filename
    if !empty(a:filetype)
        Tlibtrace 'vimtags', a:filetype, len(g:vimtags_defs[a:filetype])
        return get(g:vimtags_defs, a:filetype, [])
    elseif !empty(a:filename)
        let l:filetype = s:GetFiletype(a:filename, bufnr(a:filename))
        if empty(l:filetype)
            return []
        else
            return s:GetPatterns(l:filetype, a:filename)
        endfor
    else
        throw 'Vimtags: Either filetype or filename must be non-empty'
    endif
endf


function! vimtags#Test_GetPatterns() abort "{{{3
    call assert_fails('call s:GetPatterns("", "")')
    call assert_equal([], s:GetPatterns('', 'foo/bar.unknown'))
    call assert_equal([], s:GetPatterns('unknown', ''))
    call assert_equal(g:vimtags_defs['latex'], s:GetPatterns('latex', ''))
    call assert_equal(g:vimtags_defs['latex'], s:GetPatterns('', 'foo/bar.tex'))
endf


function! s:GetScanRx(patterns) abort "{{{3
    Tlibtrace 'vimtags', type(a:patterns)
    let l:scan_rx = join(map(copy(a:patterns), 'v:val.rx'), '\|')
    Tlibtrace 'vimtags', l:scan_rx
    let l:scan_rx = substitute(l:scan_rx, '\\(', '\\%(', 'g')
    Tlibtrace 'vimtags', l:scan_rx
    return '\%('. l:scan_rx .'\)'
endf


function! s:GetTag(lines, relfilename, patterns, lnum, line, env) abort "{{{3
    Tlibtrace 'vimtags', a:relfilename, type(a:patterns), a:line
    let l:tagname = ''
    let l:tagfields = ''
    let l:pattern = {}
    let l:hide = 0
    let l:line = a:line
    for l:pattern in a:patterns
        let l:ml = matchlist(l:line, l:pattern.rx)
        if !empty(l:ml)
            if has_key(l:pattern, 'ignore_rx') && l:line =~# l:pattern.ignore_rx
                continue
            endif
            Tlibtrace 'vimtags9', l:ml
            let l:tagname = get(l:ml, get(l:pattern, 'submatch', 1), '')
            if !empty(l:tagname)
                if has_key(l:pattern, 'if')
                    for [l:var, l:comparison, l:val] in l:pattern.if
                        if !has_key(a:env, l:var) || a:env[l:var] !~# l:val
                            Tlibtrace 'vimtags', 'skip', l:pattern.if
                            continue
                        endif
                    endfor
                endif
                if has_key(l:pattern, 'lnum')
                    let [l:lnum0, l:lnum1] = l:pattern.lnum
                    if a:lnum < l:lnum0 || a:lnum > l:lnum1
                        Tlibtrace 'vimtags', 'skip', a:lnum, l:pattern.lnum
                        continue
                    endif
                endif
                if has_key(l:pattern, 'let')
                    call extend(a:env, l:pattern.let)
                endif
                if has_key(l:pattern, 'prevline_rx')
                    let l:line = a:lines[a:lnum - 2]
                    let l:tagname = matchstr(l:line, l:pattern.prevline_rx)
                endif
                let l:hide = get(l:pattern, 'hide', 0)
                let l:tabfields0 = l:pattern.extra
                if !empty(l:tabfields0)
                    if type(l:tabfields0) == 1
                        let l:tagfields = l:tabfields0
                    else
                        let l:tagfields = join(l:tabfields0, "\t")
                    endif
                endif
                break
            endif
        endif
    endfor
    Tlibtrace 'vimtags', l:tagname, l:tagfields
    if empty(l:tagname) || l:hide
        " throw 'Vimtags: Internal error: Cannot find the right tag for: '. l:line
        return ''
    else
        return join([l:tagname, a:relfilename, '/^'. escape(tlib#rx#Escape(l:line, 'M'), '/	') .'$/;"', l:tagfields], "\t")
    endif
endf


function! s:GetTagsFromLines(relfilename, patterns, lines) abort "{{{3
    Tlibtrace 'vimtags', a:relfilename, type(a:patterns), len(a:lines)
    let l:scan_rx = s:GetScanRx(a:patterns)
    let l:lines = filter(copy(a:lines), 'v:val =~# l:scan_rx')
    Tlibtrace 'vimtags', l:scan_rx, len(l:lines)
    " if g:vimtags#debug
    "     echom 'Vimtags:' len(l:lines) 'eligible lines in' a:relfilename
    " endif
    let l:env = {}
    let l:tags = map(l:lines, 's:GetTag(l:lines, a:relfilename, a:patterns, v:key + 1, v:val, l:env)')
    let l:tags = filter(l:tags, '!empty(v:val)')
    Tlibtrace 'vimtags', len(l:tags)
    return l:tags
endf


let s:empty = ['!_TAG_FILE_FORMAT	2	//'
                \ , '!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/'
                \ , '!_TAG_PROGRAM_AUTHOR	Tom Link	/micathom@gmail.com/'
                \ , '!_TAG_PROGRAM_NAME	vimtags	//'
                \ , '!_TAG_PROGRAM_VERSION	'. g:loaded_vimtags .'	//'
                \ ]
    " \ , '!_TAG_PROGRAM_URL	http://ctags.sourceforge.net	/official site/'

function! s:GetEmptyTags() abort "{{{3
    return copy(s:empty)
endf


function! s:UpdatetagsfileWithLines(filetype, filename, lines, tagsfile, tags) abort "{{{3
    Tlibtrace 'vimtags', a:filetype, a:filename, len(a:lines), a:tagsfile, len(a:tags)
    let l:tags = !empty(a:tags) ? a:tags : (filereadable(a:tagsfile) ? readfile(a:tagsfile) : s:GetEmptyTags())
    Tlibtrace 'vimtags', len(l:tags)
    let l:patterns = s:GetPatterns(a:filetype, a:filename)
    if !empty(l:patterns)
        let l:relfilename =  tlib#file#Relative(fnamemodify(a:filename, ':p'), fnamemodify(a:tagsfile, ':p:h'))
        let l:new_tags = s:GetTagsFromLines(l:relfilename, l:patterns, a:lines)
        Tlibtrace 'vimtags', len(l:new_tags)
        " if g:vimtags#debug
        "     echom 'Vimtags:' len(l:new_tags) 'in' l:relfilename
        " endif
        if !empty(l:new_tags)
            let l:filter_rx = "\t". l:relfilename ."\t"
            let l:filter_rx = substitute(l:filter_rx, '\\', '/', 'g')
            Tlibtrace 'vimtags', l:filter_rx
            let l:tags = filter(l:tags, 'v:val !~# l:filter_rx')
            Tlibtrace 'vimtags', len(l:tags)
            let l:tags = extend(l:tags, l:new_tags)
            Tlibtrace 'vimtags', len(l:tags)
        endif
    endif
    return l:tags
endf


function! s:UpdateBuffer(bufnr, filetype, tagsfile, tags, writefile) abort "{{{3
    Tlibtrace 'vimtags', a:bufnr, a:filetype, a:tagsfile, len(a:tags), a:writefile
    if a:writefile
        let l:tags0 = a:tags
        let l:tags = s:GetNewTags(a:tags)
    else
        let l:tags0 = a:tags
        let l:tags = a:tags
    endif
    if empty(getbufvar(a:bufnr, 'vimtags_file', ''))
        call setbufvar(a:bufnr, 'vimtags_file', a:tagsfile)
    endif
    let l:filename = bufname(a:bufnr)
    let l:lines = getbufline(a:bufnr, 1, line('$'))
    let l:tags = s:UpdatetagsfileWithLines(a:filetype, l:filename, l:lines, a:tagsfile, l:tags)
    if a:writefile
        call s:WriteTagsFile(a:tagsfile, l:tags0, l:tags, 0)
    endif
    return l:tags
endf


function! s:WriteTagsFile(tagsfile, tags0, tags1, verbose) abort "{{{3
    Tlibtrace 'vimtags', a:tagsfile, len(a:tags0), len(a:tags1)
    let l:tags1 = a:tags1[0 : len(s:empty) - 1] + sort(a:tags1[len(s:empty) : -1])
    Tlibtrace 'vimtags', len(a:tags1), (len(a:tags0)!=len(l:tags1)), (a:tags0!=l:tags1)
    if len(a:tags0) != len(l:tags1) || a:tags0 != l:tags1
        call writefile(l:tags1, a:tagsfile)
        if a:verbose || g:vimtags#debug
            echom 'Vimtags: Wrote' a:tagsfile '('. len(l:tags1) .' lines)'
        endif
    endif
    return l:tags1
endf


function! s:ReadTagsFile(readtags, tagsfile) abort "{{{3
    if !a:readtags || !filereadable(a:tagsfile)
        return []
    else
        let l:tags = readfile(a:tagsfile)
        return l:tags
    endif
endf


function! s:GetNewTags(tags) abort "{{{3
    return copy(empty(a:tags) ? s:empty : a:tags)
endf


function! vimtags#Update(bang, tagsfile, ...) abort "{{{3
    Tlibtrace 'vimtags', a:bang, a:tagsfile, filereadable(a:tagsfile), a:000
    let l:filepattern = a:0 >= 1 ? a:1 : '**'
    let l:tags0 = s:ReadTagsFile(!a:bang, a:tagsfile)
    let l:tags = s:GetNewTags(l:tags0)
    let l:filescan_rx = '\%('. join(map(values(g:vimtags_filetypes), 'v:val.rx'), '\|') .'\)'
    let l:filenames = filter(glob(l:filepattern, 1, 1), 'v:val =~# l:filescan_rx && !isdirectory(v:val)')
    Tlibtrace 'vimtags', len(l:tags0), len(l:filenames)
    let l:pb = tlib#progressbar#Init(len(l:filenames))
    try
        let l:fidx = 1
        for l:filename in l:filenames
            call tlib#progressbar#Display(l:fidx, pathshorten(l:filename))
            let l:bufnr = bufnr(l:filename)
            if l:bufnr == -1
                if !filereadable(l:filename)
                    throw 'vimtags#Update: File not readable: '. l:filename
                else
                    let l:tags = s:UpdatetagsfileWithLines('', l:filename, readfile(l:filename), '', l:tags)
                endif
            else
                let l:filetype = s:GetFiletype(l:filename, l:bufnr)
                let l:tags = s:UpdateBuffer(l:bufnr, l:filetype, a:tagsfile, l:tags, 0)
            endif
        endfor
    finally
        call tlib#progressbar#Restore(l:pb)
    endtry
    if !empty(a:tagsfile)
        Tlibtrace 'vimtags', len(l:tags0)
        let l:tags = s:WriteTagsFile(a:tagsfile, l:tags0, l:tags, 1)
    endif
    return l:tags
endf


function! s:SetupBuffer(bufnr, filetype, tagsfile) abort "{{{3
    Tlibtrace 'vimtags', a:bufnr, a:filetype, a:tagsfile
    augroup Vimtags
        exec 'autocmd BufWritePost <buffer> call s:UpdateBuffer('. a:bufnr .', '. string(a:filetype) .', '. string(a:tagsfile) .', s:ReadTagsFile(1, '. string(a:tagsfile) .'), 1)'
    augroup END
endf


function! s:IsVimtagsFile(tagsfile) abort "{{{3
    let l:lines = readfile(a:tagsfile, 5)
    return len(l:lines) >= len(s:empty) && l:lines[3] == s:empty[3]
endf


function! vimtags#MaybeSetupBuffer(bufnr, filetype) abort "{{{3
    Tlibtrace 'vimtags', a:filetype, a:bufnr
    if !exists('b:vimtags_tagsfile')
        for l:tagsfile in tagfiles()
            if s:IsVimtagsFile(l:tagsfile)
                Tlibtrace 'vimtags', l:tagsfile
                let b:vimtags_tagsfile = l:tagsfile
                call s:SetupBuffer(a:bufnr, empty(&filetype) ? a:filetype : &filetype, fnamemodify(l:tagsfile, ':p'))
                break
            endif
        endfor
    endif
endf


