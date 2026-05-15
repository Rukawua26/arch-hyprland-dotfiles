function ls --wraps='eza -1 --icons=auto' --description 'alias ls=ls -a --color=auto'
    command ls -a --color=auto $argv
end
