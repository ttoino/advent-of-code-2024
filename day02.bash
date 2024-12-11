#!/usr/bin/env bash
# Enable strict mode
set -euo pipefail

# Read the input
readarray DATA

safe() {
    local array=("$@")

    local cool=1
    local direction=0

    for ((i = 0; i < ${#array[@]} - 1; i++)); do
        local diff=$((array[i + 1] - array[i]))

        if ((direction == 0)); then
            if ((diff < 0)); then
                direction=-1
            elif ((diff > 0)); then
                direction=1
            fi
        fi

        diff=$((diff * direction))

        if ! ((diff >= 1 && diff <= 3)); then
            cool=0
            break
        fi
    done

    echo $cool
}

# Part 1
result=0
for line in "${DATA[@]}"; do
    IFS=' ' read -r -a array <<<"$line"

    cool=$(safe "${array[@]}")
    result=$((result + cool))
done
echo "Part 1: $result"

# Part 2
result=0
for line in "${DATA[@]}"; do
    IFS=' ' read -r -a array <<<"$line"

    cool=0
    for ((i = 0; i < ${#array[@]}; i++)); do
        tmp_array=("${array[@]}")
        unset "tmp_array[i]"
        fn=$(safe "${tmp_array[@]}")
        if ((fn)); then
            cool=1
            break
        fi
    done

    result=$((result + cool))
done
echo "Part 2: $result"
