



ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
      -H "Authorization: Bearer $GH_TOKEN" \
      https://api.github.com/${path#/} \
     "$@"
}

com-json() {
    cat << EOF
{
  "body":"${1}"
}
EOF
}

add-comment() {
    declare body=$1 id=${2:-89}
    : ${body:? required}
    comment=$(com-json "$@")
    ghub repos/lalyos-trainings/git-wed/issues/${id}/comments -d "${comment}"
}


# ha nem kap parametert akkor issue number közelező
# második paraméter nincs meg akkor listáz
# ha megad reactiont, akkor rárakja
reaction-json() {
    cat << EOF
{
  "content":"${1}"
}
EOF
}

comment-reaction() {
  declare issue_id=$1 reaction_id=$2 
  : ${issue_id:? required}


  if [[ -z ${reaction_id} ]]; then
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r
  echo "================================="
  echo "would you like to add a reaction? (yes/no)"
  read user_choice
  
    if [[ ${user_choice} == "yes" ]]; then
    echo ${user_choice}
    fi


  else
  reaction=$(reaction-json "${reaction_id}")
  echo ${reaction}
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${reaction}"

  fi

}



read_tester() {
  echo "your choce"
  read user_choice
  echo ${user_choice}
}


