set -gx EDITOR nvim
set -gx VISUAL nvim
set -g fish_greeting

# Rust/Cargo
fish_add_path ~/.cargo/bin

if status is-interactive
    abbr -a e exit
    abbr -a v nvim
    abbr -a t tmux
    abbr -a c clear
    abbr -a s 'cd ..'
    abbr -a ss 'cd ../..'
    bind \ee edit_command_buffer  # Alt+e to edit in nvim

    # eza (ls replacement)
    abbr -a l eza
    abbr -a ls eza
    abbr -a ll eza -l
    abbr -a la eza -la
    abbr -a lt eza --tree
    abbr -a lta eza --tree -a

    # Zoxide
    zoxide init fish | source
end
