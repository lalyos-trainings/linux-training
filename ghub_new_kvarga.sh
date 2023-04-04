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


react-json() {
      cat <<EOF
  {
    "content":"${1}"
  }
EOF
}

react() {
    declare issue_number=$1 reaction=$2
    : ${issue_number:? required}

    ghub repos/lalyos-trainings/git-wed/issues/${issue_number}/reactions | jq .[].content

    if [[ -n $reaction ]]; then
        json=$(react-json "${reaction}")
        ghub repos/lalyos-trainings/git-wed/issues/${issue_number}/reactions \
        -d "${json}"
    fi
}