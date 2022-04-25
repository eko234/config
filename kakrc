# FREE KEYS
# TAG:PLUGINS
# <a-!> this bad boy expands the expandables!
# %file{} expansions exists
# number params go to captures in searchs
# I can cretea a magic orderd set to implemetnsome nifty stuff, i can use commands that
# can ommit updating it to make a smart jumper or something
# NOTE remember kakoune piping is like actually echoing the selections already
source "%val{config}/plugins/plug.kak/rc/plug.kak"
source "%val{config}/auto-load/tree.kak"
set global tree_cmd 'kak-tree -c ~/.config/kak/kak-tree.toml'
set-option global tree_cmd '/home/jujo/kak-tree/target/release/kak-tree -c /home/jujo/.config/kak/kak-tree.toml '
source "%val{config}/auto-load/synonyms.kak"

plug "TeddyDD/kakoune-wiki" config %{
  wiki-setup %sh{ echo $HOME/wiki }
}

plug "https://gitlab.com/listentolist/kakoune-table.git"
plug "occivink/kakoune-filetree"
# plug "maximbaz/restclient.kak"

plug "delapouite/kakoune-buffers" %{
  map global user b ": enter-user-mode -lock buffers<ret>"
}

plug 'delapouite/kakoune-livedown'

plug "eko234/kakground" config %{
  alias global kg kakground
}

plug "eko234/git-konflict.kak" config %{
  declare-user-mode konflict
  map global user K ': enter-user-mode konflict<ret>'
  map global konflict s -docstring "Solve conflicts" ': konflict-start<ret>'
  map global konflict j -docstring "Use mine" ': konflict-use-mine<ret>'
  map global konflict k -docstring "Use yours" ': konflict-use-yours<ret>'
  map global konflict J -docstring "Use mine then yours" ': konflict-use-mine-then-yours<ret>'
  map global konflict K -docstring "Use yours then mine" ': konflict-use-yours-then-mine<ret>'
  map global konflict d -docstring "Use none" ': konflict-use-none<ret>'
}

plug "eko234/kakstate"
plug "eko234/kakoune-rectangles" config %{
  map global user <semicolon> ": rectangle<ret>"
}

plug "abuffseagull/kakoune-toggler" do %{ cargo install --path . } config %{
  map global normal <minus> ": toggle-word<ret>"
}

plug "eko234/meats" config %{
  declare-user-mode meats
  map global user  u ': enter-user-mode meats<ret>'
  map global meats u ': stabR<ret>' -docstring "STAB"
  map global meats i ': lickR<ret>' -docstring "LICK"
}

plug "eko234/kaktakomb" config %{
  set global kaktakomb_secret SUPAMEGASICRET
}

plug "eburghar/kakpipe" do %{
	cargo install --force --path . --root ~/.local
}

plug "dgmulf/local-kakrc" config %{
    set-option global source_local_kakrc true
}

require-module kakpipe

set-option global grepcmd "ag --column --noheading"
# TAG:INTERFACE
set global modelinefmt '%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} %val{client}@%val{session}:虚'
set-option global startup_info_version 99999999999999999999999999999999999999999999
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ show-matching
set-face global MatchingChar black,white
set-option global tabstop 2
set-option global indentwidth 2
set-option global autoinfo 'command'
set-option global ui_options terminal_status_on_top=yes terminal_assistant=cat
# set-option global ui_options terminal_assistant=cat
# add-highlighter global/ wrap -width 80 -word -indent -marker '↪ '
add-highlighter global/ wrap -word -indent -marker '↪ '
add-highlighter global/ regex \b(TODO|DATE|TAG|FIXME|XXX|NOTE|BUG|DEBUG|TBD|HACK|WONTFIX)\b 0:default+rb
# add-highlighter global/show-trailing-whitespaces regex '\h+$' 0:Error
# set-face global CurWord default,rgba:80808040
set-option global scrolloff 4,5

map global user H ": remove-highlighter global/curword <ret>"

hook global RegisterModified "/" %{
  add-highlighter -override global/search regex "%reg{/}" 0:+u
}

declare-option str-list rvb
hook global WinDisplay .* %{
  set-option -add global rvb %reg{percent}
  set-option global rvb %sh{
    echo $kak_opt_rvb | tr ' ' '\n' | awk '!seen[$0]++' | tac | tr '\n' ' '
  }
}

define-command show-recent-buffers -override %{
  info %sh{
    # paste <(echo "j\nk\nl\n;") <(echo $kak_opt_rvb | tr ' ' '\n' | tac) | sed 's/\t/ /g'
    # paste <(echo $kak_opt_rvb | tr ' ' '\n' | tac)
    res=$(paste <(printf "1\n2") <(printf "2\n3"))
    echo "FUCKER $res"
    # echo "fak"
  }
}

plug "gustavo-hms/luar" %{
  set-option global luar_interpreter "luajit"
  plug "gustavo-hms/peneira" %{
    require-module peneira
    #
    declare-user-mode fuzzy
    # set-option global peneira_files_command "find ."
    set-option global peneira_files_command "rg --files"
    set-face global PeneiraSelected default,rgb:2B3933
    map global user f ': enter-user-mode fuzzy<ret>' -docstring "fuzzy"
    map global fuzzy f ': peneira-files<ret>'        -docstring "files"
    map global fuzzy l ': peneira-lines<ret>'        -docstring "lines"
    map global fuzzy s ': peneira-symbols<ret>'      -docstring "symbols"
    define-command peneira-buffers %{
      peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
        buffer %arg{1}
      }
    }
    map global fuzzy b ': peneira-buffers<ret>'   -docstring "buffers"

  # define-command peneira-recent-buffers -override %{
    #   # { echo $kak_opt_rvb | tr ' ' '\n' | awk '!seen[$0]++' | tac }
    #   peneira 'recent buffers: ' %{ echo $kak_opt_rvb } %{
    #     buffer %arg{1}
    #   }
    # }
    # map global fuzzy r ': peneira-recent-buffers<ret>' -docstring "recent buffers"
  }
}

plug "occivink/kakoune-snippets" config %{
  set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
  set-option global snippets_auto_expand false
  map global insert <a-2> '<esc>:snippets-select-next-placeholders<ret>i'
  map global user S ':snippets-menu<ret>' -docstring "Snipptes"
  alias global spit snippets-insert
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
    # set-option global kaktree_size 50%
    set-option global kaktree_show_help false
    # set-option global kaktreeclient kak
    # set-option global kaktree_file_icon      '⠀⠀📄'
}

eval %sh{
  kcr init kakoune
}

# plug 'kakounedotcom/prelude.kak'
# plug 'kakounedotcom/connect.kak'
# plug 'alexherbo2/alacritty.kak'
# plug 'alexherbo2/auto-pairs.kak'
# enable-auto-pairs
plug "eko234/auto-pairs.klone"
require-module auto-pairs
auto-pairs-enable
plug 'h-youhei/kakoune-surround'
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

hook global BufSetOption filetype=nim %{
  set-option buffer formatcmd "nimfmt %val{buffile}"
  # set-option buffer formatcmd "nimpretty %val{buffile}"
}

hook global BufCreate .*[.](rkt|rktd|rktl|rkts) %{ set-option buffer filetype scheme}
hook global BufCreate .*[.](asdf|asd) %{ set-option buffer filetype lisp }
hook global BufCreate .*[.](raku|pm6|pmod.*) %{ set-option buffer filetype perl }
hook global InsertChar \t %{ exec -draft h @ }
eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log ~/kak-lsp-log"

hook global WinSetOption filetype=(python) %{
  set-option window tabstop 4
  set-option window indentwidth 4
}

hook global WinSetOption filetype=(clojure|go|ruby|racket|rust|scheme|python|lisp|javascript|typescript|c|cpp|pascal|json|html|css|bash|nim) %{
  # set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
  # lsp-auto-hover-enable
  lsp-enable-window
  lsp-semantic-tokens
  lsp-inline-diagnostics-enable window
  # lsp-inlay-diagnostics-enable window
  lsp-diagnositc-lines-enable window
  map global user h ":lsp-hover<ret>"
}

hook global WinSetOption filetype=(lisp) %{
  lsp-enable-window
  map global user h ":lsp-hover<ret>"
}

# TAG:COMMANDS
define-command -params .. \
    -docstring %{
       run a shell command and print its output to a fifo
     } fifo %{ evaluate-commands %sh{
     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-make.XXXXXXXX)/fifo
     mkfifo ${output}
     ( eval "$@" > ${output} 2>&1 & ) > /dev/null 2>&1 < /dev/null
     printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
               edit! -fifo ${output} -scroll *$1*
               hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
           }"
}}

define-command save-selection-to %{
  info -style modal "suck my duck"
  on-key %{
    info -style modal
    exec %sh{printf "\"$kak_key""Z\n"}
  }
}

define-command with-register %{
  info -title registers -- %sh{
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
     [ ! -z "$kak_key" ] && printf "\"$kak_key"
    }
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

define-command meths %{
  echo %sh{qalc "$kak_selection"}
}

define-command gotofileB -docstring "go to file relative to current" %{
  edit %sh{
    dirname "$kak_bufname" | xargs printf "%s/$kak_selection\n"
  }
}

define-command gotofileSB -docstring "go to file absolute" %{
  edit %sh{
    printf "$kak_selection\n"
  }
}

define-command pure %{
  nop %sh{ {
    pgrep ran.sh | xargs kill -9
    feh --bg-max ~/Pictures/p/void.png
  } > /dev/null 2>&1 < /dev/null & }
}

define-command stop %{
  nop %sh{ {
    pgrep ran.sh | xargs kill -9
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

define-command dicto -override %{
  prompt 'dicto!: ' %{
    eval -try-client docs kakpipe --prefix == --name DICTIONARY -- sdcv %val{text}
  }
}

define-command transl -override %{
  prompt 'transl!: ' %{
    eval -try-client docs kakpipe --prefix == --name TRANSLATION -- trans -brief %val{text}
  }
}

define-command wiq -override %{
  prompt 'wikiquery!: ' %{
    eval -try-client docs kakpipe --prefix == --name WIKIQ -- wiki %val{text}
  }
}

define-command split %{
  new eval buffer %val{bufname}
}

define-command ide -params 0..1 %{
    try %{ rename-session %arg{1} }
    rename-client main
    set-option global jumpclient main
    new rename-client tools
    set-option global toolsclient tools
    new rename-client docs
    set-option global docsclient docs
}

define-command idoc -params 0..1 %{
    try %{ rename-session %arg{1} }
    rename-client main
    set-option global jumpclient main
    new rename-client docs
    set-option global docsclient docs
}

define-command totools %{
  eval -try-client tools buffer %val{bufname}
}

define-command tagss %{
  peneira "GOTOTAG: " %{
    grep -n "$kak_opt_comment_line TAG:" $kak_bufname | xargs -0 echo
  } %{
    exec %sh{echo $1 | awk -F ":" '{printf"%s%s", $1, "g"}'}
  }
}

define-command query-cheat-sheet -override %{
  execute-keys -try-client docs %sh{
    echo ":e -scratch *cheat*<ret>"
    echo "%%d"
    echo "! cht.sh \?T<left><left><left>"
  }
}

define-command query-howdoi -override -params 1.. %{
  execute-keys -try-client docs %sh{
    echo ": e -scratch *how*<ret>"
    echo "%%d"
    echo "! howdoi $@<ret>"
  }
}

define-command info-on %{
  set-option global autoinfo 'command|onkey'
}

define-command info-off %{
  set-option global autoinfo 'command'
}

define-command toggleinfo -override %{
  eval %sh{
    on=$(echo $kak_opt_autoinfo | grep onkey)
    [ ! -z "$on" ] && echo "set-option global autoinfo command" || echo "set-option global autoinfo command|onkey"
  }
}

# TAG:MAPS
map global normal / '/(?i)'
map global normal ? '?(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal <a-?> '<a-?>(?i)'
map global normal <c-_> ':  set-register slash ""<ret>' ## for some reason this is <c-/>
map global normal <space> ,                              -docstring 'leader'
map global user 0 ': toggleinfo<ret>'              -docstring 'toggle info'
map global normal , <space>                              -docstring 'remove other selections'
map global normal <a-,> <a-space>                        -docstring 'remove main selection'
map global normal <c-y> '<a-|>xclip -i -selection clipboard<ret>'  -docstring 'copy'
map global normal <c-p> '\! xclip -o -selection clipboard<ret>'    -docstring 'paste'
map global normal <tab> '<c-i>vv'
map global normal <c-o> '<c-o>vv'
map global user w ':  w<ret>'                              -docstring "save"
map global user e ': execute-keys %{<esc>: synonyms-set-thesaurus th_en_US_v2<ret><esc>: synonyms-replace-selection<ret>}' -docstring "synonyms"
map global normal <c-k> ': kakpipe-toolsclient<ret>'    -docstring "kakpipe shorthand"
map global user c ':  comment-line<ret>'                   -docstring "comment"
map global user C ':  comment-block<ret>'                  -docstring "comment"
map global user F ':  format<ret>'                         -docstring "format"
map global normal <c-x> 's^<ret>s\s<ret>wbdi<backspace><ret><esc><space>' -docstring "naive format"
map global user x ':  restclient-execute<ret>'            -docstring "execute rest client"
declare-user-mode surround
# map global user s     ':  surround<ret>'       -docstring 'surround mode'
map global user s ':  enter-user-mode surround<ret>'       -docstring 'surround mode'
map global surround s ':  surround<ret>'                   -docstring 'surround'
map global surround c ':  change-surround<ret>'            -docstring 'change'
map global surround d ':  delete-surround<ret>'            -docstring 'delete'
map global surround t ':  select-surrounding-tag<ret>'     -docstring 'select tag'
map global normal = ': meths<ret>'
map global user d %{: dicto<ret>} -docstring "Dictionary"
map global user t %{: transl<ret>} -docstring "Translate"
declare-user-mode grep
map global user G ':  enter-user-mode -lock grep<ret>'   -docstring "grep mode"
map global user g ':  grep '                             -docstring 'grep '
map global grep h ':  grep %val{buffile}<c-a><a-f><a-f>' -docstring 'here'
map global grep s ':  grep %reg{.} <ret>'                -docstring "grep selection"
map global grep S ':  grep %reg{.} %val{buffile} <ret>'  -docstring "grep selection in current file"
map global grep n ':  grep-next-match<ret>'              -docstring 'next'
map global grep N ':  grep-previous-match<ret>'          -docstring 'prev'
map global grep d ':  delete-buffer *grep*<ret>'         -docstring 'delete grep buffer'
map global normal "'" "<a-i>w*"
map global normal <a-E> ':next-tag<ret>' -docstring "next Tag"
map global normal <a-A> ':prev-tag<ret>' -docstring "prev Tag"
map global user T ':add-tag<ret>' -docstring "Add tag"
# map global normal <F1> '<c-o>' -docstring 'prev jump'
# map global normal <F2> '<tab>' -docstring 'next jump'
# map global insert <a-1> 'λ'
# map global insert <a-2> 'ñ'
map global normal <a-3> ':kaktree-toggle<ret>'
map global user Q ': query-cheat-sheet<ret>' -docstring 'query cheat sheet'
map global user q ': query-howdoi ' -docstring 'query howdoi'
map global user i ': wiq<ret>' -docstring 'query wiki'
# map global goto L l
# map global goto H h
# map global goto J j
# map global goto K k
map global user R ': runasync '  -docstring "Run async"
map global user r ': with-register<ret>'  -docstring "with register"
declare-user-mode files
map global user k ": enter-user-mode files<ret>"                     -docstring "files"
map global files m '<esc>: gotofileB<ret>'                           -docstring "go to file full creating it"
map global files s '<esc>: gotofileSB<ret>'                          -docstring "go to file relative creating it"
map global files k '<esc>: edit ~/.config/kak/kakrc<ret>'            -docstring "go to main kakrc"
map global files p '<esc>: edit ./.kakrc<ret>'                       -docstring "go to porject local kakrc"
map global files ! '<esc>: edit ~/.config/kak-lsp/kak-lsp.toml<ret>' -docstring "Edit lsp config"
map global files A '<esc>: e ~/.config/alacritty/alacritty.yml<ret>' -docstring "alacritty"
map global files b '<esc>: edit ~/.bashrc<ret>'                      -docstring "bashrc"
map global files z '<esc>: edit ~/.zshrc<ret>'                      -docstring "bashrc"
map global user m ': make<ret>'            -docstring 'run phony make'
map global user M ': make '                -docstring 'prompt for make'
map global user a ': %val{selection}<home>' -docstring 'do to selection'
map global user A ': eval %val{selection}<ret> : echo ev!<ret>' -docstring 'eval selection'
map global user Z ': save-selection-to<ret>'
map global user z ': restore-selection-from<ret>'
map global user X '<a-i>w: snippets-expand-trigger<ret>'
declare-user-mode my-lsp
map global my-lsp h ': lsp-hover-buffer docs<ret>' -docstring 'open hover info in docs'
map global user p ': enter-user-mode lsp<ret>'
map global user P ': enter-user-mode my-lsp<ret>'
decl str curpapedir
decl str-list papelist
decl int curpapeix
decl str purepape "~/Pictures/p/void.png"

define-command shuffle-pape %{
  lua %opt{curpapedir} %{
    local curpapedir = args()
    local pfile = io.popen('ls -a "' .. curpapedir .. '" | grep -v /')
    local entries = -2 -- discarding cur and prev dir
    for filename in pfile:lines() do
      entries = entries + 1
    end
    pfile:close()
  }
}

define-command pick-pape-dir %{
  peneira "Pick pape dir: " %{
    printf "%s\n" $(ls -d ~/Pictures/p/*/ | sed 's/.$//' | xargs)
  } %{
    set global curpapedir %arg{1}
  }
}

# CHCHCHCHANGES
map global insert , ,<c-u>
map global insert . .<c-u>
map global insert ! !<c-u>
map global insert ? ?<c-u>

hook global InsertChar k %{ try %{
  exec -draft hH <a-k>jk<ret> d
  exec <esc>
}}

# plug "chambln/kakoune-kit" config %{
plug "eko234/kakoune-kit" config %{
    map global user o ': git status -bs<ret>' -docstring 'git status'
    hook global WinSetOption filetype=git-status %{
        map window normal c ': git commit --verbose '
        map window normal l ': git log --oneline --graph<ret>'
        map window normal d ': -- %val{selections}<a-!><home> git diff '
        map window normal D ': -- %val{selections}<a-!><home> git diff --cached '
        map window normal a ': -- %val{selections}<a-!><home> git add '
        map window normal A ': -- %val{selections}<a-!><home> terminal git add -p '
        map window normal r ': -- %val{selections}<a-!><home> git reset '
        map window normal R ': -- %val{selections}<a-!><home> terminal git reset -p '
        map window normal o ': -- %val{selections}<a-!><home> git checkout '
    }
    hook global WinSetOption filetype=git-log %{
        map window normal d     ': %val{selections}<a-!><home> git diff '
        map window normal <ret> ': %val{selections}<a-!><home> git show '
        map window normal r     ': %val{selections}<a-!><home> git reset '
        map window normal R     ': %val{selections}<a-!><home> terminal git reset -p '
        map window normal o     ': %val{selections}<a-!><home> git checkout '
    }
}

define-command hlcw -override %{
    eval -draft %{ try %{
            # exec <space><a-i>w <a-k>\A\w+\z<ret>
            # add-highlighter -override global/curword regex "\b\Q%val{selection}\E\b" 0:default+rb
            add-highlighter -override global/curword regex "%val{selection}" 0:default+rb
        } catch %{
            add-highlighter -override global/curword group
        }
    }
}

define-command git-diff-current-file -override %{
  execute-keys ": git diff %reg{percent}<ret>"
}

alias global gdcf git-diff-current-file
map global user h ": hlcw<ret>"
colorscheme base16-shitcake
colorscheme base16-cupcake
colorscheme ayu-mirage
colorscheme default
colorscheme minsk
colorscheme warm
# colorscheme ashes

define-command -override fzf-files %{
    > bash -c %{
fzf --preview 'cat {}' | xargs kcr edit
  }
}

define-command -override calen %{
    > bash -c %{
    cal
  }
}

declare-user-mode connect
map global user , ": enter-user-mode connect<ret>"
map global connect f ": fzf-files<ret>" -docstring %{ fuzzy find files }
map global connect r ": repl-new<ret>" -docstring %{ new repl }
map global connect s ": repl-send-text<ret>" -docstring %{ send text to repl }

define-command instascratch -docstring "open instantaneous scratch buffer" %{
  edit -scratch
}

alias global es instascratch

hook global ModuleLoaded tmux %{
    define-command popup -params 1.. -shell-completion -docstring '
    tmux-terminal-popup <program> [<arguments>]: create a new terminal as a tmux popup
    The program passed as argument will be executed in the new popup' \
    %{
        tmux-terminal-impl 'display-popup -E -h 75% -d #{pane_current_path}' %arg{@}
    }
}

# map global normal X 'xJx'
define-command git-stash -params .. %{
  echo %sh{
    git stash $@
  }
}

hook global BufWritePre .* %{
  try %{
    execute-keys -draft "<esc><percent><a-s><a-K>^\n<ret>s\s+$\n<ret>H<a-d>"
  } catch %{
    echo "Mmmm, those clean clean lines..."
  }
}

# add-highlighter -override global/curword regex "%val{selection}" 0:default+rb
# set-face global PrimarySelection default+rb
# set-face global SecondarySelection default+rbd

define-command expand -override %{
  execute-keys -draft %{| printf "%reg{dot}" <a-!><a-!><ret>}
}

map global user E ": expand<ret>"
