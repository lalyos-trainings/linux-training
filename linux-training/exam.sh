issue() {
  declare body=$1 number=$2
  : ${body:? required}
  json=$(comment-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues/${number:=89}/comments -d "${json}"
  
}

comment-json() {
  cat <<EOF
  {
    "body":"${1}",
    "number":"${2}"
  }
EOF
}

