func! CompassCompl(st,base)
    if a:st
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '[a-z0-9\$@]' 
            let start -= 1
        endwhile
        return start
      else

        let basefilename='~/.compass-ui/autocomplete_cache/'. substitute( expand('%:p'), '[^a-z0-9]', '_','g')   
        if a:base[0] == "$"
            let wordfile=basefilename. "_variable"
            let get_word_cmd='test -f '. wordfile .' && cat '. wordfile .'|tr "\n" ,'
            exe 'let wordlist=['. system(get_word_cmd) . ']'

            " add variable in current file
            let file = getline(1, '$') 
            let jfile = join(file, ' ') 
            let int_vals = split(jfile, '\ze\$')
            let int_vars = {} 
            for i in int_vals
                let val = matchstr(i, '^\$[a-z_][a-z_\-0-9]*')
                if val != ''
                    call add(wordlist, val)
                endif
            endfor

        else
            let line = getline('.')
            if line =~ '@include'
              let wordfile=basefilename. "_mixin"
              let get_word_cmd='test -f '. wordfile .' && cat '. wordfile .'|tr "\n" ,'
              exe 'let wordlist=['. system(get_word_cmd) . ']'

              " add mixin in current file
              let int_vals = getline(1, '$')
              let int_vars = {} 
              for i in int_vals
                let val = matchlist(i, '^@mixin \([a-z0-9\_]*[^{]*\)')
                if len(val) > 0 && val[1] != ''
                  call add(wordlist, val[1])
                endif
              endfor

              " if you need complete mixin args, comment below 5 lines
              let clean_wordlist = []
              for i in wordlist
                call add(clean_wordlist, matchstr(i, "^[a-z0-9\-_]*"))
              endfor
              let wordlist = clean_wordlist

            endif
        endif

        " if we got scss words
        if exists('wordlist')
            let res = []
            for m in wordlist
                if m =~ '^' . a:base
                    call add(res, m)
                endif
            endfor

            return res
        end 
        
        " default match csscomplete#CompleteCSS 
        return csscomplete#CompleteCSS(0, a:base)
    endif
endfunc
autocmd BufNewFile,BufRead *.scss  set ft=scss.css iskeyword+=- ofu=CompassCompl
autocmd BufNewFile,BufRead *.sass  set ft=sass.css iskeyword+=- ofu=CompassCompl

