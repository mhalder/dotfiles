function fish_user_key_bindings
    fish_vi_key_bindings
    fzf_configure_bindings

    # Restore emacs-style history navigation in insert mode
    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
end
