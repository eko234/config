#some notes
#Zave zeek zelectionZ
#* set selection as search pattern
#ga last buffer

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
# map global user <a-C> ':comment-box<ret>'              -docstring "comment"

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

plug "kak-lsp/kak-lsp" do %{
  cargo install --locked --force --path .
}

set global lsp_cmd "kak-lsp -s %val{session} -vvv --log ~/kak-lsp-log"

hook global WinSetOption filetype=(racket|scheme|python|lisp|javascript|json|html|css|bash) %{
  set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
  lsp-enable-window
  lsp-inlay-diagnostics-enable window
  lsp-auto-hover-enable
}

# plugin

# list projects
# rename project
# project = {name, path, last-update?}

# use:
# when you list projects you can:
# 1) go to a project
# 2) rename a project keeping the path
# 3) delete a project
# 4) add a project
# 5) show full path
# so i must create a temporal buffer to show project info and in that buffer enable those keys
declare-user-mode binnacle


# parameterized for linux, if you use apple stuff, configure
# path resolver and base name program options
# if for some reason a process fails and the config file gets empty
# you can try and recover from the temporal file binnacle.tmp
declare-option str binnacle_dir_path "%sh{ echo $HOME }/.config/binnacle/"
declare-option str binnacle_config_path "%sh{ echo $HOME }/.config/binnacle/binnacle.json"
declare-option str binnacle_config_tmp_path "%sh{ echo $HOME }/.config/binnacle/binnacle.tmp"

declare-option str binnacle_abs_path_program "readlink -f"
declare-option str binnacle_base_name_program "basename"
declare-option bool binnacle_create_beacons yes
declare-option bool binnacle_kill_orphan_beacons yes
declare-option bool binnacle_fresh_beacon_on_path_change yes

# a beacon could be a json
# object with fields like greeting,
# notes... that can be customized
# but at first it can be plain text
# and the user will do what he will

map global user P ':enter-user-mode binnacle<ret>'

map global binnacle l -docstring 'list projects' ':list projects'
map global binnacle a -docstring 'add project'   ':add-project-prompt'


# first run the command binnacle_setup

define-command binnacle-setup %{
  execute-keys %sh{
    if [ -d ${kak_opt_binnacle_dir_path} ] && [ -f ${kak_opt_binnacle_config_path} ];
    then
      echo ':echo already setup<ret>'
    else
      [ ! -d ${kak_opt_binnacle_dir_path} ]\
      && mkdir -p ${kak_opt_binnacle_dir_path}
      [ ! -f ${kak_opt_binnacle_config_path} ]\
      && echo '{"projects": {}}' > ${kak_opt_binnacle_config_path}
    fi
  }
}

map global user z :add-project<ret> 

# PUBLIC
define-command add-project %{
  add-project-p1
}

define-command open-binnacle-buffer %{
  e ¡binnacle! -scratch
  execute-keys "iwelcome back, these are your projects <esc>gh"
  set-option buffer readonly true
}

# define-command rename-project
# define-command delete-project
# define-command change-project-path
# define-command go-to-project

# HIDDEN
define-command -hidden add-project-p1 %{
  prompt -file-completion "enter project dir (defaults to current dir): " %{add-project-p2 %val{text}}
}

define-command -hidden add-project-p2 -params 1 %{
  prompt "enter project alias (defaults to base dir): " %{add-project-i %sh{echo $1} %val{text}} 
}

#TODO
#define hooks for beacon files
#define hooks for binnacle buffer
#maybe define something like a main beacon
define-command -hidden add-project-i -file-completion -params 1..2 %{
  execute-keys %sh{
    case $1 in
      ("."|*[[:blank:]]*)
        abspath=$(${kak_opt_binnacle_abs_path_program} $PWD)
        case $2 in
          (*[![:blank:]]*)
            base=$2
          ;;
          *)
            base=$(${kak_opt_binnacle_base_name_program} $PWD)
          ;;
        esac
      ;;
      *)
        abspath=$(${kak_opt_binnacle_abs_path_program} $PWD/$1)
        case $2 in
          (*[![:blank:]]*)
            base=$2
          ;;
          *)
            base=$(${kak_opt_binnacle_base_name_program} $PWD/$1)
          ;;
        esac
      ;;
    esac

    keyexists=$(cat ${kak_opt_binnacle_config_path} | jq '.projects."'"$base"'"' || echo FAIL)

    case $keyexists in
      (*[[:blank:]]*)
      ;;
      FAIL)
        echo ":fail something got fucked up<ret>"
      ;;
      null)
      ;;
      *)
        echo ":fail @$abspath@ already registered with @$base@, use an alias or rename the project causing the conflict<ret>"
        exit 0
      ;;
    esac

    if [ -d $1 ]; then
      cat ${kak_opt_binnacle_config_path} > ${kak_opt_binnacle_config_tmp_path}
      cat ${kak_opt_binnacle_config_tmp_path} | jq  '.projects += {"'"$base"'":"'"$abspath"'"}' > ${kak_opt_binnacle_config_path}

      #if create beacons and beacon doesnt exist, create it do it
  
      echo ":echo success<ret>"
    else
      echo ":fail not a directory<ret>"
    fi
  }
}# PLUGINS
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
