



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
    # echo ${user_choice}
    select chosen_emoji in +1 -1 laugh confused heart hooray rocket eyes
    do
    echo ${chosen_emoji} was chosen for issue: ${issue_id}
    chosen_emoji_json=$(reaction-json "${chosen_emoji}")
    
    # echo ${chosen_emoji_json}
    ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${chosen_emoji_json}"
    
    echo "would you like to react again? (yes/no)"
    read user_choice_2

      if [[ ${user_choice_2} == "no" ]]; then
      break
      fi
    
    echo "1) +1"
    echo "2) -1"
    echo "3) laugh"
    echo "4) confused"
    echo "5) heart"
    echo "6) hooray"
    echo "7) rocket"
    echo "8) eyes"
    # nem találtam jobb megoldást most egy listára.
    echo "choose a reaction:"

    done

    fi


  else
  reaction=$(reaction-json "${reaction_id}")
  echo ${reaction_id} added to issue ${issue_id}
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${reaction}"

  fi

}



# read_tester() {
#   echo "your choce"
#   read user_choice
#   echo ${user_choice}
# }


