set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx RIPGREP_CONFIG_PATH ~/.ripgreprc
set -gx VAULT_ADDR "https://vault.lan.halder.me"
set -gx VAULT_NAMESPACE ""
set -g fish_greeting
set -g fish_key_bindings fish_vi_key_bindings

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
    abbr -a lt 'eza -T -L 2'

    # source .env
    abbr -a se 'bass source .env'

    # podman
    abbr -a drc 'podman rm -f (podman ps -a -q)'
    abbr -a dri 'podman rmi -f (podman images -q)'
    abbr -a pd 'flatpak run io.podman_desktop.PodmanDesktop'
    if not test -f ~/.config/fish/completions/podman.fish
        podman completion fish > ~/.config/fish/completions/podman.fish
    end

    # lazygit
    abbr -a lz lazygit

    # kubernetes
    abbr -a kx kubectx
    abbr -a kk k9s
    abbr -a kn kubens

    # Zoxide
    zoxide init fish | source

    # nvm.fish - set default and auto switch on directory change
    set -g nvm_default_version 22
    set --query nvm_current_version || nvm use --silent $nvm_default_version
    function _nvm_auto_use --on-variable PWD
        if test -f .nvmrc
            nvm use --silent
        end
    end

    # Mise - runtime version manager
    mise activate fish | source
    if not test -f ~/.config/fish/completions/mise.fish
        mise completion fish > ~/.config/fish/completions/mise.fish
    end

    # vault
    abbr -a vr vault-renew
    abbr -a vl 'vault login'

    # Fnox - secret manager
    if test -f ~/.vault-token
        set -gx VAULT_TOKEN (cat ~/.vault-token)
    end
    fnox activate fish | source

    # Start sesh session picker if not already in tmux
    if not set -q TMUX
        set -l session (sesh list | fzf --height 40% --reverse --border)
        and sesh connect $session
    end
else
    # Non-interactive shells use shims for tool access
    mise activate fish --shims | source
    if test -f ~/.vault-token
        set -gx VAULT_TOKEN (cat ~/.vault-token)
    end
    fnox activate fish | source
end
