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


react() {
    default=89
    issue_id=${1:-$default}
    if [[ $# -eq 0 ]]; then
        echo "You did not provide issue number. By default, we are checking issue 89."
    else echo "You will see the reactions of issue" ${issue_id}
    fi
    echo ghub repos/lalyos-trainings/git-wed/issues/${issue_id}/reactions
}

# ghub repos/lalyos-trainings/git-wed/issues/89/reactions