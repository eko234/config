# PLUGINS
source "%val{config}/plugins/plug.kak/rc/plug.kak"

evaluate-commands %sh{
  kcr init kakoune
}

plug "maximbaz/restclient.kak"
plug "chambln/kakoune-kit"

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
  enter-user-mode tabs
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
map global user ¡ ':edit ~/.config/kak-lsp/kak-lsp.toml<ret>' -docstring "w"
map global user K ':source "%val{config}/kakrc"<ret>'    -docstring "re-source"
map global user A ':e ~/.config/alacritty/alacritty.yml<ret>' -docstring "alacritty"
map global user t ':edit ~/.tmux.conf<ret>'              -docstring "tmux"
map global user B ':edit ~/.bashrc<ret>'                 -docstring "bashrc"
map global user c ':comment-line<ret>'                   -docstring "comment"
map global user C ':comment-block<ret>'                  -docstring "comment"

map global user <a-Q> ':q!<ret>'                        -docstring "bye bye"
map global user r ':tmux-repl-vertical<ret>'            -docstring "repl"
map global user R ':tmux-repl-horizontal<ret>'          -docstring "repl"
map global normal <backspace> ':send-text<ret>'           -docstring "send text"   
map global user x ':restclient-execute<ret>'            -docstring "execute rest client"

declare-user-mode surround 
map global user s ':enter-user-mode surround<ret>'       -docstring 'surround mode'
map global surround s ':surround<ret>'                   -docstring 'surround'
map global surround c ':change-surround<ret>'            -docstring 'change'
map global surround d ':delete-surround<ret>'            -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>'     -docstring 'select tag'

declare-user-mode grep
map global user g ':enter-user-mode -lock grep<ret>' -docstring "grep mode"
map global grep g ':grep '                           -docstring 'grep '
map global grep n ':grep-next-match<ret>'            -docstring 'next'
map global grep N ':grep-previous-match<ret>'        -docstring 'prev'
map global grep d ':delete-buffer *grep*<ret>'       -docstring 'delete grep buffer'

declare-user-mode move-mode
map global user m ':enter-user-mode -lock move-mode<ret>'
map global move-mode h 'dhPh'
map global move-mode l 'dpl'
map global move-mode ) 'f)'
map global move-mode ( 'f('
map global move-mode  <a-)> '<a-f>)'
map global move-mode  <a-(> '<a-f>('

map global normal <F1> '<c-o>' -docstring 'prev jump'
map global normal <F2> '<tab>' -docstring 'next jump'
map global insert <a-1> 'λ'
map global insert <a-2> '\'
map global normal <a-3> ':kaktree-toggle<ret>'
hook global BufCreate .*[.](rkt|rktd|rktl|rkts) %{ set-option buffer filetype scheme}
hook global BufCreate .*[.](asdf|asd) %{ set-option buffer filetype lisp}
hook global InsertChar \t %{ exec -draft h @ }


# THIS IS FOR WHEN I HAVE ACTUAL LSP INSTALLED 
# plug "kak-lsp/kak-lsp" do %{
#   cargo install --locked --force --path .
# }

# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log ~/kak-lsp-log"

# hook global WinSetOption filetype=(racket|scheme|python|lisp|javascript|json|html|css|bash) %{
#   set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
#   lsp-enable-window
#   lsp-inlay-diagnostics-enable window
#   lsp-auto-hover-enable
# }

