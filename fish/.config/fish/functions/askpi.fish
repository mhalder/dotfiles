function askpi --wraps "pi -p --no-tools --model copilot/gpt-4.1" --description "Run pi in non-interactive print mode"
    command pi -p --no-tools --model copilot/gpt-4.1 $argv
end
