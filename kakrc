source "%val{config}/plugins/plug.kak/rc/plug.kak"

plug 'alexherbo2/prelude.kak'
require-module prelude
plug 'alexherbo2/auto-pairs.kak'
require-module auto-pairs

plug "andreyorst/kaktree" config %{
    hook global WinSetOption filetype=kaktree %{
        remove-highlighter buffer/numbers
        remove-highlighter buffer/matching
        remove-highlighter buffer/wrap
        remove-highlighter buffer/show-whitespaces
    }
    kaktree-enable
}

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

# tabs to spaces
hook global InsertChar \t %{
    exec -draft h @
                  }
set-option global tabstop 2
set-option global indentwidth 2

# custom keys
map global normal <space> , -docstring 'leader'
map global user r ':tmux-repl-vertical<ret>' -docstring 'repl v'
map global user t ':kaktree-toggle<ret>' -docstring 'tree'
map global user C  %{/([<lt>]{7})(.*)([>>]{7})} -docstring 'find conflict'
map global user y '<a-|>clip.exe<ret>' -docstring 'copy outside'
map global user w ':w<ret>' -docstring "save"
map global user e ':e' -docstring "edit"
map global user <space> ':' -docstring "command.."

# lsp
hook global WinSetOption filetype=(racket|rust|ruby|lisp|python|php|haskell|c|cpp|latex) %{
 lsp-enable-window
 lsp-auto-hover-enable
 set global lsp_hover_anchor true
 auto-pairs-enable
 # set global lsp_snippet_callback snippets-insert
}

plug "alexherbo2/connect.kak"
require-module connect
plug "listentolist/kakoune-rainbow" config %{
       require-module rainbow
#     # suggested mapping
       map global user B ": rainbow<ret>" -docstring "rainbow brackets"
       map global user R ": rmhl window/ranges_rainbow_specs<ret>" \
           -docstring "remove rainbow highlighter"
}

plug "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak"

# lispy things
map global user a 'iλ<esc>' -docstring "lambda" 
map global user s ':send-text "%val{selection}<c-v><ret>" <ret>' -docstring "send selection to repl" 
map global user L ':send-text "racket<c-v><ret>"<ret>' -docstring "start racket in repl"
map global user l ':send-text "(load ""%val{buffile}"")<c-v><ret>"<ret>' -docstring "load current file to repl"
map global user g ':send-text "racket %val{buffile} <c-v><ret>"<ret>' -docstring "run current file"


