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

plug 'danr/kakoune-easymotion'

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
  map global normal ^ q
  map global normal <a-^> Q
  map global normal q b
  map global normal Q B
  map global normal <a-q> <a-b>
  map global normal <a-Q> <a-B>

  map global normal b ': enter-user-mode tabs<ret>' -docstring 'tabs'
  map global normal B ': enter-user-mode -lock tabs<ret>' -docstring 'tabs (lock)'
}

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
map global user e ':e ' -docstring "edit"
map global user <space> ':' -docstring "command.."
map global user m ':easy-motion-WORD<ret>' -docstring "easy motion"

hook global WinCreate .* %{
  addhl buffer/ column 80 default,rgb:404051
}

# lsp
hook global WinSetOption filetype=(racket|rust|ruby|lisp|python|javascript|haskell|c|cpp|latex|css) %{
 lsp-enable-window
 lsp-auto-hover-enable
 set global lsp_hover_anchor true
 auto-pairs-enable
 # set global lsp_snippet_callback snippets-insert
}
plug "alexherbo2/connect.kak"
require-module connect
plug "https://bitbucket.org/KJ_Duncan/kakoune-racket.kak"
# lispy things
map global user a 'iλ<esc>' -docstring "lambda"
map global insert <a-1> 'λ'
map global user s ':send-text "%val{selection}<c-v><ret>" <ret>' -docstring "send selection to repl" 
map global user L ':send-text "racket<c-v><ret>"<ret>' -docstring "start racket in repl"
map global user l ':send-text "(load ""%val{buffile}"")<c-v><ret>"<ret>' -docstring "load current file to repl"
map global user g ':send-text "racket %val{buffile} <c-v><ret>"<ret>' -docstring "run current file"
