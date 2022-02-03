# capture group are available in registers!!
# TAG: PLUGINS
# NOTE remember kakoune piping is like actually echoing the selections already
source "%val{config}/plugins/plug.kak/rc/plug.kak"
source "%val{config}/auto-load/tree.kak"
source "%val{config}/auto-load/synonyms.kak"
plug "alexherbo2/tmux.kak"


define-command beep %{
  nop %sh{ spd-say -t child_female "bada BING bada BOOOm"}
}

define-command tomato-skip %{
  nop %sh{good-pomodoro -c skip}
}

define-command tomato-pause %{
  nop %sh{good-pomodoro -c pause}
}

define-command tomato-continue %{
  nop %sh{good-pomodoro -c continue}
}

# define-command tomato-kill %{
#   nop %sh{good-pomodoro -c kill}
# }

define-command tomato-start %{
  nop %sh{good-pomodoro -c start}
}

hook global ModuleLoaded powerline %{ require-module powerline_tomato }

provide-module powerline_tomato %§
  declare-option -hidden bool powerline_module_tomato true
  declare-option -hidden str powerline_tomato_string '<3'
  set-option -add global powerline_modules 'tomato'

  define-command powerline-update-tomato %{
    set-option global powerline_tomato_string %sh{
      # spd-say -t child_female "bada BING bada BOOOm"
      good-pomodoro
    }
  }

  define-command powerline-tomato %{ evaluate-commands %sh{
      default=$kak_opt_powerline_base_bg
      next_bg=$kak_opt_powerline_next_bg
      normal=$kak_opt_powerline_separator
      thin=$kak_opt_powerline_separator_thin
      if [ "$kak_opt_powerline_module_tomato" = "true" ]; then
          fg=$kak_opt_powerline_color02
          bg=$kak_opt_powerline_color04
          [ "$next_bg" = "$bg" ] && separator="{$fg,$bg}$thin" || separator="{$bg,${next_bg:-$default}}$normal"
          printf "%s\n" "set-option -add global powerlinefmt %{$separator{$fg,$bg} %opt{powerline_tomato_string} }"
          printf "%s\n" "set-option global powerline_next_bg $bg"
      fi
    }
  }


  define-command powerline-tomato-setup-hooks %{
    remove-hooks global powerline-tomato
    evaluate-commands %sh{
      if [ "$kak_opt_powerline_module_tomato" = "true" ]; then
        # printf "%s\n" "hook -group powerline-tomato global NormalIdle .*  powerline-update-tomato"
        # printf "%s\n" "hook -group powerline-tomato global InsertIdle .*  powerline-update-tomato"
        # printf "%s\n" "hook -group powerline-tomato global PrompIdle .*  powerline-update-tomato"
        printf "%s\n" "hook -group powerline-tomato global User tick powerline-update-tomato"
      fi
    }
  }

  define-command -hidden powerline-toggle-tomato -params ..1 %{ evaluate-commands %sh{
      [ "$kak_opt_powerline_module_tomato" = "true" ] && value=false || value=true
      if [ -n "$1" ]; then
          [ "$1" = "on" ] && value=true || value=false
      fi
      printf "%s\n" "set-option global powerline_module_tomato $value"
  }}
§

set-option global grepcmd "ag --column"
# set global tree_cmd 'kak-tree -c ~/.config/kak/kak-tree.toml'
set-option global tree_cmd '/home/jujo/kak-tree/target/release/kak-tree -c /home/jujo/.config/kak/kak-tree.toml '

# INTERFACE
# colorscheme monokai
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
    # powerline-theme gruvbox
    #  rgb:476054
    #  rgb:263531
    # declare-option -hidden str powerline_color00 white
    # declare-option -hidden str powerline_color01 rgb:263531
    # declare-option -hidden str powerline_color02 white 
    # declare-option -hidden str powerline_color03 rgb:263531
    # declare-option -hidden str powerline_color04 rgb:263531
    # declare-option -hidden str powerline_color05 white 
    # declare-option -hidden str powerline_color06 white 
    # declare-option -hidden str powerline_color07 white 
    # declare-option -hidden str powerline_color08 rgb:263531
    # declare-option -hidden str powerline_color09 rgb:263531
    # declare-option -hidden str powerline_color10 white 
    # declare-option -hidden str powerline_color11 rgb:263531
    # declare-option -hidden str powerline_color12 rgb:263531
    # declare-option -hidden str powerline_color13 white
    # declare-option -hidden str powerline_color14 white
    # declare-option -hidden str powerline_color15 rgb:263531
    # declare-option -hidden str powerline_color16 rgb:263531
    # declare-option -hidden str powerline_color17 rgb:263531
    # declare-option -hidden str powerline_color18 rgb:263531
    # declare-option -hidden str powerline_color19 rgb:263531
    # declare-option -hidden str powerline_color20 rgb:263531
    # declare-option -hidden str powerline_color21 rgb:263531
    # declare-option -hidden str powerline_color22 rgb:263531
    # declare-option -hidden str powerline_color23 rgb:263531
    # declare-option -hidden str powerline_color24 rgb:263531
    # declare-option -hidden str powerline_color25 rgb:263531
    # declare-option -hidden str powerline_color26 rgb:263531
    # declare-option -hidden str powerline_color27 rgb:263531
    # declare-option -hidden str powerline_color28 rgb:263531
    # declare-option -hidden str powerline_color29 rgb:263531
    # declare-option -hidden str powerline_color30 rgb:263531
    # declare-option -hidden str powerline_color31 rgb:263531
    # declare-option -hidden str powerline_next_bg rgb:263531
    # declare-option -hidden str powerline_base_bg rgb:263531
    # set-face global StatusLine white,rgb:263531
    # set-face global StatusLineInfo white,rgb:263531
    set-option global powerline_separator ""
    set-option global powerline_separator_thin ""
    # set-option global powerline_format 'git bufname line_column mode_info filetype client session position'
    set-option global powerline_format 'git bufname line_column mode_info filetype client session position tomato'
} config %{
    powerline-start
}

plug "Crote/kakoune-tmux-extra"
plug "eko234/kakoune-macro-store"

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

### INTERFACE
evaluate-commands %sh{
    kcr init kakoune
}

# plug 'delapouite/kakoune-livedown'
plug "TeddyDD/kakoune-wiki" config %{
  wiki-setup %sh{ echo $HOME/wiki }
}
# plug "alexherbo2/alacritty.kak"
# plug "caksoylar/kakoune-focus"

# map global user <space> ': focus-toggle<ret>' -docstring "toggle selections focus"

# define-command focus-live-enable %{
#     focus-selections
#     hook -group focus window NormalIdle .* %{ focus-extend }
# }

# define-command focus-live-disable %{
#     remove-hooks window focus
#     focus-clear
# }


plug "occivink/kakoune-roguelight"
plug "lePerdu/kakboard"
plug "maximbaz/restclient.kak"

plug "eburghar/kakpipe" do %{
	cargo install --force --path . --root ~/.local
}

define-command kakpipe-toolsclient %{
  prompt -shell-completion ':: ' %{
    eval -try-client tools %{kakpipe -S -w -- sh -c %val{text}}
  }
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
    map global user f ':enter-user-mode fuzzy<ret>' -docstring "fuzzy"
    map global fuzzy f ':peneira-files<ret>'        -docstring "files"
    map global fuzzy l ':peneira-lines<ret>'        -docstring "lines"

    define-command peneira-buffers %{
      peneira 'buffers: ' %{ printf '%s\n' $kak_quoted_buflist } %{
        buffer %arg{1}
      }
    }
    map global fuzzy b ':peneira-buffers<ret>'   -docstring "buffers"
  }

  plug "raiguard/harpoon.kak" %{
    harpoon-add-bindings
  }
}

plug "occivink/kakoune-snippets" config %{
  set-option -add global snippets_directories "%opt{plug_install_dir}/kakoune-snippet-collection/snippets"
  set-option global snippets_auto_expand false
  map global insert <a-2> '<esc>:snippets-select-next-placeholders<ret>i'
  map global user S ':snippets-menu<ret>'
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
    # set-option global kaktree_file_icon      '⠀⠀🦆'
    set-option global kaktree_show_help false
    set-option global kaktree_file_icon      '⠀⠀📄'
}

plug 'alexherbo2/auto-pairs.kak'
enable-auto-pairs
#require-module auto-pairs
#auto-pairs-enable

plug "andreyourst/plug.kak" noload
plug 'h-youhei/kakoune-surround'
# plug 'Delapouite/kakoune-registers'
# plug 'Delapouite/kakoune-palette'
plug "Delapouite/kakoune-buffers" %{
  map global user b ': enter-user-mode -lock buffers<ret>' -docstring 'buffers (lock)…'
}

map global normal / '/(?i)'
map global normal ? '?(?i)'
map global normal <a-/> '<a-/>(?i)'
map global normal <a-?> '<a-?>(?i)'
map global normal <c-_> ':  set-register slash ""<ret>' ## for some reason this is <c-/>
hook global WinCreate    .* 'git show-diff'
hook global BufWritePost .* %{ git update-diff }

# MAPS
map global normal <space> ,                              -docstring 'leader'
map global normal , <space>                              -docstring 'remove other selections'
map global normal <a-,> <a-space>                        -docstring 'remove main selection'

map global user Y     '<a-|>xclip -i -selection clipboard<ret>'
map global normal <c-y> '<a-|>xclip -i -selection clipboard<ret>'
map global user p '\i'                                   -docstring 'no hookies'
map global user w ':  w<ret>'                              -docstring "save"
map global user e ': execute-keys %{<esc>: synonyms-set-thesaurus th_en_US_v2<ret><esc>: synonyms-replace-selection<ret>}'    -docstring "synonyms"
map global user E '  !explorer.exe . <ret>'                -docstring "explorer"
map global user k ':  edit-kakrc<ret>'                     -docstring "kakrc"
map global user ! ':  edit ~/.config/kak-lsp/kak-lsp.toml<ret>' -docstring "w"
map global normal <c-k> ': kakpipe-toolsclient<ret>'    -docstring "kakpipe shorthand"
map global user K ':  source "%val{config}/kakrc"<ret>'    -docstring "re-source"
map global user A ':  e ~/.config/alacritty/alacritty.yml<ret>' -docstring "alacritty"
# map global user T ':  edit ~/.tmux.conf<ret>'              -docstring "tmux"
map global user B ':  edit ~/.bashrc<ret>'                 -docstring "bashrc"
map global user c ':  comment-line<ret>'                   -docstring "comment"
map global user C ':  comment-block<ret>'                  -docstring "comment"
map global user F ':  format<ret>'                         -docstring "format"
# map global normal <c-t> '<c-s>%s\h+$<ret>d<space><c-o><c-o>'
map global normal <c-x> 's^<ret>s\s<ret>wbdi<backspace><ret><esc><space>' -docstring "naive format"
map global normal ^ '<a-`>'

# map global normal <a-E> '?^\n<ret>;'
# map global normal <a-A> '<a-?>^\n<ret>;'

map global user <a-Q> ':q!<ret>'                        -docstring "bye bye"
map global user r ':  tmux-repl-vertical<ret>'            -docstring "repl"
map global user R ':  tmux-repl-horizontal<ret>'          -docstring "repl"
map global normal <backspace> ':  send-text<ret>'         -docstring "send text"
map global user x ':  restclient-execute<ret>'            -docstring "execute rest client"

declare-user-mode surround
map global user s     ':  enter-user-mode surround<ret>'       -docstring 'surround mode'
map global surround s ':  surround<ret>'                   -docstring 'surround'
map global surround c ':  change-surround<ret>'            -docstring 'change'
map global surround d ':  delete-surround<ret>'            -docstring 'delete'
map global surround t ':  select-surrounding-tag<ret>'     -docstring 'select tag'

declare-user-mode grep
map global user g ':  enter-user-mode -lock grep<ret>' -docstring "grep mode"
map global grep g ':  grep '                           -docstring 'grep '
map global grep n ':  grep-next-match<ret>'            -docstring 'next'
map global grep N ':  grep-previous-match<ret>'        -docstring 'prev'
map global grep d ':  delete-buffer *grep*<ret>'       -docstring 'delete grep buffer'

map global normal "'" "<a-i><a-w>*"

declare-user-mode splits
map global normal <c-w> ':enter-user-mode splits<ret>'
map global splits h ':newh<ret>'
map global splits v ':newv<ret>'

map global user m ':easy-motion-word<ret>'
map global user l ':easy-motion-line<ret>'

# # TAG: # HOOKERS lmao
# define-command next-tag %{
#   execute-keys %sh{
#     comment=${kak_opt_comment_line}
#     printf "?^%s TAG:<ret>;ghvt" $comment
#   }
# }

# define-command prev-tag %{
#   execute-keys %sh{
#     comment=${kak_opt_comment_line}
#     printf "<a-?>^%s TAG:<ret>;ghvt" $comment
#   }
# }

# define-command add-tag %{
#   execute-keys %sh{
#     comment=${kak_opt_comment_line}
#     printf "ghi%s TAG:" $comment
#   }
# }

# map global normal <a-E> ':next-tag<ret>'
# map global normal <a-A> ':prev-tag<ret>'
# map global user t ':add-tag<ret>'
map global normal <F1> '<c-o>' -docstring 'prev jump'
map global normal <F2> '<tab>' -docstring 'next jump'
map global insert <a-1> 'λ'
map global insert <a-2> 'ñ'
map global normal <a-3> ':kaktree-toggle<ret>'
hook global BufCreate .*[.](rkt|rktd|rktl|rkts) %{ set-option buffer filetype scheme}
hook global BufCreate .*[.](asdf|asd) %{ set-option buffer filetype lisp}
hook global InsertChar \t %{ exec -draft h @ }
hook global WinSetOption filetype=(fennel) %{
  # set-option buffer comment_line 'i'
  hook window InsertChar \] -always %{
    # execute-keys '<esc>i'
  }
}

# # THIS IS FOR WHEN I HAVE ACTUAL LSP INSTALLED
# plug "kak-lsp/kak-lsp" do %{
#     cargo install --locked --force --path .
# }

eval %sh{kak-lsp --kakoune -s $kak_session}  # Not needed if you load it with plug.kak.
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log ~/kak-lsp-log"
hook global WinSetOption filetype=(ruby|racket|rust|scheme|python|lisp|javascript|json|html|css|bash) %{
  # set-option global lsp_server_configuration pyls.configurationSources=["flake8"]
  # lsp-inline-diagnostics-enable window
  # lsp-auto-hover-enable
  lsp-enable-window
  map global user h ":lsp-hover<ret>"
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

# map global user q ':query-cheat-sheet<ret>' -docstring 'query cheat sheet'
map global user q ':query-howdoi<ret>' -docstring 'query howdoi'
map global goto L l
map global goto H h
map global goto J j
map global goto K k

# declare-user-mode meats

# map global user j ':enter-user-mode meats<ret>' -docstring 'yummy'
# map global meats j ':flash-n-lick <ret>'        -docstring 'get some'
# map global meats s ':stab <ret>'                -docstring 'shove'
# map global meats e ':eat <ret>'                 -docstring 'slurp'

# define-command stab %{
#   info -style modal "enter a key to save :)"
#   on-key %|
#     info -style modal
#     echo %sh{
#       $(cd /home/jujo/meats ; fennel meats.fnl stab "$kak_key:$kak_buffile:$kak_cursor_line:$kak_cursor_column")
#     }
#   |
# }

# define-command flash-n-lick %{
#   info -style modal %sh{
#     result="$(cd /home/jujo/meats ; fennel meats.fnl flash)"
#     echo "$result"
#   }

#   on-key %@
#     info -style modal
#     evaluate-commands %sh{
#       if [ ${#kak_key} -gt 1 ]; then
#         echo "nop"
#       else
#         filetoedit=$(cd /home/jujo/meats ; fennel meats.fnl lick "$kak_key")
#         echo "edit $filetoedit"
#       fi
#     }
#   @
# }

# define-command eat %{
#   nop %sh{
#     echo $(cd /home/jujo/meats ; fennel ~/meats/meats.fnl eat)
#   }
# }

hook global BufSetOption filetype=javascript %{
    set-option buffer formatcmd "prettier --stdin-filepath=%val{buffile}"
}

hook global BufSetOption filetype=janet %{
  set-option buffer formatcmd "jfmt"
}

define-command split %{
  new eval buffer %val{bufname} ';' select %val{selection}
}

require-module kakoune-macro-store
map global normal <a-Q> ": store-macro-at-interactive<ret>"
map global normal <a-q> ": play-macro-from-interactive<ret>"

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

require-module kakpipe

define-command dicto %{
  prompt 'dicto!: ' %{eval kakpipe -S --prefix == --name DICTIONARY -- sdcv %val{text}}
}

map global user d %{: dicto<ret>}

define-command transl %{
  prompt 'transl!: ' %{eval kakpipe -S --prefix == --name TRANSLATION -- trans -brief %val{text}}
}

map global user t %{: transl<ret>}

plug "JacobTravers/kakoune-grep-write"

plug "abuffseagull/kakoune-discord" do %{ cargo install --path . --force } %{
  discord-presence-enable
}

plug "abuffseagull/kakoune-toggler" do %{ cargo install --path . }

plug "1g0rb0hm/search.kak" config %{
  set-option global search_context 3 # number of context lines
}

# plug "the-mikedavis/buffercraft.kak"

hook global BufWritePre .* %{
  nop %sh{
    container=$(dirname "$kak_hook_param")
    test -d "$container" ||
      mkdir --parents "$container"
  }
}

plug "https://gitlab.com/Screwtapello/kakoune-repl-buffer"

plug "dgmulf/local-kakrc" config %{
    set-option global source_local_kakrc true
}

hook global BufCreate (.*)kakrc %{
  set-option buffer filetype kak 
}

plug "listentolist/kakoune-table" domain "gitlab.com" config %{
    # suggested mappings
    # map global user t ": evaluate-commands -draft table-align<ret>" -docstring "align table"
    # map global user t ": table-enable<ret>" -docstring "enable table mode"
    # map global user T ": table-disable<ret>" -docstring "disable table mode"
    # map global user t ": table-toggle<ret>" -docstring "toggle table mode"
    # map global user t ": enter-user-mode table<ret>" -docstring "table"
    # map global user T ": enter-user-mode -lock table<ret>" -docstring "table (lock)"
}

define-command meth %{
  prompt "meth: " %{
    echo %sh{ qalc "$kak_text" } 
  }
}

map global normal = ': meth<ret>'

eval %sh{ kks init }

# define-command nnn %{
#   kks-connect terminal-popup sh -c 'nnn -p - | xargs kks edit'
# }

# map global normal <a-3> ': nnn<ret>'
#
# face global StatusLine rgb:c4bfb0,rgb:222526
#

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
    eval dirty %arg{1}
  }
}

### COLOR
# code

colorscheme mygruvbox

define-command supah-commands %{
  peneira "DO: " %{
printf "pure
bgru-p"
  } %{
    eval %arg{1}
  }
}

map global user J ': supah-commands<ret>' -docstring "SUPA!"
