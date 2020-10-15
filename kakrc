source "%val{config}/plugins/plug.kak/rc/plug.kak"

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

plug 'alexherbo2/prelude.kak'
require-module prelude
plug 'alexherbo2/auto-pairs.kak'
require-module auto-pairs

colorscheme default
# interface
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ wrap
add-highlighter global/ show-matching
# custom keys
map global normal <space> , -docstring 'leader'
map global user r ':tmux-repl-vertical<ret>' -docstring 'repl v'
map global user t ':kaktree-toggle<ret>' -docstring 'tree'
map global user C  %{/([<lt>]{7})(.*)([>>]{7})} -docstring 'find conflict'
map global user y '<a-|>clip.exe<ret>' -docstring 'copy outside'

# tabs to spaces
hook global InsertChar \t %{
    exec -draft h @
                  }
                   
set-option global tabstop 2
set-option global indentwidth 2
                  
hook global WinSetOption filetype=(rust|ruby|lisp|python|php|haskell|c|cpp|latex) %{
 lsp-enable-window
 lsp-auto-hover-enable
 set global lsp_hover_anchor true
 auto-pairs-enable

 # set global lsp_snippet_callback snippets-insert
}



plug "eraserhd/parinfer-rust" do %{
      cargo install --force --path .
} config %{
      hook global WinSetOption filetype=(clojure|lisp|scheme|racket) %{
                parinfer-enable-window -smart
    }
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





plug 'JJK96/kakoune-repl-send' %{
    # Suggested mapping
  map global normal <backspace> ': repl-send<ret>'
}



hook global WinSetOption filetype=lisp %{
    repl-send-start
    set window repl_send_command "sbcl"
    set window repl_send_exit_command "(exit)"
}


# lispy things
map global user s ':send-text "%val{selection}<c-v><ret>" <ret>' -docstring "send selection to repl" 
map global user L ':send-text "sbcl<c-v><ret>"<ret>' -docstring "start sbcl in repl"
map global user l ':send-text "(load ""%val{buffile}"")<c-v><ret>"<ret>' -docstring "load current file to repl"



