x() {
    echo 1.st param=...${1:-default}
}



miko() {   
    local time=${1:-${NEXT:-1730}}
    local now=$(date +%s)
    local pause=$(date -d ${time} +%s)
    echo time left till ${time} 'is' $(( (${pause} - ${now}) /60 )) minutes
}

coffee() {
    local now=$(date +%s)
    local start=$(date -d ${NEXT:-17:30} +%s)
    local end=$(( ${start} + 600))

    local remain=$(( ( ${end} - ${now} ) / 60))
    
    if [[ ${now} -lt ${start} ]]; then
        echo minutes till next coffee: $(( (${start} - ${now}) / 60))
    else
        if [[ ${remain} -lt 0 ]]; then 
            echo coffee break is eneded
        else 
            echo time left: ${remain}
        fi
    fi

}




hint() { 
    latest=$(
        curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r
    )
    curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}
}



isa() { 
    select key in ~/.ssh/*.pub /mnt/c/Users/MSI/.ssh/*.pub; do
    if [[ $REPLY == 'q' ]]; then
        break;
    fi
    ssh-add ${key%.pub}
    done
}


echo_teszt() {
    echo 'echo első teszt'
}

echo_teszt2() {
    $(echo_teszt)
    echo 'második teszt'
}





#!/bin/bash

# set -eo pipefail
# if [[ "$TRACE" ]]; then
#     : ${START_TIME:=$(date +%s)}
#     export START_TIME
#     export PS4='+ [TRACE $BASH_SOURCE:$LINENO][ellapsed: $(( $(date +%s) -  $START_TIME  ))] '
#     set -x
# fi

# debug() {
#   [[ "$DEBUG" ]] && echo "-----> $*" 1>&2
# }

# main() {
#   : ${DEBUG:=1}
# }

# [[ "$0" == "$BASH_SOURCE" ]] && main "$@" || true


outtest() {
# idézőjeltől literálisan vesz mindent, variable, commands stb
## here-doc
  cat > a.txt  <<-EOF
	home: $HOME
	ma: $(date)
	ketto
	harom
EOF

}



sleep_five () {

    for i in {1..5}; do
    sleep 30 & 
    done


}



teams() {
  ghub /orgs/lalyos-trainings/teams -s \
    | jq .[].name -r
}

devs() {
  ghub /organizations/2652852/team/7635002/members -s \
    | jq .[].login -r
}

github_nevek() {
    devs | \
    while read name; do
    printf "github name: %-20s real name: " "${name}" 
    ghub /users/${name} -s | jq .name -r 
    done
}

table() {
  printf '%20s %20s\n' "LOGIN" "FULL_NAME"
  for name in $(devs); do
    real=$(ghub /users/${name} -s | jq .name -r)
    printf '%20s %20s\n'  ${name} "${real}"
  done
}


lunch_own() {
    order_number=0
    printf '%20s %20s\n\n' "LOGIN" "LUNCH"

    ghub /repos/lalyos-trainings/git-wed/issues -s | jq .[].user.login -r |
    while read name; do
        
        # echo ${order}
        lunch=$(ghub /repos/lalyos-trainings/git-wed/issues -s | jq .[$order_number].body -r)
        printf '%20s %20s\n'  "${name}" "${lunch}"
        order_number=$(( ${order_number} + 1 ))
        # echo ${order}
    done

}

lunch() {
  ghub repos/lalyos-trainings/git-wed/issues -s | jq .[] -c \
  | while read order; do
    user=$(echo $order | jq .user.login -r)
    food=$(echo $order | jq .body -r)
    printf '%-15s %-15s %s\n' $user $food
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



issue-create() {
  declare title=$1 body=$2
  : ${title:? required} ${body:? required}

  json=$(issue-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues -d "${json}"
}



close-all() {
    ghub repos/lalyos-trainings/git-wed/issues | jq .[].number|\
    while read issue; do
    ghub repos/lalyos-trainings/git-wed/issues/${issue} -X PATCH -d ' { "state":"closed" } ' &> /dev/null &
    done
}

cat-test() {
    cat << EOF
    a
    a
    a
    EOF
EOF
}

add-comment() {
    declare body=$1 id=${$2:=89}
    : ${body:? required}
    echo ${body} ${id}
    # ghub repos/lalyos-trainings/git-wed/issues/${id}
}




