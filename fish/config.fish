# INIT

# ENV
# Path through: set -Ua fish_user_paths $HOME/.cargo/bin
# set -x LESS '-r'
# set -x PAGER 'less -FX'

# ALIAS
alias grep='grep --color=auto'
alias grepc='grep --color=always'
alias ls='ls -1 --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias asp='unbuffer apt search --names-only'
alias ssh='TERM=xterm-256color /usr/bin/ssh'
alias hms='home-manager switch --flake ~/nixpkgs'
alias ssh='TERM=xterm-256color /usr/bin/ssh'
alias dcu='docker compose up -d'
alias dcd='docker ps --filter label=com.docker.compose.project -aq | xargs docker rm --volumes -f'
alias cdg='cd (git rev-parse --show-toplevel)'

function ec --description 'emacsclient --nw ...'
    emacsclient --nw $argv
end

function octal
    stat -c '%a %n' $argv
end

function docker-purge --description 'Stop and remove all containers.'
    docker ps -aq | xargs docker rm --volumes -f
end

# Fish
function fish_greeting
end


set -g __fish_git_prompt_shorten_branch_len '20'
function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end


    # $normal (fish_vcs_prompt)
    echo -n -s (set_color $fish_color_user) "$USER" $normal
    set_color normal
    echo -n @
    set_color $color_cwd
    echo -n (basename $PWD)

    if test -n "$IN_NIX_SHELL"
        echo -n " ❄ "
    end

    set_color yellow
    echo -n (fish_vcs_prompt)
    # Indicate status by color
    # if not test $last_pipestatus -eq 0
    #     set_color $fish_color_error
    # end
    set_color normal
    echo -n $suffix

    echo " "
end
