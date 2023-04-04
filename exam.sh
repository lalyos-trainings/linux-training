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
   "body":"${1:? body required}"
}
EOF
}

comment() {
  declare comment=$1 issuenumber=$2
  : ${comment:? required} 
  : ${issuenumber:? required} 
  json=$(comment-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues/"$issuenumber"/comments -d "${json}"
}