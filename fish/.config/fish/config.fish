set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx RIPGREP_CONFIG_PATH ~/.ripgreprc
set -g fish_greeting

# Rust/Cargo
fish_add_path ~/.cargo/bin
fish_add_path ~/.fzf/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin

if status is-interactive
    abbr -a e exit
    abbr -a v nvim
    abbr -a t tmux
    abbr -a c clear
    abbr -a s 'cd ..'
    abbr -a ss 'cd ../..'
    bind \ee edit_command_buffer  # Alt+e to edit in nvim

    # eza
    abbr -a l eza
    abbr -a ls eza
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
    abbr -a lt 'eza --tree'

    # source .env
    abbr -a se 'export (cat .env | xargs -L 1)'

    # podman
    abbr -a drc 'podman rm -f (podman ps -a -q)'
    abbr -a dri 'podman rmi -f (podman images -q)'
    abbr -a pd 'flatpak run io.podman_desktop.PodmanDesktop'
    podman completion fish | source

    # lazygit
    abbr -a lz lazygit

    # kubernetes
    abbr -a kx kubectx
    abbr -a kk k9s
    abbr -a kn kubens

    # Zoxide
    zoxide init fish | source

    # nvm.fish - set default and auto switch on directory change
    set -g nvm_default_version lts
    set --query nvm_current_version || nvm use --silent $nvm_default_version
    function _nvm_auto_use --on-variable PWD
        if test -f .nvmrc
            nvm use --silent
        end
    end

    # Start sesh session picker if not already in tmux
    if not set -q TMUX
        set -l session (sesh list | fzf --height 40% --reverse --border)
        and sesh connect $session
    end
end
