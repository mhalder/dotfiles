function askpi --wraps "pi -p --no-tools --model github-copilot/gpt-4.1" --description "Run pi in non-interactive print mode with response time"
    set -l start_ms (date +%s%3N)

    command pi -p --no-tools --model github-copilot/gpt-4.1 $argv
    set -l cmd_status $status

    set -l end_ms (date +%s%3N)
    set -l elapsed_s (math --scale=3 "($end_ms - $start_ms) / 1000")
    printf "\nresponse time: %ss\n" $elapsed_s >&2

    return $cmd_status
end
