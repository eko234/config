# PLUGINS
source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyourst/plug.kak" noload
plug 'h-youhei/kakoune-surround'
plug 'Delapouite/kakoune-registers'
plug "Delapouite/kakoune-buffers" %{
      map global user b ': enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
}

plug "andreyorst/fzf.kak" config %{
	map global user f -docstring "fzf" ': fzf-mode<ret>'
}

plug "enricozb/tabs.kak" %{
  set-option global modelinefmt_tabs ' ♩ ♪ ♫ ♬ ♭ ♮ ♯ ♥ ♥ ♥ ¯\_(ツ)_/¯ %val{cursor_line}:%val{cursor_char_column}|%val{buf_line_count} {{context_info}} {{mode_info}}'
  # enter-user-mode tabs
}

# INTERFACE
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ show-matching
set-face global MatchingChar black,blue
set-option global tabstop 2
set-option global indentwidth 2
set-option global ui_options ncurses_assistant=cat

# MAPS
map global normal <space> , -docstring 'leader'
map global normal , <space> -docstring 'leader'
map global user y '<a-|>xclip -selection clipboard<ret>' -docstring 'copy outside'
map global user p '\i'
map global user w ':w<ret>' -docstring "save"
map global user e ':e ' -docstring "edit"
map global user E '!explorer.exe . <ret>' -docstring "explorer"
map global user <space> ':' -docstring "command.."
map global user k ':edit-kakrc<ret>' -docstring "kakrc"
map global user B ':edit ~/.bashrc<ret>' -docstring "bashrc"
map global user c ':comment-line<ret>' -docstring "comment"
map global user C ':comment-block<ret>' -docstring "comment"
map global user <a-Q> ':q!<ret>' -docstring "bye bye"
declare-user-mode surround
map global surround s ':surround<ret>' -docstring 'surround'
map global surround c ':change-surround<ret>' -docstring 'change'
map global surround d ':delete-surround<ret>' -docstring 'delete'
map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
map global user s ':enter-user-mode surround<ret>' -docstring 'surround mode'
map global insert <a-1> 'λ'
map global insert <a-2> '\'
# map global user R ':' 
# map global user K 

# HOOKS
hook global WinSetOption filetype=(lua|rust|ruby|lisp|python|javascript|haskell|c|cpp|latex|css|scheme) %{
  # something some day
}

hook global BufCreate '.*.rkt' %{
 set-option buffer filetype lisp
 auto-pairs-enable
}

hook global InsertChar \t %{
    exec -draft h @
}

define-command mt %{
  info -title "!" 'You
are
going
to
die'
}

define-command sh %{
  prompt "say hi: " %{echo %val{text}}
}
