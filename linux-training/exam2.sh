issue() {
  declare number=$1 content=${2:-}
  : #${content:? required} ${number:? required}
  json=$(comment-json "$@")
  if [[ -z "$content" ]]; then
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions | jq .[].content -r
  else
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions -d "${json}"
  fi  
}

comment-json() {
  cat <<EOF
  {
    "content":"${2}",
    "number":"${1}"
  }
EOF
}