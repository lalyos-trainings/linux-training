
# alap ghub függvény
ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
      -H "Authorization: Bearer $GH_TOKEN" \
      https://api.github.com/${path#/} \
     "$@"
}

# comment jsonifier
com-json() {
    cat << EOF
{
  "body":"${1}"
}
EOF
}

# add-comment
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
  # ha nincs issue megadva, akkor befejeződik a program
  : ${issue_id:? required}

  # ha nincs reakció, akkor végrehajtja
  if [[ -z ${reaction_id} ]]; then
  
  # jelenlegi emojik listázása
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r
  else

  # ha volt alapból emoji, akkor hozzáadja az issuehoz
  # jsonifier
  reaction=$(reaction-json "${reaction_id}")
  echo ${reaction_id} added to issue ${issue_id}
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${reaction}"
  fi

  # user selection lehetőség loopolva és elválasztva
  echo "================================="
  echo "would you like to add another reaction? (yes/no)"
  read user_choice

  # ha szeretne hozzáadni emojit a user
    if [[ ${user_choice} == "yes" ]]; then
    # echo ${user_choice} tesztelés
  
  # választható emojik kilistázása, majd user inputra vár
    select chosen_emoji in +1 -1 laugh confused heart hooray rocket eyes
    do
    echo ${chosen_emoji} was chosen for issue: ${issue_id}
    # jsont csinál a user válaszból
    chosen_emoji_json=$(reaction-json "${chosen_emoji}")
    # echo ${chosen_emoji_json} tesztelés
    
    #létrehozza a reakciót a poszton 
    ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${chosen_emoji_json}"
    
    
    echo "would you like to react again? (yes/no)"
    read user_choice_2

    # amíg a user yesszel válaszol, addig hozzáadhat új emojit
    # ha a user nem szeretne többet hozzáadni, akkor befejeződik a function
      if [[ ${user_choice_2} == "no" ]]; then
      break
      fi
    

    # válaszlehetőséges listázása újra és újabb user inputra vár
    # nem tudok kitalálni jobb megoldást most egy listára.
    echo "1) +1"
    echo "2) -1"
    echo "3) laugh"
    echo "4) confused"
    echo "5) heart"
    echo "6) hooray"
    echo "7) rocket"
    echo "8) eyes"
    echo "choose a reaction:"

    done

    fi
}



# read_tester() {
#   echo "your choce"
#   read user_choice
#   echo ${user_choice}
# }


