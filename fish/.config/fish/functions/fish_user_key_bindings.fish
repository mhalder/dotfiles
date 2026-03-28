function fish_user_key_bindings
    fish_vi_key_bindings
    fzf_configure_bindings

    # fzf.fish uses ctrl-r (new-style) which Ghostty sends as \cr (old-style)
    bind \cr _fzf_search_history
    bind -M insert \cr _fzf_search_history

    # Restore emacs-style history navigation in insert mode
    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
end
