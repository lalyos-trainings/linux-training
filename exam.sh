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

teams() {
  ghub /orgs/lalyos-trainings/teams -s \
    | jq .[].name -r
}

devs() {
  ghub /organizations/2652852/team/7635002/members -s \
    | jq .[].login -r
}

lista() {
    devs | while read name; do echo users/$name; done > sigmausers.txt
    cat sigmausers.txt | while read name; do ghub $name -s | jq .name -r; done

}

table() {
  printf '%20s %20s\n' "LOGIN" "FULL_NAME"
  devs | while read name; do
    #echo === $name
    real=$(ghub /users/${name} -s | jq .name -r)
    printf '%20s %20s\n'  ${name} "${real}"
  done
}

# for i in $(cat devs.txt); do echo === $i done

table2() {
  printf '%20s %20s\n' "LOGIN" "FULL_NAME"
  devs | while read name; do
    real=$(ghub /users/${name} -s | jq .name -r)
    printf '%20s %20s\n'  ${name} "${real}"
  done
}


lunch() {
    ghub repos/lalyos-trainings/git-wed/issues -s | jq '.[]|[.user.login,.body]' -cr \
    | while read lunch; do
        printf '%20s %20s\n' $lunch
    done
}


epiclunch() {
  printf '%20s %20s\n' "NAME" "FOOD"
  ghub repos/lalyos-trainings/git-wed/issues -s | jq .[] -c \
  | while read order; do
    user=$(echo $order | jq .user.login -r)
    food=$(echo $order | jq .body -r)
    printf '%20s %20s\n' $user "$food"
  done
}



issue-json() {
  cat <<EOF
{
  "title":"${1}",
  "body":"${2}"
}
EOF
}

issue() {
  declare title=$1 body=$2
  : ${title:? required} ${body:? required}

  json=$(issue-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues -d "${json}"
}

close-all() {
  ghub repos/lalyos-trainings/git-wed/issues -s | jq .[].number | while read issue; do 
    echo === closing issue: ${issue}
    ghub repos/lalyos-trainings/git-wed/issues/${issue} -X PATCH -d '{"state":"closed"}' &> /dev/null &
  done

}

comment() {
    cat <<EOF
{
  "body":"${1}"
}
EOF
}

comment_issue() {
    declare text=$1
    default=89
    issue_id=${2:-$default}
    : ${text:? required}
    comment=$(comment "$@")
    ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/comments -d "${comment}"
}


#react nevü függvény
# ha nem kap paramétert: kiírja, hogy melyik issue-ról van szó
# ha megadja az issuet és nem ad meg reactet, akkor listázza ki az adott issure való reactionoket
# ha mindkettő megadja, akkor rárak egy reactet

reaction-json() {
      cat <<EOF
{
  "content":"${1}"
}
EOF
}

give_reaction() {
  declare reaction=$1 issue_id=$2
  reaction=$(reaction-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -d "${reaction}"
}

react() {
    declare issue_id=$1 react_type=$2
    : ${issue_id:? You have to provide an issue number}
    local react_count=$(ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r | wc -l)
    error_status=$?
    if [[ $react_count = 0 ]]; then
      echo "ERROR - There is no issue ${issue_id} in this repository"
      return
    else echo "You will see the reactions of issue" ${issue_id}
    fi

    echo "This issue with ID ${issue_id} currently has ${react_count} reactions."
    echo "Below is a list of the ${react_count} reactions related to this issue."
    ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r
    echo
    echo "Your reaction is:" ${react_type}
    echo
    give_reaction ${react_type} ${issue_id}

    read -p "Would you like to see the list of reactions again?(Y/N)" answer
    while ! [[ $answer =~ [yYnN] ]]; do
      read -p "Would you like to see the list of reactions again?(Y/N)" answer
    done
    if [[ $answer =~ [yY] ]]; then
      react_count=$(ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r | wc -l)
      ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions -s | jq .[].content -r
      echo "There are ${react_count} reactions related to issue ID ${issue_id}"
      echo "The script is finished. Bye!"
    else
      echo "The script is finished. Bye!"
    fi

}