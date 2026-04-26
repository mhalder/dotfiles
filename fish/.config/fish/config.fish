set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx RIPGREP_CONFIG_PATH ~/.ripgreprc
set -gx VAULT_ADDR "https://vault.mesh.halder.io"
set -gx VAULT_NAMESPACE ""
set -gx ZEPHYR_SDK_INSTALL_DIR ~/tools/zephyr-sdk-0.17.0
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
    abbr -a t 'tmux new -A -s main "nvim main.md"'
    abbr -a tl 'tmux ls'
    abbr -a ta 'tmux attach'
    abbr -a c clear
    abbr -a s 'cd ..'
    abbr -a ss 'cd ../..'
    bind \ee edit_command_buffer  # Alt+e to edit in nvim

    function __fzf_search_home --description 'Run fzf picker rooted at home directory'
        commandline --current-token --replace "~/"
        _fzf_search_directory
    end
    bind ctrl-t __fzf_search_home
    bind -M insert ctrl-t __fzf_search_home

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
    abbr -a drv 'podman volume rm -f (podman volume ls -q)'
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

    # Mise - runtime version manager
    mise activate fish | source
    if type -q gh
        set -gx MISE_GITHUB_TOKEN (gh auth token 2>/dev/null)
    end
    if type -q glab
        set -gx MISE_GITLAB_TOKEN (glab config get token --host gitlab.com 2>/dev/null)
    end
    if not test -f ~/.config/fish/completions/mise.fish
        mise completion fish > ~/.config/fish/completions/mise.fish
    end

    # Zoxide
    zoxide init fish | source

    # vault
    abbr -a vr vault-renew
    abbr -a vl 'vault login'

    # Fnox - secret manager
    if test -f ~/.vault-token
        set -gx VAULT_TOKEN (cat ~/.vault-token)
    end
    fnox activate fish | source

else
    # Non-interactive shells use shims for tool access
    mise activate fish --shims | source
    if type -q gh
        set -gx MISE_GITHUB_TOKEN (gh auth token 2>/dev/null)
    end
    if type -q glab
        set -gx MISE_GITLAB_TOKEN (glab config get token --host gitlab.com 2>/dev/null)
    end
    if test -f ~/.vault-token
        set -gx VAULT_TOKEN (cat ~/.vault-token)
    end
    fnox activate fish | source
end

