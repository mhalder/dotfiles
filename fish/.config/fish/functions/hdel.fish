function hdel --description "Interactively delete history entries with fzf"
    for cmd in (history | fzf --multi)
        history delete --exact --case-sensitive -- $cmd
    end
end
