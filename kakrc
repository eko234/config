# PLUGINS
source "%val{config}/plugins/plug.kak/rc/plug.kak"
evaluate-commands %sh{
  kcr init kakoune
}

hook global WinSetOption filetype=(python) %{
  set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
  lsp-enable-window
}

hook global WinSetOption filetype=(javascript) %{
  lsp-enable-window
}

plug "andreyorst/kaktree" config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}

plug 'alexherbo2/auto-pairs.kak'
require-module auto-pairs
auto-pairs-enable 

plug "andreyourst/plug.kak" noload
plug 'h-youhei/kakoune-surround'
plug 'Delapouite/kakoune-registers'
plug 'Delapouite/kakoune-palette'
plug 'KJ_Duncan/kakoune-kotlin.kak' domain "bitbucket.org"
plug "Delapouite/kakoune-buffers" %{
      map global user b ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
}

plug "andreyorst/fzf.kak" config %{
  map global user f -docstring "fzf" ': fzf-mode<ret>'
}

plug "enricozb/tabs.kak" %{
  set-option global modelinefmt_tabs '%val{cursor_line}:%val{cursor_char_column}|%val{buf_line_count} {{context_info}} {{mode_info}}'
  # enter-user-mode tabs
}

# INTERFACE
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ show-matching
set-face global MatchingChar black,blue
set-option global tabstop 2
set-option global indentwidth 2
set-option global ui_options ncurses_assistant=cat 
add-highlighter global/ wrap             -marker '↪ '
add-highlighter global/ regex \b(TODO|FIXME|XXX|NOTE|BUG|DEBUG|TBD|HACK)\b 0:default+rb

# MAPS
map global normal <space> ,                              -docstring 'leader'
map global normal , <space>                              -docstring 'leader'
map global user y '<a-|>xclip -selection clipboard<ret>' -docstring 'copy outside'
map global user p '\i'                                   -docstring 'no hookies'
map global user w ':w<ret>'                              -docstring "save"
map global user e ':e '                                  -docstring "edit"
map global user E '!explorer.exe . <ret>'                -docstring "explorer"
map global user <space> ':'                              -docstring "command.."
map global user k ':edit-kakrc<ret>'                     -docstring "kakrc"
map global user ¡ ':edit ~/.config/kak/plugins/kak-lsp/kak-lsp.toml<ret>' -docstring "w"
map global user K ':source "%val{config}/kakrc"<ret>'    -docstring "re-source"
map global user t ':edit ~/.tmux.conf<ret>'              -docstring "tmux"
map global user B ':edit ~/.bashrc<ret>'                 -docstring "bashrc"
map global user c ':comment-line<ret>'                   -docstring "comment"
map global user C ':comment-block<ret>'                  -docstring "comment"
map global user <a-Q> ':q!<ret>'                         -docstring "bye bye"
map global user r ':tmux-repl-vertical<ret>'             -docstring "repl"
declare-user-mode surround                               
map global surround s ':surround<ret>'                   -docstring 'surround'
map global surround c ':change-surround<ret>'            -docstring 'change'
map global surround d ':delete-surround<ret>'            -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>'     -docstring 'select tag'

define-command slurp-forward %@
  try %=execute-keys %#?(\)|\]|\}|>|"|')<ret>hl#=
  execute-keys %sh|
    case "$kak_selection" in
      ')') printf "%s\n" "d";;
      '}') printf "%s\n" "d";;
      ']') printf "%s\n" "d";;
      ">") printf "%s\n" "d";;
      '"') printf "%s\n" "d";;
      "'") printf "%s\n" "d";;
      *)   printf "%s\n" ":fail no_more_delimiters<ret>";;
    esac
  |
  execute-keys %&?(\(|\[|\{|<lt>|"|'|[a-zA-Z0-9\?!<lt><gt>]+)&
@

map global normal <a-J> ':execute-keys dpl<ret>'
map global normal <a-K> ':execute-keys dhPh<ret>'
# map global normal <a-L> ':slurp-forward'
# map global normal <a-L> ':slurp-backwards'
map global user s ':enter-user-mode surround<ret>'       -docstring 'surround mode'
map global normal <F1> '<c-o>' -docstring 'prev jump'
map global normal <F2> '<tab>' -docstring 'next jump'
map global insert <a-1> 'λ'
map global insert <a-2> '\'
map global normal <a-3> ':kaktree-toggle<ret>'
hook global BufCreate '.*.rkt' %{ set-option buffer filetype lisp }
hook global InsertChar \t %{ exec -draft h @ }
