let open_brackets = ["(", "{", "[", "\"", "\'"]
let close_brackets = [")", "}", "]", "\"", "\'"]

function! IsPair(beforeletter, nowletter)
    if index(g:open_brackets, a:beforeletter) == -1
        return 0

    elseif index(g:open_brackets, a:beforeletter) == index(g:close_brackets, a:nowletter)
        return 1

    else
        return 0
endfunction

function! CloseBracketColumn(beforeletter)
    let line_tail = strpart(getline('.'), col('.') - 1)
    let close_bracket = g:close_brackets[index(g:open_brackets, a:beforeletter)]
    let nested = 0
    let colcount = 0

    for c in line_tail
        if c == a:beforeletter
            let nested = nested + 1
        elseif IsPair(a:beforeletter, c)
            if nested == 0
                return colcount
            else
                let nested = nested - 1
            endif
        endif
        let colcount = colcount + 1
    endfor
    return -1
endfunction

function! IndentBraces()
    let beforeletter = getline(".")[col(".") - 2]
    let nowletter = getline(".")[col(".") - 1]

    if beforeletter == ':'
        return "\n\t"

    elseif IsPair(beforeletter, nowletter) " (), focus on ')'
        return "\n\t\n\<BS>\<UP>\<END>"

    elseif index(g:close_brackets, nowletter) != -1 " (hello world), focus on )
        return "\n\<ESC>O\t"

    elseif index(g:open_brackets, beforeletter) != -1 " (hello, focus on h
        let close_bracket_colunm = CloseBracketColumn(beforeletter)
        if close_bracket_colunm == -1
            return "\n\t"

        else
            return "\n\t" . repeat("\<RIGHT>", close_bracket_colunm) . "\n\<BS>\<UP>\<ESC>I"
        endif

    else
        return "\n"
    endif
endfunction


function! BracketBackspace()
    let beforeletter = getline(".")[col(".") - 2]
    let nowletter = getline(".")[col(".") - 1]
    if IsPair(beforeletter, nowletter)
        return "\<RIGHT>\<BS>\<BS>"
    else
        return "\<BS>"
    endif
endfunction

function! OrgHandler()
    let target_directory = expand("~/.dotfiles/org.d")
    let target_file = target_directory . "/" . "org.md"
    call timer_start(10, { -> execute('edit ' . fnameescape(target_file))})
endfunction
