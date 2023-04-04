react() {
  declare number=$1 content=${2:-}
  : ${number:? required}
  json=$(react-json "$@")
  if [[ -z "$content" ]]; then
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions | jq .[].content -r
  else
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions -d "${json}"
  fi  
}

react-json() {
  cat <<EOF
  {
    "content":"${2}",
    "number":"${1}"
  }
EOF
}