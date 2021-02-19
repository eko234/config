source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug 'alexherbo2/prelude.kak'
require-module prelude
plug 'alexherbo2/auto-pairs.kak'
require-module auto-pairs
plug 'danr/kakoune-easymotion'
plug 'h-youhei/kakoune-surround'
plug 'Delapouite/kakoune-registers'
plug 'eraserhd/kak-ansi'
plug "Delapouite/kakoune-buffers" %{
      map global user b ': enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
}
plug "andreyorst/fzf.kak" config %{
	map global user f -docstring "fzf" ': fzf-mode<ret>'
}
plug "ul/kak-lsp" do %{
     cargo install --locked --force --path .
}
# interface
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ wrap
add-highlighter global/ show-matching
set-face global MatchingChar black,blue
set global modelinefmt '%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]' # Default modeline.

plug "enricozb/tabs.kak" %{
  set-option global modelinefmt_tabs '%val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}}'
  # enter-user-mode tabs
}

##################
# tabs to spaces #
##################
hook global InsertChar \t %{
    exec -draft h @
                  }
set-option global tabstop 2
set-option global indentwidth 2
###############
# custom keys #
###############


map global normal <space> , -docstring 'leader'
map global normal , <space> -docstring 'leader'
map global user r ':tmux-repl-vertical<ret>' -docstring 'repl v'
map global user C  %{/([<lt>]{7})(.*)([>>]{7})} -docstring 'find conflict'
map global user y '<a-|>xclip -selection clipboard<ret>' -docstring 'copy outside'
map global user p '\i'
map global user w ':w<ret>' -docstring "save"
map global user e ':e ' -docstring "edit"
map global user <space> ':' -docstring "command.."
map global user m ':easy-motion-WORD<ret>' -docstring "easy motion"
map global user o ':tmux-terminal-horizontal kak %val{buffile}<ret>' -docstring "split h"
map global user k ':edit-kakrc<ret>' -docstring "kakrc"
map global user c ':comment-line<ret>' -docstring "comment"
declare-user-mode surround
map global surround s ':surround<ret>' -docstring 'surround'
map global surround c ':change-surround<ret>' -docstring 'change'
map global surround d ':delete-surround<ret>' -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
map global user s ':enter-user-mode surround<ret>' -docstring 'surround mode'
hook global WinCreate .* %{
addhl buffer/ column 80 default,rgb:404051
}

# lsp
hook global WinSetOption filetype=(rust|ruby|lisp|python|javascript|haskell|c|cpp|latex|css|scheme) %{
 lsp-enable-window
 lsp-auto-hover-enable
 set global lsp_hover_anchor true
 auto-pairs-enable
 # set global lsp_snippet_callback snippets-insert
}

hook global BufCreate '.*.rkt' %{
 set-option buffer filetype lisp
 auto-pairs-enable
}

plug "alexherbo2/connect.kak"
require-module connect
# lispy things
map global insert <a-1> 'λ'
declare-user-mode repl
map global user r ':enter-user-mode<space>repl<ret>' 
map global repl s ':send-text "%val{selection}<c-v><ret>" <ret>' -docstring "send selection to repl"
map global repl L ':send-text "racket<c-v><ret>"<ret>' -docstring "start racket in repl"
map global repl l ':send-text "(load ""%val{buffile}"")<c-v><ret>"<ret>' -docstring "load current file to repl"
map global repl g ':send-text "racket %val{buffile} <c-v><ret>"<ret>' -docstring "run current file"
