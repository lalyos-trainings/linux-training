json_ketto() {
  cat <<EOF
{
  "body":"${1:? body required}"
}
EOF
}

post_comment(){
  declare numb=$2 body=$1
  : ${numb:=89}
  : ${body:? required}
  json=$(json_ketto "${body}")
  ghub /repos/lalyos-trainings/git-wed/issues/${numb}/comments -d "${json}"
}

react(){
  declare issue_number=$1 reaction_text=$2
  if [[ -z $1 ]]; then
    echo issue number is missing
    return
  fi
  if [[ $1 == 89 ]]; then
    if [[ -z $2 ]]; then
      echo list reactions
    else 
      echo add some reaction
    fi
  else
    echo not such an issue
  fi

}


ghub /repos/lalyos-trainings/git-wed/issues/89/reactions -d '{"rocket":"1"}'
