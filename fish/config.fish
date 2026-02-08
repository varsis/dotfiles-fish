set -x EDITOR nvim
set -x PROJECTS ~/Projects
set -x GOPATH ~/Developer/Go
fish_add_path -p ~/Developer/Go/bin
fish_add_path -p ~/.cargo/bin/
fish_add_path -p ~/.bin/
fish_add_path -a /opt/homebrew/bin/
fish_add_path -a /Applications/Postgres.app/Contents/Versions/latest/bin/
fish_add_path -a ~/Applications/Ghostty.app/Contents/MacOS/

status is-interactive; and begin
    # apps et al
    alias d docker
    alias e nvim
    alias v nvim
    alias vimdiff 'nvim -d'
    alias ta 'tmux new -A -s default'
    alias freeze 'freeze -c full'

    # git
    alias g git
    alias ga 'git add'
    alias gaa 'git add -A'
    alias gb 'git branch -v'
    alias gc 'git commit -s'
    alias gca 'git commit -sa'
    alias gcam 'git commit -sam'
    alias gcm 'git commit -sm'
    alias gco 'git checkout'
    alias gd 'git diff'
    alias gl 'git pull --prune'
    alias glg 'git log --graph --decorate --oneline --abbrev-commit'
    alias glga 'glg --all'
    alias glnext 'git log --oneline (git describe --tags --abbrev=0 @^)..@'
    alias gm 'git switch (git main-branch)'
    alias gms 'git switch (git main-branch); and git sync'
    alias gmt 'go mod tidy'
    alias gp 'git push origin HEAD'
    alias gpa 'git push origin --all'
    alias gpr 'git ppr'
    alias grm 'go run ./...'
    alias gs 'git status -sb'
    alias gw 'git switch'
    alias gwc 'git switch -c'

    # kubectl
    alias k kubectl
    alias kd 'kubectl describe'
    alias kdebug 'kubectl run -i -t debug --rm --image=caarlos0/debug --restart=Never'
    alias kdp 'kubectl describe po'
    alias kdrain 'kubectl drain --ignore-daemonsets --delete-local-data'
    alias ke 'kubectl edit'
    alias kex 'kubectl exec -it'
    alias kfails 'kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'
    alias kg 'kubectl get'
    alias kga 'kubectl get --all-namespaces'
    alias kgno 'kubectl get no --sort-by=.metadata.creationTimestamp'
    alias kgp 'kubectl get po'
    alias kimg 'kubectl get deployment --output=jsonpath='\''{.spec.template.spec.containers[*].image}'\'''
    alias kn kubens
    alias knrunning 'kubectl get pods --field-selector=status.phase!=Running'
    alias krm 'kubectl delete'
    alias kvs 'kubectl view-secret'
    alias kx kubectx
    alias sk 'kubectl -n kube-system'

    # nx
    alias nxb 'nx build'
    alias nxr 'nx run'
    alias nxs 'nx serve'
    alias nxt 'nx test'
    alias nxta 'nx affected:test'
    alias nxba 'nx affected:build'
    alias nxg 'nx graph'
    alias nxl 'nx lint'

    # files
    alias fd 'fd --hidden'
    alias la 'lsd -A'
    alias ll 'lsd -l'
    alias lla 'lsd -lA'
    alias llt 'lsd -l --tree'
    alias ls lsd
    alias lt 'lsd --tree'

    # nvim
    alias vim=nvim
    alias vi=nvim

    # disable fish greeting
    set fish_greeting
    fish_config theme choose gruvbox-dark
    fish_config prompt choose astronaut

    # Use VI bindings
    fish_vi_key_bindings

    bind \ee edit_command_line

    # traps the shell quit and switch to the last session if it's the last pane
    # if last session is not available anymore, switch to default
    function __trap_exit_tmux
        test (tmux list-windows | count) = 1 || exit
        test (tmux list-panes | count) = 1 || exit
        tmux switch-client -l || tmux switch-client -t default
    end

    if set -q TMUX
        trap __trap_exit_tmux EXIT
    end

    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x HOMEBREW_NO_ENV_HINTS 1
    set -x FZF_DEFAULT_OPTS '--color bg:#1b1b1b,bg+:#3c3836,fg:#ebdbb2,fg+:#ebdbb2,header:#fb4934,hl:#fb4934,hl+:#fb4934,info:#d3869b,marker:#83a598,pointer:#ebdbb2,prompt:#d3869b,selected-bg:#665c54,spinner:#ebdbb2'

    # GPG Key
    set -gx GPG_TTY (tty)

    zoxide init fish | source
    fzf --fish | source

    # ASDF configuration code
    if test -z $ASDF_DATA_DIR
        set _asdf_shims "$HOME/.asdf/shims"
    else
        set _asdf_shims "$ASDF_DATA_DIR/shims"
    end

    # Do not use fish_add_path (added in Fish 3.2) because it
    # potentially changes the order of items in PATH
    if not contains $_asdf_shims $PATH
        set -gx --prepend PATH $_asdf_shims
    end
    set --erase _asdf_shims
end

if test -f ~/.localrc.fish
    source ~/.localrc.fish
end

# pnpm
set -gx PNPM_HOME "/Users/chris/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
