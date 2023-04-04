miko() { 
    local time=${1:-${NEXT:-17:30}}
    local now=$(date +%s)
    local pause=$(date -d ${time} +%s)
    echo time left till ${time} : $(( (${pause} - ${now} ) /60  )) minutes
}

coffee() {
    # Add user input instead of environmental variable
    read -p "Enter the time of the next break:" next
    if [[ $next ]] && [ $next -eq $next 2>/dev/null ]; then
        echo "You can only give integer values"
    else
        local now=$(date +%s)
        local start=$(date -d ${next:-17:30} +%s)
        local end=$(( ${start} + 600 )) 
        local remain=$(( (${end}-${now}) / 60 ))
        if [[ ${now} -lt ${start} ]]; then
            echo minutes till next coffee: $(( (${start}-${now}) / 60))
        else
            if  [[ ${remain} -lt 0 ]];  then
                echo coffe break has ended
            else
                echo time left: ${remain}
            fi
        fi
    fi
}

x() {
    echo 1.st param=... ${1:-default}
}

hint () { 

    latest=$(

        curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r

    );

    curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}

}


isa () {
    select key in ~/.ssh/*.pub; do
        if [[ $REPLY == 'q' ]]; then
          break;
        fi
        echo selected: $REPLY
        ssh-add ${key%.pub}
    done
}


# outtest () {

#     # here.doc
#     # Ha idézőjelben írom az EOF-t akkor nem cserél ki mindent literálisan
#       cat > a.txt  <<EOF
#     home: $HOME
#     ma: $(date)
#     egy
#     ketto
#     harom
#     EOF
# }



sleep_runner () {

    for run in {1..5}; do
      sleep 30 &
    done
}

#!/bin/bash
alias r="source $BASH_SOURCE"

ghub() {
    declare path=$1
    : ${path:? required}
    shift # Ez azért kell, hogy egyel eltolja a pozícionális paramétereket
    curl \
      -H "Authorization: Bearer $GH_TOKEN" \
      https://api.github.com/${path#/} \
     "$@" # Ezzel több pozícionális paramétert is megadhatok
}

teams() {
  ghub /orgs/lalyos-trainings/teams -s \
    | jq .[].name -r
}

devs() {
  ghub /organizations/2652852/team/7635002/members -s \
    | jq .[].login -r
}

table() {
  printf '%20s %20s\n' "LOGIN" "FULL_NAME"
  devs | while read name; do
    real=$(ghub /users/${name} -s | jq .name -r)
    printf '%20s %20s\n'  ${name} "${real}"
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

issue() {
  declare number=$1 content=${2:-}
  : #${content:? required} ${number:? required}
  json=$(comment-json "$@")
  if [[ -z "$content" ]]; then
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions
  else
    ghub repos/lalyos-trainings/git-wed/issues/${number}/reactions -d "${json}"
  fi  
  #echo "${json}"
}
#ghub repos/lalyos-trainings/git-wed/issues/23 -X PATCH -d '{"state":"closed"}'

comment-json() {
  cat <<EOF
  {
    "content":"${2}",
    "number":"${1}"
  }
EOF
}