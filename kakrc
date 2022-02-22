# capture group are available in registers!!
# <a-S> is kinda cool for tags stuff dude
# <a-;> lets me go to normal mode for one shot commands, quite nice indeed
# TAG:PLUGINS
# NOTE remember kakoune piping is like actually echoing the selections already
source "%val{config}/plugins/plug.kak/rc/plug.kak"
# source "%val{config}/auto-load/tree.kak"
# set global tree_cmd 'kak-tree -c ~/.config/kak/kak-tree.toml'
# set-option global tree_cmd '/home/jujo/kak-tree/target/release/kak-tree -c /home/jujo/.config/kak/kak-tree.toml '
source "%val{config}/auto-load/synonyms.kak"
# plug "alexherbo2/tmux.kak"
# plug "Crote/kakoune-tmux-extra"
# plug "JacobTravers/kakoune-grep-write"
# plug "eraserhd/kak-ansi"
plug "TeddyDD/kakoune-wiki" config %{
  wiki-setup %sh{ echo $HOME/wiki }
}
plug "maximbaz/restclient.kak"
plug "eburghar/kakpipe" do %{
	cargo install --force --path . --root ~/.local
}
plug "dgmulf/local-kakrc" config %{
    set-option global source_local_kakrc true
}

# plug "listentolist/kakoune-table" domain "gitlab.com" config %{
#     # suggested mappings
#     # map global user t ": evaluate-commands -draft table-align<ret>" -docstring "align table"
#     # map global user t ": table-enable<ret>" -docstring "enable table mode"
#     # map global user T ": table-disable<ret>" -docstring "disable table mode"
#     # map global user t ": table-toggle<ret>" -docstring "toggle table mode"
#     # map global user t ": enter-user-mode table<ret>" -docstring "table"
#     # map global user T ": enter-user-mode -lock table<ret>" -docstring "table (lock)"
# }

# plug "abuffseagull/kakoune-discord" do %{ cargo install --path . --force } %{
#   discord-presence-enable
# }

# plug "1g0rb0hm/search.kak" config %{
#   set-option global search_context 3 # number of context lines
# }

require-module kakpipe
# eval %sh{ kcr init kakoune }
# eval %sh{ kks init }

set-option global grepcmd "ag --column"

# TAG:INTERFACE
define-command -override remove-scratch-message -docstring 'remove scratch message' %{
  remove-hooks global remove-scratch-message
  hook -group remove-scratch-message global BufCreate '\*scratch\*' %{
    execute-keys '%d'
    hook -always -once buffer NormalIdle '' %{
      rename-buffer /dev/null
      evaluate-commands -no-hooks -- edit -scratch '*scratch*'
      delete-buffer /dev/null
    }
  }
}

remove-scratch-message
set-option global startup_info_version 999999999999999999999999

plug "andreyorst/powerline.kak" defer powerline %{
    set-option global powerline_separator ""
    set-option global powerline_separator_thin ""
    # set-option global powerline_format 'git bufname line_column mode_info filetype client session position'
    set-option global powerline_format 'git bufname line_column mode_info filetype client session position tomato'
} config %{
    powerline-start
}

add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ show-matching
set-face global MatchingChar black,white
set-option global tabstop 2
set-option global indentwidth 2
set-option global ui_options terminal_status_on_top=yes terminal_assistant=cat
# set-option global ui_options terminal_assistant=cat
add-highlighter global/ wrap             -marker '↪ '
add-highlighter global/ regex \b(TODO|TAG|FIXME|XXX|NOTE|BUG|DEBUG|TBD|HACK|WONTFIX)\b 0:default+rb
# add-highlighter global/show-trailing-whitespaces regex '\h+$' 0:Error
# set-face global CurWord default,rgba:80808040
set-option global scrolloff 4,5
hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        # add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:CurWord
        add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:default+rb
    } catch %{
        add-highlighter -override global/curword group
    }
    }
}

hook global RegisterModified "/" %{
  add-highlighter -override global/search regex "%reg{/}" 0:+u
}

# plug "chambln/kakoune-kit"
# plug "danr/kakoune-easymotion"
plug "gustavo-hms/luar" %{
  set-option global luar_interpreter "luajit"
  plug "gustavo-hms/peneira" %{
    require-module peneira
    #
    declare-user-mode fuzzy
    # set-option global peneira_files_command "find ."
    set-option global peneira_files_command "rg --files"
    map global user f ': enter-user-mode fuzzy<ret>' -docstring "fuzzy"
    map global fuzzy f ' :peneira-files<ret>'        -docstring "files"
    map global fuzzy l ': peneira-lines<ret>'        -docstring "lines"
    map global fuzzy s ': peneira-symbols<ret>'      -docstring "symbols"

    define-command peneira-buffers %{
      peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
        buffer %arg{1}
      }
    }
    map global fuzzy b ': peneira-buffers<ret>'   -docstring "buffers"

    # define-command peneira-tags %{
    #   peneira 'tags: ' %{ printf "%s\n" $kak_opt_comment_line}
    # }

    # map global fuzzy t ': peneira-tags<ret>' -docstring "tags"
  }

  # plug "raiguard/harpoon.kak" %{
  #   harpoon-add-bindings
  # }
}

plug "occivink/kakoune-snippets" config %{
  set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
  set-option global snippets_auto_expand false
  map global insert <a-2> '<esc>:snippets-select-next-placeholders<ret>i'
  map global user S ':snippets-menu<ret>' -docstring "Snipptes"
}

plug "andreyorst/kakoune-snippet-collection"

plug "andreyorst/kaktree" config %{
      hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
        remove-highlighter buffer/wrap
    }
    kaktree-enable
    # set-option global kaktree_dir_icon_open  '▾ 🗁 '
    # set-option global kaktree_dir_icon_close '▸ 🗀 '
    # set-option global kaktree_file_icon      '⠀⠀🖺'
    set-option global kaktree_dir_icon_open  '▾ 📂'
    set-option global kaktree_dir_icon_close '▸ 📁'
    set-option global kaktree_file_icon      '⠀⠀🦆'
    set-option global kaktree_show_help false
    # set-option global kaktree_file_icon      '⠀⠀📄'
}

plug 'alexherbo2/auto-pairs.kak'
enable-auto-pairs
#require-module auto-pairs
#auto-pairs-enable

# plug "andreyourst/plug.kak" noload
plug 'h-youhei/kakoune-surround'
# plug 'Delapouite/kakoune-registers'
# plug 'Delapouite/kakoune-palette'

# plug "Delapouite/kakoune-buffers" %{
#   map global user b ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
# }

# TAG:HOOKS
hook global WinCreate    .* 'git show-diff'
hook global BufWritePost .* %{ git update-diff }
hook global BufWritePre .* %{
  nop %sh{
    container=$(dirname "$kak_hook_param")
    test -d "$container" ||
      mkdir --parents "$container"
  }
}

hook global BufCreate (.*)kakrc %{
  set-option buffer filetype kak 
}

hook global BufSetOption filetype=javascript %{
    set-option buffer formatcmd "prettier --stdin-filepath=%val{buffile}"
}

hook global BufSetOption filetype=janet %{
  set-option buffer formatcmd "jfmt"
}

hook global BufCreate .*[.](rkt|rktd|rktl|rkts) %{ set-option buffer filetype scheme}
hook global BufCreate .*[.](asdf|asd) %{ set-option buffer filetype lisp}
hook global InsertChar \t %{ exec -draft h @ }
hook global WinSetOption filetype=(fennel) %{
  # set-option buffer comment_line 'i'
  hook window InsertChar \] -always %{
    # execute-keys '<esc>i'
  }
  # waiting for them to merge the accumulate keyword
  evaluate-commands %sh{
      # Grammar
      keywords="require-macros eval-compiler doc lua hashfn macro macros import-macros pick-args pick-values macroexpand macrodebug
                do values if when each for fn lambda λ partial while set global var local let tset set-forcibly! doto match or and
                not not= collect icollect accumulate rshift lshift bor band bnot bxor with-open"
      re_keywords='\\$ \\$1 \\$2 \\$3 \\$4 \\$5 \\$6 \\$7 \\$8 \\$9 \\$\\.\\.\\.'
      builtins="_G _VERSION arg assert bit32 collectgarbage coroutine debug
                dofile error getfenv getmetatable io ipairs length load
                loadfile loadstring math next os package pairs pcall
                print rawequal rawget rawlen rawset require select setfenv
                setmetatable string table tonumber tostring type unpack xpcall"
      join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }
  # Add the language's grammar to the static completion list
      printf %s\\n "declare-option str-list fennel_static_words $(join "${keywords} ${builtins} false nil true" ' ')"
      # Highlight keywords
      printf %s "
          add-highlighter shared/fennel/code/keywords regex \b($(join "${keywords} ${re_keywords}" '|'))\b 0:keyword
          add-highlighter shared/fennel/code/builtins regex \b($(join "${builtins}" '|'))\b 0:builtin
      "
  }
}

eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log ~/kak-lsp-log"
hook global WinSetOption filetype=(ruby|racket|rust|scheme|python|lisp|javascript|json|html|css|bash) %{
  # set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
  # lsp-inline-diagnostics-enable window
  # lsp-auto-hover-enable
  lsp-enable-window
  map global user h ":lsp-hover<ret>"
}

# TAG:COMMANDS

define-command save-selection-to %{
  info -style modal "Venomify your feet!"
  on-key %{
    info -style modal
    exec %sh{printf "\"$kak_key""Z\n"}
  }
}

define-command restore-selection-from %{
  info -style modal %sh{
    printf "Pick your poison:\n"
    [ ! -z "$kak_reg_a" ] && printf "a :: %s\n" "$kak_reg_a"
    [ ! -z "$kak_reg_b" ] && printf "b :: %s\n" "$kak_reg_b"
    [ ! -z "$kak_reg_c" ] && printf "c :: %s\n" "$kak_reg_c"
    [ ! -z "$kak_reg_d" ] && printf "d :: %s\n" "$kak_reg_d"
    [ ! -z "$kak_reg_e" ] && printf "e :: %s\n" "$kak_reg_e"
    [ ! -z "$kak_reg_f" ] && printf "f :: %s\n" "$kak_reg_f"
    [ ! -z "$kak_reg_g" ] && printf "g :: %s\n" "$kak_reg_g"
    [ ! -z "$kak_reg_h" ] && printf "h :: %s\n" "$kak_reg_h"
    [ ! -z "$kak_reg_i" ] && printf "i :: %s\n" "$kak_reg_i"
    [ ! -z "$kak_reg_j" ] && printf "j :: %s\n" "$kak_reg_j"
    [ ! -z "$kak_reg_k" ] && printf "k :: %s\n" "$kak_reg_k"
    [ ! -z "$kak_reg_l" ] && printf "l :: %s\n" "$kak_reg_l"
    [ ! -z "$kak_reg_m" ] && printf "m :: %s\n" "$kak_reg_m"
    [ ! -z "$kak_reg_n" ] && printf "n :: %s\n" "$kak_reg_n"
    [ ! -z "$kak_reg_o" ] && printf "o :: %s\n" "$kak_reg_o"
    [ ! -z "$kak_reg_p" ] && printf "p :: %s\n" "$kak_reg_p"
    [ ! -z "$kak_reg_q" ] && printf "q :: %s\n" "$kak_reg_q"
    [ ! -z "$kak_reg_r" ] && printf "r :: %s\n" "$kak_reg_r"
    [ ! -z "$kak_reg_s" ] && printf "s :: %s\n" "$kak_reg_s"
    [ ! -z "$kak_reg_t" ] && printf "t :: %s\n" "$kak_reg_t"
    [ ! -z "$kak_reg_u" ] && printf "u :: %s\n" "$kak_reg_u"
    [ ! -z "$kak_reg_v" ] && printf "v :: %s\n" "$kak_reg_v"
    [ ! -z "$kak_reg_w" ] && printf "w :: %s\n" "$kak_reg_w"
    [ ! -z "$kak_reg_x" ] && printf "x :: %s\n" "$kak_reg_x"
    [ ! -z "$kak_reg_y" ] && printf "y :: %s\n" "$kak_reg_y"
    [ ! -z "$kak_reg_z" ] && printf "z :: %s\n" "$kak_reg_z"
  }
  on-key %{
    info -style modal
    exec %sh{
     [ ! -z "$kak_key" ] && printf "\"$kak_key""z\n"
    }
  }
}

define-command kakpipe-toolsclient %{
  prompt -shell-completion ':: ' %{
    eval -try-client tools %{kakpipe -S -w -- sh -c %val{text}}
  }
}

define-command kp -params 2 %{
  eval -try-client tools %{
    kakpipe -S -N %arg{1} -w -- sh -c "%arg{2}"
  }
}

define-command bg -params .. %{
  nop %sh{ {
    $@ & echo $!
    echo "eval -client '$kak_client' 'spawned $!'" | kak -p ${kak_session}
  } > /dev/null 2>&1 < /dev/null & }
}

define-command next-tag %{
  execute-keys %sh{
    comment=${kak_opt_comment_line}
    printf "?^%s TAG:<ret>;ghvt" $comment
  }
}

define-command prev-tag %{
  execute-keys %sh{
    comment=${kak_opt_comment_line}
    printf "<a-?>^%s TAG:<ret>;ghvt" $comment
  }
}

define-command add-tag %{
  execute-keys %sh{
    comment=${kak_opt_comment_line}
    printf "ghi%s TAG:" $comment
  }
}

define-command meth %{
  prompt "meth: " %{
    echo %sh{ qalc "$kak_text" } 
  }
}

define-command gotofileB %{
  edit %sh{
    dirname "$kak_bufname" | xargs printf "%s/$kak_selection\n"
  }
}
 
define-command pure %{
  nop %sh{ {
    pgrep ran.sh | xargs kill -9
    feh --bg-max ~/Pictures/p/void.png
  } > /dev/null 2>&1 < /dev/null & }
}

define-command bgru -params 1 %{
  nop %sh{ {
    ~/scripts/ran.sh "$1" 3 &
  } > /dev/null 2>&1 < /dev/null & }
}

define-command bgru-p %{
  peneira "Pick your poison: " %{
    printf "%s\n" $(ls -d ~/Pictures/p/*/ | sed 's/.$//' | xargs)
  } %{
    eval bgru %arg{1}
  }
}

define-command runasync -params .. %{
  nop %sh{ {
    $@
  } > /dev/null 2>&1 < /dev/null & }
}

define-command dicto %{
  prompt 'dicto!: ' %{eval kakpipe -S --prefix == --name DICTIONARY -- sdcv %val{text}}
}

define-command transl %{
  prompt 'transl!: ' %{eval kakpipe -S --prefix == --name TRANSLATION -- trans -brief %val{text}}
}

define-command split %{
  new eval buffer %val{bufname} ';' select %val{selection}
}

define-command ide -params 0..1 %{
    try %{ rename-session %arg{1} }

    rename-client main
    set-option global jumpclient main

    new rename-client tools
    set-option global toolsclient tools

    # new rename-client docs
    # set-option global docsclient docs
}

define-command totools %{
  eval -try-client tools buffer %val{bufname}
}

define-command supah-commands %{
  peneira "DO: " %{
printf "pure
bgru-p"
  } %{
    eval %arg{1}
  }
}

define-command supin %{
  peneira ":|=|: " %{
printf "wikim
tagss
meth
dicto"
  } %{
    eval %arg{1}
  }
}

define-command tagss %{
  peneira "GOTOTAG: " %{
    grep -n "$kak_opt_comment_line TAG:" $kak_bufname | xargs -0 echo
  } %{
    exec %sh{echo $1 | awk -F ":" '{printf"%s%s", $1, "g"}'}
  }
}

define-command query-cheat-sheet %{
  execute-keys %sh{
    printf ":e -scratch *cheat*<ret>"
    printf "%%d"
    printf "! cht.sh \?T<left><left><left>"
  }
}

define-command query-howdoi %{
  execute-keys %sh{
    printf ":e -scratch *how*<ret>"
    printf "%%d"
    printf "! howdoi "
  }
}

# TAG:MAPS
map global normal / '/(?i)'
map global normal ? '?(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal <a-?> '<a-?>(?i)'
map global normal <c-_> ':  set-register slash ""<ret>' ## for some reason this is <c-/>
map global normal <space> ,                              -docstring 'leader'
map global normal , <space>                              -docstring 'remove other selections'
map global normal <a-,> <a-space>                        -docstring 'remove main selection'
map global normal <c-y> '<a-|>xclip -i -selection clipboard<ret>'
map global user p '\i'                                   -docstring 'no hookies'
map global user w ':  w<ret>'                              -docstring "save"
map global user e ': execute-keys %{<esc>: synonyms-set-thesaurus th_en_US_v2<ret><esc>: synonyms-replace-selection<ret>}'    -docstring "synonyms"
map global user k ':  edit ~/.config/kak/kakrc<ret>'                     -docstring "kakrc"
map global user ! ':  edit ~/.config/kak-lsp/kak-lsp.toml<ret>' -docstring "Edit lsp config"
map global normal <c-k> ': kakpipe-toolsclient<ret>'    -docstring "kakpipe shorthand"
map global user K ':  source "%val{config}/kakrc"<ret>'    -docstring "re-source"
map global user A ':  e ~/.config/alacritty/alacritty.yml<ret>' -docstring "alacritty"
map global user B ':  edit ~/.bashrc<ret>'                 -docstring "bashrc"
map global user c ':  comment-line<ret>'                   -docstring "comment"
map global user C ':  comment-block<ret>'                  -docstring "comment"
map global user F ':  format<ret>'                         -docstring "format"
# map global normal <c-t> '<c-s>%s\h+$<ret>d<space><c-o><c-o>'
map global normal <c-x> 's^<ret>s\s<ret>wbdi<backspace><ret><esc><space>' -docstring "naive format"
# map global normal ^ '<a-`>'
map global user x ':  restclient-execute<ret>'            -docstring "execute rest client"
declare-user-mode surround
map global user s     ':  enter-user-mode surround<ret>'       -docstring 'surround mode'
map global surround s ':  surround<ret>'                   -docstring 'surround'
map global surround c ':  change-surround<ret>'            -docstring 'change'
map global surround d ':  delete-surround<ret>'            -docstring 'delete'
map global surround t ':  select-surrounding-tag<ret>'     -docstring 'select tag'
map global normal = ': meth<ret>'
map global user d %{: dicto<ret>} -docstring "Dictionary"
map global user t %{: transl<ret>} -docstring "Translate"
declare-user-mode grep
map global user G ':  enter-user-mode -lock grep<ret>' -docstring "grep mode"
map global user g ':  grep '                           -docstring 'grep '
map global grep n ':  grep-next-match<ret>'            -docstring 'next'
map global grep N ':  grep-previous-match<ret>'        -docstring 'prev'
map global grep d ':  delete-buffer *grep*<ret>'       -docstring 'delete grep buffer'
map global normal "'" "<a-i><a-w>*"
map global normal <a-E> ':next-tag<ret>' -docstring "next Tag"
map global normal <a-A> ':prev-tag<ret>' -docstring "prev Tag"
map global user T ':add-tag<ret>' -docstring "Add tag"
map global normal <F1> '<c-o>' -docstring 'prev jump'
map global normal <F2> '<tab>' -docstring 'next jump'
# map global insert <a-1> 'λ'
# map global insert <a-2> 'ñ'
map global normal <a-3> ':kaktree-toggle<ret>'
# map global user Q ':query-cheat-sheet<ret>' -docstring 'query cheat sheet'
map global user q ':query-howdoi<ret>' -docstring 'query howdoi'
# map global goto L l
# map global goto H h
# map global goto J j
# map global goto K k
map global user l ': supah-commands<ret>' -docstring "SUPA OUT"
map global user <semicolon> ': supin<ret>' -docstring "SUPA IN"
map global user r ': runasync '  -docstring "Run async"
# this shit wont work lmao
map global goto m ': gotofileB<ret>'       -docstring "go to file creating it"
map global user m ': make<ret>'            -docstring 'run phony make'
map global user M ': make '                -docstring 'prompt for make'
map global user a ': %val{selection}<c-a>' -docstring 'do to selection'
map global user Z ' :save-selection-to<ret>'
map global user z ' :restore-selection-from<ret>'
