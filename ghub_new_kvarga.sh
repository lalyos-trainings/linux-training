#!/bin/bash
alias r="source $BASH_SOURCE"

ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
        -H "Authorization: Bearer $GH_TOKEN" \
        https://api.github.com/${path#/} \
        "$@"
}

comment-json() {
    cat <<EOF
    {
        "body":"${1}"
    }
EOF
}

add-comment() {
    declare comment_body=$1 issue_number=${2:-89}
    : ${comment_body:? required}
    json=$(comment-json "${comment_body}")
    ghub repos/lalyos-trainings/git-wed/issues/${issue_number}/comments \
    -d "${json}"
}


react() {
    declare issue_number=$1 reaction=$2
    : ${issue_number:? required}
    reaction_options=( "+1" "-1" "laugh" "confused" "heart" "hooray" "rocket" "eyes"  )
    if [[ $reaction == "-a" ]]; then
        select input in "${reaction_options[@]}"; do
        if [[ $REPLY == "q" ]]; then
            break;
        fi
        ghub repos/lalyos-trainings/git-wed/issues/${issue_number}/reactions \
        -d "{\"content\":\"${input}\"}"
        done
    elif [[ -n $reaction ]]; then
        echo "Not a valid switch, use -a for adding."
    else
        ghub repos/lalyos-trainings/git-wed/issues/${issue_number}/reactions | jq .[].content
    fi
}