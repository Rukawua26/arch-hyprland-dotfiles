function ll --wraps='eza -lha --icons=auto --sort=name --group-directories-first' --wraps='ls -la' --description 'alias ll=ls -la'
    ls -la $argv
end
